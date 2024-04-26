#!/bin/bash

load_dir() {
  local result=''

  # $1, the first parameter is the directory to load files from
  # if [ -d $1 ]; then
  cd $1

  # For each file in the directory, append `{FILENAME}={FILEVALUE}'\n` to result string
  for FILENAME in *; do
    # Make sure the directory is not empty
    if [ "$FILENAME" != "*" ]; then
      # First tr uppercases all letters
      # Second tr replaces underscores with dashes
      KEY=$(echo $FILENAME | tr '_' '.')

      # $2, is the numbers of characters to strip in front of the key
      KEY="${KEY:$2}"

      VALUE=$(cat $FILENAME)
      result="${result}$KEY=$VALUE\n"
    fi
  done
  # fi

  echo "$result"
}

# We have 3 directories to load env variables from:
#   1. $WORKDIR/ssm
#   2. $WORKDIR/secret

echo "hi"

# For SSM, we strip the first character since it's always a '_'
SSM_VARS=$(load_dir "$WORKDIR/ssm" 1)

echo "$SSM_VARS"

SECRET_VARS=$(load_dir "$WORKDIR/secret" 0)

echo "$SECRET_VARS"

ENV_VARS=""
if [ "$SSM_VARS" != "" ]; then
  ENV_VARS+="$SSM_VARS"
fi

if [ "$SECRET_VARS" != "" ]; then
  ENV_VARS+="$SECRET_VARS"
fi

# Do not use cat here, we use printf to render new lines in output file
printf "$ENV_VARS" > $WORKDIR/.env

