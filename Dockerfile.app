ARG IMAGE

FROM $IMAGE

COPY --chown=app:app etc/.bashrc etc/run .

RUN python -m venv /venv
RUN ./run python -m pip install --no-cache-dir --upgrade pip
