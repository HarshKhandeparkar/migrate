# $1 = Script Name
# $2 = Command
# $3 = Command Output
produces-output() {
  if [ "$3" != "" ];
  then
    echo -e "${GREEN_NO_UNDER}command ${ORANGE_UNDER}"$2"${GREEN_NO_UNDER} produces an output ${GREEN_NO_UNDER}✓${NC}"
    sleep 0.3
  else
    echo -e "${RED_NO_UNDER}Error: no output from command ${ORANGE_UNDER}"$2"${NC} ${RED_UNDER}X${NC}"
    sleep 0.3
    log_error "No output from command '$2'" "$1" "$3"
  fi
}
