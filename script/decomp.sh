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
    cd $DATA_DIR
    java -cp $ASM_JAR:$ASM_COMMONS_JAR:$ASM_TREE_JAR:$MAPPING_IO_JAR:$TINY_REMAPPER_JAR net.fabricmc.tinyremapper.Main $CLIENT_JAR $CLIENT_REMAPPED_JAR $MAP_TINY intermediary named
}

# Decompile
decompile () {
    # Decompile into WORKSPACE_JAVA_DIR
    cd $DATA_DIR
    java -jar $VINEFLOWER_JAR -dgs=1 -hdc=0 -asc=1 -mcs=1 -ega=1 -rsy=0 $CLIENT_REMAPPED_JAR $WORKSPACE_JAVA_DIR

    # Move (rather than copy) non-Java files to WORKSPACE_RESOURCES_DIR
    cd $WORKSPACE_JAVA_DIR
    files=$(find . -type f ! -name "*.java")
    for file in $files; do
        mkdir -p "$WORKSPACE_RESOURCES_DIR/$(dirname $file)"
        mv $file "$WORKSPACE_RESOURCES_DIR/$file"
    done
    find . -type d -empty -delete
}

# Cleanup dependencies
cleanup () {
    rm -rf $WORKSPACE_JAVA_DIR/com/jcraft
    rm -rf $WORKSPACE_JAVA_DIR/paulscode
}

# Record all files in $WORKSPACE_DIR
record () {
    cd $WORKSPACE_DIR
    find . -type f > $DATA_DIR/files.txt
}

# Patch files in $WORKSPACE_DIR
patch () {
    cd $WORKSPACE_DIR
    while IFS= read -r line; do
        PATCH_PATH="$PATCH_DIR/${line%.*}.patch"
        if [ -f "$PATCH_PATH" ]; then
            echo "Patching $line..."
            git apply $PATCH_PATH
            if [ $? -ne 0 ]; then
                echo "Failed to apply $(basename $PATCH_PATH)!"
                exit 1
            fi
        fi
    done < $FILES_TXT
}

# Copy files in SRC_DIR
copy () {
    cd $SRC_DIR
    find . -type f | cpio -pdm $WORKSPACE_DIR
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

mkdir -p $WORKSPACE_DIR

# Check if WORKSPACE_DIR is empty
if [ ! -z "$(ls -A $WORKSPACE_DIR)" ]; then
    echo "src directory is not empty!"
    exit 1
fi

mkdir -p $WORKSPACE_JAVA_DIR
mkdir -p $WORKSPACE_RESOURCES_DIR

# Decompile
echo "Decompiling JAR..."
decompile

# Cleanup
echo "Cleaning up dependencies from JAR..."
cleanup

# Record
echo "Recording patchable files..."
record

# Init git in WORKSPACE_DIR
cd $WORKSPACE_DIR
git init
git add .
git commit -m "Initial commit"
cd $ROOT_DIR

# Patch
echo "Patching files..."
patch

# Copy
echo "Copying files..."
copy