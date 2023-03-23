# windows, prerequisite: install docker on your system
# details, usage: https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container
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

#  docker container ls -a
#  docker container exec -it tutorial powershell
#  ls, exit
#  terraform destroy -auto-approve
