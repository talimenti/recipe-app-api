FROM python:3.9
LABEL maintainer="traian"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false

RUN apt-get update && apt-get -y --no-install-recommends install jq curl

RUN apt-get install \
    postgresql-client \ 
    libpq-dev \
    musl-dev \
    -y

RUN python -m venv /py && \
    /py/bin/pip install --trusted-host files.pythonhosted.org \
    --trusted-host pypi.org --trusted-host pypi.python.org --upgrade pip && \
    /py/bin/pip install --trusted-host files.pythonhosted.org \ 
    --trusted-host pypi.org --trusted-host pypi.python.org -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org -r /tmp/requirements.dev.txt ; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user