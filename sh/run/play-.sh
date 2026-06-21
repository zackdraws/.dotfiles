#!/usr/bin/env bash
set -euo pipefail

find . -type f -iname "*TEXT*" -print0 | xargs -0 mpv
