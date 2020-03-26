#!/bin/bash

source $util/produces-output.sh
source $util/exit-status.sh
source $util/outputs-match.sh

script_1-test() {
  echo -ne "${GREEN_NO_UNDER}"
  echo -ne "Testing script "
  echo -ne "${ORANGE_UNDER}"
  echo -e "script_1${NC}\n"
  sleep 0.5

  echo -ne "${GREEN_NO_UNDER}"
  echo -ne "Running "
  echo -ne "${ORANGE_UNDER}"
  echo -e "script_1 -h${NC}"
  script_1Outh=$($scripts/script_1.sh -h)
  script_1OuthExit=$(echo $?)
  sleep 0.5

  echo -e " "
}

script_1-result() {
  produces-output 'script_1' 'script_1 -h' "$script_1Outh"
  exit-status 'script_1' 'script_1 -h' "$script_1Outh" "$script_1OuthExit"
}
