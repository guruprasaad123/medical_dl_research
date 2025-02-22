#!/bin/sh

### BEGIN INIT INFO
# Provides:          gunicorn
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Python WSGI HTTP server
# Description:       Starts the Gunicorn Python WSGI HTTP server.
### END INIT INFO

NAME="gunicorn"
DESC="Python WSGI HTTP Server"

SCRIPTNAME="/etc/init.d/$NAME"

CONFIG_VARS="APP_MODULE CONFIG_FILE LOG_LEVEL WORKING_DIR VIRTUALENV"

PID_DIR="/var/run/$NAME"
LOG_DIR="/var/log/$NAME"


PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
. /lib/lsb/init-functions

GUNICORN="/usr/bin/gunicorn"

if [ -f /etc/default/$NAME ]; then
  . /etc/default/$NAME
fi

USER=`whoami`
[ "$RUN_USER" ] && USER=$RUN_USER

 
if [ ! -d $PID_DIR ]; then
  mkdir $PID_DIR
  chown $USER $PID_DIR
fi

[ -x $GUNICORN ] || [ "$USE_VIRTUALENVS" = "yes" ] || log_failure_msg "Can't find $GUNICORN"

start_one()
{
  local args name pid
  name=$1
  args="--daemon --pid=$PID_DIR/$name.pid --log-file=$LOG_DIR/$name.log"

  log_action_begin_msg "$name"
  if [ -f "$PID_DIR/$name.pid" ]; then
    pid=`cat $PID_DIR/$name.pid`

    if [ "$pid" ]; then
      ps $pid > /dev/null
      if [ $? = 0 ]; then
        log_action_end_msg 0 "running already"
        return 0
      else
        rm -f $PID_DIR/$name.pid
      fi
    else
      rm -f $PID_DIR/name.pid
    fi
  fi

  if [ -f $CONF_DIR/$name.conf ]; then
    . $CONF_DIR/$name.conf

    if [ -z "$APP_MODULE" ]; then
      log_action_end_msg 1 "no module name defined"
      return 1
    fi
    if [ -z "$CONFIG_FILE" ]; then
      log_action_end_msg 1 "no configuration file defined"
      return 1
    fi
    [ "$WORKING_DIR" ] && cd $WORKING_DIR
    [ "$LOG_LEVEL" ] && args="$args --log-level=$LOG_LEVEL"
    
    if  [ "$VIRTUALENV" ]; then
      . $VIRTUALENV/bin/activate 
      GUNICORN=$VIRTUALENV/bin/gunicorn
    fi
 
    if [ ! -x $GUNICORN ]; then
      log_action_end_msg 1 "Can't find $GUNICORN"
      return 1
    fi
    
    sudo -E -u $USER $GUNICORN $args --config=$CONFIG_FILE -- $APP_MODULE
      
    for var in $CONFIG_VARS; do
      unset $var
    done

    log_action_end_msg 0
  else
    log_action_end_msg 1 "can't find config file $CONF_DIR/$name.conf"
  fi
}

stop_one()
{
  local name pid
  name=$1

  log_action_begin_msg "$name"
  if [ -f "$PID_DIR/$name.pid" ]; then
    pid=`cat $PID_DIR/$name.pid`

    if [ "$pid" ]; then
      ps $pid > /dev/null
      if [ $? = 0 ]; then
        kill -9 $pid
        if [ $? != 0 ]; then
          log_action_end_msg 1
          return 1
        fi
      fi
    fi
    rm -f $PID_DIR/$name.pid
  fi
  log_action_end_msg 0
}

reload_one()
{
  local name pid
  name=$1

  log_action_begin_msg "$name"
  if [ -f "$PID_DIR/$name.pid" ]; then
    pid=`cat $PID_DIR/$name.pid`

    if [ "$pid" ]; then
      ps $pid > /dev/null
      if [ $? = 0 ]; then
        kill -HUP $pid
        if [ $? = 0 ]; then
          log_action_end_msg 0
        else
          log_action_end_msg 1
          return 1
        fi
      else
        log_action_end_msg 1 "not running"
        rm -f $PID_DIR/$name.pid

        return 1
      fi
    else
      log_action_end_msg 1 "not running"
      rm -f $PID_DIR/$name.pid

      return 1
    fi
  else
    log_action_end_msg 1 "not running or doesn't exists"
    return 1
  fi
}

start()
{
  if [ "x$RUN" != "xyes" ] ; then
    log_failure_msg "$NAME init script disabled; edit /etc/default/$NAME"
    exit 1
  fi

  log_daemon_msg "Starting $DESC" "$NAME"
  echo
  for n in $CONFIGS; do
    start_one $n
  done
}

stop()
{
  log_daemon_msg "Stopping $DESC" "$NAME"
  echo
  for n in $CONFIGS; do
    stop_one $n
  done
}

reload()
{
  log_daemon_msg "Reloading $DESC" "$NAME"
  echo
  for n in $CONFIGS; do
    reload_one $n
  done
}

restart()
{
  stop
  start
}

inc()
{
  local name pid
  name=$1

  log_begin_msg "Increasing worker: "
  if [ -f "$PID_DIR/$name.pid" ]; then
    pid=`cat $PID_DIR/$name.pid`

    if [ "$pid" ]; then
      ps $pid > /dev/null
      if [ $? = 0 ]; then
        kill -TTIN $pid
        if [ $? = 0 ]; then
          log_success_msg "$name"
        else
          log_failure_msg "$name"
          exit 1
        fi
      else
        log_failure_msg "'$name' is not running"
        rm -f $PID_DIR/$name.pid

        exit 1
      fi
    fi
  else
    log_failure_msg "'$name' is not running or doesn't exists"
    exit 1
  fi
}

dec()
{
  local name pid
  name=$1

  log_begin_msg "Decreasing worker: "
  if [ -f "$PID_DIR/$name.pid" ]; then
    pid=`cat $PID_DIR/$name.pid`

    if [ "$pid" ]; then
      ps $pid > /dev/null
      if [ $? = 0 ]; then
        kill -TTOU $pid
        if [ $? = 0 ]; then
          log_success_msg "$name"
        else
          log_failure_msg "$name"
          exit 1
        fi
      else
        log_failure_msg "'$name' is not running"
        rm -f $PID_DIR/$name.pid

        exit 1
      fi
    fi
  else
    log_failure_msg "'$name' is not running or doesn't exists"
    exit 1
  fi
}



case "$1" in
  start) start;;
  stop) stop;;
  reload) reload;;
  restart) restart;;
  start_one) start_one $2;;
  stop_one) stop_one $2;;
  reload_one) reload_one $2;;
  inc) inc $2;;
  dec) dec $2;;
  *)
    echo "Usage $0 {start|stop|reload|restart|start_one <conf>|stop_one <conf>|reload_one <conf>|inc <conf>|dec <conf>}"
    exit 1
    ;;
esac

exit 0
