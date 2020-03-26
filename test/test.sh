#!/bin/bash

#--------File paths--------#
root="`dirname \"$0\"`/.."
scripts="$root/scripts"
tests="$root/test/tests"
util="$root/test/util"
#--------File paths--------#


source $root/build/config.sh
source $root/test/config.sh
source $root/util/colors.sh


#--------Import Tests------#
for test in $(echo $tests_list | tr -d ,)
do
  source $tests/$test/test.sh
done
#--------Import Tests------#

if [ ! -d $root/tests-log ];
then
  mkdir $root/tests-log
fi

print_help() {
  echo -e "
  This script is used for testing the $display_name scripts.\n
  Usage:
    test => Test all scripts.
    test -h/--help => Print this help page.
    test -a/--all => Runs all the available tests.
    test [script-name] => Runs the test for the specified script only.

  Available Tests: $tests_list

    NOTE: All errors will be logged in /tests-log/ directory
  "
}

create_log() {
  date=$(date +%d-%B-%Y)
  time=$(date +%H:%M:%S)
  log_file="$root/tests-log/test-$date-$time.log"
  if [ -s $log_file ];
  then
    rm $log_file # remove duplicate
  fi

  touch $log_file
}

log_error() {
  # $1 = error desc
  # $2 = script name
  # $3 = output
  echo -e "($2): $1 \n Output: \n $3 \n" >> $log_file
}

complete() {
  if [ ! -s $log_file ];
  then
    errorsFound="false"
  else
    errorsFound="true"
  fi

  if [ "$errorsFound" == "false" ];
  then
    echo -e "${GREEN_NO_UNDER}"
    echo -e " ____________________________"
    echo -ne "${GREEN_NO_UNDER}"
    echo -ne "|"
    echo -ne "${GREEN_UNDER}"
    echo -ne "TESTS COMPLETED SUCCESSFULLY"
    echo -ne "${NC}"
    echo -ne "${GREEN_NO_UNDER}"
    echo -e "|"
    echo -e "${NC}"

    echo "No errors were found while testing. ✓" >> $log_file
    exit 0
  elif [ "$errorsFound" == "true" ]; then
    echo -e "${RED_NO_UNDER}"
    echo -e " ____________"
    echo -ne "${RED_NO_UNDER}"
    echo -ne "|"
    echo -ne "${RED_UNDER}"
    echo -ne "TESTS FAILED"
    echo -ne "${NC}"
    echo -ne "${RED_NO_UNDER}"
    echo -e "|"
    echo -e "${NC}"

    echo -e "${ORANGE_UNDER}NOTE: All errors have been logged in $log_file${NC}"
    exit 1
  fi
}

full-test() {
  create_log

  for test in $(echo $tests_list | tr -d ,)
  do
    $test-test
    $test-result
  done

  complete
}
if [ "$1" != "" ];
then
  if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    print_help
    exit

  elif [ "$1" == "-a" ] || [ "$1" == "--all" ]; then
    full-test
  else
    create_log
    $1-test
    $1-result
    complete
  fi
else
  full-test
fi
