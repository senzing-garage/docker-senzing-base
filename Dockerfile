ARG BASE_IMAGE=debian:13.1-slim@sha256:c2880112cc5c61e1200c26f106e4123627b49726375eb5846313da9cca117337

# -----------------------------------------------------------------------------
# Stage: Final
# -----------------------------------------------------------------------------

# Create the runtime image.

FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2024-06-24

LABEL Name="senzing/senzing-base" \
  Maintainer="support@senzing.com" \
  Version="1.6.25"

# Define health check.

HEALTHCHECK CMD ["/app/healthcheck.sh"]

# Run as "root" for system installation.

USER root

# Install packages via apt.
# Required for msodbcsql17:  libodbc1:amd64 odbcinst odbcinst1debian2:amd64 unixodbc

RUN apt-get update \
  && apt-get -y install \
  build-essential \
  curl \
  gdb \
  jq \
  libbz2-dev \
  libffi-dev \
  libgdbm-dev \
  libncursesw5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libssl-dev \
  libssl3 \
  lsb-release \
  odbc-postgresql \
  odbcinst \
  postgresql-client \
  python3-dev \
  python3-pip \
  python3-venv \
  sqlite3 \
  tk-dev \
  unixodbc \
  vim \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Activate virtual environment.

ENV VIRTUAL_ENV=/app/venv
ENV PATH="/app/venv/bin:${PATH}"

# Install packages via pip.

COPY requirements.txt ./
RUN pip3 install --upgrade pip \
  && pip3 install -r requirements.txt \
  && rm requirements.txt

# Copy files from repository.

COPY ./rootfs /

# Downgrade to TLSv1.1

RUN sed -i 's/TLSv1.2/TLSv1.1/g' /etc/ssl/openssl.cnf

# Set environment variables for root.

ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV ODBCSYSINI=/etc/opt/senzing
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/python
ENV SENZING_ETC_PATH=/etc/opt/senzing

# Make non-root container.

USER 1001

# Set environment variables for USER 1001.

ENV LD_LIBRARY_PATH=/opt/senzing/g2/lib:/opt/senzing/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV ODBCSYSINI=/etc/opt/senzing
ENV PATH=${PATH}:/opt/senzing/g2/python:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin
ENV PYTHONPATH=/opt/senzing/g2/python
ENV SENZING_ETC_PATH=/etc/opt/senzing

# Runtime execution.

WORKDIR /
CMD ["/bin/bash"]
