ARG FUNCTION_DIR="/function"

FROM python:3.12-alpine3.20 AS python-alpine

RUN apk add --no-cache \
    libstdc++=13.2.1_git20240309-r0

FROM python-alpine AS build-image

# Add specific Alpine repositories to resolve dependencies
RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/main" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

# Install dependencies including specific versions
RUN apk update && \
    apk add --no-cache \
    autoconf=2.71-r2 \
    build-base=0.5-r3 \
    libtool=2.4.7-r3 \
    automake=1.16.5-r2 \
    make=4.4.1-r2 \
    cmake=3.29.3-r0 \
    libcurl=8.8.0-r0

# Add repository for older version of libexecinfo-dev
RUN apk add --no-cache \
    --repository=https://dl-cdn.alpinelinux.org/alpine/v3.16/main/ \
    libexecinfo-dev=1.1-r1

ARG FUNCTION_DIR

RUN mkdir -p ${FUNCTION_DIR}

# Upgrade pip and install awslambdaric
RUN python -m pip install --upgrade pip && \
    python -m pip install --no-cache-dir --target ${FUNCTION_DIR} awslambdaric==2.0.12

FROM python-alpine

ARG FUNCTION_DIR

WORKDIR ${FUNCTION_DIR}

COPY --from=build-image ${FUNCTION_DIR} ${FUNCTION_DIR}

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Change ownership of the FUNCTION_DIR to the non-root user
RUN chown -R appuser:appgroup ${FUNCTION_DIR}

ENV LAMBDA_TASK_ROOT=${FUNCTION_DIR}

# Set the default command to handle Lambda invocation
ENTRYPOINT [ "/usr/local/bin/python", "-m", "awslambdaric" ]

# Use the non-root user
USER appuser
