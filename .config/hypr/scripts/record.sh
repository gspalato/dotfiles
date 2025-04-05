#!/bin/env bash

pgrep -x "wf-recorder" && pkill -INT -x wf-recorder && notify-send -h string:wf-recorder:record -t 1000 "Finished Recording" && exit 0

notify-send -h string:wf-recorder:record -t 1000 "Recording in <b>3</b>"

sleep 1

notify-send -h string:wf-recorder:record -t 1000 "Recording in <b>2</b>"

sleep 1

notify-send -h string:wf-recorder:record -t 950 "Recording in <b>1</b>"

sleep 1

dateTime=$(date +%m-%d-%Y-%H:%M:%S)
wf-recorder --bframes max_b_frames -a -f $HOME/Videos/$dateTime.mp4
