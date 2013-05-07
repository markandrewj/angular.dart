import '_specs.dart';

main() {
  describe(r'$watch/$digest', () {
    it('should watch and fire on simple property change', () {
      // TODO deboer: spys?
      var timesRun = 0;
      var lastValue;
      var scope = new Scope();
      scope.$watch('name', (v) { timesRun++; lastValue = v; });
      expect(timesRun).toEqual(0);
      scope.$digest();

      expect(timesRun).toEqual(1);
      scope['name'] = 'james';
      scope.$digest();
      expect(timesRun).toEqual(2);
      expect(lastValue).toEqual('james');
    });

    it('should watch and run a function', () {
      var timesRun = 0;
      var passedValue;
      var scope = new Scope();
      scope.$watch((x) { timesRun++; passedValue = x;});
      expect(timesRun).toEqual(0);
      scope.$digest();

      expect(timesRun).toEqual(1);
      expect(passedValue).toEqual(scope);
    });
  });
}