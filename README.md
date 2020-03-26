# Migrate v0.0.0
[![GitHub version](https://github-basic-badges.herokuapp.com/release/HarshKhandeparkar/migrate.svg)](https://github.com/HarshKhandeparkar/migrate/releases/latest)
 [![GitHub downloads](https://github-basic-badges.herokuapp.com/downloads/HarshKhandeparkar/migrate/total.svg)](https://github.com/HarshKhandeparkar/migrate/releases/latest)

This tool will migrate all of your configuration files, settings, themes, applications and favourite files from one installation to another with a few commands. Favourite of the Distro Hoppers!

### Table of Contents
- [Examples](#examples)
- [Prerequisites](#prerequisites)
- [Installation](#installation)


### Prerequisites
1. [curl](https://www.tecmint.com/install-curl-in-linux/)
2. [jq](https://stedolan.github.io/jq/download/)


### Installation
There are two ways of installing this tool - [Using Debian Package](#debian-package) (For Debian Based OSes) **OR** [From Tarball](#tarball) (Any OS)

#### Debian Package
[Debian Packages](https://www.madebymany.com/stories/what-is-a-debian-package) with `.deb` extension can be used to install Migrate with a few clicks or a single terminal command.

Download the `.deb` package of any version in the [GitHub Releases](https://github.com/HarshKhandeparkar/migrate/releases/) or use the command below to download the latest one.

```bash
wget $(curl https://api.github.com/repos/HarshKhandeparkar/migrate/releases/latest | jq '.assets[].browser_download_url' | grep .deb | tr -d \")
```

You can install this debian package either by double-clicking it or using `dpkg` as shown below. (This requires root privileges)
```bash
sudo dpkg -i /path/to/package.deb
```

#### Tarball
A compressed archive with extension `.tar.gz` created with the tool `tar` is included in the [GitHub Releases](https://github.com/HarshKhandeparkar/migrate/releases/). The tarball includes the README, LICENSE, Source Code etc. You can download one from GitHub or use the command below to download the latest.

```bash
wget $(curl https://api.github.com/repos/HarshKhandeparkar/migrate/releases/latest | jq '.assets[].browser_download_url' | grep .tar.gz | tr -d \")
```

You can uncompress the tarball (in a new directory) by double-clicking it or using the following command.
```bash
tar -xzf /path/to/tarball.tar.gz -C /path/to/extract/to/
```

The tarball includes compiled [binary scripts](#binary-scripts) as well as the [source code](#source-code).

##### Binary Scripts
The binary scripts are stored in the `bin/` directory.
You can install the files for a single user by copying the files into the `~/bin/` directory.
This directory may not be created by default so you will have to create it first.

You can install the scripts using the following command in the directory where the tarball was extracted.
```bash
cp ./bin/* $HOME/bin/
```

To install the scripts globally, you can copy them into the `/usr/local/bin/` directory of the system using the following command in the directory where the tarball was extracted. (This requries root privileges)
```bash
sudo cp ./bin/* /usr/local/bin/
```

##### Source Code
The final source code for the scripts is included in the `concat/` directory. The scripts in this directory can be used directly but are not compiled to binary. It is recommended that non-binary files should be installed for a single user in the `~/bin/` directory.
This directory may not be created by default so you will have to create it first.

You can install the scripts using the following command in the directory where the tarball was extracted.
```bash
cp ./concat/* $HOME/bin/
```


> Open Source By Harsh Khandeparkar
