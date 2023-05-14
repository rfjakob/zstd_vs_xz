#!/bin/bash

set -eux

cd "$(dirname "$0")"

IN=$PWD/silesia.tar
RESULTS=$PWD/results.txt
rm -f "$RESULTS"

WORK=$(mktemp -d)
cd "$WORK"
cp "$IN" .
IN=$(basename "$IN")

# Cleanup trap
trap 'rm -rf "$WORK"' EXIT

echo "CMD	LEVEL	REAL	USER	SYS	INSIZE	OUTSIZE" | tee -a "$RESULTS"

INSIZE=$(stat -c %s $IN)
TIME_FORMAT="%e	%U	%S"

for i in $(seq 1 19) ; do
	TIMES=$(/usr/bin/time -f "$TIME_FORMAT" zstd -$i -q -T0 "$IN" 2>&1)
	OUTSIZE=$(stat -c %s "$IN.zst")
	rm "$IN.zst"
	echo "zstd	-$i	$TIMES	$INSIZE	$OUTSIZE" | tee -a "$RESULTS"
done

for i in $(seq 0 9) ; do
	TIMES=$(/usr/bin/time -f "$TIME_FORMAT" xz -$i -T0 --keep "$IN" 2>&1)
	OUTSIZE=$(stat -c %s "$IN.xz")
	rm "$IN.xz"
	echo "xz	-$i	$TIMES	$INSIZE	$OUTSIZE" | tee -a "$RESULTS"
done

cat "$RESULTS"
