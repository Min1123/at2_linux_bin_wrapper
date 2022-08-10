#!/usr/bin/env bash

source bootstrap.bashconf

MISSING_DEPS=""

# Check dependencies
for i in ${DEPENDENCIES}
do
	which ${i} &> /dev/null
	if [ $? -ne 0 ]; then
		MISSING_DEPS="${MISSING_DEPS} $i"
	fi
done

if [ "x${MISSING_DEPS}" == "x" ]; then
	echo "No missing dependencies."
else
	echo "Missing dependencies: ${MISSING_DEPS}"
	exit -1
fi


if [ -a br ]; then
	echo "No need to Buildroot."
else

	if [ -a buildroot ]; then
		echo "Buildroot already cloned."
	else
		git clone ${BUILDROOT_REPO} --depth=1 -b ${BUILDROOT_VERSION}
	fi

	if [ -a buildroot/output/images/rootfs.tar ]; then
		echo "Buildroot already built."
	else
		cp -f config_files/buildroot.config buildroot/.config
		cd buildroot
			make
		cd -
	fi

	if [ -a buildroot/output/images/rootfs.tar ]; then
		echo "Buildroot build succeeded."
		mkdir -p br
		tar -xf buildroot/output/images/rootfs.tar -C br ./lib ./usr/lib
		rm -rf buildroot
	else
		echo "Buildroot did not produce a rootfs image."
		exit -2
	fi
fi

# Try to get AdTrack2 from initial site
if [ -a adtrack-2.4.24-linux-bin-debian-stretch-x86.tar.gz ]; then
	echo "AdTrack2 already downloaded."
else
	aria2c ${AT2_URL}${AT2_FILE}
fi

# Try to get back to AdTrack2 from archive.org
if [ -a adtrack-2.4.24-linux-bin-debian-stretch-x86.tar.gz ]; then
	echo "AdTrack2 already downloaded."
else
	aria2c ${AT2_AO_URL}${AT2_FILE}
fi

if [ -a adtrack2 ]; then
	echo "Archive already extracted."
else
	tar --strip-components=1 -xf ${AT2_FILE}
fi

