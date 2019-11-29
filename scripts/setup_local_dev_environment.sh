#!/usr/bin/env bash

LOGFILE_PATH="./setup_local_dev_environment_log.log"

# Print out when the script started.
echo "This script started at: ", $(date) | tee $LOGFILE_PATH

# Greet the user, inform him/her of what this script will do and the type of operating system the script is running on.
echo "Hello, $USER"   | tee -a $LOGFILE_PATH
echo "This script will install Homebrew, git and Node.js."  | tee -a $LOGFILE_PATH
echo "The current operating system this script is running on is $OSTYPE"  | tee -a $LOGFILE_PATH

# Check if application exists, if not, install it.
# Homebrew
if [[ -e $(command -v brew) ]] #=> Check if brew exists in directory
then
    echo "brew already installed" | tee -a $LOGFILE_PATH  #=> If it exists, then it will be printed out
else
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" | tee -a $LOGFILE_PATH #=> If it doesn't exist then it will be installed.
fi

# git
if [[ -e $(command -v git) ]] #=> Check if git exists in directory
then
    echo "git already installed"| tee -a $LOGFILE_PATH #=> If it exists, then it will be printed out
else
    brew install git | tee -a $LOGFILE_PATH #=> If it doesn't exist then it will be installed.
fi

# Node.js
if [[ -e $(command -v node) ]] #=> Check if node exists in directory
then
    echo "node already installed"| tee -a $LOGFILE_PATH #=> If it exists, then it will be printed out
else
    brew install node | tee -a $LOGFILE_PATH #=> If it doesn't exist then it will be installed.
fi

# Print out running version of Homebrew, git, Node.js and npm 
echo "Your version of Homebrew is: ", $(brew -v) | tee -a $LOGFILE_PATH
echo "Your version of git is: ", $(git --version) | tee -a $LOGFILE_PATH
echo "Your version of Node.js is: ", $(node -v) | tee -a $LOGFILE_PATH
echo "Your version of npm is: ", $(npm -v) | tee -a $LOGFILE_PATH

# Print out when the script ended.
echo "This script ended at: ", $(date) | tee -a $LOGFILE_PATH