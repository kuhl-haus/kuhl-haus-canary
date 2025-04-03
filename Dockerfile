ARG BASE_IMAGE=python:3.13-slim
FROM ${BASE_IMAGE} AS builder

WORKDIR /build
COPY . /build/

# Install PDM
RUN pip install --no-cache-dir pdm

# Build wheel
RUN pdm build

# Application Layer
FROM python:3.13-slim

WORKDIR /app
COPY --from=builder /build/dist/*.whl /tmp/
# Install into site-packages from wheel
RUN pip install --no-cache-dir /tmp/*.whl

CMD ["sh", "-c", "python -m kuhl_haus.canary.app --script=canary"]
