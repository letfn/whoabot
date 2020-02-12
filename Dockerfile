FROM letfn/python

WORKDIR /drone/src

USER root
RUN apt-get update && apt-get upgrade -y

USER app
ENV HOME=/app/src

COPY --chown=app:app requirements.txt /app/src/
RUN . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt
COPY --chown=app:app src /app/src

COPY service /service
ENTRYPOINT [ "/tini", "--", "/service" ]
