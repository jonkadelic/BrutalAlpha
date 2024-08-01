#!/bin/bash

# Common
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $SCRIPTPATH/common.sh

# Data
DATA=(
    "https://github.com/MCPHackers/RetroMCP-Java/releases/download/v1.0/RetroMCP-Java-CLI.jar $RMCP_JAR"
)

# Make directories
mkdir -p $DATA_LIB_DIR

# Download data
for i in "${DATA[@]}"; do
    FILE=$(echo $i | cut -d ' ' -f 2)
    URL=$(echo $i | cut -d ' ' -f 1)
    if [ ! -f "$FILE" ]; then
        echo "Downloading $(basename $FILE)..."
        wget -q $URL -O $FILE
    fi
done
