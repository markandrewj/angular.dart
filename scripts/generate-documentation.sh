#!/bin/bash
. $(dirname $0)/env.sh

# Temporary change to delete the Build Status image markdown from the README (image md not supported by dartdoc-viewer)
cp README.md README-orig.md
cat README-orig.md | sed "1s/^AngularDart.*/AngularDart/" > README.md

# Dart doc can not be run from the same directory as dartdoc-viewer
# see: https://code.google.com/p/dart/issues/detail?id=17231
cd lib

echo "Generating documentation"
"$DART_DOCGEN" $DOC_OPTION $DOCDIR_OPTION \
    --out ../docs \
    --start-page=angular \
    --exclude-lib=js,metadata,meta,mirrors,intl,number_symbols,number_symbol_data,intl_helpers,date_format_internal,date_symbols,angular.util \
    --no-include-sdk \
    --package-root=../packages/ \
    angular.dart \
    filter/module.dart \
    directive/module.dart \
    animate/module.dart \
    utils.dart \
    mock/module.dart \
    perf/module.dart \

cd ..

DOCVIEWER_DIR="dartdoc-viewer";
if [ ! -d "$DOCVIEWER_DIR" ]; then
   git clone https://github.com/angular/dartdoc-viewer.git -b angular-skin $DOCVIEWER_DIR
else
   (cd $DOCVIEWER_DIR; git pull origin angular-skin)
fi;

# Create a version file from the current build version
doc_version=`head CHANGELOG.md | awk 'NR==2' | sed 's/^# //'`
dartsdk_version=`cat $DARTSDK/version`
head_sha=`git rev-parse --short HEAD`

echo $doc_version at $head_sha \(with Dart SDK $dartsdk_version\) > docs/VERSION

rm -rf $DOCVIEWER_DIR/client/web/docs/
mv docs/ $DOCVIEWER_DIR/client/web/docs/
(cd $DOCVIEWER_DIR/client; pub build)

# Revert the temp copy of the README.md file
 mv README-orig.md README.md

