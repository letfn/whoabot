FROM letfn/python

WORKDIR /drone/src

RUN apt-get update && apt-get upgrade -y

COPY requirements.txt /app/src/
RUN . /app/venv/bin/activate && pip install --no-cache-dir -r /app/src/requirements.txt
COPY src /app/src

COPY service /service
ENTRYPOINT [ "/service" ]
