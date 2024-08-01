#!/bin/bash

# Paths
ROOT_DIR="$(dirname "$SCRIPTPATH")"
DATA_DIR="$ROOT_DIR/data"
DATA_LIB_DIR="$DATA_DIR/lib"
WORKSPACE_DIR="$ROOT_DIR/workspace"
WORKSPACE_JAVA_DIR="$WORKSPACE_DIR/src/main/java"
WORKSPACE_RESOURCES_DIR="$WORKSPACE_DIR/src/main/resources"
SRC_DIR="$ROOT_DIR/src"
PATCH_DIR="$ROOT_DIR/patch"
RMCP_DIR="$ROOT_DIR/rmcp"

MAP_TINY="$DATA_DIR/mappings.tiny"
EXCEPTIONS_EXC="$DATA_DIR/exceptions.exc"
RMCP_JAR="$DATA_LIB_DIR/rmcp.jar"

FILES_TXT="$WORKSPACE_DIR/files.txt"
