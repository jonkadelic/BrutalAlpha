#!/bin/bash

# Common
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $SCRIPTPATH/common.sh

# Data
DATA=(
    "$MAP_TINY"
    "$EXCEPTIONS_EXC"
    "$RMCP_JAR"
)

setup_rmcp () {
    mkdir -p $RMCP_DIR
    cd $RMCP_DIR
    java -jar $RMCP_JAR setup a1.1.2_01 > /dev/null
    cp $EXCEPTIONS_EXC $RMCP_DIR/conf/$(basename $EXCEPTIONS_EXC)
    cp $MAP_TINY $RMCP_DIR/conf/$(basename $MAP_TINY)
    java -jar $RMCP_JAR decompile client #> /dev/null
}

copy_sources() {
    cd $RMCP_DIR/minecraft/src
    find . -type f -name '*.java' | cpio -pdm $WORKSPACE_JAVA_DIR
    cd $ROOT_DIR
    mkdir temp
    cd temp
    unzip $RMCP_DIR/jars/minecraft.jar > /dev/null
    find . -type f ! -name '*.class' | cpio -pdm $WORKSPACE_RESOURCES_DIR
    cd $ROOT_DIR
    rm -rf temp
}

# Record all files in $WORKSPACE_DIR
record () {
    cd $WORKSPACE_DIR
    find . -type f > $FILES_TXT
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

mkdir -p $WORKSPACE_DIR

# Check if WORKSPACE_DIR is empty
if [ ! -z "$(ls -A $WORKSPACE_DIR)" ]; then
    echo "$(basename $WORKSPACE_DIR) directory is not empty!"
    exit 1
fi

mkdir -p $WORKSPACE_JAVA_DIR
mkdir -p $WORKSPACE_RESOURCES_DIR

# Decompile
echo "Decompiling..."
setup_rmcp
copy_sources

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