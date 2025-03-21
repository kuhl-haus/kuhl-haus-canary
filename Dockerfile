FROM public.ecr.aws/docker/library/python:3.12-slim

WORKDIR /libs/metrics
COPY ./kuhl-haus-metrics /libs/metrics/
RUN pip install --no-cache-dir --upgrade -r /libs/metrics/requirements.txt
RUN pip install --no-cache-dir .
RUN pytest /libs/metrics/tests -v

WORKDIR /app
COPY ./kuhl-haus-canary /app/
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt
RUN pip install --no-cache-dir .
RUN pytest /app/tests -v

CMD ["sh", "-c", "python -m kuhl_haus.canary.app --script=canary"]
