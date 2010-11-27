#!/bin/bash
#
# sample-bbs   This shell script takes care of starting and stopping
#              sample-bbs (Sample BBS daemon).
#
# chkconfig: - 85 15
# description: sample-bbs is the Sample BBS daemon.

# Check that networking is up.
#[ ${NETWORKING} = "no" ] && exit 0

. /etc/rc.d/init.d/functions

RETVAL=0

prog="sample-bbs"
#user="nobody"
pythpath=$0
linktest=`readlink $pythpath`
if [ -f "$linktest" ]; then
  pythpath=$linktest
fi
basedir=$(cd $(dirname $(dirname $pythpath));pwd)
#run="$basedir/perl5/perlbrew/perls/perl-5.12.2/bin/starman"
run="/home/aska/perl5/perlbrew/perls/perl-5.12.2/bin/starman"
psgifile="$basedir/app.psgi"
pidfile="$basedir/run/$prog.pid"
lockfile="$basedir/run/$prog"
debugfile="$basedir/run/$prog.debug"
port="18080"
#facility="local0"
#interval="15"

export PERL5LIB="$basedir/lib:$PERL5LIB"
export SAMPLE_BBS_BASEDIR=$basedir

success() {
  echo -n "$1 success."
}

failure() {
  echo -n "$1 failure."
}

start() {
  if [ -f "$lockfile" ]; then
    if [ -f "$pidfile" ]; then
      PID=`cat $pidfile`
      PROC=`ps --pid $PID --no-heading | wc -l`
      if [ $PROC -ne 0 ]; then
        echo -n $"Starting $prog: "
        failure $"$base startup"
        echo
        echo "already starting $prog: "
        echo "if stopped please remove $pidfile."
        return 0
      fi
      rm $pidfile
    else
      rm $lockfile
    fi
  fi
  echo -n $"Starting $prog: "
  $run --disable-keepalive --pid $pidfile -D --port $port $psgifile
  
  RETVAL=$?
  [ $RETVAL -eq 0 ] && touch $lockfile
  [ $RETVAL -eq 0 ] && success $"$base startup" || failure $"$base startup"
  echo
  return $RETVAL
}

stop() {
  echo -n $"Shutting down $prog: "
  pid=`cat $pidfile | tr "\n" " " 2>/dev/null`
  rm -f $lockfile
  kill -TERM $pid
  RETVAL=0
  for i in `seq 1 10`;
    do
    sleep 1
    if [ ! -f $pidfile ]; then
      RETVAL=0
      break
    fi
  done
  [ $RETVAL -eq 0 ] && success $"$base stop" || failure $"$base stop"
  echo
  return $RETVAL
}

# See how we were called.
case "$1" in
  start)
    shift
    start $*
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    RETVAL=$?
    ;;
  *)
    echo -n $"Usage"
    echo ": $prog {start|stop|restart}"
    exit 1
esac

exit $RETVAL
