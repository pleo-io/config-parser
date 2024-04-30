KEY=sputnik.endpoint

if [[ "$KEY" == "$APPLICATION_NAME."* ]]; then
  KEY=${KEY#"$APPLICATION_NAME."}
fi

printf "$KEY"