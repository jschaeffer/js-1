#!/bin/bash
eval ${*}
status=${?}
#echo "eval return status = ${status}"
exit ${status}
