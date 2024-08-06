#!/bin/bash

log() {
  # UTC time
  TIME=$(date -u +"%FT%TZ")

  # $1 is the message to log passed as the first - and only - function paramter
  echo "time=\"${TIME}\" level=INFO msg=\"$1\""
}

load_dir() {
  local result=''

  # $1, the first parameter is the directory to load files from
  if [ -d $1 ]; then
    cd $1

    # For each file in the directory, append `{FILENAME}={FILEVALUE}'\n` to result string
    for FILENAME in *; do
      FILE_LINE_COUNT=$(wc -l <$FILENAME)
      
      # Make sure the directory is not empty AND that it's not multi-lined      
      if [[ "$FILENAME" != "*" && $(($FILE_LINE_COUNT > 1)) == 0 ]]; then
        # Replaces underscores with dots
        KEY=$(echo "$FILENAME" | tr '_' '.')

        # $2, is the numbers of characters to strip in front of the key
        KEY="${KEY:$2}"

        # Removes the infrastructure.global prefix if it exists
        if [[ "$KEY" == "infrastructure.global."* ]]; then
          KEY=${KEY#"infrastructure.global."}
        fi

        # Removes the application.global prefix if it exists
        if [[ "$KEY" == "application.global."* ]]; then
          KEY=${KEY#"application.global."}
        fi
        
        # Removes the application.$application_name prefix if it exists
        if [[ "$KEY" == "application.$APPLICATION_NAME."* ]]; then
          KEY=${KEY#"application.$APPLICATION_NAME."}
        fi

        # Removes the .terraform suffix if it exists
        if [[ "$KEY" == *".terraform" ]]; then
          KEY=${KEY%".terraform"}
        fi

        log "source=$FILENAME destination=$KEY"
        
        VALUE=$(cat "$FILENAME")
        RESULT="${result}$KEY=$VALUE"
        printf "%s\n" "$RESULT" >> $WORKDIR/application.properties
      fi
    done
  fi
}

# We have 3 directories to load env variables from:
#   1. $WORKDIR/aws-parameter-store
#   2. $WORKDIR/aws-secret

# For aws-parameter-store, we strip the first character since it's always a '_'
log "Loading AWS Parameter Store variables..."
load_dir "$WORKDIR/aws-parameter-store" 1
log "Loaded AWS Parameter Store variables"

log "Loading AWS Secret variables..."
load_dir "$WORKDIR/aws-secret" 0
log "Loaded AWS Secret variables"
