#!/bin/bash

set -e

if [ -n "$DIST_VERSION" ]; then
    version=$DIST_VERSION
else
    version=`git describe --dirty --tags || echo unknown`
fi

yarn clean
VERSION=$version yarn build

# include the sample config in the tarball. Arguably this should be done by
# `yarn build`, but it's just too painful.
cp config.sample.json webapp/

mkdir -p dist
cp -r webapp kb-web-$version

# Just in case you have a local config, remove it before packaging
rm kb-web-$version/config.json || true

$(dirname $0)/normalize-version.sh ${version} > kb-web-$version/version

tar chvzf dist/kb-web-$version.tar.gz kb-web-$version
rm -r kb-web-$version

echo
echo "Packaged dist/kb-web-$version.tar.gz"
