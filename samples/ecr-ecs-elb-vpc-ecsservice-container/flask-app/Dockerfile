FROM python:3.8-slim-buster

WORKDIR /app

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY app .

ENV FLASK_APP=app

ENV FLASK_ENV=development

EXPOSE 5000

RUN python init_db.py

CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0","--port","5000"]