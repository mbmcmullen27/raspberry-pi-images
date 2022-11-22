#!/bin/bash

[ -z "$script" ] && script=ssh-enabled
cp "/home/builder/src/init-scripts/${script}.sh" /home/builder/src/init-scripts/selected.sh

update-binfmts --enable
packer build src/raspios.json
