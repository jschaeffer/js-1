#!/bin/bash


#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script compares the new version with the old version returning :
   0 if they are equal
   1 if the new version is greater than the old version
   -1 if the new version is less than the old version

OPTIONS:
  -h   Show this message
  -n   Required. New version
  -o   Required. Old version
EOF
  
}

######################################################################
#                       Main script
######################################################################

while getopts "hn:o:" OPTION
do
    case $OPTION in
      h)
        usage
        exit 1
        ;;
      n)
        NEW_VERSION=${OPTARG}
        ;;
      o)
        CURRENT_VERSION=${OPTARG}
        ;;
      ?)
        usage
        exit
        ;;
    esac
done

# Ensure required parameters are entered
if [ -z ${NEW_VERSION} -o -z ${CURRENT_VERSION} ] ; then
    usage
    exit 1
fi

NEW_VERSION=$(echo $NEW_VERSION|sed 's/_/./g')
CURRENT_VERSION=$(echo $CURRENT_VERSION|sed 's/_/./g')

typeset    IFS='.'
typeset -a v1=( $NEW_VERSION )
typeset -a v2=( $CURRENT_VERSION )
typeset    n diff

for (( n=0; n<4; n+=1 )); do
  diff=$((v1[n]-v2[n]))
  if [ $diff -ne 0 ] ; then
    [ $diff -lt 0 ] && echo '-1' || echo '1'
    exit
  fi
done
echo  '0'