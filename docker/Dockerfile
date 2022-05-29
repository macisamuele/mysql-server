FROM ubuntu:latest

# Setup initial dependencies
RUN set -eux \
    && apt-get update \
    && apt-get install -y \
        build-essential \
        ccache \
        cmake \
        curl \
        git \
        libaio-dev \
        libbison-dev \
        libcurl4-openssl-dev \
        libfido2-dev \
        libgoogle-perftools-dev \
        libjemalloc-dev \
        libkrb5-dev \
        libldap-dev \
        libncurses-dev \
        libnuma-dev \
        libsasl2-dev \
        libsasl2-modules-gssapi-mit \
        libtirpc-dev \
        libudev-dev \
        pkg-config \
        rapidjson-dev \
        rpcsvc-proto \
        tmux \
    && apt-get clean \
    && rm --recursive --force /var/lib/apt/lists/*

# Configure ccache
ENV CCACHE_DIR=/ccache
VOLUME /cache
ENV PATH="/usr/lib/ccache:${PATH}"

# Setup Boost
RUN set -eux \
    && curl \
        --location \
        https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_1_77_0.tar.gz \
        -o \
        /tmp/boost.tar.gz \
    && tar -xf /tmp/boost.tar.gz -C / \
    && mv /boost_1_77_0 /boost \
    && rm /tmp/boost.tar.gz 

# Setup OpenSSL
RUN set -eux \
    && curl \
        --location \
        https://www.openssl.org/source/openssl-1.1.1o.tar.gz \
        -o \
        /tmp/openssl-1.1.1o.tar.gz \
    && tar -xf /tmp/openssl-1.1.1o.tar.gz -C / \
    && cd /openssl-1.1.1o && ./config && cd - \
    && make -C /openssl-1.1.1o -j 6 \
    && make -C /openssl-1.1.1o install \
    && rm --recursive /openssl-1.1.1o \
    && rm /tmp/openssl-1.1.1o.tar.gz

# Clone repository
RUN set -eux \
    && git clone \
        --depth 1 \
        --branch maci-docker-setup \
        https://github.com/macisamuele/mysql-server \
        /code

# Setup project
RUN set -eux \
    && mkdir /build \
    && cd /build \
    && cmake /code \
        -DFORCE_INSOURCE_BUILD=1 \
        -DWITH_BOOST=/boost

# First project build
RUN set -eux \
    && make -j 4 -C /build
