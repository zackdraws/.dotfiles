#!/bin/bash

read -p "mov-cli -s youtube.yt-dlp" command_start

echo "$output"

full_comamnds="$command_start $command_rest"
eval "$full_command"
