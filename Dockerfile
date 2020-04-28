ARG BASE_IMAGE=debian:10.2
FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2020-01-29

LABEL Name="senzing/senzing-base" \
      Maintainer="support@senzing.com" \
      Version="1.4.0"

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.
# Required for msodbcsql17:  libodbc1:amd64 odbcinst odbcinst1debian2:amd64 unixodbc

RUN apt update \
 && apt -y install \
      build-essential \
      curl \
      jq \
      libbz2-dev \
      libffi-dev \
      libgdbm-dev \
      libncursesw5-dev \
      libodbc1:amd64 \
      libreadline-gplv2-dev \
      libssl-dev \
      libsqlite3-dev \
      lsb-release \
      odbcinst \
      odbc-postgresql \
      postgresql-client \
      python3-dev \
      python3-pip \
      sqlite \
      tk-dev \
      unixodbc \
      wget \
      vim \
 && rm -rf /var/lib/apt/lists/*

# Install packages via pip.

RUN pip3 install --upgrade pip \
 && pip3 install \
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
