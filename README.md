# Fast-Terraform (with AWS)
This repo covers Terraform with LABs using AWS: 
- Resources, Data Sources, Variables, Meta Arguments, Provisioners, Dynamic Blocks, Modules, Workspaces, 
- Provisioning AWS Resources (EC2, VPC, IAM Users, User Groups, Policies, Roles, ECS, EKS, Lambda) and details. 

**Keywords:** Terraform, Infrastructure as Code, AWS, Cloud Provisioning

# Quick Look (HowTo): Terraform Hands-on LABs
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

# Quick Look (HowTo): AWS Terraform Samples
These samples focus on how to create and use AWS components (EC2, EBS, EFS, Lambda, ECS, EKS, ASG, ELB, API Gateway, S3, DynamoDB) with Terraform:

- [Sample: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](https://github.com/omerbsezer/Fast-Terraform/blob/main/EC2-VPC-Ubuntu-Win-SSH-RDP.md)
- [Sample: Lambda Function, IAM Role, IAM Policy, Simple Python Code]()
- [Sample: Create Thumbnail Application using Python, Lambda]()
- [Sample: EC2 with EBS and EFS using Terraform]()
- [Sample: Creating ECS (Elastic Container Service), Pushing/Pulling Image ECR (Elastic Container Registry)]()
- [Sample: Creating EKS (Elastic Kubernetes Service)]()
- [Sample: ELB, EC2, Auto Scaling Group]()
- [Sample: S3, Lambda]()

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
  - Similar to Native Infrastructure as Code (IaC): CloudFormation (AWS), Resource Manager (Azure), Google Cloud Deployment Manager (Google Cloud) 
- It is free, open source (https://github.com/hashicorp/terraform) and has a large community with enterprise support options.
- Commands, tasks, codes turn into the IaC.
  - With IaC, tasks is savable, versionable, repetable and testable.
  - With IaC, desired configuration is defined as 'Declerative Way'.
- **Agentless:** Terraform doesn’t require any software to be installed on the managed infrastructure
- It has well-designed documentation:
  - https://developer.hashicorp.com/terraform/language
  - https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Terraform uses a modular structure  

![image](https://user-images.githubusercontent.com/10358317/228594238-dddc325b-6297-4eec-a1b2-aa3652e3d818.png) (ref: Redis)


## What is Terraform? <a name="what_is_terraform"></a>

## How Terraform Works? <a name="how_terrafom_works"></a>

## Terraform File Components <a name="terrafom_file_components"></a>


### Providers <a name="providers"></a>


### Resources <a name="resources"></a>


- Go to LAB to learn:
  - [LAB: Resources => Provision Basic EC2 (Ubuntu 22.04)](https://github.com/omerbsezer/Fast-Terraform/blob/main/Resources-Basic-EC2.md)

### Variables (tfvar) <a name="variables"></a>


- Go to LAB to learn:
  - [LAB: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/Variables-Locals-Output-EC2.md)

### Values (Locals, Outputs) <a name="values"></a>


- Go to LAB to learn:
  - [LAB: Variables, Locals, Output => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/Variables-Locals-Output-EC2.md)

### Meta Arguments <a name="meta_arguments"></a>


- Go to LAB to learn:
  - [LAB: Meta Arguments (Count, For_Each, Map) => Provision IAM Users, Groups, Policies, Attachment Policy-User](https://github.com/omerbsezer/Fast-Terraform/blob/main/Meta-Arguments-IAM-User-Group-Policy.md)

### Dynamic Blocks <a name="dynamic_blocks"></a>


- Go to LAB to learn:
  - [LAB: Dynamic Blocks => Provision Security Groups, EC2, VPC](https://github.com/omerbsezer/Fast-Terraform/blob/main/Dynamic-Blocks-Security-Groups-EC2.md)

### Data Sources <a name="datasources"></a>


- Go to LAB to learn:
  - [LAB: Data Sources with Depends_on => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/Data-Sources-EC2.md)

### Provisioners <a name="provisioners"></a>

- Go to LAB to learn:
  - [LAB: Provisioners (file, remote-exec), Null Resources (local-exec) => Provision Key-Pair, SSH Connection](https://github.com/omerbsezer/Fast-Terraform/blob/main/Provisioners-Null-Resources.md)

### Modules <a name="modules"></a>

- Go to LAB to learn:
  - [LAB: Modules => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/Modules-EC2.md)

### Workspaces <a name="workspaces"></a>

- Go to LAB to learn:
  - [LAB: Workspaces => Provision EC2 with Different tfvars Files](https://github.com/omerbsezer/Fast-Terraform/blob/main/Workspaces-EC2.md)

### Templates <a name="templates"></a>


- Go to LAB to learn:
  - [LAB: Templates => Provision IAM User, User Access Key, Policy](https://github.com/omerbsezer/Fast-Terraform/blob/main/Templates-User-Policy.md)

### Backend and Remote States <a name="backends_remote_states"></a>


- Go to LAB to learn:
  - [LAB: Backend - Remote States => Provision EC2 and Save State File on S3](https://github.com/omerbsezer/Fast-Terraform/blob/main/Backend-Remote-State.md)

## Terraform Best Practices <a name="best_practice"></a>

## AWS Terraform Samples <a name="samples"></a>

### Sample: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections <a name="ec2_vpc_key_pair_ssh_rdp"></a>

- Go to Sample:
  - [Sample: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](https://github.com/omerbsezer/Fast-Terraform/blob/main/EC2-VPC-Ubuntu-Win-SSH-RDP.md)

## Details <a name="details"></a>

## Other Useful Resources Related Terraform <a name="resource"></a>

## References <a name="references"></a>
- Redis: https://developer.redis.com/create/aws/terraform/
