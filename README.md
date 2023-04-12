# Fast-Terraform (with AWS)
This repo covers Terraform with LABs using AWS: 
- Resources, Data Sources, Variables, Meta Arguments, Provisioners, Dynamic Blocks, Modules, Workspaces, 
- Provisioning AWS Resources (EC2, VPC, IAM Users, User Groups, Policies, Roles, ECS, EKS, Lambda) and details. 

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

# Quick Look (How-To): AWS Terraform Samples
These samples focus on how to create and use AWS components (EC2, EBS, EFS, Lambda, ECS, EKS, ASG, ELB, API Gateway, S3, DynamoDB) with Terraform:

- [SAMPLE-01: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE01-EC2-VPC-Ubuntu-Win-SSH-RDP.md)
- [SAMPLE-02: Lambda Function, IAM Role, IAM Policy, Simple Python Code](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE02-Lambda-API-Gateway-Python.md)
- [SAMPLE-03: EBS (Elastic Block Storage: HDD, SDD) and EFS (Elastic File System: NFS) Configuration with EC2s (Ubuntu and Windows Instances)](https://github.com/omerbsezer/Fast-Terraform/blob/main/SAMPLE03-EC2-EBS-EFS.md)
- [SAMPLE: Pushing/Pulling Image ECR, Creating ECS Cluster and Task Definition, Running Service]()
- [SAMPLE: Container running on Lambda]()
- [SAMPLE: Creating EKS (Elastic Kubernetes Service)]()
- [SAMPLE: ELB, EC2, Auto Scaling Group]()
- [SAMPLE: S3, Lambda]()
- [SAMPLE: Create Thumbnail Application using Python, Lambda]()

# Table of Contents
- [Motivation](#motivation)
- [What is Terraform?](#what_is_terraform)
- [How Terraform Works?](#how_terrafom_works)
- [Terraform Commands](#terrafom_commands)
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
- [Terraform Debugging and Validation](#debugging_validation)
- [Terraform Best Practices](#best_practice)
- [Terraform AWS Applications](#applications)
  - [Application: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](#ec2_vpc_key_pair_ssh_rdp)
- [Details](#details)
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
  ![image](https://user-images.githubusercontent.com/10358317/231143883-a2348511-dd12-4e0f-806d-3144ac88aa4d.png)

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

  ![image](https://user-images.githubusercontent.com/10358317/231147788-ba40b795-4050-49df-b1ad-48b273257410.png)

- TF state file stores the latest status of the infrastructure after running "apply" command.
- TF state file deletes the status of the infrastructure after running "destroy" command.
- TF state files are stored:
  - on local PC 
  - on remote cloud (AWS S3, Terraform Cloud) 

- Please have a look LABs and SAMPLEs to learn how Terraform works in real scenarios.
 
## Terraform File Components <a name="terrafom_file_components"></a>


### Providers <a name="providers"></a>
- Terraform supposes for different providers (AWS, Google Cloud, Azure).
- Terraform downloads required executable files from own cloud to run IaC (code) for the corresponding providers.
- AWS (https://registry.terraform.io/providers/hashicorp/aws/latest/docs): 

  ![image](https://user-images.githubusercontent.com/10358317/231405120-1d6907be-53f6-46e8-8e6f-a5dd73a0cfb5.png)

- Google Cloud (GCP) (https://registry.terraform.io/providers/hashicorp/google/latest/docs):

  ![image](https://user-images.githubusercontent.com/10358317/231405236-73faf1e4-3ea8-45df-982e-d56f64eba2a5.png)

- Azure (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs):

  ![image](https://user-images.githubusercontent.com/10358317/231405457-7b90a689-96c6-434d-a319-162adc04f772.png)

### Resources <a name="resources"></a>
- Resources are used to define for different cloud components and objects (e.g. EC2 instances, VPC, VPC Compoenents: Router Tables, Subnets, IGW, .., Lambda, API Gateway, S3 Buckets, etc.). 
- To learn the details, features of the cloud components, you should know how the cloud works, which components cloud have, how to configure the cloud components.
- Syntax:
  - resource <AWS Object> <User_Defined_Variable_Name_With_Underscore> {}
    - e.g. resource "aws_instance" "instance" {}
    - e.g. resource "aws_vpc" "my_vpc" {}
    - e.g. resource "aws_subnet" "public" {}
    - e.g. resource "aws_security_group" "allow_ssh" {}
  
    ![image](https://user-images.githubusercontent.com/10358317/231420818-d0c3e679-787b-4d85-a784-6f4acdb7fa01.png)
  
- Important part is to check the usage of the resources (shows which arguments are optional, or required) from Terraform Registry page by searching the "Object" terms like "instance", "vpc", "security groups"
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
  
  ![image](https://user-images.githubusercontent.com/10358317/231423197-71c23a76-a55e-4cf0-bb51-d81e45b30ff1.png)

- There are different parts:
  - Argument References (inputs) (some parts are optional, or required)
  - Attributes References (outputs)
  - Example code snippet to show how it uses
  - Others (e.g. timeouts, imports)

- Go to LAB to learn:
  - [LAB-02: Resources => Provision Basic EC2 (Ubuntu 22.04)](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB02-Resources-Basic-EC2.md)

### Variables (tfvar) <a name="variables"></a>


![image](https://user-images.githubusercontent.com/10358317/231144889-3edd38a4-1ff9-4c82-8155-50f0089757fa.png)

![image](https://user-images.githubusercontent.com/10358317/231145166-f032ae1e-9bbb-436a-9c0e-3c0be8fb627c.png)


- Go to LAB to learn:
  - [LAB-03: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB03-Variables-Locals-Output-EC2.md)

### Values (Locals, Outputs) <a name="values"></a>

![image](https://user-images.githubusercontent.com/10358317/231145122-ad345a85-3666-4098-9f2a-3fab2dcba410.png)

- Go to LAB to learn:
  - [LAB-03: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB03-Variables-Locals-Output-EC2.md)

### Meta Arguments <a name="meta_arguments"></a>

- Go to LAB to learn:
  - [LAB-04: Meta Arguments (Count, For_Each, Map) => Provision IAM Users, Groups, Policies, Attachment Policy-User](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB04-Meta-Arguments-IAM-User-Group-Policy.md)

### Dynamic Blocks <a name="dynamic_blocks"></a>

![image](https://user-images.githubusercontent.com/10358317/231145371-c9322d06-326d-44f7-95e2-e9ec6f806bfe.png)

- Go to LAB to learn:
  - [LAB-05: Dynamic Blocks => Provision Security Groups, EC2, VPC](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB05-Dynamic-Blocks-Security-Groups-EC2.md)

### Data Sources <a name="datasources"></a>

![image](https://user-images.githubusercontent.com/10358317/231145418-c333d2df-706f-4325-8eb2-5d677fa30ce5.png)


- Go to LAB to learn:
  - [LAB-06: Data Sources with Depends_on => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB06-Data-Sources-EC2.md)

### Provisioners <a name="provisioners"></a>

![image](https://user-images.githubusercontent.com/10358317/231145525-4f97c4a1-dc6f-4323-a8ca-7041c27d00d9.png)

- Go to LAB to learn:
  - [LAB-07: Provisioners (file, remote-exec), Null Resources (local-exec) => Provision Key-Pair, SSH Connection](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB07-Provisioners-Null-Resources.md)

### Modules <a name="modules"></a>

![image](https://user-images.githubusercontent.com/10358317/231145600-59034277-0781-4285-9fa8-987a1c7f6e27.png)

- Go to LAB to learn:
  - [LAB-08: Modules => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB08-Modules-EC2.md)

### Workspaces <a name="workspaces"></a>

![image](https://user-images.githubusercontent.com/10358317/231145703-c35b657c-7e39-4d53-980f-4561fda9489d.png)

- Go to LAB to learn:
  - [LAB-09: Workspaces => Provision EC2 with Different tfvars Files](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB09-Workspaces-EC2.md)

### Templates <a name="templates"></a>

![image](https://user-images.githubusercontent.com/10358317/231145808-06b895d6-a424-4c7c-858c-76b64e5574e6.png)

- Go to LAB to learn:
  - [LAB-10: Templates => Provision IAM User, User Access Key, Policy](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB10-Templates-User-Policy.md)

### Backend and Remote States <a name="backends_remote_states"></a>

![image](https://user-images.githubusercontent.com/10358317/231145912-908af9fe-56ef-479e-8ee4-9c5f7f92329e.png)

- Go to LAB to learn:
  - [LAB-11: Backend - Remote States => Provision EC2 and Save State File on S3](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB11-Backend-Remote-State.md)

## Terraform Best Practices <a name="best_practice"></a>

## AWS Terraform Samples <a name="samples"></a>

### Sample: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections <a name="ec2_vpc_key_pair_ssh_rdp"></a>

- Go to Sample:
  - [Sample: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](https://github.com/omerbsezer/Fast-Terraform/blob/main/EC2-VPC-Ubuntu-Win-SSH-RDP.md)

## Details <a name="details"></a>

## Other Useful Resources Related Terraform <a name="resource"></a>

## References <a name="references"></a>
- Redis: https://developer.redis.com/create/aws/terraform/
