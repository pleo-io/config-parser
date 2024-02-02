#!/bin/bash

# For each file in the directory, append `{FILENAME}={FILEVALUE}'\n` to result string
load_ssm_files() {
  # $1, the first parameter is the directory to load files from
  local result=''

  cd $1
  for FILENAME in *; do
    # Make sure the directory is not empty
    if [ "$FILENAME" != "*" ]; then
      # First tr uppercases all letters
      # Second tr replaces underscores with dashes
      KEY=$(echo $FILENAME | tr '[a-z]' '[A-Z]' | tr '_' '-')
      
      # We strip the first character since it's always a '-'
      KEY="${KEY:1}"

      VALUE=$(cat $FILENAME)
      result+="$KEY=$VALUE\n"
    fi
  done
  
  echo "$result"
}

SSM_VARS=$(load_ssm_files "./etc/ssm")

# Do not use cat here, we use printf to render new lines in output file
printf "$SSM_VARS" > /etc/env/.env

