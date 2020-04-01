#!/bin/sh
#
# gunicorn_pypiserver        Startup script for gunicorn for 
#
# chkconfig: - 86 14
# processname: gunicorn_pypiserver
# pidfile: /var/run/pypiserver.pid
# description: Python application server for pypiserver
#
### BEGIN INIT INFO
# Provides: gunicorn_pypiserver
# Required-Start: $local_fs $remote_fs $network
# Required-Stop: $local_fs $remote_fs $network
# Default-Start: 3
# Default-Stop: 0 1 2 4 5 6
# Short-Description: start and stop gunicorn for pypiserver
### END INIT INFO

#
# This Init Script for the Python Gunicorn WSGI Server has been tested
# under RHEL6.5. This script doesn't use any RHEL stuff, so it should run 
# on any distribution.
# Most of the script - the lines from about 50 to 130 are here to colorize the output
# The logic itself is deadsimple, but neverthereless it IS hard to get right..
#


#
# EDIT BELOW
#
NAME="guniserver"                                   # The application Name. Need python module "setproctitle" to work. Install with pip install setproctitle
VIRTUALENV="~/research/bin/activate"            # The path to the virtualenv to use, can also be empty
GUNICORN_PARAMS="--bind 127.0.0.1:8000 --user myuser --group mygroup --workers 2 --daemon --name $NAME --pid $PIDFILE"     # All the shiny parameters for gunicorn
# of course a --config /path/to/configfile is possible
APP="app:app"     # The application to start with application parameters
SCL_PATH="/opt/rh"                                  # The SCL Path in RedHat Linux - set it if you use an SCL 
SCLS=""                                  # Space seperated list of scls - Software Collections used by RedHat. Can be an empty string of not used
#
# EDIT SHOULD STOP HERE, BUT FEEL FREE TO DO SO
#

if [[ -n $VIRTUALENV ]] ; then
    GUNICORN_BIN=${VIRTUALENV}/bin/gunicorn
else
    GUNICORN_BIN=$(which gunicorn)
fi
PIDFILE="/var/run/$NAME.pid"                        # The PIDFILE to write the pid to
PID=""
RETVAL=2

##################################################################################
# Helper functions. I've never understood the /etc/rc.d/init.d/functions anyways #
# Just to have a colored output                                                  #
##################################################################################
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_COLOR_NONE="\e[0m"
COLOR_CYAN="\033[0;36m"

# Color function
function echo_color {
    echo -n -e $1
    shift
    echo -n -e $*
    echo -e $COLOR_COLOR_NONE
}

# Color function
function echo_red {
    echo_color $COLOR_RED $*
}

# Color function
function echo_green {
    echo_color $COLOR_GREEN $*
}

# Color function
function echo_red_klammer {
    echo -n -e "\033[4C"
    echo -n \[
    echo -n -e $COLOR_RED
    echo -n $1
    echo -n -e $COLOR_COLOR_NONE
    echo \]
}

# Color function
function echo_failed {
    echo_red_klammer failed
}

# Color function
function echo_state_red {
    state=$1
    shift
    echo -n $*
    echo_red_klammer $state
}

# Color function
function echo_state_green {
    state=$1
    shift
    echo -n $*
    echo_green_klammer $state
}

# Color function
function echo_green_klammer {
    echo -n -e "\033[4C"
    echo -n \[
    echo -n -e $COLOR_GREEN
    echo -n $1
    echo -n -e $COLOR_COLOR_NONE
    echo \]
}

# Color function
function echo_success {
    echo_green_klammer success
}

# Color function - but also exit
function exit_n {
    exitcode=$1
    shift
    echo -n $*         1>&2
    [[ $exitcode == 0 ]] && echo_success
    [[ $exitcode == 0 ]] || echo_failed
    exit $exitcode
}

# Enable the Software Collections if there are any defined
function enable_scls {
    for SCL in $SCLS
    do
        ENABLE_FILE=/${SCL_PATH}/${SCL}/enable
        if [[ -f $ENABLE_FILE ]] ; then
            source $ENABLE_FILE
        else
            exit_n 1 "SCL $SCL not found"
        fi
    done
}

# Enable the Software Collections if there is one defined
function enable_virtualenv {
    _virtualenv=$1
    [[ -z $_virtualenv ]] && return 0
    if [[ -f $_virtualenv/bin/activate ]] ; then
        source $_virtualenv/bin/activate
    else
        exit_n 1 "Virtualenv $_virtualenv not found"
    fi
}

enable_scls $SCLS
enable_virtualenv $VIRTUALENV

[[ -f $GUNICORN_BIN ]] || exit_n 1 "Gunicorn Binary $GUNICORN_BIN not found"
[[ -x $GUNICORN_BIN ]] || exit_n 1 "Gunicorn Binary $GUNICORN_BIN not executeable"


function is_running {
    [[ -f $PIDFILE ]] && PID=$(<$PIDFILE)
    kill -0 $PID 2>/dev/null 
    if [[ $? == 0 ]] ; then
        return 0
    else
        rm -f $PIDFILE
    fi
    PID=$(pgrep -l -f "gunicorn.*master.*${NAME}")
    if [[ $? == 0 ]] ; then
        echo $PID > $PIDFILE
        return 0
    fi
    return 1
}

function is_stopped {
    is_running
    [[ $? == 0 ]] && return 1
    return 0
}

start() {
    is_running && echo_state_green running "$NAME is already running" && RETVAL=0 && return
    $GUNICORN_BIN $GUNICORN_PARAMS "$APP"
    sleep 1    # yep - misa being coward...
    is_running && echo_state_green success "$NAME started" && RETVAL=0 && return 
    is_running && echo_state_red success "$NAME failed to start" && RETVAL=0
}

stop() {
    is_stopped &&  echo_state_green stopped "$NAME is already stopped" && RETVAL=0 && return
    kill -TERM $PID
    sleep 1    # yep - misa being coward...
    is_stopped && echo_state_red stopped "$NAME has stopped"  && RETVAL=0 && return
    is_stopped || echo_state_red failed "$NAME failed to stop" && RETVAL=1
}

status() {
    is_running && echo_state_green running "$NAME is running " && RETVAL=0 && return
    is_running || echo_state_red stopped "$NAME is stopped " && RETVAL=0
}

restart() {
    is_running && stop
    is_running || start
}

reload() {
    is_stopped && echo_state_red stopped "$NAME is not running" && RETVAL=1 && return
    kill -HUP $PID
    echo_state_green reloaded "$NAME got a reload signaled"
    RETVAL=0
}

# See how we were called.
case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart
        ;;
    reload)
        reload
        ;;
    status)
        status
        ;;
    *)
        echo $"Usage: $prog {start|stop|restart|reload|try-restart|status|help}"
        RETVAL=3
esac

if [[ $RETVAL == 2 ]] ; then
    echo -n "Returncode is 2. State is "
    echo -n -e "\033[4C"
    echo -n \[
    echo -n -e $COLOR_CYAN
    echo -n unkown
    echo -n -e $COLOR_COLOR_NONE
    echo \]
fi

exit $RETVAL