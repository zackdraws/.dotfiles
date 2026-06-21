#!/usr/bin/env bash
set -euo pipefail

OUT="${SCREEN_RECORD_DIR:-$HOME/Videos}/screen-recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/hypr-record.pid"
notify() {
  notify-send "$@" 2>/dev/null || true
}

start() {
  if ! command -v wf-recorder >/dev/null 2>&1; then
    notify "Recording failed" "wf-recorder was not found"
    exit 1
  fi

  mkdir -p "$(dirname "$OUT")"
  args=(-f "$OUT")

  if [[ "${SCREEN_RECORD_AUDIO:-1}" != "0" ]]; then
    audio_source="${SCREEN_RECORD_AUDIO_SOURCE:-}"

    if [[ -z "$audio_source" ]] && command -v pactl >/dev/null 2>&1; then
      default_sink="$(pactl get-default-sink 2>/dev/null || true)"
      if [[ -n "$default_sink" ]]; then
        audio_source="$default_sink.monitor"
      fi
    fi

    if [[ -n "$audio_source" ]]; then
      args+=(--audio="$audio_source")
    else
      args+=(--audio)
    fi
  fi

  wf-recorder "${args[@]}" &
  echo $! > "$PIDFILE"
  notify "Recording started"
}
stop() {
  pid="$(cat "$PIDFILE")"
  if kill -0 "$pid" 2>/dev/null; then
    kill -INT "$pid" || true
  fi
  rm -f "$PIDFILE"
  notify "Recording stopped"
}
if [[ -f "$PIDFILE" ]]; then
  stop
else
  start
fi
