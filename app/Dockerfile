# Use the previously built image as the base
FROM 975050106607.dkr.ecr.eu-west-2.amazonaws.com/base-image:e9f0467

ARG FUNCTION_DIR="/function"
ARG APP_DIR="/app"

# Copy the application code into the container
COPY . ${APP_DIR}

# Set the working directory
WORKDIR ${APP_DIR}

# Ensure the function directory is available
RUN mkdir -p ${FUNCTION_DIR}

# Install any application-specific dependencies
# If you have a requirements.txt, you can install dependencies here
# RUN python -m pip install -r requirements.txt --target ${FUNCTION_DIR}

# Set the command to the Lambda function handler
CMD [ "app.lambda_handler" ]