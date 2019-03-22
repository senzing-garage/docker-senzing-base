ARG BASE_IMAGE=debian:9

# -----------------------------------------------------------------------------
# Stage: db2_builder
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE} as db2_builder

ENV REFRESHED_AT=2019-03-22

LABEL Name="senzing/senzing-base-db2-builder" \
      Version="1.0.0"

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      unzip

# Copy the DB2 ODBC client code.
# The tar.gz files must be independently downloaded before the docker build.

ADD ./downloads/ibm_data_server_driver_for_odbc_cli_linuxx64_v11.1.tar.gz /opt/IBM/db2
ADD ./downloads/v11.1.4fp4a_jdbc_sqlj.tar.gz /tmp/db2-jdbc-sqlj

# Extract ZIP file.

RUN unzip -d /tmp/extracted-jdbc /tmp/db2-jdbc-sqlj/jdbc_sqlj/db2_db2driver_for_jdbc_sqlj.zip

# -----------------------------------------------------------------------------
# Final stage
# -----------------------------------------------------------------------------

FROM ${BASE_IMAGE}

ENV REFRESHED_AT=2019-03-22

LABEL Name="senzing/senzing-base" \
      Version="1.0.0"

# Install packages via apt.

RUN apt-get update \
 && apt-get -y install \
      curl \
      gnupg \
      jq \
      lsb-core \
      lsb-release \
      odbc-postgresql \
      postgresql-client \
      python-dev \
      python-pip \
      python-pyodbc \
      sqlite \
      unixodbc \
      unixodbc-dev \
      wget \
 && rm -rf /var/lib/apt/lists/*

# Install libmysqlclient21.

ENV DEBIAN_FRONTEND=noninteractive

# RUN wget -qO - https://repo.mysql.com/RPM-GPG-KEY-mysql | apt-key add - \
#  && wget https://repo.mysql.com/mysql-apt-config_0.8.11-1_all.deb \
#  && dpkg --install mysql-apt-config_0.8.11-1_all.deb \
#  && apt-get update \
#  && apt-get -y install libmysqlclient21 \
#  && rm mysql-apt-config_0.8.11-1_all.deb \
#  && rm -rf /var/lib/apt/lists/*

# Create MySQL connector.
# References:
#  - https://dev.mysql.com/downloads/connector/odbc/
#  - https://dev.mysql.com/doc/connector-odbc/en/connector-odbc-installation-binary-unix-tarball.html

# RUN wget https://cdn.mysql.com//Downloads/Connector-ODBC/8.0/mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit.tar.gz \
#  && tar -xvf mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit.tar.gz \
#  && cp mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit/lib/* /usr/lib/x86_64-linux-gnu/odbc/ \
#  && mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit/bin/myodbc-installer -d -a -n "MySQL" -t "DRIVER=/usr/lib/x86_64-linux-gnu/odbc/libmyodbc8w.so;" \
#  && rm mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit.tar.gz \
#  && rm -rf mysql-connector-odbc-8.0.13-linux-ubuntu18.04-x86-64bit

# Install packages via pip.

RUN pip install \
    psutil \
    pyodbc

# Copy files from "db2_builder" stage.

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/adm/db2trc", \
    "/opt/IBM/db2/clidriver/adm/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/bin/db2dsdcfgfill", \
    "/opt/IBM/db2/clidriver/bin/db2ldcfg", \
    "/opt/IBM/db2/clidriver/bin/db2lddrg", \
    "/opt/IBM/db2/clidriver/bin/db2level", \
    "/opt/IBM/db2/clidriver/bin/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/cfg/db2cli.ini.sample", \
    "/opt/IBM/db2/clidriver/cfg/db2dsdriver.cfg.sample", \
    "/opt/IBM/db2/clidriver/cfg/db2dsdriver.xsd", \
    "/opt/IBM/db2/clidriver/cfg/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/conv/alt/08501252.cnv", \
    "/opt/IBM/db2/clidriver/conv/alt/12520850.cnv", \
    "/opt/IBM/db2/clidriver/conv/alt/IBM00850.ucs", \
    "/opt/IBM/db2/clidriver/conv/alt/IBM01252.ucs", \
    "/opt/IBM/db2/clidriver/conv/alt/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/include/sqlcli1.h", \
    "/opt/IBM/db2/clidriver/include/sqlsystm.h", \
    "/opt/IBM/db2/clidriver/include/sqlca.h", \
    "/opt/IBM/db2/clidriver/include/sqlcli.h", \
    "/opt/IBM/db2/clidriver/include/sql.h", \
    "/opt/IBM/db2/clidriver/include/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/lib/libdb2.so.1", \
    "/opt/IBM/db2/clidriver/lib/libdb2o.so.1", \
    "/opt/IBM/db2/clidriver/lib/" \
    ]

COPY --from=db2_builder [ \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2admh.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2adm.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clia1.lst", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clias.lst", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clih.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2cli.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clit.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2clp.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2diag.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2sqlh.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/db2sql.mo", \
    "/opt/IBM/db2/clidriver/msg/en_US.iso88591/" \
    ]

COPY --from=db2_builder [ \
    "/tmp/extracted-jdbc/db2jcc.jar", \
    "/tmp/extracted-jdbc/db2jcc4.jar", \
    "/tmp/extracted-jdbc/sqlj.zip", \
    "/tmp/extracted-jdbc/sqlj4.zip", \
    "/opt/IBM/db2/jdbc/" \
    ]

# FIXME: The following files have not yet been approved for distribution, but are necessary.
# Once the files are approved for distribution:
#  1) db2dsdriver.cfg: Remove "Authentication" and "SecurityTransportMode" parameters.
#  2) Remove "RUN touch /opt/IBM/db2/clidriver/bin/crypto_not_installed" from this Dockerfile.

#COPY --from=db2_builder [ \
#    "/opt/IBM/db2/clidriver/lib/icc/libgsk8cms_64.so", \
#    "/opt/IBM/db2/clidriver/lib/icc/libgsk8iccs_64.so", \
#    "/opt/IBM/db2/clidriver/lib/icc/libgsk8km_64.so", \
#    "/opt/IBM/db2/clidriver/lib/icc/libgsk8ssl_64.so", \
#    "/opt/IBM/db2/clidriver/lib/icc/libgsk8sys_64.so", \
#    "/opt/IBM/db2/clidriver/lib/icc/" \
#    ]

#COPY --from=db2_builder [ \
#    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/ICCSIG.txt", \
#    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/libicclib084.so", \
#    "/opt/IBM/db2/clidriver/lib/icc/C/icc/icclib/" \
#    ]

# FIXME: For testing only.

# COPY --from=db2_builder /opt/IBM/db2  /opt/IBM/db2

# Set environment variables.

ENV SENZING_ROOT=/opt/senzing
ENV PYTHONPATH=${SENZING_ROOT}/g2/python
ENV LD_LIBRARY_PATH=${SENZING_ROOT}/g2/lib:${SENZING_ROOT}/g2/lib/debian:/opt/IBM/db2/clidriver/lib
ENV DB2_CLI_DRIVER_INSTALL_PATH=/opt/IBM/db2/clidriver
ENV PATH=$PATH:/opt/IBM/db2/clidriver/adm:/opt/IBM/db2/clidriver/bin

# Copy files from repository.

COPY ./rootfs /

# Create files and links.

RUN touch /opt/IBM/db2/clidriver/bin/crypto_not_installed \
 && ln -s /opt/IBM/db2/clidriver/lib/libdb2.so.1  /opt/IBM/db2/clidriver/lib/libdb2.so \
 && ln -s /opt/IBM/db2/clidriver/lib/libdb2o.so.1 /opt/IBM/db2/clidriver/lib/libdb2o.so

# Runtime execution.

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["/bin/bash"]
