ARG BASE_IMAGE=debian:9
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-08-05

LABEL Name="senzing/senzing-base" \
      Maintainer="support@senzing.com" \
      Version="1.2.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

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
 && make altinstall \
 && rm /usr/src/Python-3.7.3.tgz \
 && rm -rf /usr/src/Python-3.7.3

# Make soft links for Python 3.7. See https://www.python.org/dev/peps/pep-0394

RUN ln -sf /usr/local/bin/easy_install-3.7  /usr/bin/easy_install3 \
 && ln -sf /usr/local/bin/idle3.7           /usr/bin/idle3 \
 && ln -sf /usr/local/bin/pip3.7            /usr/bin/pip3 \
 && ln -sf /usr/local/bin/pydoc3.7          /usr/bin/pydoc3 \
 && ln -sf /usr/local/bin/python3.7         /usr/bin/python3 \
 && ln -sf /usr/local/bin/python3.7m-config /usr/bin/python3-config  \
 && ln -sf /usr/local/bin/pyvenv-3.7        /usr/bin/pyvenv3 \
 && mv /usr/bin/lsb_release /usr/bin/lsb_release.00

# Install packages via pip.

RUN pip2 install --upgrade pip \
 && pip3 install --upgrade pip

RUN pip2 install \
      psutil

RUN pip3 install \
      psutil

# Copy files from repository.

COPY ./rootfs /

# Make non-root container.

USER 1001

# Set environment variables.

ENV SENZING_ROOT=/opt/senzing
ENV DB2_CLI_DRIVER_INSTALL_PATH=/opt/IBM/db2/clidriver
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian:${DB2_CLI_DRIVER_INSTALL_PATH}/lib
ENV PATH=$PATH:${DB2_CLI_DRIVER_INSTALL_PATH}/adm:${DB2_CLI_DRIVER_INSTALL_PATH}/bin

# Runtime execution.

WORKDIR /
CMD ["/bin/bash"]
