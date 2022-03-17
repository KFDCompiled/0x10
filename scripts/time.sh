#!/bin/bash

if [[ "$#" -ne 2 ]]; then
  echo -ne "\n[*]\tShell script to calculate how much time passed between start and end times.\n[*]\tUSAGE: $0 HH:MM HH:MM" >&2
  exit 1
fi

START=$1
FINISH=$2

/usr/bin/dateutils.ddiff -f "%H hours %M minutes" $START $FINISH

