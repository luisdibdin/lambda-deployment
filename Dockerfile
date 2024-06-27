FROM public.ecr.aws/docker/library/python:3.12-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
ENV POETRY_NO_INTERACTION=1
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_VIRTUALENVS_CREATE=true
ENV POETRY_CACHE_DIR="/var/cache/pypoetry"
ENV POETRY_HOME="/usr/local"
ENV POETRY_VERSION="1.8.3"
ENV LANG=en_US.UTF-8
ENV TZ=:/etc/localtime
ENV LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
ENV LAMBDA_TASK_ROOT=/var/task
ENV LAMBDA_RUNTIME_DIR=/var/runtime

RUN addgroup -S taskgroup && adduser -S taskuser -G taskgroup

# Install dependencies
RUN apk update && \
    apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    tzdata \
    curl \
    bash \
    wget

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

WORKDIR /var/task

# Create a constraints.txt file for awslambdaric to avoid PEP 517 builds
RUN echo "awslambdaric" > constraints.txt

# Install common packages
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-interaction --no-cache --no-ansi --only main -C constraints.txt

ENV PATH="/var/task/.venv/bin:$PATH"

# Copy the entrypoint script
COPY lambda-entrypoint.sh /lambda-entrypoint.sh
RUN chmod +x /lambda-entrypoint.sh

# Set the entrypoint
ENTRYPOINT [ "/lambda-entrypoint.sh" ]

# Set the default command to handle Lambda invocation
CMD [ "python3", "-m", "awslambdaric" ]
