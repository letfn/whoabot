ARG IMAGE

FROM $IMAGE

RUN python -m pip install --no-cache-dir --upgrade pip pip-tools pipx

RUN groupadd  -g 1000 app
RUN useradd -u 1000 -d /app -s /bin/bash -g app -M app
RUN mkdir -p /app && chown -R -v app:app /app
RUN echo "app ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

USER app
ENV HOME=/app
WORKDIR /app

RUN python -m venv /venv
RUN . /venv/bin/activate && python -m pip install --no-cache-dir --upgrade pip
