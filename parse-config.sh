#!/bin/bash

# For each file in the directory, append `{FILENAME}={FILEVALUE}'\n` to result string
load_dir() {
  local result=''
  
  # $1, the first parameter is the directory to load files from
  if [ -d $1 ]; then
    cd $1

    for FILENAME in *; do
      # Make sure the directory is not empty
      if [ "$FILENAME" != "*" ]; then
        # First tr uppercases all letters
        # Second tr replaces underscores with dashes
        KEY=$(echo $FILENAME | tr '_' '.')

        # We strip the first character since it's always a '_'
        KEY="${KEY:$2}"

        VALUE=$(cat $FILENAME)
        result="${result}$KEY=$VALUE\n"
      fi
    done
  fi

  echo "$result"
}
 
# We have 3 directories to load env variables from:
#   1. /etc/ssm
#   2. /etc/secret
SSM_VARS=$(load_dir "./etc/ssm" 1)
SECRET_VARS=$(load_dir "./etc/secret" 0)

ENV_VARS=""
if [ "$SSM_VARS" != "" ]; then
  ENV_VARS+="$SSM_VARS"
fi

if [ "$SECRET_VARS" != "" ]; then
  ENV_VARS+="$SECRET_VARS"
fi

# Do not use cat here, we use printf to render new lines in output file
printf "$ENV_VARS" > /etc/env/.env

