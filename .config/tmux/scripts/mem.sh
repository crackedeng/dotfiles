#!/bin/sh
ps=$(sysctl -n vm.pagesize)
total=$(sysctl -n hw.memsize)
used=$(vm_stat | awk -v ps="$ps" '/Pages (active|wired)/{gsub(/\./,"",$NF); s+=int($NF)*ps} END{print s}')
printf "%d%%" $((used * 100 / total))
