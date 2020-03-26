#!/bin/bash

source $util/produces-output.sh
source $util/exit-status.sh
source $util/outputs-match.sh

migrate-test() {
  echo -ne "${GREEN_NO_UNDER}"
  echo -ne "Testing script "
  echo -ne "${ORANGE_UNDER}"
  echo -e "migrate${NC}\n"
  sleep 0.5

  echo -ne "${GREEN_NO_UNDER}"
  echo -ne "Running "
  echo -ne "${ORANGE_UNDER}"
  echo -e "migrate -h${NC}"
  migrateOuth=$($scripts/migrate.sh -h)
  migrateOuthExit=$(echo $?)
  sleep 0.5

  echo -e " "
}

migrate-result() {
  produces-output 'migrate' 'migrate -h' "$migrateOuth"
  exit-status 'migrate' 'migrate -h' "$migrateOuth" "$migrateOuthExit"
}
