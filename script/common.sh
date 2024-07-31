#!/bin/bash

# Paths
ROOTDIR="$(dirname "$SCRIPTPATH")"
DATADIR="$ROOTDIR/data"
SRCDIR="$ROOTDIR/src"
NEWSRCDIR="$ROOTDIR/newsrc"
PATCHDIR="$ROOTDIR/patch"

CLIENT_JAR="$DATADIR/client.jar"
CLIENT_REMAPPED_JAR="$DATADIR/client-remapped.jar"
MAP_TINY="$DATADIR/map.tiny"
TINY_REMAPPER_JAR="$DATADIR/tiny-remapper.jar"
VINEFLOWER_JAR="$DATADIR/vineflower.jar"
MAPPING_IO_JAR="$DATADIR/mapping-io.jar"
ASM_JAR="$DATADIR/asm.jar"
ASM_COMMONS_JAR="$DATADIR/asm-commons.jar"
ASM_TREE_JAR="$DATADIR/asm-tree.jar"
FILES_TXT="$DATADIR/files.txt"
