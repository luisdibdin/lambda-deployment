FROM public.ecr.aws/lambda/python:3.11

ENV POETRY_VERSION=1.7.1
ENV PYTHONPATH=${LAMBDA_TASK_ROOT}

WORKDIR ${LAMBDA_TASK_ROOT}

RUN pip install --no-cache-dir "poetry==${POETRY_VERSION}"

COPY poetry.lock pyproject.toml ./

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

COPY app ./

CMD [ "app.lambda_handler" ]