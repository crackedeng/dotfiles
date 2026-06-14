#!/bin/sh
name="$1"
case "$name" in
    ''|[0-9]*) echo "unnamed_session" ;;
    *) echo "$name" ;;
esac
