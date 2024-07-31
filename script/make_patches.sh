#!/bin/bash

# Common
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $SCRIPTPATH/common.sh

# Check $SRCDIR exists
if [ ! -d "$SRCDIR" ]; then
    echo "Missing $(basename $SRCDIR)!"
    exit 1
fi

# Generate patches from files in SRCDIR
cd $SRCDIR
while IFS= read -r line; do
    PATCHPATH="$PATCHDIR/${line%.*}.patch"
    echo "Checking $line..."
    git diff --quiet --exit-code $line
    if [ $? -ne 0 ]; then
        mkdir -p "$(dirname $PATCHPATH)"
        echo "Creating $(dirname $line)/$(basename $PATCHPATH)..."
        git diff -U1 --minimal --binary $line > $PATCHPATH
    fi
done < $FILES_TXT

# Copy untracked files to NEWSRCDIR
cd $SRCDIR
echo "Copying untracked files to $NEWSRCDIR..."
git ls-files --others --exclude-standard | cpio -pdm $NEWSRCDIR