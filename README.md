# docker-senzing-base

If you are beginning your journey with
[Senzing](https://senzing.com/),
please start with
[Senzing Quick Start guides](https://docs.senzing.com/quickstart/).

You are in the
[Senzing Garage](https://github.com/senzing-garage)
where projects are "tinkered" on.
Although this GitHub repository may help you understand an approach to using Senzing,
it's not considered to be "production ready" and is not considered to be part of the Senzing product.
Heck, it may not even be appropriate for your application of Senzing!

## Overview

The `senzing/senzing-base` docker image is a Senzing-ready, python image
supporting python 2.7 and 3.7.
The image can be used in a Dockerfile `FROM senzing/senzing-base` statement to simplify
building apps with Senzing.
As a docker container it runs as non-root and is immutable.

For examples on how to use the `senzing/senzing-base` docker image, see
[github.com/senzing/docker-python-demo](https://github.com/senzing-garage/docker-python-demo)
or [github.com/senzing/docker-senzing-debug](https://github.com/senzing-garage/docker-senzing-debug).

### Related artifacts

1. [DockerHub](https://hub.docker.com/r/senzing/senzing-base)
1. [Helm Chart](https://github.com/senzing-garage/charts/tree/main/charts/senzing-base)

### Contents

1. [Expectations](#expectations)
1. [Demonstrate using Docker](#demonstrate-using-docker)
    1. [Configuration](#configuration)
    1. [External database](#external-database)
    1. [Database support](#database-support)
    1. [Run docker container](#run-docker-container)
1. [References](#references)

### Legend

1. :thinking: - A "thinker" icon means that a little extra thinking may be required.
   Perhaps there are some choices to be made.
   Perhaps it's an optional step.
1. :pencil2: - A "pencil" icon means that the instructions may need modification before performing.
1. :warning: - A "warning" icon means that something tricky is happening, so pay attention.

### Expectations

- **Space:** This repository and demonstration require 6 GB free disk space.
- **Time:** Budget 40 minutes to get the demonstration up-and-running, depending on CPU and network speeds.
- **Background knowledge:** This repository assumes a working knowledge of:
  - [Docker](https://github.com/senzing-garage/knowledge-base/blob/main/WHATIS/docker.md)

## Demonstrate using Docker

### Configuration

Configuration values specified by environment variable or command line parameter.

- **[SENZING_DATABASE_URL](https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_database_url)**
- **[SENZING_DEBUG](https://github.com/senzing-garage/knowledge-base/blob/main/lists/environment-variables.md#senzing_debug)**

### External database

:thinking: **Optional:**  Use if storing data in an external database.
If not specified, the internal SQLite database will be used.

1. :pencil2: Specify database.
   Example:

    ```console
    export DATABASE_PROTOCOL=postgresql
    export DATABASE_USERNAME=postgres
    export DATABASE_PASSWORD=postgres
    export DATABASE_HOST=senzing-postgresql
    export DATABASE_PORT=5432
    export DATABASE_DATABASE=G2
    ```

1. Construct Database URL.
   Example:

    ```console
    export SENZING_DATABASE_URL="${DATABASE_PROTOCOL}://${DATABASE_USERNAME}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_DATABASE}"
    ```

1. Construct parameter for `docker run`.
   Example:

    ```console
    export SENZING_DATABASE_URL_PARAMETER="--env SENZING_DATABASE_URL=${SENZING_DATABASE_URL}"
    ```

### Database support

:thinking: **Optional:**  Some database need additional support.
For other databases, these steps may be skipped.

1. **Db2:** See
   [Support Db2](https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/support-db2.md)
   instructions to set `SENZING_OPT_IBM_DIR_PARAMETER`.
1. **MS SQL:** See
   [Support MS SQL](https://github.com/senzing-garage/knowledge-base/blob/main/HOWTO/support-mssql.md)
   instructions to set `SENZING_OPT_MICROSOFT_DIR_PARAMETER`.

### Run docker container

1. Run docker container.
   Example:

    ```console
    sudo docker run \
      --interactive \
      --rm \
      --tty \
      ${SENZING_DATABASE_URL_PARAMETER} \
      ${SENZING_OPT_IBM_DIR_PARAMETER} \
      ${SENZING_OPT_MICROSOFT_DIR_PARAMETER} \
      senzing/senzing-base
    ```

## References

- [Development](docs/development.md)
- [Errors](docs/errors.md)
- [Examples](docs/examples.md)
