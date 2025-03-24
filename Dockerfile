ARG BASE_IMAGE=python:3.12
FROM ${BASE_IMAGE} AS builder

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pip install --no-cache-dir pdm

WORKDIR /build
COPY . /build/

# Install dependencies and build/install package
RUN pdm install -G testing

# Run tests
RUN pdm run pytest tests -v

# Build wheel
RUN pdm build

# Application Layer
FROM python:3.12

WORKDIR /app
COPY --from=builder /build/dist/*.whl /tmp/
# Install into site-packages from wheel
RUN pip install --no-cache-dir /tmp/*.whl

CMD ["sh", "-c", "python -m kuhl_haus.canary.app --script=canary"]
