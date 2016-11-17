#!/bin/bash

wget --user jenkins --password c1eb0x\! http://localhost:7001/exit --auth-no-challenge >/dev/null 2>&1
cat "exit"
rm "exit"
