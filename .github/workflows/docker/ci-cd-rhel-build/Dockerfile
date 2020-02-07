FROM senzing/base-image-centos:1.0.0

ARG GITHUB_HEAD_REF="master"
ARG GITHUB_OWNER="Senzing"
ARG GITHUB_EVENT_NAME="push"
ARG SENZING_REPO_URL="https://senzing-production-yum.s3.amazonaws.com/senzingrepo-1.0.0-1.x86_64.rpm"

LABEL Name="senzing-ci-cd-rhel-test-builder" \
      Maintainer="support@senzing.com" \
      Version="1.0.0"

# Set environment variables.
ENV SENZING_ACCEPT_EULA=I_ACCEPT_THE_SENZING_EULA

# Add Senzing Files
RUN yum install -y \
        ${SENZING_REPO_URL}

# Set environment variables.
ENV SENZING_ROOT=/opt/senzing
ENV SENZING_G2_DIR=${SENZING_ROOT}/g2
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian

# Clone Senzing base repository.
WORKDIR /
RUN git clone https://github.com/${GITHUB_OWNER}/docker-senzing-base.git

# Build Senzing Base
WORKDIR /docker-senzing-base
SHELL ["/bin/bash", "-c"]
RUN git checkout ${GITHUB_HEAD_REF}; \
    if [[ "${GITHUB_HEAD_REF}" != "master" && ${GITHUB_EVENT_NAME} == "pull_request" ]]; then \
        git merge master; \
    fi

RUN ./rootfs/app/healthcheck.sh