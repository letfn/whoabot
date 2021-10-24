ARG IMAGE

FROM $IMAGE

RUN python -m venv /venv
RUN . /venv/bin/activate && python -m pip install --no-cache-dir --upgrade pip
