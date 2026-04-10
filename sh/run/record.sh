#!/usr/bin/env bash
#OUT="$HOME/Videos/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
OUT="~/ok/ok/screen-recordings/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
PIDFILE="/tmp/hypr-record.pid"
start() {
  wf-recorder -f "$OUT" &
  echo $! > "$PIDFILE"
  notify-send "Recording started"
}
stop() {
  kill -INT "$(cat "$PIDFILE")"
  rm -f "$PIDFILE"
  notify-send "Recording stopped"
}
if [[ -f "$PIDFILE" ]]; then
  stop
else
  start
fi
