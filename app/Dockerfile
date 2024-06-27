FROM 975050106607.dkr.ecr.eu-west-2.amazonaws.com/base-image:194344f

COPY . ${LAMBDA_TASK_ROOT}

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "app.lambda_handler" ]