#$1 - field
#$2 - value
add-field () {
  jq ".$1=$2" $main_json > $working_json
  cat $working_json > $main_json
  cat $main_json > $working_json
}

create-blueprint () {
  working_dir=$(mktemp -d)
  working_json=$(mktemp)
  main_json=$working_dir/migrate.json

  touch $main_json
  echo '{}' > $main_json
  echo '{}' > $working_json
  cp $0 $working_dir # Put a copy of migrate

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

    echo -ne "Type the path to the directory/file: "
    read -e path

    path=$(echo $path | sed "s+~+\$HOME+" | sed "s+\$HOME+$HOME+")
    path=$(echo "$(cd "$(dirname $path)"; pwd)/$(basename "$path")")

    mkdir $working_dir/files/$i
    rsync -ar $path $working_dir/files/$i/
    path=$(echo $path | sed "s+$HOME+\$HOME+")

    add-field "files[$i]" "\"$path\""
    i=$((i + 1))
  done

  jq . $main_json

  # Create the blueprint archive
  main_dir=$(pwd)
  pushd $working_dir > /dev/null
  tar -czvf $main_dir/$(echo $name | sed "s/ /\-/").tar.gz . > /dev/null
  popd > /dev/null

  rm -rf $working_dir
}