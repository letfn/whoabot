FROM ubuntu:20.04

USER root
RUN apt-get update && apt-get install -y tini make git curl rsync sudo && apt-get upgrade -y
RUN ln -nfs /usr/bin/tini /tini

RUN groupadd  -g 1000 app
RUN useradd -u 1000 -d /app/src -s /bin/bash -g app -M app
RUN mkdir -p /app/src && chown -R -v app:app /app /app/src
RUN echo "app ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN apt install -y python3-pip
RUN apt install -y build-essential libssl-dev libffi-dev python3-dev python3-venv
RUN pip3 install --no-cache-dir --upgrade pip pip-tools pipx

USER app
ENV HOME=/app/src
WORKDIR /app/src

COPY service /service
ENTRYPOINT [ "/tini", "--", "/service" ]
