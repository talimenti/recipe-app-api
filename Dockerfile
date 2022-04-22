FROM python:3.7-alpine
MAINTAINER Traian

# tells python not to buffer the outputs, instead prints in directly
ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt  --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org

RUN mkdir /app
WORKDIR /app
COPY ./app /app

# this is for security purposes, in order not to use root account
RUN adduser -D user
USER user
