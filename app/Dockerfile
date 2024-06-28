# Use the previously built image as the base
FROM 975050106607.dkr.ecr.eu-west-2.amazonaws.com/base-image:acb8403

# Copy the application code into the container
COPY --chown=appuser:appgroup . ${LAMBDA_TASK_ROOT}

# Install any application-specific dependencies
# If you have a requirements.txt, you can install dependencies here
RUN python -m pip install --no-cache-dir -r requirements.txt --target ${LAMBDA_TASK_ROOT}

# Set the command to the Lambda function handler
CMD [ "app.lambda_handler" ]