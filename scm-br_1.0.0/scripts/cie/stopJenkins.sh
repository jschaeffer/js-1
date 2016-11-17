#!/bin/bash

wget --user jenkins --password c1eb0x\! http://localhost:8080/exit --auth-no-challenge >/dev/null 2>&1
cat "exit"
rm "exit"
