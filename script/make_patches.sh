#!/bin/bash

# Common
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $SCRIPTPATH/common.sh

# Check $WORKSPACE_DIR exists
if [ ! -d "$WORKSPACE_DIR" ]; then
    echo "Missing $(basename $WORKSPACE_DIR)!"
    exit 1
fi

# Generate patches from files in WORKSPACE_DIR
cd $WORKSPACE_DIR
while IFS= read -r line; do
    PATCHPATH="$PATCH_DIR/${line%.*}.patch"
    echo "Checking $line..."
    git diff --quiet --exit-code $line
    if [ $? -ne 0 ]; then
        mkdir -p "$(dirname $PATCHPATH)"
        echo "Creating $(dirname $line)/$(basename $PATCHPATH)..."
        git diff -U1 --minimal --binary $line > $PATCHPATH
    fi
done < $FILES_TXT

# Copy untracked files to SRC_DIR
cd $WORKSPACE_DIR
echo "Copying untracked files to $SRC_DIR..."
git ls-files --others --exclude-standard | cpio -pdm $SRC_DIR