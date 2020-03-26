# Boilerplate v1.0.0
(Read more about this ^^^ ahead)
(Feel free to change this README but keep the first line while replacing `Boilerplate` with the name of your script stack)

## bash-script-stack-boilerplate
A boilerplate/framework that provides all the essential tools for writing, testing, building and packaging BASH script stacks for Linux and other OSes.

### Table of Contents
1. [Structure](#structure)
2. [Essential Util Scripts](#essential-util-scripts)
3. [Script Format](#script-format)
4. [Building](#building)
5. [Testing](#testing)
6. [Foot Note](#foot-note)

### Structure
- **scripts**: This directory contains all the scripts of the stack. An example script `script_1` has been placed inside this directory. Read more about the [format](#script-format) of the script.
- **util**: This directory contains any util `.sh` files that may be required by more than one script. There are two [essential](#essential-util-scripts) util scripts and one example script `log-error.sh` has been placed inside this directory. These util scripts can contain any BASH code and can be accessed in other scripts using the `source` command. Read more about [using](#script-format) util scripts.
- **build**: This directory contains essential config files for [building](#building) the package.
- **test**: This directory contains the config file, the `test.sh` file and the `tests/` directory for [testing](#testing) the scripts.
- **docs**: This directory contains the documentation for the project in `.md` files.
  - **scripts**: Documentation for individual scripts. An example doc file for the example script `script_1` has been placed here.
- **CHANGELOG.md**; An example CHANGELOG file. You can edit the format as you wish.
- **LICENSE.md**: You have to replace the contents of this file by your LICENSE.
- **.gitignore**: The two directories `dist/` which is generated while [building](#building) and `tests-log/` which is generated while [testing](#testing) are recommended to be added to this file.
- **build.sh**: This file is used for [building](#building) the project.

**NOTE**: You can change the basic structure but you will have to make corresponding changes to the `test.sh` and `build.sh` files.


### Essential Util Scripts
Some essential util scripts are used by all the scripts, `build.sh` and `test.sh` files:

1. **metadata.sh**: This file contains essential variables and functions which are related to script/project metadata. An example in  the `metadata.sh` file is included.
  - **version**: The current version of the project as a string. This string is updated while [building](#building).
  - **scripts**: This is a string containing names of all the scripts included in the project separated by a comma followed by a space. e.g.: `script1, script2, script3`.
  - **print_help**: This is a recommended but non-essential function that can be used inside other scripts to display help pages efficiently.

2. **colors.sh**: This file (included) contains some essential [ANSI color code](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux) variables that are used by `test.sh`, `build.sh` and can be used by the scripts to fill the terminal with colors. You are free to add your colors but the default ones are essential.


### Script Format
Each script has some essential format components. You can write the rest of the script as you like. An example script `script_1` is included.
Every script has to have the `.sh` extension for consistency. The extension does not affect any functionality.

#### Essential Parts
1. **`dir` variable**: The line `dir=$(dirname $0)` has to be at the top of every script file after the [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)). This variable stores the path to the `scripts/` directory. This path will be used later to `source` files with the correct path.

2. **External Scripts**: All the `source` commands of the file should be placed after the `dir` variable initialization and between these two exact comments `#<external-scripts>#` and `#</external-scripts>#`. These two comments will be used in [building](#building) the project. All the source files should be imported relative to the `scripts/` directory using the `dir` variable. e.g.: `source $dir/../util/color.sh` imports the colors util file.
All the paths are relative to the `scripts/` directory so that the script can be executed from any other directory. e.g.: if the terminal is in the root of the project, running `./scripts/script_1.sh` will import the correct util file and no path errors will be shown.

#### Optional Parts
1. **`script` variable**: This is string variable containing the name of the script without any extensions. e.g.: `name="script_1"`. This variable can be useful if general help pages are displayed using the `print_help` function in the `metadata.sh` [util script](#essential-util-scripts).

2. **`options` variable**: This is a string containing all the options i.e. the arguments the script can be run with. This will be displayed with the help page using the `print_help` function in the `metadata.sh` [util script](#essential-util-scripts). e.g.: Read the `scripts/script_1.sh` file.

3. **`desc` variable**: This is a string variable containing a description for the script. This will be displayed with the help page using the `print_help` function in the `metadata.sh` [util script](#essential-util-scripts).


### Building
**NOTE**: The `build.sh` script uses the tools [shc](https://github.com/neurobin/shc), [dpkg-deb](https://blog.knoldus.com/create-a-debian-package-using-dpkg-deb-tool/) and [tar](https://www.howtoforge.com/tutorial/linux-tar-command/) which have to be installed on your system before use.

The `build.sh` script allows you to package your script stack into a `.deb` Debian archive containing compiled scripts for Debian based systems and a `.tar.gz` compressed archive containing the source code of the scripts to be installed on other systems. Support for other output package formats will be coming soon.

#### Output
The output goes to a gitignored directory `dist/` which has the following format:
1. **concat**: Scripts with concatenated imports. More on this below.
2. **bin**: The compiled binary scripts. More on this below.
2. **deb**: The precursor for building the `.deb` archive. More on this below.
3. **lib**: The final directory which contains the `.deb` archive and `.tar.gz` archive.
4. **source**: The contents of the source archive. More on this below.

#### The `build.sh` Script
The build script has the following options:
1. *Default(no option)*: Runs tests, and builds the complete project.
2. `--help/-h`: Displays the help page.
3. `-t/--no-test`: Builds the complete project without running tests.
4. `-r/--rebuild`: Does not run tests and only rebuilds the output packages. (Provided that the project was built before and the `dist/deb/` directory was preserved)

**NOTE**: This script is independent of the rest of the project. This means that if you want to download a newer version of this script, you can just replace it.

#### Build Process
When the project is built, the `build.sh` script does the following:
1. **Runs Tests**: Runs all the script [tests](#testing). If the tests fail, the further building process is stopped. (This step can be skipped by using the option `-t` or `--no-test`)

2. **Version Prompt**: It displays the current version of the script and prompts the user to enter the new version number if you have made any amendments. If the source has not changed, you can enter the same version number as before. (press `enter` to proceed) (The entered version number can have a `v` at the beginning but it is not necessary)

3. **Maintainer Name Prompt**: It prompts the user to enter the name of the maintainer. You can enter your name, your internet display name or whatever. This will be used as the [maintainer field](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-maintainer) of the Debian [control file](https://www.debian.org/doc/debian-policy/ch-controlfields.html). (press `enter` to proceed)

4. **Source URL Prompt**: It prompts the user to enter the URL to the upstream source code of the repository. This is not used by default but can be required in the copyright file. This value replaces the placeholder `$sourceUrl`. More on this in step 7.

4. **Creates `dist` Directory**: It creates/replaces the content of the build directory.

5. **Changes README Version**: It edits the first line of the README.md file and changes the version number to the latest.

6. **Changes `metadata.sh` Version**: It changes the value of the `version` variable in the `metadata.sh` [util](#essential-util-scripts) script.

7. **Prepares the DEBIAN Directory**: The `DEBIAN` directory of the `.deb` archive precursor contains the [control](https://www.debian.org/doc/debian-policy/ch-controlfields.html) and [copyright](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/) files. The template for these files is placed in the `build/` directory. In these templates, there can be placeholders like `$maintainer`, `$size`, `$year` and `$date` which are automatically replaced by the `build.sh` script and the final `control` and `copyright` files are placed in the `DEBIAN/` directory in `dist/deb/DEBIAN/`. The placeholders:
 - `$year`: The year at the time of building.
 - `$date`: The date at the time of building in the format `Day, Date Month Year Hours:Minutes:Seconds Timezone`. e.g.: `Mon, 23 Mar 2020 20:16:17 +05:30`. This is the same format that is used in the [date field](https://www.debian.org/doc/debian-policy/ch-controlfields.html#date) of the Debian [control file](https://www.debian.org/doc/debian-policy/ch-controlfields.html).
 - `$maintainer`: The maintainer name that was prompted. (Required in the control file and sometimes copyright)
 - `$sourceUrl`: The URL to the upstream source code of the project. (Sometimes required for copyright) (P.S. This field is not used by default but can be useful)
 - `$size`: The size of the scripts when installed, in [Mebibytes](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=16&cad=rja&uact=8&ved=2ahUKEwiBq7jR7LDoAhXYIbcAHZv2C6cQFjAPegQIAhAB&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FMebibyte&usg=AOvVaw27B2LLQir1mBoteMkloogg). This is the same format that is used for the [Installed-Size field](https://www.debian.org/doc/debian-policy/ch-controlfields.html#s-f-installed-size) of the Debian [control file](https://www.debian.org/doc/debian-policy/ch-controlfields.html).

8. **Concatenates Imports**: The imported scripts using the `source` in the [script format](#script-format) are concatenated to the script which has the `source` command. The code from these imported files is copied and pasted between the `#<external-scripts>#` and `#</exteral-scripts>#` comments in the [script format](#script-format). The concatenated script files are placed in the `dist/concat/` directory with the `.sh` extension.

9. **Compiles into Binary**: It compiles the concatenated scripts in `dist/concat/` directory into binary files using a tool called [shc](https://github.com/neurobin/shc). `shc` is run with the `-r` flag which makes the scripts redistributable.

10. **Copies the `bin` Files**: The binary files in `dist/bin/` are copied into the `dist/deb/usr/local/bin/` to install the scripts on the system through the `.deb` archive.

11. **Prepares the Source Archive**: The following files and directories are copied into the `dist/source/` directory:
 - **README.md**
 - **LICENSE.md**
 - **CHANGELOG.md**
 - **build.sh**
 - **docs/**
 - **scripts/**
 - **util/**
 - **dist/bin/** as **source/bin/**
 - **dist/concat/** as **source/concat/**

14. **Builds the Debian Package**: The `.deb` package in `dist/deb/` is packaged using the tool [dpkg-deb](https://blog.knoldus.com/create-a-debian-package-using-dpkg-deb-tool/) in the `dist/lib/` directory under the name `[package_name]-[version].deb`. Here `[package_name]` is replaced by the package name in `build/config.sh` and `[version]` is replaced by the user entered version name, without a `v`.

13. **Builds the Source Archive**: The [tar](https://www.gnu.org/software/tar/) tool is used to package the `dist/source/` directory into the `dist/lib/` directory under the name `[package_name]-[version].tar.gz`. Here `[package_name]` is replaced by the package name in `build/config.sh` and `[version]` is replaced by the user entered version name, without a `v`.

#### With `-t` or `--no-tests` Options
The [build process](#build-process) is started from step 2.

#### With `-r` or `--rebuild` Options
The [build process](#build-process) is started from step 4. The package is built under the current version from `util/metadata.sh` and the maintainer name is taken from the `dist/deb/DEBIAN/control` file. Hence, without that file, the package cannot be rebuilt.


### Testing
This framework provides some util scripts in `test/util/` directory and a `test/test.sh` script to write tests for your scripts in `scripts/` directory. The configuration variables are stored in `test/config.sh` and the tests are stored in `test/tests/[script_name]/test.sh`.

**NOTE**: These util scripts and `test.sh` are independent of the rest of the project. This means that you can replace them with a newer version at any point.

####  Config File
The config file in `test/config.sh` stores some essential variables that are used by `test/test.sh` while running the tests. An example file is placed in `test/`. The following variables are required:
 - **tests_list**: This is a string variable with a list of names of scripts that have tests written in `test/tests/` directory. Each name is separated by a comma followed by a space. e.g.: `scr1, scr2, scr6`.

#### The `test/test.sh` Script
The `test/test.sh` script has the following options:
1. *Default(no option)*: Runs all the available tests.
2. `--help/-h`: Displays the help page.
3. `-a/--all`: Runs all the available tests.
4. `[script-name]`: Runs the test for the specified script only.

This script initializes the following variables:
- `root`: The path to the root directory of the project. The directory in which the `test` and `scripts` directories are situated.
- `scripts`: The path to the `scripts/` directory.
- `tests`: The path to the `test/tests/` directory.
- `util`: The path to the `test/tests/util/` directory. [Read More](#test-util-functions).

These variables are accessible in the individual `test.sh` files in `test/tests/` directory.

The `test/test.sh` file creates a logfile in `tests-log/` directory which is created if it does not exist. The name of this logfile is of the format `test-[date]-[month]-[year]-[hours]:[minutes]:[seconds].log`. e.g.: `test-23-March-2020-18:29:32.log`.

The `test/test.sh` also declares a function called `log-error` which can be used by the tests in `test/tests/` and the [util funcions](#test-util-functions) in `test/util/`.

#### Writing a Test
The test for a specific script has to be written in a new directory under `test/tests/` with the same name as that of the script. An example test is included.

Each test directory must contain a `test.sh` file. This is the entry point for the test. Any extra files can be created in the directory and imported using the `source` command but the paths have to be relative to the `root`, `scripts`, `tests` and `util` variables declared in the `test/test.sh` file.

The `test.sh` file must declare the following two functions:
1. **[script_name]-test**: Here `[script_name]` has to be replaced by the name of the script. This function runs all the commands on the script and the outputs can be stored in variables. These variables will be processed in the next function. This function can return a verbose output. An example function is in `test/tests/script_1/test.sh`.

2. **[script_name]-result**: Here `[script_name]` has to be replaced by the name of the script. This function interprets the output and variables that were declared in the first function and decides whether the tests passed or failed. The [util functions](#test-util-functions) in `tests/util/` are helpful here. An example function is in `test/tests/script_1/test.sh`.


#### The `log-error` function
The log-error function declared in the `test/test.sh` script is used to log any test failures to the logfile created by the `test/test.sh` script. This function is used my the [util function](#test-util-functions)

#### Test Util Functions
This test framework provides three util scripts that export functions that can be used in the second function above. The arguments for each function are explained in their respective files in comments.

- **exit-status.sh**: If the exit status of a script command is stored in a variable (example in `test/tests/script_1/test.sh`) in the first function of the [test.sh](#writing-a-test) file, this function can be used to check whether the exit status is 0 or not. This function returns a verbose output and logs test failures to the logfile.

- **produces-output.sh**: If the output of a script command is stored in a variable (example in `test/tests/script_1/test.sh`) in the first function of the [test.sh](#writing-a-test) file, this function can be used to check whether the command returns an output or not. This function returns a verbose output and logs test failures to the logfile.

- **outputs-match.sh**: If the outputs of two commands like `-h` and `--help` are stored in two separate variables in the first function of the [test.sh](#writing-a-test) file, this function can be used to check whether the outputs are the same. This function returns a verbose output and logs test failures to the logfile.

Util files apart from these can be created and used by the user, as per the need.

****
### Foot Note
(Written on 23 March 2020)

It all started when I started writing BASH scripts to make my life easier. The project grew and I thought that I should post it on GitHub so that I never lose it. I started building `.deb` packages for it and the [BashInTheBin](https://github.com/HarshKhandeparkar/bashinthebin) Project was born.
Since I had to go through the build process each time I made a change, I thought of automating it and created the `build.sh` file. I had built a complete "BASH script stack" as I like to call it.

Over the years, I got the idea of making a new project, [GitShot](https://github.com/HarshKhandeparkar/gitshot). This project used the same framework as BashInTheBin, in fact, I just copied the code. There are remains of BashInTheBin in GitShot to this date :sweat_smile: (I fixed one a few hours ago).

Today, 23 March 2020, I thought of creating a new project called [Hopificate](https://github.com/HarshKhandeparkar/hopificate). I had to go through the tedious process of copying all the files from GitShot or BashInTheBin and then renaming some things. I also realized that the build scripts for BashInTheBin and GitShot were slightly different. Also, when I fixed a bug in one of them, I had to fix it in the other. There was no uniformity. I was frustrated.

Then, I decided, that I will make this framework a standalone boilerplate and the [BASH Script Stack Boilerplate](https://github.com/HarshKhandeparkar/bash-script-stack-boilerplate) was born.


If you used this boilerplate to make your own script stack, then please let me know by opening an issue for it. I will be very happy to see that my stupid work was helpful to others.

I am Open Sourcing this framework with no License whatsoever. You can do whatever you want with it.

> Open Source By Harsh Khandeparkar
