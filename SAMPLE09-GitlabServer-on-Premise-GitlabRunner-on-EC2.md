## SAMPLE-09: Running Gitlab Server using Docker on Local Machine and Making Connection to Provisioned Gitlab Runner on EC2 in Home Internet without Using VPN

This sample shows:
- how to run Gitlab Server using Docker on WSL2 on-premise,
- how to redirect external traffic to docker container port (Gitlab server),
- how to configure on-premise PC network configuration,
- how to run EC2 and install docker, gitlab-runner on EC2,
- how to register Gitlab runner on EC2 to Gitlab Server on-premise (in Home),
- how to run job on EC2 and returns artifacts to Gitlab Server on-premise (in Home).

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/gitlabserver-on-premise-runner-on-EC2/

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Run Gitlab Server on WSL2, run: docker-compose up -d

```
# docker-compose.yml
version: '3.6'
services:
  web:
    image: 'gitlab/gitlab-ee:latest'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://gitlab.example.com'
        #external_url 'https://gitlab.example.com'
      DOCKER_HOST: '192.168.178.28'
    ports:
      - '150:80'
      - '443:443'
      - '22:22'
    volumes:
      - '/home/omer/gitlab-tmp/config:/etc/gitlab'
      - '/home/omer/gitlab-tmp/logs:/var/log/gitlab'
      - '/home/omer/gitlab-tmp/data:/var/opt/gitlab'
    shm_size: '256m'
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/gitlabserver-on-premise-runner-on-EC2/docker-compose.yml

- Run the following in where the dockercompose.yml is present:

```
docker-compose up -d
# if u don't know the username and password
docker container ls -a
docker exec -it git-server_web_1 bash
> gitlab-rake gitlab:password:reset  # run in the container
> username: root
> password:987aws12345
> Password successfully updated for user with username root.
> exit
```

![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/0c122fd7-645a-40c3-bfb6-799d9c2fcd82)

- If you run docker in the WSL, call browser in the WSL: "sensible-browser http://gitlab.example.com:150/"

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/f3e6d11a-6b6e-4ab6-a8c6-01c718090243)

- This runs on 127.0.0.1:150 when you run "netstat -an" on windows, but we want to run it on the host machine IP "192.168.178.28:150"
- Use PORT Proxy from 127.0.0.1:150 to 192.168.178.28:150

```
netsh interface portproxy add v4tov4 listenport=150 connectaddress=127.0.0.1 connectport=150 listenaddress=192.168.178.28 protocol=tcp
# for delete: netsh interface portproxy delete v4tov4 listenport=150 listenaddress=192.168.178.28 protocol=tcp
```

- Now, when it runs on both hostIP:150 and 127.0.0.1:150. This requires to NAT Forwarding

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/f1419f87-f3ef-4666-b4d8-9bb6fd3e0295)

- On Network Config, make connection (ethernet or wireless) to static IP 192.168.178.28.
  
  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/437d7e0b-5a76-4a94-999b-a9c6dfc07f67)

- On the modem switch, enable NAT Forwarding, this enables that external traffic redirects to the host machine: 192.168.178.1 => Internet.Permit Access => PC, TCP Port 150 through 150, external 150.
 
- Test on browser (gitlab server runs) on 192.168.178.28:150:

- On 'C:\Windows\System32\drivers\etc\host' file, add '127.0.0.1 gitlab.example.com', test with 'gitlab.example.com' on browser on-premise:
  
  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/2349083d-c9b2-4ad2-980a-24839d169e76)

- Close/pause the firewall to reach the service from outside.
- Learn the external IP with googling 'what is my IP', and test 'externalIP:150' on browser:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/1a692453-4b6e-4bc6-9898-bfe31f28ee1d)

- Create EC2 on AWS with:

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/gitlabserver-on-premise-runner-on-EC2/main.tf

```
terraform init
terraform plan
terraform apply
```

- Make SSH to Ubuntu

```
ssh -i .\testkey.pem ubuntu@UbuntuPublicIP
```

- While launching the EC2, docker and gitlab-runner were installed on it. 
- Run 'curl http://externalIP:150', if it works, the connection was done to gitlab server on-premise

- Register gitlab-runner using 'sudo gitlab-runner register', url: http://gitlab.example.com:150/, token from Gitlab Server > Admin > CI > Runners > Register new Runner (for shared-runner), add tag: ec2-shared, executable: docker, and alpine.

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/d6187256-775f-4abc-a76b-c81fa1b462fd)

- Runners was added, to configure to see the local URL:
  - 'nano /etc/gitlab-runner/config.toml', url = "http://gitlab.example.com:150/", add extra =>  'clone_url = "http://88.xx.xx.xx:150"' (externalIP:150), 
  - Restart gitlab-runner on EC2: 'sudo gitlab-runner restart'

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/8d97fbde-6e04-4038-bcbb-d7cafc1fb7c1)

- List runners on EC2 'sudo gitlab-runner list': 
  
  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/b889a30a-1f0a-4668-b1a4-44633a448e46)
  
- Builds => gitlab runners run on EC2, responds to results to Gitlab Server on-premise: 
  
  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/67e7e90f-caa1-462d-9125-02dd324519a6)
  
- Running jobs on EC2:

  ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/8964536b-5df5-427e-bb45-9091fc07ed29)

## References:
- https://nagachiang.github.io/gitlab-ci-gitlab-runner-cant-fetch-changes-from-repository/#

 
