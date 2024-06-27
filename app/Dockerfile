FROM 975050106607.dkr.ecr.eu-west-2.amazonaws.com/base-image:3e31912

COPY . ${LAMBDA_TASK_ROOT}

RUN source ${LAMBDA_TASK_ROOT}/.venv/bin/activate

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "app.lambda_handler" ]