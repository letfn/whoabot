FROM python:3.8.5-slim-buster

USER root
RUN apt-get update && apt-get install -y tini make git curl rsync sudo && apt-get upgrade -y
RUN ln -nfs /usr/bin/tini /tini

RUN groupadd  -g 1000 app
RUN useradd -u 1000 -d /app/src -s /bin/bash -g app -M app
RUN mkdir -p /app/src && chown -R -v app:app /app /app/src
RUN echo "app ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN groupadd  -g 1001 boot
RUN useradd -u 1001 -d /app/src -s /bin/bash -g boot -M boot
RUN echo "boot ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

RUN pip install --no-cache-dir pip-tools

USER app
ENV HOME=/app/src
WORKDIR /app/src

COPY --chown=app:app requirements.txt /tmp/requirements.txt
RUN python3 -m venv /app/venv \
    && . /app/venv/bin/activate \
    && pip install --upgrade pip \
    && . /app/venv/bin/activate \
    && pip install --no-cache-dir -r /tmp/requirements.txt \
    && rm -f /tmp/requirements.txt \
    && sudo chown -hR boot:boot /app/venv /app/src

RUN sudo sed "s/^app /#app /" -i /etc/sudoers

USER boot

COPY service /service

ENTRYPOINT [ "/tini", "--", "/service" ]
