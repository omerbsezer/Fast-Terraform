## LAB-01: Terraform Docker => Pull Docker Image, Create Docker Container on Local Machine

This scenario shows:
- how to use Terraform to manage Docker commands (image pull, container create, etc.)
- without using any cloud, with Terraform Docker module, learning Terraform and making more practice could be easier.


**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/terraform-docker-without-cloud/main.tf

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)
- Install Docker on your system.
  - Ubuntu: https://docs.docker.com/engine/install/ubuntu/
  - Windows: https://docs.docker.com/desktop/install/windows-install/
  - Mac: https://docs.docker.com/desktop/install/mac-install/ 

## Steps

- Create main.tf and copy the code:
 
``` 
# main.tf
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {
  host    =  "npipe:////.//pipe//docker_engine"
}

resource "docker_image" "windows" {
  name         = "mcr.microsoft.com/powershell:lts-windowsservercore-1809"
  keep_locally = true
}

# docker container run -p 80:8000 --name=tutorial -it mcr.microsoft.com/powershell:lts-windowsservercore-1809 powershell
resource "docker_container" "windows" {
  image = docker_image.windows.image_id
  name  = "tutorial"
  
  stdin_open = true             # docker run -i
  tty        = true             # docker run -t
  
  entrypoint = ["powershell"]
  
  ports {
    internal = 80
    external = 8000
  }
}
``` 
**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/labs/terraform-docker-without-cloud/main.tf

![image](https://user-images.githubusercontent.com/10358317/227287393-09ff08a1-9db2-4fc5-98e8-1a20c2bdf9be.png)

- Run init command:

``` 
terraform init
``` 

![image](https://user-images.githubusercontent.com/10358317/227279233-74013a80-0a71-4c0c-84b7-e9cec6c9d30f.png)

- Validate file:

``` 
terraform validate
``` 

- Run plan command:

``` 
terraform plan
``` 

![image](https://user-images.githubusercontent.com/10358317/227279536-a2f72789-36f6-4ee1-82df-a0bed834d34d.png)

- Run apply command to create resources. Then, Terraform asks to confirm, write "yes":

``` 
terraform apply
```   

![image](https://user-images.githubusercontent.com/10358317/227281131-7463a9dc-1f61-4f48-a906-410725c0af19.png)

- With "docker container ls -a", running container is viewed: 

![image](https://user-images.githubusercontent.com/10358317/227280862-04483fb7-530d-4a75-ad22-21e8a5cbf49b.png)

- Run following command to connect container powershell:
 
```
docker container exec -it tutorial powershell
```

- Now, we are in the container, to prove it, we are looking at the users in the container (ContainerAdministrator, ContainerUser)

![image](https://user-images.githubusercontent.com/10358317/227282456-4452cbe2-611c-491a-a9f7-f6bbaab28d69.png)

- Before Terraform runs the container, it pulls the image:

![image](https://user-images.githubusercontent.com/10358317/227283686-a6b2ee63-8c01-4610-84c0-3f5d5f622166.png)

- When "keep_locally = true" in image part, image will be kept after terraform destroy.

```
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/227284301-9fa06ebe-faa5-47aa-ac52-234bf6ca2c4e.png)

- After destroy command, container is deleted, but image is still kept

![image](https://user-images.githubusercontent.com/10358317/227285010-450e8cc2-b3e8-4dd5-9272-65d9f69bfd18.png)

- With Terraform, we can manage docker images, containers..
- More information: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container


