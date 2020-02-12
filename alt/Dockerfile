FROM alpine:3.11.3 AS download

RUN apk add curl

RUN curl -sSL -o /tini https://github.com/krallin/tini/releases/download/v0.18.0/tini-static-amd64
RUN chmod 755 /tini

FROM python:3.8.1-slim-buster

WORKDIR /app/src

USER root
RUN apt-get update && apt-get upgrade -y

RUN groupadd  -g 8888 app
RUN useradd -u 8888 -d /app/src -s /bin/bash -g app -M app
RUN mkdir -p /app/src && chown -R app:app /app

COPY --from=download /tini /tini

RUN pip install --no-cache-dir --upgrade pip setuptools pip-tools python-dotenv

USER app
ENV HOME=/app/src

RUN mkdir -p /app/src
RUN python3 -m venv /app/venv
RUN . /app/venv/bin/activate && pip install --no-cache-dir --upgrade pip setuptools

COPY --chown=app:app requirements.txt /app/src
RUN . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt
COPY --chown=app:app src /app/src

COPY service /service

ENTRYPOINT [ "/tini", "--", "/service" ]
