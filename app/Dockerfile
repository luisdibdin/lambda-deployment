FROM 975050106607.dkr.ecr.eu-west-2.amazonaws.com/base-image:18b11de

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

CMD [ "app.lambda_handler" ]