#!/usr/bin/env bash

# Written by Nicolai Søborg, nsq@novozymes.com, 2017.

if [ "$#" != 1 ]; then
	echo "Usage: $0 <path>"
	echo "Will check that current user owns every (sub-)files and folders in <path>"
	exit 3 # "UNKNOWN" exit code
fi

DIR="$1"
if [ ! -d "$DIR" ]; then
	echo "WARNING: Directory '$DIR' not found. Exiting."
	exit 1
fi

if [ -z "$USER" ]; then
	USER=$(whoami)
fi

echo "[$(date)] Running '$0 $*' as $USER"

# Make sure to change internal field seperator s.t. filenames with newlines doesn't get split (...)
find "$DIR" -print0 |
{
  cnt=0
  err=false
  while IFS= read -rd '' f; do
	if [ ! -O "$f" ]; then
		echo "ERROR: $f isn't owned by $USER"
		err=true
	fi
	cnt=$((cnt+1))
  done
  if [ "$err" == true ]; then
	echo "CRITICAL: Errors detected ($cnt files checked)."
	exit 2
  else
	echo "OK: $cnt files without errors."
	exit 0
  fi
}
