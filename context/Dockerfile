ARG IMAGE

FROM $IMAGE

RUN python -m pip install --no-cache-dir --upgrade pip pip-tools pipx

RUN groupadd  -g 1000 app
RUN useradd -u 1000 -d /app -s /bin/bash -g app -M app
RUN install -d -m 0700 -o app -g app /app /venv
RUN echo "app ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

USER app
ENV HOME=/app
WORKDIR /app

RUN git clone -b release-v0.9.0 https://github.com/asdf-vm/asdf.git .asdf

COPY --chown=app:app etc/bashrc .bashrc
COPY --chown=app:app etc/run run
