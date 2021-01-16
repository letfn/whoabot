FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && apt-get install -y tini make git curl rsync sudo && apt-get upgrade -y
RUN ln -nfs /usr/bin/tini /tini

RUN groupadd  -g 1000 app
RUN useradd -u 1000 -d /app/src -s /bin/bash -g app -M app
RUN mkdir -p /app/src && chown -R -v app:app /app /app/src
RUN echo "app ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN apt install -y python3-pip python3-dev python3-venv
RUN apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
                   libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
                   libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl
RUN python3 -m pip install --no-cache-dir --upgrade pip pip-tools pipx

USER app
ENV HOME=/app/src
WORKDIR /app/src

COPY service /service
ENTRYPOINT [ "/tini", "--", "/service" ]
