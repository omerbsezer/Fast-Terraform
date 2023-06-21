# Fast-Terraform (with AWS)
This repo covers Terraform with Hands-on LABs and Samples using AWS (comprehensive, but simple): 
- Resources, Data Sources, Variables, Meta Arguments, Provisioners, Dynamic Blocks, Modules, Workspaces, Templates, Remote State.
- Provisioning AWS Components (EC2, EBS, EFS, IAM Roles, IAM Policies, Key-Pairs, VPC with Network Components, Lambda, ECR, ECS with Fargate, EKS with Managed Nodes, ASG, ELB, API Gateway, S3, CloudFront CodeCommit, CodePipeline, CodeBuild, CodeDeploy), use cases and details. Possible usage scenarios are aimed to update over time.

Why was this repo created?
- **Shows Terraform details in short with simple, clean demos and Hands-on LABs**
- **Shows Terraform AWS Hands-on Samples, Use Cases**

**Keywords:** Terraform, Infrastructure as Code, AWS, Cloud Provisioning

# Quick Look (How-To): Terraform Hands-on LABs
These LABs focus on Terraform features, help to learn Terraform:

- [LAB-00: Installing Terraform, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)
- [LAB-01: Terraform Docker => Pull Docker Image, Create Docker Container on Local Machine](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB01-Terraform-Docker-Without-Cloud.md)
- [LAB-02: Resources => Provision Basic EC2 (Ubuntu 22.04)](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB02-Resources-Basic-EC2.md)
- [LAB-03: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB03-Variables-Locals-Output-EC2.md)
- [LAB-04: Meta Arguments (Count, For_Each, Map) => Provision IAM Users, Groups, Policies, Attachment Policy-User](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB04-Meta-Arguments-IAM-User-Group-Policy.md)
- [LAB-05: Dynamic Blocks => Provision Security Groups, EC2, VPC](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB05-Dynamic-Blocks-Security-Groups-EC2.md)
- [LAB-06: Data Sources with Depends_on => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB06-Data-Sources-EC2.md)
- [LAB-07: Provisioners (file, remote-exec), Null Resources (local-exec) => Provision Key-Pair, SSH Connection](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB07-Provisioners-Null-Resources.md)
- [LAB-08: Modules => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB08-Modules-EC2.md)
- [LAB-09: Workspaces => Provision EC2 with Different tfvars Files](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB09-Workspaces-EC2.md)
- [LAB-10: Templates => Provision IAM User, User Access Key, Policy](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB10-Templates-User-Policy.md)
- [LAB-11: Backend - Remote States => Provision EC2 and Save State File on S3](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB11-Backend-Remote-State.md)
- [Terraform Cheatsheet](https://github.com/omerbsezer/Fast-Terraform/blob/main/Terraform-Cheatsheet.md)

# Quick Look (How-To): AWS Terraform Hands-on Samples
These samples focus on how to create and use AWS components (EC2, EBS, EFS, IAM Roles, IAM Policies, Key-Pairs, VPC with Network Components, Lambda, ECR, ECS with Fargate, EKS with Managed Nodes, ASG, ELB, API Gateway, S3, CloudFront, CodeCommit, CodePipeline, CodeBuild, CodeDeploy) with Terraform:

- [SAMPLE-01: Provisioning EC2s (Windows 2019 Server, Ubuntu 20.04) on VPC (Subnet), Creating Key-Pair, Connecting Ubuntu using SSH, and Connecting Windows Using RDP](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE01-EC2-VPC-Ubuntu-Win-SSH-RDP.md)
- [SAMPLE-02: Provisioning Lambda Function, API Gateway and Reaching HTML Page in Python Code From Browser](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE02-Lambda-API-Gateway-Python.md)
- [SAMPLE-03: EBS (Elastic Block Storage: HDD, SDD) and EFS (Elastic File System: NFS) Configuration with EC2s (Ubuntu and Windows Instances)](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE03-EC2-EBS-EFS.md)
- [SAMPLE-04: Provisioning ECR (Elastic Container Repository), Pushing Image to ECR, Provisioning ECS (Elastic Container Service), VPC (Virtual Private Cloud), ELB (Elastic Load Balancer), ECS Tasks and Service on Fargate Cluster](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE04-ECR-ECS-ELB-VPC-ECS-Service.md)
- [SAMPLE-05: Provisioning ECR, Lambda Function and API Gateway to run Flask App Container on Lambda](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE05-Lambda-Container-ApiGateway-FlaskApp.md)
- [SAMPLE-06: Provisioning EKS (Elastic Kubernetes Service) with Managed Nodes using Blueprint and Modules](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE06-EKS-ManagedNodes-Blueprint.md)
- [SAMPLE-07: CI/CD on AWS => Provisioning CodeCommit and CodePipeline, Triggering CodeBuild and CodeDeploy, Running on Lambda Container](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE07-CodeCommit-Pipeline-Build-Deploy-Lambda.md)
- [SAMPLE-08: Provisioning S3 and CloudFront to serve Static Web Site](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE08-S3-CloudFront-Static-WebSite.md)
- [SAMPLE-09: Running Gitlab Server using Docker on Local Machine and Making Connection to Provisioned Gitlab Runner on EC2 in Home Internet without Using VPN](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE09-GitlabServer-on-Premise-GitlabRunner-on-EC2.md)
- [SAMPLE-10: Implementing MLOps Pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and AWS Sagemaker (Endpoint)](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE10-MLOps-SageMaker-GitHub-Codepipeline-CodeBuild-CodeDeploy.md)


# Table of Contents
- [Motivation](#motivation)
- [What is Terraform?](#what_is_terraform)
- [How Terraform Works?](#how_terrafom_works)
- [Terraform File Components](#terrafom_file_components)
  - [Providers](#providers)
  - [Resources](#resources)
  - [Variables (tfvar)](#variables)
  - [Values (Locals, Outputs)](#values)
  - [Meta Arguments](#meta_arguments)
  - [Dynamic Blocks](#dynamic_blocks)
  - [Data Sources](#datasources)
  - [Provisioners (file, remote_exec, local_exec), Null Resource](#provisioners)
  - [Modules](#modules)
  - [Workspaces](#workspaces)
  - [Templates](#templates)
  - [Backends and Remote States](#backends_remote_states)
- [Terraform Best Practices](#best_practice)
- [AWS Terraform Hands-on Samples](#samples)
  - [SAMPLE-01: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](#ec2_vpc_key_pair_ssh_rdp)
  - [SAMPLE-02: Provisioning Lambda Function, API Gateway and Reaching HTML Page in Python Code From Browsers](#lambda_apigateway_python)
  - [SAMPLE-03: EBS (Elastic Block Storage: HDD, SDD) and EFS (Elastic File System: NFS) Configuration with EC2s (Ubuntu and Windows Instances)](#ebs_efs_ec2)
  - [SAMPLE-04: Provisioning ECR (Elastic Container Repository), Pushing Image to ECR, Provisioning ECS (Elastic Container Service), VPC (Virtual Private Cloud), ELB (Elastic Load Balancer), ECS Tasks and Service on Fargate Cluster](#ecr_ecs_elb_vpc_ecs_service_fargate)
  - [SAMPLE-05: Provisioning ECR, Lambda Function and API Gateway to run Flask App Container on Lambda](#ecr_lambda_apigateway_container)
  - [SAMPLE-06: Provisioning EKS (Elastic Kubernetes Service) with Managed Nodes using Blueprint and Modules](#eks_managednodes_blueprint)
  - [SAMPLE-07: CI/CD on AWS => Provisioning CodeCommit and CodePipeline, Triggering CodeBuild and CodeDeploy, Running on Lambda Container](#ci_cd)
  - [SAMPLE-08: Provisioning S3 and CloudFront to serve Static Web Site](#s3_cloudfront)
  - [SAMPLE-09: Running Gitlab Server using Docker on Local Machine and Making Connection to Provisioned Gitlab Runner on EC2 in Home Internet without Using VPN](#gitlabrunner)
  - [SAMPLE-10: Implementing MLOps Pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and AWS Sagemaker (Endpoint)](#sagemaker)
- [Details](#details)
- [Terraform Cheatsheet](#cheatsheet)
- [Other Useful Resources Related Terraform](#resource)
- [References](#references)

## Motivation <a name="motivation"></a>
Why should we use / learn Terraform?
- Terraform is cloud-agnostic and popular tool to create/provision Cloud Infrastructure resources/objects (e.g. Virtual Private Cloud, Virtual Machines, Lambda, etc.)
  - Manage any infrastructure
  - Similar to Native Infrastructure as Code (IaC): CloudFormation (AWS), Resource Manager (Azure), Google Cloud Deployment Manager (Google Cloud) 
- It is free, open source (https://github.com/hashicorp/terraform) and has a large community with enterprise support options.
- Commands, tasks, codes turn into the IaC.
  - With IaC, tasks is savable, versionable, repetable and testable.
  - With IaC, desired configuration is defined as 'Declerative Way'.
- **Agentless:** Terraform doesn’t require any software to be installed on the managed infrastructure
- It has well-designed documentation:
  - https://developer.hashicorp.com/terraform/language
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Terraform uses a modular structure.
- Terraform tracks your infrastructure with TF state file.
  ![image](https://user-images.githubusercontent.com/10358317/231144158-63009879-4687-492e-8f6a-5e233dab3f28.png)(ref: Redis)

## What is Terraform? <a name="what_is_terraform"></a>
- Terraform is cloud-independent provisioning tool to create Cloud infrastructure. 
- Creating infrastructure code with HCL (Hashicorp Language) that is similar to YAML, JSON, Python.
- Terraform Basic Tutorial for AWS: 
  - https://developer.hashicorp.com/terraform/tutorials/aws-get-started
- Reference and Details: 
  - https://developer.hashicorp.com/terraform/intro
  ![image](https://user-images.githubusercontent.com/10358317/231143883-a2348511-dd12-4e0f-806d-3144ac88aa4d.png)(ref: Terraform)

## How Terraform Works? <a name="how_terrafom_works"></a>
- Terraform works with different providers (AWS, Google CLoud, Azure, Docker, K8s, etc.)
- After creating Terraform Files (tf), terraform commands:
  - **init**: downloads the required executable apps dependent on providers.
  - **validate**: confirms the tf files.
  - **plan**: dry-run for the infrastructure, not actually running/provisioning the infrastructure
  - **apply**: runs/provisions the infrastructure
  - **destroy**: deletes the infrastructure

- Main Commands:
```
terraform init
terraform validate
terraform plan            # ask for confirmation (yes/no), after running command
terraform apply           # ask for confirmation (yes/no), after running command
terraform destroy         # ask for confirmation (yes/no), after running command
```

- Command Variants:
```
terraform plan --var-file="terraform-dev.tfvars"            # specific variable files
terraform apply -auto-approve                               # no ask for confirmation
terraform apply --var-file="terraform-prod.tfvars"          # specific variable files
terraform destroy --var-file="terraform-prod.tfvars"        # specific variable files
```
- Terraform Command Structure:

  ![image](https://user-images.githubusercontent.com/10358317/234230001-67475a51-d894-4234-8917-07d14355b205.png)

- Terraform Workflow:

  ![image](https://user-images.githubusercontent.com/10358317/231147788-ba40b795-4050-49df-b1ad-48b273257410.png)

- TF state file stores the latest status of the infrastructure after running "apply" command.
- TF state file deletes the status of the infrastructure after running "destroy" command.
- TF state files are stored:
  - on local PC 
  - on remote cloud (AWS S3, Terraform Cloud) 

- Please have a look LABs and SAMPLEs to learn how Terraform works in real scenarios.
 
## Terraform File Components <a name="terrafom_file_components"></a>
- Terraform file has different components to define infrastructure for different purposes. 
  - Providers,
  - Resources,
  - Variables,
  - Values (locals, outputs),
  - Meta Argurments (for, for_each, map, depends_on, life_cycle),
  - Dynamic Blocks,
  - Data Sources,
  - Provisioners,
  - Workspaces,
  - Modules,
  - Templates.

### Providers <a name="providers"></a>
- Terraform supposes for different providers (AWS, Google Cloud, Azure).
- Terraform downloads required executable files from own cloud to run IaC (code) for the corresponding providers.
- AWS (https://registry.terraform.io/providers/hashicorp/aws/latest/docs): 

  ![image](https://user-images.githubusercontent.com/10358317/231405120-1d6907be-53f6-46e8-8e6f-a5dd73a0cfb5.png)

- Google Cloud (GCP) (https://registry.terraform.io/providers/hashicorp/google/latest/docs):

  ![image](https://user-images.githubusercontent.com/10358317/231405236-73faf1e4-3ea8-45df-982e-d56f64eba2a5.png)

- Azure (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs):

  ![image](https://user-images.githubusercontent.com/10358317/231405457-7b90a689-96c6-434d-a319-162adc04f772.png)
  
 - Docker (https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs/resources/container):
   
   ![image](https://user-images.githubusercontent.com/10358317/231437580-0dc3ce8f-bbbe-4b4e-97b7-6598e85cb59e.png)

### Resources <a name="resources"></a>
- Resources are used to define for different cloud components and objects (e.g. EC2 instances, VPC, VPC Compoenents: Router Tables, Subnets, IGW, .., Lambda, API Gateway, S3 Buckets, etc.). 
- To learn the details, features of the cloud components, you should know how the cloud works, which components cloud have, how to configure the cloud components.
- Syntax:
  - **resource <AWS_Object> <User_Defined_Variable_Name_With_Underscore> {}**
    - e.g. resource "aws_instance" "instance" {}
    - e.g. resource "aws_vpc" "my_vpc" {}
    - e.g. resource "aws_subnet" "public" {}
    - e.g. resource "aws_security_group" "allow_ssh" {}
  
    ![image](https://user-images.githubusercontent.com/10358317/231420818-d0c3e679-787b-4d85-a784-6f4acdb7fa01.png)
  
- Important part is to check the usage of the resources (shows which arguments are optional, or required) from Terraform Registry page by searching the "Object" terms like "instance", "vpc", "security groups"
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  
  ![image](https://user-images.githubusercontent.com/10358317/231423197-71c23a76-a55e-4cf0-bb51-d81e45b30ff1.png)

- There are different parts:
  - **Argument References (inputs)** (some parts are optional, or required)
  - **Attributes References (outputs)**
  - **Example code snippet** to show how it uses
  - **Others** (e.g. timeouts, imports)

- Go to LAB to learn resources:
  - [LAB-02: Resources => Provision Basic EC2 (Ubuntu 22.04)](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB02-Resources-Basic-EC2.md)

### Variables (tfvar) <a name="variables"></a>
- Variables help to avoid hard coding on the infrastructure code. 
- The Terraform language uses the following types for its values:
  - **string:** a sequence of Unicode characters representing some text, like "hello".
  - **number:** a numeric value. The number type can represent both whole numbers like 15 and fractional values like 6.283185.
  - **bool:** a boolean value, either true or false. bool values can be used in conditional logic.
  - **list (or tuple):** a sequence of values, like ["one", "two"]. Elements in a list or tuple are identified by consecutive whole numbers, starting with zero.
  - **map (or object):** a group of values identified by named labels, like {name = "Mabel", age = 52}.
  - Strings, numbers, and bools are sometimes called primitive types. Lists/tuples and maps/objects are sometimes called complex types, structural types, or collection types.
- Normally, if you define variables, after running "terraform apply" command, on the terminal, stdout requests from the user to enter variables.
- But, if the "tfvar" file is defined, variables in the "tfvar" file are entered automatically in the corresponding variable fields.  

  ![image](https://user-images.githubusercontent.com/10358317/231144889-3edd38a4-1ff9-4c82-8155-50f0089757fa.png)

- Tfvar files for development ("DEV") environment: 
 
  ![image](https://user-images.githubusercontent.com/10358317/231437129-29191b28-368d-4fe5-8b99-abae9986e424.png)

- Tfvar files for production ("PROD") environment: 

  ![image](https://user-images.githubusercontent.com/10358317/231145166-f032ae1e-9bbb-436a-9c0e-3c0be8fb627c.png)

- Go to LAB to learn variables and tfvar file, and provisioning EC2 for different environments:
  - [LAB-03: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB03-Variables-Locals-Output-EC2.md)

### Values (Locals, Outputs) <a name="values"></a>
- "Locals" are also the variables that are mostly used as place-holder variables.

  ![image](https://user-images.githubusercontent.com/10358317/231438120-8c6f0cb4-ea56-457f-8532-7bc2ee4bc39b.png)

- "Outputs" are used to put the cloud objects' information (e.g. public IP, DNS, detailed info) out as stdout.  

  ![image](https://user-images.githubusercontent.com/10358317/231438718-880861bb-900d-49e2-b642-eafe0437a457.png)
  
- "Outputs" after running "terraform apply" command on the terminal stdout:

  ![image](https://user-images.githubusercontent.com/10358317/231439218-d8f19bdb-ed5c-48b0-ad49-1f48fbb649f8.png)

- Go to LAB to learn more about variables, locals, outputs and provisioning EC2:
  - [LAB-03: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB03-Variables-Locals-Output-EC2.md)

### Meta Arguments <a name="meta_arguments"></a>
- Different meta arguments are used for different purposes:
  - **count:** the number of objects (e.g. variables, resources, etc.)
    - https://developer.hashicorp.com/terraform/language/meta-arguments/count 
  - **for:** iteration over the list of objects (e.g. variables, resources, etc.)
  - **for_each:** iteration over the set of objects (e.g. variables, resources, etc.)  
    - https://developer.hashicorp.com/terraform/language/meta-arguments/for_each
  - **depends_on:** shows the priority order of creation of the resource. If "A" should be created before "B", user should write "depends_on= A" as an argument under "B". 
    - https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on 
  - **life_cycle:** uses to make life cycle relationship between objects (e.g. variables, resources, etc.)
    - https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle 
  - **providers:** specifies which provider configuration to use for a resource, overriding Terraform's default behavior.
    - https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider

- Count:  

  ![image](https://user-images.githubusercontent.com/10358317/231446996-da7cfb44-3c6a-43a2-ab89-8dd93a8318a5.png)

- For_each, For:

  ![image](https://user-images.githubusercontent.com/10358317/231447409-b09e98e5-4ce8-4d7d-83e0-60edc6c9b88e.png)

- Go to LAB to learn:
  - [LAB-04: Meta Arguments (Count, For_Each, Map) => Provision IAM Users, Groups, Policies, Attachment Policy-User](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB04-Meta-Arguments-IAM-User-Group-Policy.md)

### Dynamic Blocks <a name="dynamic_blocks"></a>
- "Dynamic blocks" creates small code template that reduces the code repetition.
- In the example below, it isn't needed to create parameters (description, from_port, to_port, protocol, cidr_blocks) for each ingress ports:

  ![image](https://user-images.githubusercontent.com/10358317/231145371-c9322d06-326d-44f7-95e2-e9ec6f806bfe.png)

- Go to LAB to learn:
  - [LAB-05: Dynamic Blocks => Provision Security Groups, EC2, VPC](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB05-Dynamic-Blocks-Security-Groups-EC2.md)

### Data Sources <a name="datasources"></a>
- "Data Sources" helps to retrieve/fetch/get data/information from previously created/existed cloud objects/resources.

- In the example below:
  - "filter" keyword is used to select/filter the existed objects (reources, instances, etc.)
  - "depends_on" keyword provides to run the data block after resource created.
  
  ![image](https://user-images.githubusercontent.com/10358317/231145418-c333d2df-706f-4325-8eb2-5d677fa30ce5.png)

- Go to LAB to learn:
  - [LAB-06: Data Sources with Depends_on => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB06-Data-Sources-EC2.md)

### Provisioners <a name="provisioners"></a>
- "Provisioners" provides to run any commands on the remote instance/virtual machine, or on the local machine.
- "Provisioners" in the resource block runs only once while creating the resource on remote instance. If the resource is created/provisioned before, "provisioner" block in the resource block doesn't run again.
- With "null_resource":
  - Without creating any resource, 
  - Without depending any resource, 
  - Any commands can be run.
- Provisioners in the "null_resource" run multiple times and it doesn't depend on the resource.  
- With provisioner "file", on the remote instance, new file can be created
- With provisioner "remote-exec", on the remote instance, any command can be run
- With provisioner "local-exec", on the local PC, any command can be run on any shell (bash, powershell)

  ![image](https://user-images.githubusercontent.com/10358317/231145525-4f97c4a1-dc6f-4323-a8ca-7041c27d00d9.png)

- Go to LAB to learn about different provisioners:
  - [LAB-07: Provisioners (file, remote-exec), Null Resources (local-exec) => Provision Key-Pair, SSH Connection](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB07-Provisioners-Null-Resources.md)

### Modules <a name="modules"></a>
- "Modules" helps organize configuration, encapsulation, re-usability and consistency.
- "Modules" is the structure/container for multiple resources that are used together.  
- Each modules usually have variables.tf that is configured from the parent tf file.
- Details: https://developer.hashicorp.com/terraform/language/modules
- AWS modules for different components (VPC, IAM, SG, EKS, S3, Lambda, RDS, etc.) 
  - https://registry.terraform.io/browse/modules?provider=aws

    ![image](https://user-images.githubusercontent.com/10358317/231145600-59034277-0781-4285-9fa8-987a1c7f6e27.png)

- Go to LAB to learn:
  - [LAB-08: Modules => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB08-Modules-EC2.md)

### Workspaces <a name="workspaces"></a>
- With "Workspaces":
  - a parallel, distinct copy of your infrastructure which you can test and verify in the development, test, and staging, 
  - like git, you are working on different workspaces (like branch),
  - single code but different workspaces,
  - it creates multiple state files on different workspace directories.
  
- Workspace commands:

``` 
terraform workspace help                       # help for workspace commands
terraform workspace new [WorkspaceName]        # create new workspace
terraform workspace select [WorkspaceName]     # change/select another workspace
terraform workspace show                       # show current workspace
terraform workspace list                       # list all workspaces
terraform workspace delete [WorkspaceName]     # delete existed workspace
``` 
- "dev" and "prod" workspaces are created:
  
  ![image](https://user-images.githubusercontent.com/10358317/231145703-c35b657c-7e39-4d53-980f-4561fda9489d.png)

- Go to LAB to learn:
  - [LAB-09: Workspaces => Provision EC2 with Different tfvars Files](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB09-Workspaces-EC2.md)

### Templates <a name="templates"></a>
- With "Templates" (.tftpl files):
  - avoid to write same code snippets multiple times,
  - provide to shorten the code

- In the example below, templates fields are filled with list in the resource code block:

  ![image](https://user-images.githubusercontent.com/10358317/231479114-e7cf013a-4b83-4288-b581-c180bbee7eee.png)

- Go to LAB to learn "Templates":
  - [LAB-10: Templates => Provision IAM User, User Access Key, Policy](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB10-Templates-User-Policy.md)

### Backend and Remote States <a name="backends_remote_states"></a>
- With enabling remote state file using backend:
  - multiple user can work on the same state file
  - saving common state file on S3 is possible

- With backend part ("s3"), state file is stored on S3:

  ![image](https://user-images.githubusercontent.com/10358317/231481348-2b0a35aa-f2a6-4335-87fb-fe6df31f9e73.png)

- On AWS S3 Bucket, terraform.tfstate file is saved:

  ![image](https://user-images.githubusercontent.com/10358317/231145912-908af9fe-56ef-479e-8ee4-9c5f7f92329e.png)

- Go to LAB to learn:
  - [LAB-11: Backend - Remote States => Provision EC2 and Save State File on S3](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB11-Backend-Remote-State.md)

## Terraform Best Practices <a name="best_practice"></a>

- Don't change/edit anything on state file manually. Manipulate state file only through TF commands (e.g. terraform apply, terraform state). 
- Use remote state file to share the file with other users. Keep state file on the Cloud (S3, Terraform Cloud, etc.)
- To prevent concurrent changes, state locking is important. Hence concurrent change from multiple user can be avoided. 
  - S3 supports state locking and consistency via DynamoDB.
- Backing up state file is also important to save the status. S3 enables versioning. Versioning state file can provide you backing up the state file.
- If you use multiple environment (dev, test, staging, production), use 1 state file per environment. Terraform workspace provide multiple state files for different environments.
- Use Git repositories (Github, Gitlab) to host TF codes to share other users.
- Behave your Infrastructure code as like your application code. Create CI pipeline/process for your TF Code (review tf code, run automated tests). This will shift your infrastructure code high quality.
- Execute Terraform only in an automated build, CD pipeline/process. This helps to run code automatically and run from one/single place. 
- For naming conventions: https://www.terraform-best-practices.com/naming 

## AWS Terraform Hands-on Samples <a name="samples"></a>

### SAMPLE-01: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections <a name="ec2_vpc_key_pair_ssh_rdp"></a>
- This sample shows:
  - how to create Key-pairs (public and private keys) on AWS,
  - how to create EC2s (Ubuntu 20.04, Windows 2019 Server),
  - how to create Virtual Private Cloud (VPC), VPC Components (Public Subnet, Internet Gateway, Route Table) and link to each others,
  - how to create Security Groups (for SSH and Remote Desktop).
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ec2-vpc-ubuntu-win-ssh-rdp
- **Go to the Hands-On Sample:**
  - [SAMPLE-01: Provisioning EC2s (Windows 2019 Server, Ubuntu 20.04) on VPC (Subnet), Creating Key-Pair, Connecting Ubuntu using SSH, and Connecting Windows Using RDP](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE01-EC2-VPC-Ubuntu-Win-SSH-RDP.md)
  
  ![image](https://user-images.githubusercontent.com/10358317/233837033-01c37232-75f8-4815-a5d6-e3f73139963e.png)
  
  
### SAMPLE-02:  Provisioning Lambda Function, API Gateway and Reaching HTML Page in Python Code From Browsers <a name="lambda_apigateway_python"></a>
- This sample shows:
  - how to create Lambda function with Python code,
  - how to create lambda role, policy, policy-role attachment, lambda api gateway permission, zipping code,
  - how to create api-gateway resource and method definition, lambda - api gateway connection, deploying api gateway, api-gateway deployment URL as output
  - details on AWS Lambda, API-Gateway, IAM.
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/lambda-role-policy-apigateway-python
- **Go to the Hands-On Sample:**
  - [SAMPLE-02: Provisioning Lambda Function, API Gateway and Reaching HTML Page in Python Code From Browser](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE02-Lambda-API-Gateway-Python.md)
  
  ![image](https://user-images.githubusercontent.com/10358317/233837058-7909658d-b06d-49e3-8f81-d56ccf295609.png)

### SAMPLE-03: EBS (Elastic Block Storage: HDD, SDD) and EFS (Elastic File System: NFS) Configuration with EC2s (Ubuntu and Windows Instances) <a name="ebs_efs_ec2"></a>
- This sample shows:
  - how to create EBS, mount on Ubuntu and Windows Instances,
  - how to create EFS, mount on Ubuntu Instance,
  - how to provision VPC, subnet, IGW, route table, security group.
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ec2-ebs-efs
- **Go to the Hands-On Sample:**
  - [SAMPLE-03: EBS (Elastic Block Storage: HDD, SDD) and EFS (Elastic File System: NFS) Configuration with EC2s (Ubuntu and Windows Instances)](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE03-EC2-EBS-EFS.md)
  
  ![image](https://user-images.githubusercontent.com/10358317/230903321-5bca3385-9564-44f1-bde8-fe1c873c870a.png)
  
### SAMPLE-04: Provisioning ECR (Elastic Container Repository), Pushing Image to ECR, Provisioning ECS (Elastic Container Service), VPC (Virtual Private Cloud), ELB (Elastic Load Balancer), ECS Tasks and Service on Fargate Cluster <a name="ecr_ecs_elb_vpc_ecs_service_fargate"></a>  
- This sample shows:
  - how to create Flask-app Docker image,
  - how to provision ECR and push to image to this ECR,
  - how to provision VPC, Internet Gateway, Route Table, 3 Public Subnets,
  - how to provision ALB (Application Load Balancer), Listener, Target Group,
  - how to provision ECS Fargate Cluster, Task and Service (running container as Service).
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ecr-ecs-elb-vpc-ecsservice-container 
- **Go to the Hands-On Sample:**
  - [SAMPLE-04: Provisioning ECR (Elastic Container Repository), Pushing Image to ECR, Provisioning ECS (Elastic Container Service), VPC (Virtual Private Cloud), ELB (Elastic Load Balancer), ECS Tasks and Service on Fargate Cluster](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE04-ECR-ECS-ELB-VPC-ECS-Service.md)
  
  ![ecr-ecs](https://user-images.githubusercontent.com/10358317/232244927-7d819c66-328a-4dd5-b3e1-18b2c7fd92aa.png)
  
 ### SAMPLE-05: Provisioning ECR, Lambda Function and API Gateway to run Flask App Container on Lambda <a name="ecr_lambda_apigateway_container"></a>  
- This sample shows:
  - how to create Flask-app-serverless image to run on Lambda,
  - how to create ECR and to push image to ECR,
  - how to create Lambda function, Lambda role, policy, policy-role attachment, Lambda API Gateway permission,
  - how to create API Gateway resource and method definition, Lambda - API Gateway connection, deploying API Gateway.
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/lambda-container-apigateway-flaskapp
- **Go to the Hands-On Sample:**
  - [SAMPLE-05: Provisioning ECR, Lambda Function and API Gateway to run Flask App Container on Lambda](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE05-Lambda-Container-ApiGateway-FlaskApp.md)  

  ![image](https://user-images.githubusercontent.com/10358317/233119966-9800d18c-8d0c-40de-9c1d-d14726743e5a.png)
  
  ![image](https://user-images.githubusercontent.com/10358317/233121075-ab2ac298-71b2-467d-8068-834f16b0f3c7.png)

### SAMPLE-06: Provisioning EKS (Elastic Kubernetes Service) with Managed Nodes using Blueprint and Modules <a name="eks_managednodes_blueprint"></a>  

- This sample shows:
  - how to create EKS cluster with managed nodes using BluePrints and Modules.
  - EKS Blueprint is used to provision EKS cluster with managed nodes easily. 
  - EKS Blueprint is used from: 
    - https://github.com/aws-ia/terraform-aws-eks-blueprints
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/eks-managed-node-blueprint
- **Go to the Hands-On Sample:** 
  - [SAMPLE-06: Provisioning EKS (Elastic Kubernetes Service) with Managed Nodes using Blueprint and Modules](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE06-EKS-ManagedNodes-Blueprint.md)

  ![image](https://user-images.githubusercontent.com/10358317/233836920-20d2b13b-7cb2-42c0-bb3f-70780f5f107d.png)

  ![image](https://user-images.githubusercontent.com/10358317/233836945-dfb85038-f5be-40a8-abe7-15b1334b854d.png)

 ### SAMPLE-07: CI/CD on AWS => Provisioning CodeCommit and CodePipeline, Triggering CodeBuild and CodeDeploy, Running on Lambda Container <a name="ci_cd"></a>  

- This sample shows:
  - how to create code repository using CodeCommit,
  - how to create pipeline with CodePipeline, create S3 bucket to store Artifacts for codepipeline stages' connection (source, build, deploy),
  - how to create builder with CodeBuild ('buildspec_build.yaml'), build the source code, create a Docker image,
  - how to create ECR (Elastic Container Repository) and push the build image into the ECR,
  - how to create Lambda Function (by CodeBuild automatically) and run/deploy container on Lambda ('buildspec_deploy.yaml').
- Source code is pulled from:
  - https://github.com/aws-samples/codepipeline-for-lambda-using-terraform
- Some of the fields are updated. 
- It works with 'hashicorp/aws ~> 4.15.1', 'terraform >= 0.15'
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/codecommit-codepipeline-codebuild-codedeploy-lambda-container
- **Go to the Hands-On Sample:**    
  - [SAMPLE-07: CI/CD on AWS => Provisioning CodeCommit and CodePipeline, Triggering CodeBuild and CodeDeploy, Running on Lambda Container](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE07-CodeCommit-Pipeline-Build-Deploy-Lambda.md)

  ![image](https://user-images.githubusercontent.com/10358317/233652299-66b39788-66ee-4a5e-b8e0-ece418fe98e3.png)

 ### SAMPLE-08: Provisioning S3 and CloudFront to serve Static Web Site <a name="s3_cloudfront"></a>

- This sample shows:
  - how to create S3 Bucket, 
  - how to to copy the website to S3 Bucket, 
  - how to configure S3 bucket policy,
  - how to create CloudFront distribution to refer S3 Static Web Site,
  - how to configure CloudFront (default_cache_behavior, ordered_cache_behavior, ttl, price_class, restrictions, viewer_certificate).
- **Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/s3-cloudfront-static-website/
- **Go to the Hands-On Sample:**    
  - [SAMPLE-08: Provisioning S3 and CloudFront to serve Static Web Site](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE08-S3-CloudFront-Static-WebSite.md)

  ![image](https://user-images.githubusercontent.com/10358317/234044290-e14650ed-93b4-4c49-8891-edeb959ffacb.png)

 ### SAMPLE-09: Running Gitlab Server using Docker on Local Machine and Making Connection to Provisioned Gitlab Runner on EC2 in Home Internet without Using VPN <a name="gitlabrunner"></a>
 
- This sample shows:
  - how to run Gitlab Server using Docker on WSL2 on-premise,
  - how to redirect external traffic to docker container port (Gitlab server),
  - how to configure on-premise PC network configuration,
  - how to run EC2 and install docker, gitlab-runner on EC2,
  - how to register Gitlab runner on EC2 to Gitlab Server on-premise (in Home),
  - how to run job on EC2 and returns artifacts to Gitlab Server on-premise (in Home).
- **Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/gitlabserver-on-premise-runner-on-EC2/
- **Go to the Hands-On Sample:**
  - [SAMPLE-09: Running Gitlab Server using Docker on Local Machine and Making Connection to Provisioned Gitlab Runner on EC2 in Home Internet without Using VPN](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE09-GitlabServer-on-Premise-GitlabRunner-on-EC2.md)

 ### SAMPLE-10: Implementing MLOps Pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and AWS Sagemaker (Endpoint) <a name="sagemaker"></a>

- This sample shows:
  - how to create MLOps Pipeline 
  - how to use GitHub Hooks (Getting Source Code from Github to CodePipeline)
  - how to create Build CodePipeline (Source, Build), CodeBuild (modelbuild_buildspec.yml), Deploy CodePipeline (Source, Build, DeployStaging, DeployProd), CodeBuild (modeldeploy_buildspec.yml)
  - how to save the model and artifacts on S3
  - how to create and test models using Notebooks
- **Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/mlops-sagemaker-github-codepipeline-codebuild-codedeploy
- **Go to the Hands-On Sample:**
  - [SAMPLE-10: Implementing MLOps Pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and AWS Sagemaker (Endpoint)](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE10-MLOps-SageMaker-GitHub-Codepipeline-CodeBuild-CodeDeploy.md)

   ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/fcaf0b53-90d9-4e7b-af3d-69aa03592ac2)

## Details <a name="details"></a>
- To validate the Terraform files:
  - "terraform validate"
- For dry-run:
  - "terraform plan"
- For formatting:
  - "terraform fmt"
- For debugging:
  - **Bash:** export TF_LOG="DEBUG"
  - **PowerShell:** $env:TF_LOG="DEBUG"
- For debug logging:  
  - **Bash:** export TF_LOG_PATH="tmp/terraform.log"
  - **PowerShell:** $env:TF_LOG_PATH="C:\tmp\terraform.log"

## Terraform Cheatsheet <a name="cheatsheet"></a>

- [Terraform Cheatsheet](https://github.com/omerbsezer/Fast-Terraform/blob/main/Terraform-Cheatsheet.md)

## Other Useful Resources Related Terraform <a name="resource"></a>
- **AWS Samples (Advanced):** 
  - https://github.com/aws-samples
- **AWS Samples with Terraform (Advanced):** 
  - https://github.com/orgs/aws-samples/repositories?q=Terraform&type=all&language=&sort= 
- **AWS Integration and Automation (Advanced):**  
  - https://github.com/aws-ia
- **Reference Guide: Terraform Registry Documents** 
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs  

## References <a name="references"></a>
- Redis: https://developer.redis.com/create/aws/terraform/
- https://developer.hashicorp.com/terraform/intro
- https://github.com/aws-samples
- https://github.com/orgs/aws-samples/repositories?q=Terraform&type=all&language=&sort= 
- https://github.com/aws-ia/terraform-aws-eks-blueprints
- https://github.com/aws-ia

