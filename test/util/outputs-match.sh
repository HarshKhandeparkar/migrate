# $1 = Script Name
# $2 = Name of Command 1
# $3 = Command 1 Output
# $4 = Name of Command 2
# $5 = Command 2 Output
outputs-match() {
  if [ "$3" == "$5" ];
  then
    echo -e "${GREEN_NO_UNDER}Commands ${ORANGE_UNDER}"$2"${NC}${GREEN_NO_UNDER} and ${ORANGE_UNDER}"$4"${NC}${GREEN_NO_UNDER} produce matching outputs ${GREEN_NO_UNDER}✓${NC}"
    sleep 0.3
  else
    echo -e "${RED_NO_UNDER}Error: outputs from commands ${ORANGE_UNDER}"$2"${NC}${RED_NO_UNDER} and ${ORANGE_UNDER}"$4"${NC}${RED_NO_UNDER} do not match ${RED_NO_UNDER}X${NC}"
    sleep 0.3
    log_error "outputs from commands '$2' and '$4' do not match" "$1" "'$2':\n$3\n\n'$4':\n$5"
  fi
}
