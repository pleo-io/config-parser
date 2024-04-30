#!/bin/bash

load_dir() {
  local result=''

  # $1, the first parameter is the directory to load files from
  if [ -d $1 ]; then
    cd $1

    # For each file in the directory, append `{FILENAME}={FILEVALUE}'\n` to result string
    for FILENAME in *; do
      # Make sure the directory is not empty
      if [ "$FILENAME" != "*" ]; then
        # Replaces underscores with dots
        KEY=$(echo $FILENAME | tr '_' '.')

        # $2, is the numbers of characters to strip in front of the key
        KEY="${KEY:$2}"

        # Removes the infrastructure.global prefix if it exists
        if [[ "$KEY" == "infrastructure.global."* ]]; then
          KEY=${KEY#"infrastructure.global."}
        fi

        APPLICATION_PREFIX="application.$3."
        # Removes the application.$application_name prefix if it exists
        if [[ $KEY =~ ^"$APPLICATION_PREFIX" ]]; then
          KEY=${KEY#"application.$3."}
        fi

        # Removes the .terraform suffix if it exists
        if [[ "$KEY" == *".terraform" ]]; then
          KEY=${KEY%".terraform"}
        fi

        VALUE=$(cat $FILENAME)
        result="${result}$KEY=$VALUE\n"
      fi
    done
  fi

  echo "$result"
}

# We have 3 directories to load env variables from:
#   1. $WORKDIR/aws-parameter-store
#   2. $WORKDIR/aws-secret

# For aws-parameter-store, we strip the first character since it's always a '_'
AWS_PARAMETER_STORE_VARS=$(load_dir "$WORKDIR/aws-parameter-store" 1 "$APPLICATION_NAME")
echo "$AWS_PARAMETER_STORE_VARS"

AWS_SECRET_VARS=$(load_dir "$WORKDIR/aws-secret" 0 "$APPLICATION_NAME")
echo "$AWS_SECRET_VARS"

ENV_VARS=""
if [ "$AWS_PARAMETER_STORE_VARS" != "" ]; then
  ENV_VARS+="$AWS_PARAMETER_STORE_VARS"
fi

if [ "$AWS_SECRET_VARS" != "" ]; then
  ENV_VARS+="$AWS_SECRET_VARS"
fi

# Do not use cat here, we use printf to render new lines in output file
printf "$ENV_VARS" > $WORKDIR/application.properties

