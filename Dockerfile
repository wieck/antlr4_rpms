# ----
# postgresql-babelfish 13.5 RPM build
#
# We build this on CentOS-Stream 8 for now ... should switch to Rocky
# ----
FROM rockylinux:8.5

# Build arguments passed from the build script
ARG ANTLR4_VERSION

# Adjust NCPUS to what your max. Note that values above 16
# don't work without modifying rpmmacros
ENV HOME=/root

# Add the EPEL repository
RUN dnf install -y epel-release

# Install all build dependencies
RUN dnf install -y \
	clang-devel \
	cmake \
	git \
	java-1.8.0-openjdk \
	libuuid-devel \
	rpm-build \
	unzip

# Install Antlr4 Runtime
COPY antlr4/antlr-$ANTLR4_VERSION-complete.jar /root/rpmbuild/SOURCES/
COPY antlr4/antlr4-cpp-runtime-$ANTLR4_VERSION-source.zip /root/rpmbuild/SOURCES/

RUN ls -l /root/rpmbuild/SOURCES/

# Copy RPM spec and SOURCES
COPY antlr4.spec /root/

# Run rpmbuild
RUN	cd /root && \
	rpmbuild -bb antlr4.spec
