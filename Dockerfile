# VERSION 0.0.1
# AUTHOR: marwamc
# DESCRIPTION: Basic Airflow container
# BUILD: docker build --rm -t marwamc/docker-airflow .
# Derived from: https://github.com/puckel/docker-airflow
FROM python:3.7-buster

# Never prompt the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=1.10.9
ARG AIRFLOW_USER_HOME="/usr/local/airflow"
ARG AIRFLOW_DEPS=""
ARG PYTHON_DEPS=""
ENV AIRFLOW_HOME=${AIRFLOW_USER_HOME}

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8

# Disable noisy "Handling signal" log messages:
ENV GUNICORN_CMD_ARGS --log-level WARNING


# BASE IMAGE
## BUILD DEPS
RUN apt-get update -yqq && apt-get upgrade -yqq && apt-get install -yqq --no-install-recommends \
    freetds-dev libkrb5-dev libsasl2-dev libssl-dev libffi-dev libpq-dev git

## NET & LOCALE
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
    freetds-bin build-essential default-libmysqlclient-dev apt-utils curl rsync netcat locales

RUN sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# DB: POSTGRES/PSQL
RUN	apt-get update -yqq && apt-get install -yqq --no-install-recommends iputils-ping postgresql-11

# AIRFLOW
## GNERAL PYTHON STUFF
RUN useradd -ms /bin/bash -d ${AIRFLOW_USER_HOME} airflow
RUN pip install -U pip setuptools wheel
RUN pip install pytz pyOpenSSL ndg-httpsclient pyasn1

## ACTUAL AIRFLOW & DEPS
RUN pip install apache-airflow[crypto,celery,postgres,hive,jdbc,mysql,ssh${AIRFLOW_DEPS:+,}${AIRFLOW_DEPS}]==${AIRFLOW_VERSION}

## ADDITIONAL AIRFLOW DEPS
RUN pip install 'redis==3.2' SQLAlchemy==1.3.15

# CLEANUP
RUN apt-get purge --auto-remove -yqq $buildDeps \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# OUR DAG DEPS
# COPY requirements.txt .
# RUN pip install -r requirements.txt

# RUNTIME AIRFLOW SETTINGS
# from https://github.com/puckel/docker-airflow/issues/233
ENV AIRFLOW__SCHEDULER__MIN_FILE_PROCESS_INTERVAL=300
ENV AIRFLOW__SCHEDULER__SCHEDULER_MAX_THREADS=1
ENV AIRFLOW__WEBSERVER__WORKERS=2
ENV AIRFLOW__WEBSERVER__WORKER_REFRESH_INTERVAL=1800
ENV AIRFLOW__WEBSERVER__WEB_SERVER_WORKER_TIMEOUT=300

# STARTUP
COPY entrypoint.sh /entrypoint.sh
RUN chown -R airflow: /entrypoint.sh

COPY airflow.cfg ${AIRFLOW_USER_HOME}/airflow.cfg
RUN chown -R airflow: ${AIRFLOW_USER_HOME}

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_USER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["webserver"]
