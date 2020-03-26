#!/bin/bash
set -e

#--------File paths--------#
root=`dirname $0`
#--------File paths--------#


source $root/util/colors.sh
source $root/util/metadata.sh
source $root/build/config.sh


build() {
  # $1 = version
  # $2 = maintainer
  # $3 = sourceURL
  version=$1
  maintainer=$2
  sourceUrl=$3

  if [ ! -d $root/dist ];
  then
    mkdir $root/dist
  fi
  if [ "$(ls $root/dist)" != "" ];
  then
    rm -R $root/dist/*
  fi

  mkdir -p $root/dist/deb/usr/local/bin
  mkdir $root/dist/deb/DEBIAN
  mkdir $root/dist/concat
  touch $root/dist/deb/DEBIAN/control
  touch $root/dist/deb/DEBIAN/copyright

  mkdir -p $root/dist/source/scripts
  mkdir $root/dist/source/concat
  mkdir $root/dist/source/util
  mkdir $root/dist/source/docs
  mkdir $root/dist/source/bin

  mkdir $root/dist/lib

  mkdir $root/dist/bin

  sourceUrl=$(echo $sourceUrl | sed 's/\//\\\//g')
  year=$(date +%Y)
  changedDate=$(date '+%a, %d %b %Y %H:%M:%S %:::z')

  sed -i "1s/.*/# $display_name v$version/" $root/README.md
  sed -i "s/version=\".*\"/version=\"v$version\"/" $root/util/metadata.sh

  cat $root/build/control | sed "s/\$version/${version}/g" | sed "s/\$maintainer/${maintainer}/g" | sed "s/\$date/${changedDate}/g" > $root/dist/deb/DEBIAN/control
  cat $root/build/copyright | sed "s/\$maintainer/${maintainer}/g" | sed "s/\$sourceUrl/${sourceUrl}/g" | sed "s/\$year/${year}/g" > $root/dist/deb/DEBIAN/copyright

  scripts=$(ls $root/scripts)
  for var in $scripts
  do
    start=$(grep -n '<external-scripts>' $root/scripts/$var | cut -d : -f1)
    end=$(grep -n '</external-scripts>' $root/scripts/$var | cut -d : -f1)
    size=$(wc -l $root/scripts/$var | cut -d ' ' -f1)

    end=$(($size - $end + 1))
    externalScripts=$(grep 'source' $root/scripts/$var | cut -d ' ' -f2)

    head -$start $root/scripts/$var > $root/dist/concat/$var

    for extScript in $externalScripts
    do
      extScript=$(echo "$extScript" | sed 's/\$dir/\.\/scripts/')
      cat $extScript >> $root/dist/concat/$var
    done

    tail -$end $root/scripts/$var >> $root/dist/concat/$var

    file=$(echo $var | sed 's/\.[^.]*$//')
    shc -r -f "$root/dist/concat/$var" -o "$root/dist/bin/$file"
  done
  rm $root/dist/concat/*.x.c
  cp $root/dist/bin/* $root/dist/deb/usr/local/bin/

  cp $root/dist/bin/* $root/dist/source/bin/
  cp $root/scripts/* $root/dist/source/scripts
  cp $root/CHANGELOG.md $root/dist/source/CHANGELOG.md
  cp $root/README.md $root/dist/source/README.md
  cp $root/LICENSE.md $root/dist/source/LICENSE.md

  cp $root/dist/concat/* $root/dist/source/concat
  cp $root/util/* $root/dist/source/util
  cp $root/build.sh $root/dist/source
  cp -r $root/docs $root/dist/source

  size=$(( $(du -cb $root/dist/deb/usr | grep total | tr -d "total" | tr -d " ") / 1024 ))
  touch $root/dist/deb/DEBIAN/control.tmp
  cat $root/dist/deb/DEBIAN/control | sed "s/\$size/${size}/g" > $root/dist/deb/DEBIAN/control.tmp
  cat $root/dist/deb/DEBIAN/control.tmp > $root/dist/deb/DEBIAN/control
  rm $root/dist/deb/DEBIAN/control.tmp

  outDpkgDeb=$(dpkg-deb -b $root/dist/deb $root/dist/lib/$package_name-$version.deb)

  pushd $root/dist/source > /dev/null
  outTar=$(tar -zcvf ../lib/$package_name-source-$version.tar.gz *)
  popd > /dev/null

  echo -e "${GREEN_NO_UNDER}"
  echo -e " ____________________________"
  echo -ne "${GREEN_NO_UNDER}"
  echo -ne "|"
  echo -ne "${GREEN_UNDER}"
  echo -ne "BUILD COMPLETED SUCCESSFULLY"
  echo -ne "${NC}"
  echo -ne "${GREEN_NO_UNDER}"
  echo -e "|"
  echo -e "${NC}"

  exit 0
}

if [ "$1" == "-h" ] || [ "$1" == "--help" ];
then
  echo -e "This script is for building $display_name.\n
  Usage:
    build.sh => Builds specified package version in '/dist'.
    build.sh -t/--no-test => Builds without running tests.
    build.sh -r/--rebuild => Rebuilds the current version without running tests.
    build.sh -h/--help => Prints this help page.
  "
  exit 0
elif [ "$1" == "-r" ] || [ "$1" == "--rebuild" ];
then

  if [ ! -d $root/dist/deb ];
  then
    echo -e "${RED_FLASH}Error: /dist/deb is required to rebuild"
    exit 3
  fi

  maintainer=$(cat $root/dist/deb/DEBIAN/control | grep Maintainer | cut -d : -f2 | tr -d " ")
  read -p "Repo URL(username/repo): " sourceUrl

  build `echo $version | tr -d "v"` $maintainer $sourceUrl
  exit 0
else
  if [ "$1" == "-t" ] || [ "$1" == "--no-test" ];
  then
    echo -e "${RED_FLASH}WARNING: TESTS NOT RUN${NC}"
  else
    echo -e "
  ${ORANGE_NO_UNDER}|STARTING TESTS|${NC}
    "
    sleep 0.8

    $root/test/test.sh
    testExit=$(echo $?)

    if [ "$testExit" != "0" ];
    then
      exit 1
    fi
  fi

  echo -e "Current Version: ${ORANGE_UNDER}$version${NC}"
  read -p "New Version: " version

  version=$(echo $version | tr -d "v")

  read -p "Maintainer Name: " maintainer
  read -p "Source URL: " sourceUrl

  build $version $maintainer $sourceUrl
fi

exit
