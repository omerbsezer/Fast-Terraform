FROM public.ecr.aws/lambda/python:3.7

WORKDIR ${LAMBDA_TASK_ROOT}

COPY app ${LAMBDA_TASK_ROOT}

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt --target "${LAMBDA_TASK_ROOT}"

ENV FLASK_APP=app

ENV FLASK_ENV=development

EXPOSE 5000

RUN python init_db.py

CMD ["app.handler"]