ARG BASE_IMAGE=ghcr.io/kuhl-haus/kuhl-haus-metrics:latest
FROM ${BASE_IMAGE}

WORKDIR /app
COPY . /app/
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
RUN pip install --no-cache-dir .
RUN pytest /app/tests -v

CMD ["sh", "-c", "python -m kuhl_haus.canary.app --script=canary"]
