@echo off
rem --------------------------------------------------------------------------------------
rem DO NOT CHANGE THIS FILE! ALL YOUR CHANGES WILL BE ELIMINATED AFTER AUTOMATIC UPGRADE.
rem --------------------------------------------------------------------------------------

set APP_FILE_NAME=license-server

set LAUNCHER_OPTS=-ea -Xmx5m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8
set LAUNCHER_ENV_OPTS=-Djava.awt.headless=true

set LAUNCHER_MAX_PERM_SIZE_OPTION=-XX:MaxPermSize=3m
set LAUNCHER_MAX_METASPACE_SIZE_OPTION=-XX:MaxMetaspaceSize=32m

set MIN_REQUIRED_JAVA_VERSION=1.8
set ADDITIONAL_FIND_JAVA_DIRS=
set FJ_LOOK_FOR_SERVER_JAVA=
set FJ_LOOK_FOR_X64_JAVA=
