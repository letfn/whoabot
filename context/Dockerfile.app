ARG IMAGE

FROM $IMAGE

RUN python -m venv /venv
RUN ./run python -m pip install --no-cache-dir --upgrade pip
