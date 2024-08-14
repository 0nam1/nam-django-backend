FROM python:3.11-alpine3.19

LABEL maintainer="0nam"

ENV PYTHONUNBUFFERED 1

RUN apk add --no-cache gcc musl-dev

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY /app /app

ARG DEV=flase

RUN python -m venv /py && \ 
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    if [ ${DEV} = 'true']; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

WORKDIR /app

EXPOSE 8000

ENV PATH="/py/bin:$PATH"
USER django-user