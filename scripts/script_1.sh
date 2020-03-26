#!/bin/bash
dir=$(dirname $0) # Directory of the script
set -e # Not Essential

#<external-scripts>#
source $dir/../util/colors.sh
source $dir/../util/metadata.sh
source $dir/../util/log-error.sh
#</external-scripts>#

script="script_1"
desc="This Script is the control script for the [Name] project."

options="\
    script_1 => Displays this help page.
    script_1 -h/--help => Displays this help page.
"

if [ "$1" != "" ];
then

  case $1 in

    "--help" | "-h" )
      print_help
      exit 0
      ;;

    * )
      log-error 'Option not found' 1
      ;;

  esac

else
  print_help
  exit
fi
