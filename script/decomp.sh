#!/bin/bash

# Common
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $SCRIPTPATH/common.sh

# Data
DATA=(
    "$CLIENT_JAR"
    "$MAP_TINY"
    "$TINY_REMAPPER_JAR"
    "$VINEFLOWER_JAR"
    "$MAPPING_IO_JAR"
    "$ASM_JAR"
    "$ASM_COMMONS_JAR"
    "$ASM_TREE_JAR"
)

# Remap
remap () {
    cd $DATADIR
    java -cp $ASM_JAR:$ASM_COMMONS_JAR:$ASM_TREE_JAR:$MAPPING_IO_JAR:$TINY_REMAPPER_JAR net.fabricmc.tinyremapper.Main $CLIENT_JAR $CLIENT_REMAPPED_JAR $MAP_TINY intermediary named
}

# Decompile
decompile () {
    cd $DATADIR
    java -jar $VINEFLOWER_JAR -dgs=1 -hdc=0 -asc=1 $CLIENT_REMAPPED_JAR $SRCDIR
}

# Record all files in $SRCDIR
record () {
    cd $SRCDIR
    find . -type f > $DATADIR/files.txt
}

# Patch files in $SRCDIR
patch () {
    cd $SRCDIR
    while IFS= read -r line; do
        PATCHPATH="$PATCHDIR/${line%.*}.patch"
        if [ -f "$PATCHPATH" ]; then
            echo "Patching $line..."
            git apply $PATCHPATH
            if [ $? -ne 0 ]; then
                echo "Failed to apply $(basename $PATCHPATH)!"
                exit 1
            fi
        fi
    done < $FILES_TXT
}

# Copy files in NEWSRCDIR
copy () {
    cd $NEWSRCDIR
    find . -type f | cpio -pdm $SRCDIR
}

# Main

# Check no dependencies are missing
for i in "${DATA[@]}"; do
    if [ ! -f "$i" ]; then
        echo "Missing $(basename $i)!"
        exit 1
    fi
done

# Check if client.jar is remapped
if [ ! -f "$CLIENT_REMAPPED_JAR" ]; then
    echo "Remapping client.jar..."
    remap
fi

mkdir -p $SRCDIR

# Check if src directory is empty
if [ ! -z "$(ls -A $SRCDIR)" ]; then
    echo "src directory is not empty!"
    exit 1
fi

# Decompile
echo "Decompiling client.jar..."
decompile

# Record
echo "Recording patchable files..."
record

# Init git dir in $SRCDIR
cd $SRCDIR
git init
git add .
git commit -m "Initial commit"
cd $ROOTDIR

# Patch
echo "Patching files..."
patch

# Copy
echo "Copying files from $(basename $NEWSRCDIR)..."
copy