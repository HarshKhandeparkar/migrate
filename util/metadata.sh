version="v1.0.0"
scripts="script_1" # separated by comma and a space

# The General Help Page of Any Script
print_help() {
  echo -e " $desc

  Options:
$options

  This script is a part of the Migrate project <https://github.com/HarshKhandeparkar/migrate>.
  Other scripts included in this package are `echo $(echo $scripts | sed "s/$script\,\s//")`.
  Type \"[script-name] -h\" to get more specific information.
   "
}
