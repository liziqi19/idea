#!/bin/sh
# --------------------------------------------------------------------------------------
# DO NOT CHANGE THIS FILE! ALL YOUR CHANGES WILL BE ELIMINATED AFTER AUTOMATIC UPGRADE.
# --------------------------------------------------------------------------------------

APP_FILE_NAME="license-server"

LAUNCHER_OPTS="-ea -Xmx5m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8"
LAUNCHER_ENV_OPTS="-Djava.awt.headless=true"

LAUNCHER_MAX_PERM_SIZE_OPTION="-XX:MaxPermSize=3m"
LAUNCHER_MAX_METASPACE_SIZE_OPTION="-XX:MaxMetaspaceSize=32m"

MIN_REQUIRED_JAVA_VERSION="1.8"
ADDITIONAL_FIND_JAVA_DIRS=""
FJ_LOOK_FOR_SERVER_JAVA=""
FJ_LOOK_FOR_X64_JAVA=""
