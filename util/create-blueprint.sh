#$1 - field
#$2 - value
add-field () {
  jq ".$1=$2" $main_json > $working_json
  cat $working_json > $main_json
  cat $main_json > $working_json
}

filesAdded=0
add-file() {
  path="$1"

  path=$(echo $path | sed "s+~+\$HOME+")
  fileName=$(basename "$path")
  path=$(echo "$(cd "$(dirname $path)"; pwd)")

  mkdir $working_dir/files/$filesAdded
  sudo rsync -rlptD "$path/$fileName" $working_dir/files/$filesAdded/
  path=$(echo $path | sed "s+$HOME+\$HOME+")

  add-field "files[$filesAdded]" "\"$path\""
  filesAdded=$((filesAdded + 1))
}

create-blueprint () {
  working_dir=$(mktemp -d)
  working_json=$(mktemp)
  main_json=$working_dir/migrate.json

  touch $main_json
  echo '{}' > $main_json
  echo '{}' > $working_json

  echo $0
  add-field 'version' 1

  echo -ne "What is the name of the migrate blueprint?: "
  read -e name
  add-field "name" "\"$name\""

  echo -ne "Enter any extra apt repositories/ppas that are required, separated by spaces(leave empty for none): "
  read -e apt_repos
  add-field "apt_repos" "\"$apt_repos\""

  echo -ne "Enter all the required apt packages, separated by spaces(leave empty for none): "
  read -e apt_packages
  add-field "apt_packages" "\"$apt_packages\""

  echo -ne "Enter all the required snap packages, separated by spaces(leave empty for none): "
  read -e snap_packages
  add-field "snap_packages" "\"$snap_packages\""

  add-field "files" "[]"
  mkdir $working_dir/files

  i=0
  while true;
  do
    echo -ne "Do you want to migrate a file/directory [y/N]?: "
    read -e yN

    case $yN in
      [yY][eE][sS]|[yY])
        ;;
      [nN][oO]|[nN])
        break
        ;;
      *)
        continue
        ;;
    esac

    sudo echo -n ""

    echo -ne "Type the path to the directory/file: "
    read -e path
    add-file "$path"
  done

  if [[ $(which gsettings) != "" ]];
  then
    echo -ne "GNOME Shell Found. Should the themes be migrated [y/N]?: "
    read -e doMigrateGnomeThemes

    case $doMigrateGnomeThemes in
      [yY][eE][sS]|[yY])
        echo -e "Migrating GNOME shell themes."

        add-field '"gnome-settings"' "{
          \"gtk-theme\": \"$(gsettings get org.gnome.desktop.interface gtk-theme)\",
          \"icon-theme\": \"$(gsettings get org.gnome.desktop.interface icon-theme)\",
          \"cursor-theme\": \"$(gsettings get org.gnome.desktop.interface cursor-theme)\",
          \"sound-theme\": \"$(gsettings get org.gnome.desktop.sound theme-name)\"
        }"

        add-file "~/.themes"
        add-file "/usr/share/themes"
        ;;
    esac
  fi

  jq . $main_json

  # Create the blueprint archive
  main_dir=$(pwd)
  pushd $working_dir > /dev/null
  tar -czvf $main_dir/$(echo $name | sed "s/ /\-/").tar.gz . > /dev/null
  popd > /dev/null

  rm -rf $working_dir
}
