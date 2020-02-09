FROM python:3.8.1-buster

WORKDIR /drone/src

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y figlet rsync curl make git
RUN apt-get install -y libyaml-dev

RUN pip install --no-cache-dir --upgrade pip setuptools pip-tools python-dotenv

COPY requirements.in /drone/
RUN mkdir -p /drone/src/src && pip-compile /drone/requirements.in -o /drone/src/src/requirements.txt

COPY requirements.dev /drone/
RUN pip-compile /drone/src/src/requirements.txt /drone/requirements.dev -o /drone/src/requirements.txt

RUN python3 -m venv /drone/venv
RUN . /drone/venv/bin/activate && pip install --no-cache-dir --upgrade pip setuptools pip-tools
RUN . /drone/venv/bin/activate && pip install --no-cache-dir -r /drone/src/requirements.txt
