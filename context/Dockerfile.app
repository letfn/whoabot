ARG IMAGE

FROM $IMAGE

RUN python -m venv /venv
RUN ./run python -m pip install --no-cache-dir --upgrade pip

RUN git clone -b release-v0.9.0 https://github.com/asdf-vm/asdf.git .asdf
