#!/bin/sh
# Colors
## Run the following in the terminal to print colors...
for i in {0..255} ; do
   printf "\x1b[38;5;${i}m${i} "
done

