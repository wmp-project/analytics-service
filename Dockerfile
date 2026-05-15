FROM        docker.io/library/python:3.12
WORKDIR     /app
COPY        ./ /app/
RUN         pip3.12 install --no-cache-dir .
COPY        run.sh /

ENTRYPOINT  ["bash", "/run.sh"]

