ARG FUNCTION_DIR="/function"

FROM public.ecr.aws/docker/library/python:buster as build-image

ARG FUNCTION_DIR

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
ENV POETRY_NO_INTERACTION=1
ENV POETRY_VIRTUALENVS_IN_PROJECT=false
ENV POETRY_VIRTUALENVS_CREATE=false
ENV POETRY_CACHE_DIR=/var/cache/pypoetry
ENV POETRY_HOME=/usr/local
ENV POETRY_VERSION=1.8.3

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

RUN mkdir -p ${FUNCTION_DIR}

RUN pip install \
    --target ${FUNCTION_DIR} \
        awslambdaric

FROM public.ecr.aws/docker/library/python:buster

ARG ${FUNCTION_DIR}

WORKDIR ${FUNCTION_DIR}

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

# Set the default command to handle Lambda invocation
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]
