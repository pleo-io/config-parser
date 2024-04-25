#!/bin/bash

# For each file in the directory, append `{FILENAME}={FILEVALUE}'\n` to result string
load_dir() {
  # $1, the first parameter is the directory to load files from
  local result=''

  cd $1
  for FILENAME in *; do
    # Make sure the directory is not empty
    if [ "$FILENAME" != "*" ]; then
      # First tr uppercases all letters
      # Second tr replaces underscores with dashes
      KEY=$(echo $FILENAME | tr '_' '.')

      # We strip the first character since it's always a '_'
      KEY="${KEY:1}"

      VALUE=$(cat $FILENAME)
      result="${result}$KEY=$VALUE\n"
    fi
  done
  
  echo "$result"
}
 
# We have 3 directories to load env variables from:
#   1. /etc/ssm
#   2. /etc/secret
SSM_VARS=$(load_dir "./etc/ssm")
SECRET_VARS=$(load_dir "./etc/secret")

ENV_VARS=""
if [ "$SSM_VARS" != "" ]; then
  ENV_VARS+="$SSM_VARS"
fi

if [ "$SECRET_VARS" != "" ]; then
  ENV_VARS+="$SECRET_VARS"
fi

# Do not use cat here, we use printf to render new lines in output file
printf "$ENV_VARS" > /etc/env/.env

