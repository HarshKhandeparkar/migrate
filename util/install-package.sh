#$1 - path
install-package() {
  working_dir=$(mktemp -d)

  tar -zvxf "$1" -C $working_dir > /dev/null

    if [[ $(which add-apt-repository) != "" ]] && [[ $(jq .extra_repos $working_dir/migrate.json) != "" ]];
    then
      echo "Installing apt repositories"
      for repo in $(jq .extra_repos $working_dir/migrate.json)
      do
        sudo add-apt-repository $repo
      done
    else
      echo -e "${RED_FLASH}add-apt-repository not found, this feature only works for debian based distros.${NC}"
    fi

  if [[ $(which apt) != "" ]];
  then
    echo "Installing apt packages"
    sudo apt install $(jq -r .apt_packages $working_dir/migrate.json)
  else
    echo -e "${RED_FLASH}apt not found, this feature only works for debian based distros.${NC}"
  fi

  if [[ $(which snap) != "" ]];
  then
    echo "Installing snap packages"
    sudo snap install $(jq -r .snap_packages $working_dir/migrate.json)
  else
    echo -e "${RED_FLASH}snap not found, please install snapd manually.${NC}"
  fi
}
