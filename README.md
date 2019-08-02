# docker-senzing-base

## Overview

The `senzing/senzing-base` docker image is a Senzing-ready, python image
supporting python 2.7 and 3.7.
The image can be used in a Dockerfile `FROM senzing/senzing-base` statement to simplify
building apps with Senzing.
As a docker container it runs as non-root and is immutable.

For examples on how to use the `senzing/senzing-base` docker image, see
[github.com/senzing/docker-python-demo](https://github.com/senzing/docker-python-demo)
or [github.com/senzing/docker-senzing-debug](https://github.com/senzing/docker-senzing-debug).

### Contents

1. [Expectations](#expectations)
    1. [Space](#space)
    1. [Time](#time)
    1. [Background knowledge](#background-knowledge)
1. [Demonstrate](#demonstrate)
    1. [Create SENZING_DIR](#create-senzing_dir)
    1. [Configuration](#configuration)
    1. [Run docker container](#run-docker-container)
1. [Develop](#develop)
    1. [Prerequisite software](#prerequisite-software)
    1. [Clone repository](#clone-repository)
    1. [Build docker image for development](#build-docker-image-for-development)
1. [Examples](#examples)
1. [Errors](#errors)
1. [References](#references)

## Expectations

### Space

This repository and demonstration require 6 GB free disk space.

### Time

Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.

### Background knowledge

This repository assumes a working knowledge of:

1. [Docker](https://github.com/Senzing/knowledge-base/blob/master/WHATIS/docker.md)

## Demonstrate

### Create SENZING_DIR

1. If you do not already have an `/opt/senzing` directory on your local system, visit
   [HOWTO - Create SENZING_DIR](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/create-senzing-dir.md).

### Configuration

#### SENZING_DATA_VERSION_DIR

Path on the local system where Senzing *data/nn.nnn.nnn* directory is located.
It differs from the value of the **SENZING_DATA_DIR** environment variable
used in [installing Senzing](https://github.com/Senzing/docker-yum#volumes)
because it includes the version of the data in the path.
This directory contains immutable data files used by Senzing G2.
No default.
Usually set to "/opt/senzing/data/1.0.0".

#### SENZING_ETC_DIR

Path on the local system where Senzing *etc* directory is located.
This directory contains Senzing configuration templates and files.
No default.
Usually set to "/etc/opt/senzing".

#### SENZING_G2_DIR

Path on the local system where Senzing *g2* directory is located.
This directory contains Senzing G2 code.
No default.
Usually set to "/opt/senzing/g2".

#### SENZING_VAR_DIR

Path on the local system where Senzing *var* directory is located.
This directory contains files that may mutate during execution.
No default.
Usually set to "/var/opt/senzing".

### Run docker container

1. :pencil2: Set environment variables.  Example:

    ```console
    export SENZING_DATA_VERSION_DIR=/opt/senzing/data/1.0.0
    export SENZING_ETC_DIR=/etc/opt/senzing
    export SENZING_G2_DIR=/opt/senzing/g2
    export SENZING_VAR_DIR=/var/opt/senzing
    ```

1. Run docker container.  Example:

    ```console
    sudo docker run \
      --interactive \
      --rm \
      --tty \
      --volume ${SENZING_DATA_VERSION_DIR}:/opt/senzing/data \
      --volume ${SENZING_ETC_DIR}:/etc/opt/senzing \
      --volume ${SENZING_G2_DIR}:/opt/senzing/g2 \
      --volume ${SENZING_VAR_DIR}:/var/opt/senzing \
      senzing/senzing-base
    ```

## Develop

### Prerequisite software

The following software programs need to be installed:

1. [git](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-git.md)
1. [make](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-make.md)
1. [docker](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/install-docker.md)

### Clone repository

1. Set these environment variable values:

    ```console
    export GIT_ACCOUNT=senzing
    export GIT_REPOSITORY=docker-senzing-base
    ```

1. Follow steps in [clone-repository](https://github.com/Senzing/knowledge-base/blob/master/HOWTO/clone-repository.md) to install the Git repository.

1. After the repository has been cloned, be sure the following are set:

    ```console
    export GIT_ACCOUNT_DIR=~/${GIT_ACCOUNT}.git
    export GIT_REPOSITORY_DIR="${GIT_ACCOUNT_DIR}/${GIT_REPOSITORY}"
    ```

### Build docker image for development

1. Option #1 - Using `docker` command and GitHub.

    ```console
    sudo docker build --tag senzing/senzing-base https://github.com/senzing/docker-senzing-base.git
    ```

1. Option #2 - Using `docker` command and local repository.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo docker build --tag senzing/senzing-base .
    ```

1. Option #3 - Using `make` command.

    ```console
    cd ${GIT_REPOSITORY_DIR}
    sudo make docker-build
    ```

    Note: `sudo make docker-build-base` can be used to create cached docker layers.

## Examples

## Errors

1. See [docs/errors.md](docs/errors.md).

## References
