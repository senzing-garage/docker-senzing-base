ARG BASE_IMAGE=debian:9
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-05-01

LABEL Name="senzing/senzing-base" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      build-essential \
      checkinstall \
      curl \
      gnupg \
      jq \
      libbz2-dev \
      libc6-dev \
      libffi-dev \
      libgdbm-dev \
      libncursesw5-dev \
      libreadline-gplv2-dev \
      libssl-dev \
      libsqlite3-dev \
      lsb-core \
      lsb-release \
      postgresql-client \
      python-dev \
      python-pip \
      sqlite \
      tk-dev \
      wget \
      vim \
      zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# Install Python 3.7

WORKDIR /usr/src
RUN wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz \
 && tar xzf Python-3.7.3.tgz \
 && cd Python-3.7.3 \
 && ./configure --enable-optimizations \
 && make altinstall

# update-alternatives

RUN mv /usr/bin/pip /usr/bin/pip2.7 \
 && mv /usr/bin/lsb_release /usr/bin/lsb_release.00 \
 && update-alternatives --install /usr/bin/pip     pip     /usr/bin/pip2            1 \
 && update-alternatives --install /usr/bin/pip     pip     /usr/local/bin/pip3.7    2 \
 && update-alternatives --install /usr/bin/pip3    pip3    /usr/local/bin/pip3.7    1 \
 && update-alternatives --install /usr/bin/python  python  /usr/bin/python2.7       1 \
 && update-alternatives --install /usr/bin/python  python  /usr/bin/python3.5       2 \
 && update-alternatives --install /usr/bin/python  python  /usr/bin/python3.5m      3 \
 && update-alternatives --install /usr/bin/python  python  /usr/local/bin/python3.7 4 \
 && update-alternatives --install /usr/bin/python2 python2 /usr/bin/python2.7       1 \
 && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5       1 \
 && update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.5m      2 \
 && update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.7 3

# Install packages via pip.

RUN pip install --upgrade pip

RUN pip install \
    psutil

# Set environment variables.

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian:${SENZING_ROOT}/db2/clidriver/lib
ENV DB2_CLI_DRIVER_INSTALL_PATH=${SENZING_ROOT}/db2/clidriver
ENV PATH=$PATH:${SENZING_ROOT}/db2/clidriver/adm:${SENZING_ROOT}/db2/clidriver/bin

# Copy files from repository.

COPY ./rootfs /

# Runtime execution.

WORKDIR /
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/bin/bash"]
