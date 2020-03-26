# $1 = Error Message
# $2 = Exit Code
log-error() {
  echo ""
  echo -e "${RED_FLASH}Error: $1${NC}"
  echo -e "${GREEN_NO_UNDER}Type '${ORANGE_UNDER}$script -h${NC}${GREEN_NO_UNDER}' to get a list of commands.${NC}"
  echo ""
  exit $2
}
