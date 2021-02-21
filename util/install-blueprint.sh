#$1 - path
install-blueprint() {
  working_dir=$(mktemp -d)

  tar -zvxf "$1" -C $working_dir > /dev/null

  if [[ $(which add-apt-repository) != "" ]];
  then
    if [[ $(jq -r .apt_repos $working_dir/migrate.json) != "" ]];
    then
      echo "Installing apt repositories"
      for repo in $(jq .apt_repos $working_dir/migrate.json)
      do
        sudo add-apt-repository $repo
      done
    fi
  else
    echo -e "${RED_FLASH}add-apt-repository not found, this feature only works for debian based distros.${NC}"
  fi

  if [[ $(which apt) != "" ]];
  then
    if [[ $(jq -r .apt_packages $working_dir/migrate.json) != "" ]];
    then
      echo "Installing apt packages"
      sudo apt install $(jq -r .apt_packages $working_dir/migrate.json)
    fi
  else
    echo -e "${RED_FLASH}apt not found, this feature only works for debian based distros.${NC}"
  fi

  if [[ $(which snap) != "" ]];
  then
    if [[ $(jq -r .snap_packages $working_dir/migrate.json) != "" ]];
    then
      echo "Installing snap packages"
      sudo snap install $(jq -r .snap_packages $working_dir/migrate.json)
    fi
  else
    echo -e "${RED_FLASH}snap not found, please install snapd manually.${NC}"
  fi

  if [[ $(jq '.files | length' $working_dir/migrate.json) != 0 ]];
  then
    echo -e "Migrating files."
    echo -e "Please enter sudo password. May be required to transfer some files properly."
    sudo echo -n ""

    i=0
    while true;
    do
      path=$(jq -r ".files[$i]" $working_dir/migrate.json)
      if [[ $path == null ]];
      then
        break
      fi

      path=$(echo $path | sed "s+\$HOME+"$HOME"+")

      sudo rsync -rlptD $working_dir/files/$i/ "$path/"

      i=$((i + 1))
    done
  fi
}
