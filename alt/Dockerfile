FROM python:3.8.2-slim-buster

ARG _TINI_VERSION=0.18.0

USER root
RUN apt-get update && apt-get install -y tini && apt-get upgrade -y

RUN groupadd  -g 1000 app
RUN useradd -u 1000 -d /app/src -s /bin/bash -g app -M app
RUN mkdir -p /app/src && chown -R -v app:app /app /app/src

RUN pip install --no-cache-dir pip-tools python-dotenv

USER app
ENV HOME=/app/src
WORKDIR /app/src

COPY --chown=app:app requirements.txt /app/src/requirements.txt
RUN python3 -m venv /app/venv && . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt

COPY service /service

RUN sudo chown -R -v app:app /app /service

ENTRYPOINT [ "/tini", "--", "/service" ]
