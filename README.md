# Fast-Terraform (with AWS)
This repo covers Terraform with LABs using AWS: Resources, Data Sources, Variables, Meta Arguments, Provisioners, Dynamic Blocks, Modules, Workspaces, Provisioning AWS Resources (EC2, VPC, IAM Users, User Groups, Policies, Roles, ECS, EKS, Lambda) and details. Possible usage scenarios are aimed to update over time.

**Keywords:** Terraform, Infrastructure as Code, AWS, Cloud Provisioning

**PS:** AWS Services are created using Terraform in the LABs. 

# Quick Look (HowTo): Hands-on LABs
- [LAB: Installing Terraform, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/Terraform-Install-AWS-Configuration.md)
- [LAB: Pulling Docker Image, Creating Docker Container Using Terraform Without Cloud](https://github.com/omerbsezer/Fast-Terraform/blob/main/Terraform-Docker-Without-Cloud.md)
- [LAB: Resources                             => Provision Basic EC2 (Ubuntu 22.04)](https://github.com/omerbsezer/Fast-Terraform/blob/main/Basic-Resource-EC2-Ubuntu.md)
- [LAB: Variables, Locals, Output             => Provision EC2s](https://github.com/omerbsezer/Fast-Terraform/blob/main/EC2-Variables-Locals-Output.md)
- [LAB: Meta Arguments (Count, For_Each, Map) => Provision IAM Users, User Groups, Policies, Attachment Policy-User Group](https://github.com/omerbsezer/Fast-Terraform/blob/main/IAM-User-Group-Policy-Count-ForEach-Map.md)
- [LAB: Dynamic Blocks                        => Provision Security Groups, EC2, VPC](https://github.com/omerbsezer/Fast-Terraform/blob/main/SG-DynamicBlocks-VPC-EC2.md)
- [LAB: Data Sources with Depends_on          => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/Data-Sources-EC2.md)
- [LAB: Provisioners (file, remote-exec), Null Resources (local-exec) => Provision Key-Pair, SSH Connection](https://github.com/omerbsezer/Fast-Terraform/blob/main/Provisioners-Null-Resources.md)
- [LAB: Modules => Provision EC2](https://github.com/omerbsezer/Fast-Terraform/blob/main/Modules-EC2.md)
- [LAB: Workspaces => Provision ]()
- [LAB: Templates => Provision]()
- [LAB: Backends - Remote States => ]()

# Quick Look (HowTo): Application
- [Application: EC2s (Windows 2019 Server, Ubuntu 20.04), VPC, Key-Pairs for SSH, RDP connections](https://github.com/omerbsezer/Fast-Terraform/blob/main/EC2-VPC-Ubuntu-Win-SSH-RDP.md)
- [Application: Lambda Function, IAM Role, IAM Policy, Python Code using Terraform]()
- [Application: EC2 with EBS and EFS using Terraform]()
- [Application: Creating ECS (Elastic Container Service), Pushing/Pulling Image ECR (Elastic Container Registry)]()
- [Application: Creating EKS (Elastic Kubernetes Service)]()
- [Application: ELB, EC2, Auto Scaling Group]()
- [Application: S3, Lambda]()

# Table of Contents
- [Motivation](#motivation)
- [What is Terraform?](#what_is_terraform)
- [How Terraform Works?](#how_terrafom_works)
- [Terraform Commands](#terrafom_commands)
- [Terraform File Components](#terrafom_file_components)
  - [Providers](#providers)
  - [Resources](#resources)
  - [Variables (tfvar)](#variables)
  - [Locals](#locals)
  - [Output Values](#output_values)
  - [Meta Arguments (for loop, for_each loop, count, depends_on, lifecycle)](#meta_arguments)
  - [Expressions](#expressions)
  - [Dynamic Blocks](#dynamic_blocks)
  - [Provisioners (file, remote_exec, local_exec), Null Resource](#provisioners)
  - [Modules](#modules)
  - [Workspaces](#workspaces)
  - [Data Sources](#data_sources)
  - [Backends and Remote States](#backends_remote_states)
- [Terraform Debugging and Validation](#debugging_validation)
- [Terraform Import](#import)  
- [Terraform Template](#template)
- [Terraform Best Practices](#best_practice)
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

### Resources <a name="resources"></a>

### Variables (tfvar) <a name="variables"></a>

### Datasources <a name="datasources"></a>

### Values (Local, Output) <a name="values"></a>

### Meta Arguments <a name="meta_arguments"></a>

### Expressions <a name="expressions"></a>

### Dynamic Blocks <a name="dynamic_blocks"></a>

### Provisioners <a name="provisioners"></a>

### Modules <a name="modules"></a>

### Workspaces <a name="workspaces"></a>

### Backends and Remote States <a name="backends_remote_states"></a>

## Terraform Best Practices <a name="best_practice"></a>

## Terraform Project: AWS - EC2 <a name="project1"></a>

## Details <a name="details"></a>

## Other Useful Resources Related Terraform <a name="resource"></a>

## References <a name="references"></a>
- Redis: https://developer.redis.com/create/aws/terraform/
