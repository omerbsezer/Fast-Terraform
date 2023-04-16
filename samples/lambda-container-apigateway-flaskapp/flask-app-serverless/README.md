## Flask-App Serverless Docker Image for Lambda Container

- Dockerfile is created for this sample, for specific Lambda container usage.
- App.py is updated
  - importing "serverless_wsgi, shlex, subprocess" libraries
  - handler return is updated:
    - "serverless_wsgi.handle_request(app, event, context)"
  - sqlite db file copies to "/tmp/" directory, because lambda allows only the files under "/tmp/" to have write permission	
    - "subprocess.check_output(shlex.split("cp database.db /tmp/database.db"))"
    - "subprocess.check_output(shlex.split("/bin/chmod 777 /tmp/database.db"))"

- Build Docker image:

```
docker build -t flask-app-serverless .
```

- Source code is pulled from:
  - https://www.digitalocean.com/community/tutorials/how-to-make-a-web-application-using-flask-in-python-3
  - https://github.com/do-community/flask_blog

- For app, Thank you Digital Ocean for the sample Flask app!