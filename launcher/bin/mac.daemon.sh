#!/bin/sh
# --------------------------------------------------------------------------------------
# DO NOT CHANGE THIS FILE! ALL YOUR CHANGES WILL BE ELIMINATED AFTER AUTOMATIC UPGRADE.
# --------------------------------------------------------------------------------------

DAEMONS_FOLDER="/Library/LaunchDaemons"
DAEMON_LABEL="$2"
DAEMON_LINK="$DAEMONS_FOLDER/$DAEMON_LABEL.plist"
LOGS_DIR="$3"

fix_log_file() {
  if [ -f "$1" ]; then
    chmod a+rw "$1"
  fi
}

fix_permissions() {
  chmod u+x,go-w "$DAEMONS_FOLDER"
  chmod 644 "$DAEMON_LINK"
  chown root "$DAEMON_LINK"
  chmod -h 644 "$DAEMON_LINK"
  chown -h root "$DAEMON_LINK"
  fix_log_file "$LOGS_DIR/launcher-daemon-stdout.log"
  fix_log_file "$LOGS_DIR/launcher-daemon-stderr.log"
}

case "$1" in
  install)
    ln -s "$4/launcher.daemon.plist" "$DAEMON_LINK"
    fix_permissions
  ;;

  uninstall)
    launchctl unload "$DAEMON_LINK" 1>/dev/null 2>&1
    rm -f "$DAEMON_LINK"
  ;;

  load)
    fix_permissions
    launchctl load "$DAEMON_LINK"
    exit $?
  ;;

  unload)
    fix_permissions
    launchctl unload "$DAEMON_LINK"
    exit $?
  ;;

  exists)
    if [ -f "$DAEMON_LINK" ]; then
      exit 0
    else
      exit 1
    fi
  ;;

  *)
    echo "Wrong usage: $@" 1>&2
    exit 3
  ;;
esac
