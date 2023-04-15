## Flask-App Docker Image

- Dockerfile is created for this sample.
- App code is open source and taken:
  - https://www.digitalocean.com/community/tutorials/how-to-make-a-web-application-using-flask-in-python-3
  - https://github.com/do-community/flask_blog

- To build Linux Container and  run on local:

```
docker build -t flask-app .
docker container run -p 5000:5000 -d flask-app
```

![image](https://user-images.githubusercontent.com/10358317/232225583-253f20dc-4d95-43b3-a4a7-d156f2d0c886.png)


- If you are using WSL2 on Windows, use sensible browser on WSL2

```
sensible-browser http://localhost:5000/
```

![image](https://user-images.githubusercontent.com/10358317/232225726-d02927fe-9d64-4fba-b279-ff7c0ec7dbc1.png)


- For app, Thank you Digital Ocean!
