#!/usr/bin/env bash

source bootstrap.bashconf

if [ -a adtrack2 ]; then
	:
else
	echo "Missing files, please run ./bootstrap.sh first."
	exit -1
fi

padsp ${QEMU_USER} -L br ./adtrack2

