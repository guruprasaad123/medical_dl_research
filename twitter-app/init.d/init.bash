#! /bin/bash
### BEGIN INIT INFO
# Provides:          yourapp
# Required-Start:    nginx
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: The main django process
# Description:       The gunicorn process that receives HTTP requests
#                    from nginx
#
### END INIT INFO
#
# Author:       mle <geobi@makina-corpus.net>
#
APPNAME=flashapp
USER=ec2-user
PATH=/bin:/usr/bin:/sbin:/usr/sbin
ACTIVATE=research/bin/activate
APPMODULE=hello:app
DAEMON=gunicorn
BIND=127.0.0.1:8000
PIDFILE=/var/run/gunicorn.pid
LOGFILE=/var/log/$DAEMON.log
WORKERS=2

echo "str"

. /lib/lsb/init-functions


if [ -e "/etc$APPNAME" ]
then
    . /etc/default/$APPNAME
fi


case "$1" in
  start)
        log_daemon_msg "Starting deferred execution scheduler" "$APPNAME"
        source $ACTIVATE
        $DAEMON --daemon --bind=$BIND --pid=$PIDFILE --workers=$WORKERS --user=$USER --log-file=$LOGFILE $APPMODULE
        log_end_msg $?
    ;;
  stop)
        log_daemon_msg "Stopping deferred execution scheduler" "APPNAME"
        killproc -p $PIDFILE $DAEMON
        log_end_msg $?
    ;;
  force-reload|restart)
    $0 stop
    $0 start
    ;;
  status)
    status_of_proc -p $PIDFILE $DAEMON && exit 0 || exit $?
    ;;
  *)
    echo "Usage: /etc/init.d/$APPNAME {start|stop|restart|force-reload|status}"
    exit 1
    ;;
esac

exit 0