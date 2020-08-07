#!/bin/bash
dir=$(dirname $0) # Directory of the script
set -e # Not Essential

#<external-scripts>#
source $dir/../util/colors.sh
source $dir/../util/metadata.sh
source $dir/../util/log-error.sh
source $dir/../util/create-package.sh
#</external-scripts>#

script="migrate"
desc="This Script is the main script of the Migrate project."

options="\
    migrate => Displays this help page.
    migrate -h/--help => Displays this help page.
    migrate -c/--create => Creates a new migrate package.
"

if [ "$1" != "" ];
then

  case $1 in

    "--help" | "-h" )
      print_help
      exit 0
      ;;

    "--create" | "-c" )
      create-package
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
