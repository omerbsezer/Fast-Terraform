FROM public.ecr.aws/lambda/python:3.8
COPY requirements.txt ${LAMBDA_TASK_ROOT}
RUN pip3 install --no-cache-dir -r requirements.txt
COPY aws-lambda-url.py ${LAMBDA_TASK_ROOT}

CMD ["aws-lambda-url.lambda_handler"]