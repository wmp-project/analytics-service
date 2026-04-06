FROM        docker.io/library/python:3.12
WORKDIR     /app
COPY        ./ /app/
RUN         pip3.12 install --no-cache-dir .
ENTRYPOINT  ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]

