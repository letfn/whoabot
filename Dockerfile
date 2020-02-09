FROM letfn/python

WORKDIR /drone/src

RUN apt-get update && apt-get upgrade -y

COPY service /service

ENTRYPOINT [ "/service" ]
