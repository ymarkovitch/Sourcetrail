#!/bin/sh
# Exit on error
set -e

SRCDIR="$(readlink -f "$(dirname "$0")/../..")"

# index sample projects
SOURCETRAIL="$SRCDIR/build/app/Sourcetrail"
PROJECTS_PATH="$SRCDIR/bin/app/user/projects"

for project in tictactoe_cpp tictactoe_py tutorial javaparser
do
    "$SOURCETRAIL" index --full "$PROJECTS_PATH/$project/$project.srctrlprj"
done

# create AppDir
rm -rf AppDir

PREFIX="$SRCDIR/AppDir/Sourcetrail"

mkdir -p "$PREFIX/"{bin,lib,share}

cp -T "$SRCDIR/build/app/Sourcetrail" "$PREFIX/bin/sourcetrail"
cp    "$SRCDIR/build/app/sourcetrail_indexer" "$PREFIX/bin/"

pushd "$PREFIX/share"
# Create share/applications, share/data, share/mime/packages
mkdir -p applications data mime/packages

cp "$SRCDIR/setup/Linux/data/sourcetrail.desktop"  applications
cp "$SRCDIR/setup/Linux/data/sourcetrail-mime.xml" mime/packages

for datadir in \
    color_schemes \
    syntax_highlighting_rules \
    fonts \
    gui \
    java \
    python \
    fallback \
    license \
    cxx
do
    cp -R -t data "$SRCDIR/bin/app/data/$datadir"
done
cp -R -t data/fallback "$SRCDIR/bin/app/user/projects"

popd # $PREFIX/share

# print file structure
# find AppDir | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"

# create icons

ICON="$PREFIX/share/data/gui/icon/logo_1024_1024.png"
HICOLOR_DIR="$PREFIX/share/icons/hicolor"

createIcon()
{
    mkdir -p "$HICOLOR_DIR/$1/apps/"
    convert "$ICON" -resize $1 "$HICOLOR_DIR/$1/apps/sourcetrail.png"
}

createIcon 512x512
createIcon 256x256
createIcon 128x128
createIcon 64x64
createIcon 48x48

cp -R -t "$PREFIX" "$SRCDIR/setup/Linux/data/package"/*
