#!/usr/bin/env bash

echo "$(pwd):"
for X in *; do
	echo "$X"
	NAME=$(echo "$X" | sed -r 's/\.gz$//')
	gunzip -c "$X" > "$NAME"
done

