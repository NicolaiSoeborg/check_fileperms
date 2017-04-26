#!/usr/bin/env bash

# Written by Nicolai Søborg, nsq@novozymes.com, 2017.

if [ "$#" != 1 ]; then
	echo "Usage: $0 <path>"
	echo "Will check that current user has write access to every (sub-)files and folders in <path>"
	exit 3 # "UNKNOWN" exit code
fi

DIR="$1"
if [ ! -d "$DIR" ]; then
	echo "WARNING: Directory '$DIR' not found. Exiting."
	exit 1
fi

echo "$(date) Running '$0 $@' as $USER"

# Make sure to change internal field seperator s.t. filenames with newlines doesn't get split (...)
find "$DIR" -print0 |
{
  cnt=0
  err=false
  while IFS= read -rd '' f; do
	if [ ! -w "$f" ]; then
		echo "ERROR: $USER can't write to $f"
		err=true
	fi
	cnt=$(($cnt+1))
  done
  if [ "$err" == true ]; then
	echo "CRITICAL: Errors detected ($cnt files checked)."
	exit 2
  else
	echo "OK: $cnt files without errors."
	exit 0
  fi
}
