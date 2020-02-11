FROM python:3.8.1-slim-buster

WORKDIR /drone/src

RUN echo 9

RUN apt-get update && apt-get upgrade -y

RUN pip install --no-cache-dir --upgrade pip setuptools pip-tools python-dotenv

RUN mkdir -p /app/src
RUN python3 -m venv /app/venv
RUN . /app/venv/bin/activate && pip install --no-cache-dir --upgrade pip setuptools pip-tools

COPY requirements.txt /app/src
RUN . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt
COPY src /app/src

COPY service /service
ENTRYPOINT [ "/service" ]
