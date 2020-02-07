FROM python:3.8.1-buster

WORKDIR /drone/src

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libyaml-dev figlet

RUN pip install --upgrade pip setuptools pip-tools python-dotenv

COPY requirements.in ./
RUN mkdir -p src && pip-compile requirements.* -o src/requirements.txt

COPY requirements.dev ./
RUN pip-compile src/requirements.txt requirements.dev -o requirements.txt

RUN python3 -m venv /drone/venv
RUN . /drone/venv/bin/activate && pip install --upgrade pip setuptools pip-tools
RUN . /drone/venv/bin/activate && pip install -r requirements.txt

RUN curl -sSL -O https://github.com/gohugoio/hugo/releases/download/v0.64.0/hugo_0.64.0_Linux-64bit.tar.gz \
  && tar xvfz hugo_0.64.0_Linux-64bit.tar.gz hugo \
  && rm -f hugo_0.64.0_Linux-64bit.tar.gz \
  && chmod 755 hugo \
  && mv hugo /usr/local/bin/

RUN curl -sSL -O https://github.com/drone/drone-cli/releases/download/v1.2.1/drone_linux_amd64.tar.gz \
  && tar xvfz drone_linux_amd64.tar.gz \
  && rm -f drone_linux_amd64.tar.gz \
  && chmod 755 drone \
  && mv drone /usr/local/bin/

RUN curl -sSL -O https://github.com/CircleCI-Public/circleci-cli/releases/download/v0.1.5879/circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && tar xvfz circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && rm -f circleci-cli_0.1.5879_linux_amd64.tar.gz \
  && chmod 755 circleci-cli_0.1.5879_linux_amd64/circleci \
  && mv circleci-cli_0.1.5879_linux_amd64/circleci /usr/local/bin/
