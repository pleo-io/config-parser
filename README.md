## Overview
The `parse-env.sh` script is used as an init container to create a `.env` file from other config files. In our current setup, these other config files are K8S secrets mounted as volumes. The format of the resulting `.env` file is a traditional `KEY=VALUE` text file, with each entry being seperated by a new line. This way, applications need to be only aware of one file to load its configuration. Aside from the bundling, the script also formats the key to standardise naming.

Note that for the moment we only parse one other config file coming from SSM, but we might add other later.