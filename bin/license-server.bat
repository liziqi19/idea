@echo off
rem --------------------------------------------------------------------------------------
rem DO NOT CHANGE THIS FILE! ALL YOUR CHANGES WILL BE ELIMINATED AFTER AUTOMATIC UPGRADE.
rem --------------------------------------------------------------------------------------

rem workaround for the case if ERRORLEVEL was set by parent process
set ERRORLEVEL=

setlocal disabledelayedexpansion
set "JB_SCRIPT=%~df0"
set "JB_SCRIPT_DIR=%~dp0"
set "JB_ALL_ARGS=%*"
setlocal enabledelayedexpansion

rem get rid of "Terminate batch job (Y/N)?" question on Ctrl+C
if "!JB_WORKAROUND_CTRL_C!" == "" (
  set JB_WORKAROUND_CTRL_C=1
  call "!JB_SCRIPT!" !JB_ALL_ARGS! <nul
  exit /b !ERRORLEVEL!
)

endlocal
rem reset this variable to not pass it to the child processes
set JB_WORKAROUND_CTRL_C=
cd /d "%JB_SCRIPT_DIR%\.."
setlocal enabledelayedexpansion

set "LAUNCHER_SETENV_BAT=!cd!\launcher\conf\launcher.setenv.bat"
if exist "!LAUNCHER_SETENV_BAT!" (
  endlocal
  call "%LAUNCHER_SETENV_BAT%" <nul
  setlocal enabledelayedexpansion
)

endlocal
set "FIND_JAVA_BAT=%cd%\launcher\bin\findJava.bat"
setlocal enabledelayedexpansion

if "!MIN_REQUIRED_JAVA_VERSION!" == "" (
  endlocal
  set "MIN_REQUIRED_JAVA_VERSION=1.6"
  setlocal enabledelayedexpansion
  goto skip_min_required_java_version_check
)
call "!FIND_JAVA_BAT!" fun version_ge !MIN_REQUIRED_JAVA_VERSION! 1.6 <nul
if not "!ERRORLEVEL!" == "0" (
  echo Cannot start launcher with Java !MIN_REQUIRED_JAVA_VERSION!, will look for at least Java 1.6. 1>&2
  endlocal
  set "MIN_REQUIRED_JAVA_VERSION=1.6"
  setlocal enabledelayedexpansion
)
:skip_min_required_java_version_check

set "EXPLICIT_JAVA_FILE=!cd!\conf\!APP_FILE_NAME!.java.path"
if exist "!EXPLICIT_JAVA_FILE!" (
  for /f "delims=" %%i in ('type "!EXPLICIT_JAVA_FILE!"') do (
    endlocal
    set "FJ_JAVA_EXEC=%%i"
    setlocal enabledelayedexpansion
  )
)

call "!FIND_JAVA_BAT!" !MIN_REQUIRED_JAVA_VERSION! !ADDITIONAL_FIND_JAVA_DIRS! <nul
if not "!ERRORLEVEL!" == "0" (
  exit /b -1
)

call "!FIND_JAVA_BAT!" fun version_ge !FJ_JAVA_VERSION! 1.8 <nul
if "!ERRORLEVEL!" == "0" (
  set "JL_LAUNCHER_OPTS=!LAUNCHER_OPTS! !LAUNCHER_MAX_METASPACE_SIZE_OPTION!"
) else (
  set "JL_LAUNCHER_OPTS=!LAUNCHER_OPTS! !LAUNCHER_MAX_PERM_SIZE_OPTION!"
)

if 0 == 0 (
  endlocal
  set "FJ_JAVA_EXEC=%FJ_JAVA_EXEC%"
  set "JL_LAUNCHER_OPTS=%JL_LAUNCHER_OPTS%"
  set "JL_JAVA_PROPERTIES=%LAUNCHER_ENV_OPTS%"
  set "JB_COMMAND_SUFFIX=-jar launcher\lib\%APP_FILE_NAME%-launcher.jar"
  setlocal enabledelayedexpansion
)

endlocal
set /a I=0
setlocal enabledelayedexpansion

for /f "tokens=1* delims=#" %%x in ('call "!FJ_JAVA_EXEC!" !JL_LAUNCHER_OPTS! !JB_COMMAND_SUFFIX! get-launch-info !JB_ALL_ARGS! 2^>nul') do (
  for /f %%v in ("VAR!I!") do (
    endlocal
    set "%%v=%%y"
    set /a I=I+1
    setlocal enabledelayedexpansion
  )
)

endlocal
set "APP_DISPLAY_NAME=%VAR0%"
set "IS_SERVICE=%VAR1%"
set "IS_CONSOLE=%VAR2%"
setlocal enabledelayedexpansion

if not "!IS_SERVICE!" == "" (
  endlocal
  set "JL_LAUNCHER_OPTS=-Xrs %JL_LAUNCHER_OPTS%"
  setlocal enabledelayedexpansion
)

if not "!IS_CONSOLE!" == "" if not "!APP_DISPLAY_NAME!" == "" (
  title !APP_DISPLAY_NAME!
)

call "!FJ_JAVA_EXEC!" "-Djl.service=!APP_DISPLAY_NAME! Launcher" "-Djl.home=!cd!" !JL_LAUNCHER_OPTS! !JB_COMMAND_SUFFIX! !JB_ALL_ARGS! <nul
exit /b !ERRORLEVEL!
