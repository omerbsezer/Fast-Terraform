## SAMPLE-04: Provisioning ECR (Elastic Container Repository), Pushing Image to ECR, Provisioning ECS (Elastic Container Service), VPC (Virtual Private Cloud), ELB (Elastic Load Balancer), ECS Tasks and Service on Fargate Cluster

This sample shows:
- how to create Flask-app Docker image,
- how to provision ECR and push to image to this ECR,
- how to provision VPC, Internet Gateway, Route Table, 3 Public Subnets,
- how to provision ALB (Application Load Balancer), Listener, Target Group,  
- how to provision ECS Fargate Cluster, Task and Service (running container as Service)

There are 5 main parts:
- **0_ecr.tf**: includes private ECR code
- **1_vpc.tf**: includes VPC, IGW, Route Table, Subnets code
- **2_ecs.tf**: includes ECS Cluster, Task Definition, Role and Policy code
- **3_elb.tf**: includes to ALB, Listener, Target Group, Security Group code 
- **4_ecs_service.tf**: includes ECS Fargate Service code with linking to loadbalancer, subnets, task definition.

   ![ecr-ecs](https://user-images.githubusercontent.com/10358317/232244927-7d819c66-328a-4dd5-b3e1-18b2c7fd92aa.png)

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ecr-ecs-elb-vpc-ecsservice-container

**ECS Pricing:**
- For the ECS Cluster:
  - **Free**
- For the ECS on 1 EC2 Instance (e.g. m5.large => 2 vCPU, 8 GB RAM):
  - **Per Hour:** $0.096  
  - **Per Day:**  $2.304
  - **For 30 days:** $69.12
  - Please have look for instance pricing: https://aws.amazon.com/ec2/pricing/on-demand/ 
- For the Fargate: 
  - AWS Fargate pricing is calculated based on the **vCPU and memory** resources used from the time you start to download your container image until the ECS Task (Container) terminate.
    - e.g. 2 x (1vCPU, 4GB RAM) on Linux: 
      - **Per Hour:** 2 x ($0,0665) = $0.133
      - **Per Day:** $3,18
      - **Per 30 Days:** $95.67
    - e.g. 2 x (1vCPU, 4GB RAM) on Win: 
      - **Per Hour:** 2 x ($0,199) = $0.398
      - **Per Day:** $9.55
      - **Per 30 Days:** $286.56
  - Please have look for fargate pricing: https://aws.amazon.com/fargate/pricing/

# Table of Contents
- [Flask App Docker Image Creation](#app)
- [Creating ECR (Elastic Container Repository), Pushing Image into ECR](#ecr)
- [Creating VPC (Virtual Private Cloud)](#vpc)
- [Creating ECS (Elastic Container Service)](#ecs)
- [Creating ELB (Elastic Load Balancer)](#elb)
- [Creating ECS Service](#ecsservice)
- [Demo: Terraform Run](#run)

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

### Flask App Docker Image Creation <a name="app"></a>
- We have Flask-App to run on AWS ECS. To build image, please have a look:
  - https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ecr-ecs-elb-vpc-ecsservice-container/flask-app

### Creating ECR (Elastic Container Repository), Pushing Image into ECR <a name="ecr"></a>

- Create 0_ecr.tf:
 
```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Creating Elastic Container Repository for application
resource "aws_ecr_repository" "flask_app" {
  name = "flask-app"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ecr-ecs-elb-vpc-ecsservice-container/ecr/0_ecr.tf

![image](https://user-images.githubusercontent.com/10358317/232241506-8abd69f6-8802-434e-976f-0420a226fa3f.png)

```
cd /ecr
terraform init
terraform plan
terraform apply
```

- On AWS ECR:

  ![image](https://user-images.githubusercontent.com/10358317/232226427-e8a9883e-298d-4268-b553-960f31994933.png)

- To see the pushing docker commands, click "View Push Commands"

```
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin <UserID>.dkr.ecr.eu-central-1.amazonaws.com
docker tag flask-app:latest <UserID>.ecr.eu-central-1.amazonaws.com/flask-app:latest
docker push <UserID>.dkr.ecr.eu-central-1.amazonaws.com/flask-app:latest
```

- Image was pushed:

  ![image](https://user-images.githubusercontent.com/10358317/232226726-bffcca9f-4654-44bc-86dc-02a8d2d17c38.png)

- On AWS ECR:

  ![image](https://user-images.githubusercontent.com/10358317/232226806-aa709e35-25de-4110-ad5c-92949cc1ebe8.png) 

### Creating VPC (Virtual Private Cloud) <a name="vpc"></a>

- Create 1_vpc.tf:
 
```
# Internet Access -> IGW ->  Route Table -> Subnets
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
	region = "eu-central-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "My VPC"
  }
}

resource "aws_subnet" "public_subnet_a" {
  availability_zone = "eu-central-1a"
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.0.0/24"
  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public_subnet_b" {
  availability_zone = "eu-central-1b"
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "Public Subnet B"
  }
}

resource "aws_subnet" "public_subnet_c" {
  availability_zone = "eu-central-1c"
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "Public Subnet C"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My VPC - Internet Gateway"
  }
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "Public Subnet Route Table"
    }
}

resource "aws_route_table_association" "route_table_association1" {
    subnet_id      = aws_subnet.public_subnet_a.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association2" {
    subnet_id      = aws_subnet.public_subnet_b.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association3" {
    subnet_id      = aws_subnet.public_subnet_c.id
    route_table_id = aws_route_table.route_table.id
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ecr-ecs-elb-vpc-ecsservice-container/1_vpc.tf

![image](https://user-images.githubusercontent.com/10358317/232241321-50a2fe1f-4fb2-4c82-b785-02bf1b326c63.png)

### Creating ECS (Elastic Container Service) <a name="ecs"></a>

- Create 2_ecs.tf:
 
```
# Getting data existed ECR
data "aws_ecr_repository" "flask_app" {
  name = "flask-app"
}

# Creating ECS Cluster
resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster" # Naming the cluster
}

# Creating ECS Task
resource "aws_ecs_task_definition" "flask_app_task" {
  family                   = "flask-app-task" 
  container_definitions    = <<DEFINITION
  [
    {
      "name": "flask-app-task",
      "image": "${data.aws_ecr_repository.flask_app.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5000,
          "hostPort": 5000
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 512         # Specifying the memory our container requires
  cpu                      = 256         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

# Creating Role for ECS
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Role - Policy Attachment for ECS
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ecr-ecs-elb-vpc-ecsservice-container/2_ecs.tf

![image](https://user-images.githubusercontent.com/10358317/232241736-14bbd3db-0c7d-4892-8f76-d762ed971c7e.png)

### Creating ELB (Elastic Load Balancer) <a name="elb"></a>

- Create 3_elb.tf:
 
```
# Internet Access -> IGW -> LB Security Groups -> Application Load Balancer  (Listener 80) -> Target Groups  -> ECS Service -> ECS SG -> Tasks on each subnets 

# Creating Load Balancer (LB)
resource "aws_alb" "application_load_balancer" {
  name               = "test-lb-tf" # Naming our load balancer
  load_balancer_type = "application"
  subnets = [ 
    "${aws_subnet.public_subnet_a.id}",
    "${aws_subnet.public_subnet_b.id}",
    "${aws_subnet.public_subnet_c.id}"
  ]
  # Referencing the security group
  security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
}

# Creating a security group for LB
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating LB Target Group
resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "${aws_vpc.my_vpc.id}" 
}

# Creating LB Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
  }
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ecr-ecs-elb-vpc-ecsservice-container/3_elb.tf

![image](https://user-images.githubusercontent.com/10358317/232241821-b859d54f-69ae-40ba-8034-b35fc5309fe1.png)

### Creating ECS Service <a name="ecsservice"></a>

- Create 4_ecs_service.tf:
 
```
# Creating ECS Service
resource "aws_ecs_service" "my_first_service" {
  name            = "my-first-service"                             # Naming our first service
  cluster         = "${aws_ecs_cluster.my_cluster.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.flask_app_task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  desired_count   = 3 # Setting the number of containers to 3

  load_balancer {
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our target group
    container_name   = "${aws_ecs_task_definition.flask_app_task.family}"
    container_port   = 5000 # Specifying the container port
  }

  network_configuration {
    subnets          = ["${aws_subnet.public_subnet_a.id}", "${aws_subnet.public_subnet_b.id}", "${aws_subnet.public_subnet_c.id}"]
    assign_public_ip = true                                                # Providing our containers with public IPs
    security_groups  = ["${aws_security_group.service_security_group.id}"] # Setting the security group
  }
}

# Creating SG for ECS Container Service, referencing the load balancer security group
resource "aws_security_group" "service_security_group" {
  vpc_id      = aws_vpc.my_vpc.id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    # Only allowing traffic in from the load balancer security group
    security_groups = ["${aws_security_group.load_balancer_security_group.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Log the load balancer app URL
output "app_url" {
  value = aws_alb.application_load_balancer.dns_name
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/ecr-ecs-elb-vpc-ecsservice-container/4_ecs_service.tf

![image](https://user-images.githubusercontent.com/10358317/232241887-e71759c4-6a09-4cb3-9f18-f0dc36e08eda.png)

### Demo: Terraform Run <a name="run"></a>

- Run:
 
```
terraform init
terraform validate
terraform plan
terraform apply
```

![image](https://user-images.githubusercontent.com/10358317/232227578-21f28564-d960-45ea-af0d-3c4b3bddbc91.png)

![image](https://user-images.githubusercontent.com/10358317/232227661-5ea1a161-03f0-4a76-b5c1-c9d3c1610333.png)

- On AWS ECS Cluster:

  ![image](https://user-images.githubusercontent.com/10358317/232227690-14ca0e5d-43bf-443e-b228-338081f17eb8.png)

- On AWS ECS Service (service runs on the cluster):

  ![image](https://user-images.githubusercontent.com/10358317/232227740-b0216d39-d141-4174-a506-61fc46245f02.png)

- ECS Service Tasks (task includes running 3 containers):

  ![image](https://user-images.githubusercontent.com/10358317/232227792-8f3bcd80-edcb-4893-bb5e-25432d87f38f.png)

- Running Container Details (CPU, Memory Usage, Network, Environment Variable, Volume Configuration, Logs):

  ![image](https://user-images.githubusercontent.com/10358317/232227895-07a3475a-c62a-4966-a35b-807fb4e136a6.png)

- On AWS EC2 > LoadBalancer:

  ![image](https://user-images.githubusercontent.com/10358317/232228088-74870060-9cbb-46e6-9f28-6162ff310e2e.png)

- Target Groups:

  ![image](https://user-images.githubusercontent.com/10358317/232228412-d53c99d9-ec75-44ab-a5dc-c5b9e77cd638.png)
  
- On AWS VPC:

  ![image](https://user-images.githubusercontent.com/10358317/232229182-87c75449-0bd5-4048-833c-d0e9c3dc41c0.png)
 
- When go to the output of the ELB DNS: http://test-lb-tf-634023821.eu-central-1.elb.amazonaws.com/

  ![image](https://user-images.githubusercontent.com/10358317/232228546-8c9beb79-2133-438e-a05c-a36beef7b3f5.png)
  
- LB redirects 3 different containers. Each container has own SQLlite. So, each refresh to LB page, it shows 3 different page:
- Container 0:

  ![image](https://user-images.githubusercontent.com/10358317/232228846-a442f536-e127-448e-a699-350be155c5bb.png)
  
- Container 1: 

  ![image](https://user-images.githubusercontent.com/10358317/232228931-3370f751-fe9a-43e9-b75b-ec98b0a3693b.png)
   
- Container 2: 

  ![image](https://user-images.githubusercontent.com/10358317/232228879-fc9ca3fb-6d0c-4be6-a484-b6ac76375dd2.png)

 
- Destroy the infra:

```
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/232229470-6fd4dc95-bb63-4bda-860a-1fecc14a4fa5.png)

- Delete the ECR Repo:

```
cd ecr
terraform destroy
```

![image](https://user-images.githubusercontent.com/10358317/232229541-913de839-4df6-4d5b-881b-56be12801334.png)

