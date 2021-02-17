#!/bin/bash
dir=$(dirname $0) # Directory of the script

#<external-scripts>#
source $dir/../util/colors.sh
source $dir/../util/metadata.sh
source $dir/../util/log-error.sh
source $dir/../util/create-blueprint.sh
source $dir/../util/install-blueprint.sh
#</external-scripts>#

script="migrate"
desc="This Script is the main script of the Migrate project."

options="\
    migrate => Displays this help page.
    migrate -h/--help => Displays this help page.
    migrate -c/--create => Creates a new migrate blueprint.
    migrate -i/--install [path-blueprint.tar.gz] => Install the specified migrate blueprint.
"

if [ "$1" != "" ];
then

  case $1 in

    "--help" | "-h" )
      print_help
      exit 0
      ;;

    "--create" | "-c" )
      create-blueprint
      exit 0
      ;;

    "--install" | "-i")
      if [[ $2 == "" ]];
      then
        log-eror 'Blueprint path not specified' 2
      else
        install-blueprint "$2"
      fi
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
