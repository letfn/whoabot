ARG IMAGE

FROM $IMAGE

RUN python -m pip install --no-cache-dir --upgrade pip pip-tools pipx

