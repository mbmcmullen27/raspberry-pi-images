#!/bin/bash

update-binfmts --enable
packer build src/raspios.json
