#!/bin/bash

# Common
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $SCRIPTPATH/common.sh

# Data
DATA=(
    "https://piston-data.mojang.com/v1/objects/daa4b9f192d2c260837d3b98c39432324da28e86/client.jar $CLIENT_JAR"
    "https://raw.githubusercontent.com/jonkadelic/a1.1.2_01-official/bd3435cc3bc97ce128ff2384e82e875f48957c19/complete/a1.1.2_01-official.tiny $MAP_TINY"
    "https://maven.fabricmc.net/net/fabricmc/tiny-remapper/0.9.0/tiny-remapper-0.9.0.jar $TINY_REMAPPER_JAR"
    "https://github.com/Vineflower/vineflower/releases/download/1.10.1/vineflower-1.10.1-slim.jar $VINEFLOWER_JAR"
    "https://maven.fabricmc.net/net/fabricmc/mapping-io/0.6.1/mapping-io-0.6.1.jar $MAPPING_IO_JAR"
    "https://maven.fabricmc.net/org/ow2/asm/asm/9.7/asm-9.7.jar $ASM_JAR"
    "https://maven.fabricmc.net/org/ow2/asm/asm-commons/9.7/asm-commons-9.7.jar $ASM_COMMONS_JAR"
    "https://maven.fabricmc.net/org/ow2/asm/asm-tree/9.7/asm-tree-9.7.jar $ASM_TREE_JAR"
)

# Make directories
mkdir -p $DATADIR

# Download data
for i in "${DATA[@]}"; do
    FILE=$(echo $i | cut -d ' ' -f 2)
    URL=$(echo $i | cut -d ' ' -f 1)
    if [ ! -f "$FILE" ]; then
        echo "Downloading $(basename $FILE)..."
        wget -q $URL -O $FILE
    fi
done
