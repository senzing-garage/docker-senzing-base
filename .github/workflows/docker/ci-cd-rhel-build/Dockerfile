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