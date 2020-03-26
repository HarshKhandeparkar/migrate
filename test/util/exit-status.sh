# $1 = Script Name
# $2 = Command
# $3 = Command Output
# $4 = Exit Status

exit-status () {
  if [ "$4" == "0" ];
  then
    echo -e "${GREEN_NO_UNDER}command ${ORANGE_UNDER}"$2"${GREEN_NO_UNDER} exits with status "$4" ${GREEN_NO_UNDER}✓${NC}"
    sleep 0.3
  else
    echo -e "${RED_NO_UNDER}Error: command ${ORANGE_UNDER}"$2"${NC}${RED_NO_UNDER} exits with status "$4" ${RED_N0_UNDER}X${NC}"
    sleep 0.3
    log_error "Command "$2" exits with status '$4'" "$1" "$3"
  fi
}
