FROM        sonarsource/sonar-scanner-cli AS sonar-scanner
WORKDIR     /usr/src
COPY        ./ /usr/src/
RUN         sonar-scanner \
            -Dsonar.host.url=http://172.31.17.79:9000 \
            -Dsonar.login=admin -Dsonar.password=admin123 -Dsonar.qualitygate.wait=true \
            -Dsonar.projectKey=analytics-service \
            -Dsonar.sources=. && \
            touch /tmp/scan-success

FROM        docker.io/library/python:3.12
COPY        --from=sonar-scanner /tmp/scan-success /tmp/
WORKDIR     /app
COPY        ./ /app/
RUN         pip3.12 install --no-cache-dir .
COPY        run.sh /

ENTRYPOINT  ["bash", "/run.sh"]

