#!/bin/sh

# ----
# build-antlr4-rpms.sh
# ----
ANTLR4_VERSION="4.9.3"

# Remember the current working directory
CURDIR="$(pwd)"
TMPDIR="$(pwd)/tmp"
CFGDIR="$(dirname $1)"

# Location of the local git clone of repositories
BABELFISH_ENG_REPO="./babelfishpg_engine"
BABELFISH_EXT_REPO="./babelfishpg_extensions"

# Cleanup from previous builds
rm -rf RPMS
#rm -rf "${TMPDIR}"
#mkdir -p "${TMPDIR}"

# Download Antlr4 components on demand
ANTLR4_JAR="antlr-${ANTLR4_VERSION}-complete.jar"
ANTLR4_ZIP="antlr4-cpp-runtime-${ANTLR4_VERSION}-source.zip"
ANTLR4_JAR_URL="https://www.antlr.org/download/${ANTLR4_JAR}"
ANTLR4_ZIP_URL="https://www.antlr.org/download/${ANTLR4_ZIP}"
mkdir -p antlr4
if [ -f "./antlr4/${ANTLR4_JAR}" ] ; then
	echo "Using existing ./antlr4/${ANTLR4_JAR}"
else
	echo "Downloading ${ANTLR4_JAR_URL} as ./antlr4/${ANTLR4_JAR}"
	curl "${ANTLR4_JAR_URL}" --output "./antlr4/${ANTLR4_JAR}" || exit 1
fi
if [ -f "./antlr4/${ANTLR4_ZIP}" ] ; then
	echo "Using existing ./antlr4/${ANTLR4_ZIP}"
else
	echo "Downloading ${ANTLR4_ZIP_URL} as ./antlr4/${ANTLR4_ZIP}"
	curl "${ANTLR4_ZIP_URL}" --output "./antlr4/${ANTLR4_ZIP}" || exit 1
fi

# Now it is time to actually run the rpmbuild inside a docker image build.
podman build -t antlr4-rpmbuild \
	--build-arg ANTLR4_VERSION="${ANTLR4_VERSION}" \
	. 2>&1 | tee podman-build-antlr4.log

# Create a container with that image and extract the Babelfish
# Engine RPMs from that. 
echo "Extracing RPM files"
mkdir RPMS || exit 1
id=$(podman create localhost/antlr4-rpmbuild) || exit 1
podman cp "${id}:/root/rpmbuild/RPMS/." ./RPMS/ || exit 1
podman rm "${id}"
echo "RPMs built:"
ls -lhR --color=auto RPMS
