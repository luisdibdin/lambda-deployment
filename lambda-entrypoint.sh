#!/bin/bash

# Activate the virtual environment
source /var/task/.venv/bin/activate

# Execute the Lambda function handler
exec "$@"