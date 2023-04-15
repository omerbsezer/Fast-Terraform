## SAMPLE-04: ECR-ECS-ELB-VPC-ECS-Service

This sample shows:
- how to create 

There are 5 main parts:
- **0_ecr.tf**: includes 
- **1_vpc.tf**: includes
- **2_ecs.tf**: includes 
- **3_elb.tf**: includes 
- **4_ecs_service.tf**: includes 

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/ecr-ecs-elb-vpc-ecsservice-container

# Table of Contents
- [Flask App Docker Image Creation](#image)
- [ECR, Pushing Image](#ecr)
- [VPC](#vpc)
- [ECS](#ecs)
- [ELB](#elb)
- [ECS Service](#ecsservice)
- [Demo: Terraform Run](#run)

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps


### VPC <a name="vpc"></a>

- Create main.tf:
 
```
```
