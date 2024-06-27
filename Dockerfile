FROM public.ecr.aws/lambda/python:3.12

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONBUFFERED=1
ENV POETRY_NO_INTERACTION=1
ENV POETRY_VIRTUALENVS_IN_PROJECT=true
ENV POETRY_VIRTUALENVS_CREATE=true
ENV POETRY_CACHE_DIR=/var/cache/pypoetry
ENV POETRY_HOME=/usr/local
ENV POETRY_VERSION=1.8.3
ENV PATH=/var/task/.venv/bin:$PATH

RUN addgroup -S taskgroup && adduser --disabled-password --gecos "" taskuser -G taskgroup

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python3 -

RUN chown -R taskuser:taskgroup /var/task

USER taskuser

# Copy pyproject.toml and poetry.lock
COPY --chown=taskuser:taskgroup pyproject.toml poetry.lock ./

# Install project dependencies using Poetry
RUN poetry install --no-interaction --no-cache --no-ansi --only main

# Set the entrypoint
ENTRYPOINT [ "/lambda-entrypoint.sh" ]
