#!/bin/bash

CHECK_INTERVAL=5
IDLE_THRESHOLD=30  # секунд
IDLE_COUNTER=0

while true; do

  IS_MUTED=$(pactl get-source-mute alsa_input.pci-0000_00_1f.3.analog-stereo | awk '{ print $2 }')

  if [[ "$IS_MUTED" == "yes" ]]; then
    IDLE_COUNTER=$((IDLE_COUNTER + CHECK_INTERVAL))
  else
    IDLE_COUNTER=0
  fi

  if [[ $IDLE_COUNTER -ge $IDLE_THRESHOLD ]]; then
    systemctl --user is-active easyeffects && systemctl --user stop easyeffects
  else
    ! systemctl --user is-active easyeffects && systemctl --user start easyeffects
  fi

  sleep $CHECK_INTERVAL
done

