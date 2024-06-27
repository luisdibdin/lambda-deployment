ARG FUNCTION_DIR="/function"

FROM python:3.12-alpine3.20 as python-alpine

RUN apk add --no-cache \
    libstdc++

FROM python-alpine as build-image

# Add specific Alpine repositories to resolve dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# Install dependencies including specific versions
RUN apk update && \
    apk add --no-cache \
    autoconf=2.71-r2 \
    build-base \
    libtool \
    automake \
    make \
    cmake \
    libcurl

# Add repository for older version of libexecinfo-dev
RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main/ libexecinfo-dev

ARG FUNCTION_DIR

RUN mkdir -p ${FUNCTION_DIR}

# Upgrade pip and install awslambdaric
RUN python -m pip install --upgrade pip && \
    python -m pip install --target ${FUNCTION_DIR} awslambdaric

FROM python-alpine

ARG FUNCTION_DIR

WORKDIR ${FUNCTION_DIR}

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

ENV LAMBDA_TASK_ROOT=${FUNCTION_DIR}

# Set the default command to handle Lambda invocation
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

