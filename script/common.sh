#!/bin/bash

# Paths
ROOT_DIR="$(dirname "$SCRIPTPATH")"
DATA_DIR="$ROOT_DIR/data"
WORKSPACE_DIR="$ROOT_DIR/workspace"
WORKSPACE_JAVA_DIR="$WORKSPACE_DIR/src/main/java"
WORKSPACE_RESOURCES_DIR="$WORKSPACE_DIR/src/main/resources"
SRC_DIR="$ROOT_DIR/src"
PATCH_DIR="$ROOT_DIR/patch"

CLIENT_JAR="$DATA_DIR/client.jar"
CLIENT_REMAPPED_JAR="$DATA_DIR/client-remapped.jar"
MAP_TINY="$DATA_DIR/map.tiny"
TINY_REMAPPER_JAR="$DATA_DIR/tiny-remapper.jar"
VINEFLOWER_JAR="$DATA_DIR/vineflower.jar"
MAPPING_IO_JAR="$DATA_DIR/mapping-io.jar"
ASM_JAR="$DATA_DIR/asm.jar"
ASM_COMMONS_JAR="$DATA_DIR/asm-commons.jar"
ASM_TREE_JAR="$DATA_DIR/asm-tree.jar"
FILES_TXT="$DATA_DIR/files.txt"
