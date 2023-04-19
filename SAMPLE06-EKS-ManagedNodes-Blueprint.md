## SAMPLE-06: Provisioning EKS (Elastic Kubernetes Service) with Managed Nodes using Blueprint and Modules 

This sample shows:
- how to create EKS cluster with managed nodes using BluePrints and Modules.

**Notes:**
- EKS Blueprint is used to provision EKS cluster with managed nodes easily. 
- TF file creates 65 Resources, it takes ~30 mins to provision cluster.
- EKS Blueprint is used from: 
  - https://github.com/aws-ia/terraform-aws-eks-blueprints
- Gameserver example is updated and run: 
  - https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/examples/agones-game-controller 

There are 1 main part:
- **main.tf**: includes:
  - EKS module: 2 managed nodes, 1 ASG for managed nodes, 1 Elastic IP, 3 SGs
  - EKS addon module: metrics_server, cluster_autoscaler
  - VPC module: 1 VPC, 6 Subnets (3 Public, 3 Private), 3 Route Tables, 1 IGW, 1 NAT, 1 NACL 

**Code:** https://github.com/omerbsezer/Fast-Terraform/tree/main/samples/eks-managed-node-blueprint

**EKS Pricing:**
- For the Cluster (Managed Control Plane):
  - **Per Hour:** $0.10 per for each Amazon EKS cluster
  - **Per Day:**  $2.4
  - **For 30 days:** $72
- For the 1 Worker Node Linux (e.g. m5.large => 2 vCPU, 8 GB RAM):
  - **Per Hour:** $0.096  
  - **Per Day:**  $2.304
  - **For 30 days:** $69.12
  - Please have look for instance pricing: https://aws.amazon.com/ec2/pricing/on-demand/ 
- For the Fargate: 
  - AWS Fargate pricing is calculated based on the **vCPU and memory** resources used from the time you start to download your container image until the EKS Pod terminate.
    - e.g. 2 x (1vCPU, 4GB RAM) on Linux: 
      - **Per Hour:** 2 x ($0,0665) = $0.133
      - **Per Day:** $3,18
      - **Per 30 Days:** $95.67
    - e.g. 2 x (1vCPU, 4GB RAM) on Win: 
      - **Per Hour:** 2 x ($0,199) = $0.398
      - **Per Day:** $9.55
      - **Per 30 Days:** $286.56
  - Please have look for fargate pricing: https://aws.amazon.com/fargate/pricing/ 
- https://cloudonaut.io/versus/docker-containers/eks-fargate-vs-eks-managed-node-group/
- https://cloudonaut.io/versus/docker-containers/ecs-fargate-vs-eks-managed-node-group/ 

### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)

## Steps

- Create main.tf:
 
```
terraform {
  required_providers {
   aws = {
      source  = "hashicorp/aws"
      version = ">= 4.47"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.10"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

data "aws_availability_zones" "available" {}

locals {
  name   = basename(path.cwd)
  region = "eu-central-1"

  cluster_version = "1.24"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}

################################################################################
# Cluster
################################################################################

#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.12"

  cluster_name                   = local.name
  cluster_version                = local.cluster_version
  cluster_endpoint_public_access = true

  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    initial = {
      instance_types = ["m5.large"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  tags = local.tags
}

################################################################################
# Kubernetes Addons
################################################################################

module "eks_blueprints_kubernetes_addons" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints/modules/kubernetes-addons"
  
  eks_cluster_id       = module.eks.cluster_name
  eks_cluster_endpoint = module.eks.cluster_endpoint
  eks_oidc_provider    = module.eks.oidc_provider
  eks_cluster_version  = module.eks.cluster_version

  # Add-ons
  enable_metrics_server     = true
  enable_cluster_autoscaler = true
  eks_worker_security_group_id = module.eks.cluster_security_group_id

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = local.tags
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
}
```

**Code:** https://github.com/omerbsezer/Fast-Terraform/blob/main/samples/eks-managed-node-blueprint/main.tf

![image](https://user-images.githubusercontent.com/10358317/233113882-6b81b0ca-d35a-42da-b1c0-4b5236375ddf.png)

### Demo: Terraform Run <a name="run"></a>

- Run:
 
```
terraform init
terraform validate
terraform plan
terraform apply
```

![image](https://user-images.githubusercontent.com/10358317/233094869-ac12920c-d536-476a-b283-306c1846a3d7.png)

- Run to add cluster into your kubeconfig:

```
aws eks --region eu-central-1 update-kubeconfig --name eks-managed-node
```

![image](https://user-images.githubusercontent.com/10358317/233095399-80e169b6-de30-446e-84c2-7745655179a3.png)

- To see nodes, pods

```
kubectl get nodes -o wide
kubectl get pods -o wide --all-namespaces
```

![image](https://user-images.githubusercontent.com/10358317/233095954-d3745626-eebc-483a-b298-c6d829ce7979.png)

- Create test pod (nginx)

```
kubectl run my-nginx --image=nginx
kubectl get pods -o wide --all-namespaces
```

![image](https://user-images.githubusercontent.com/10358317/233096322-d9738e2e-5ea5-4187-8763-d9cabd27ffd7.png)

![image](https://user-images.githubusercontent.com/10358317/233096504-a991ed50-5a85-4f46-bc33-b795237f26b4.png)

- Enter the pod using sh:

```
kubectl exec -it my-nginx -- sh
```

![image](https://user-images.githubusercontent.com/10358317/233097613-f81a3773-97cc-4795-aab0-82795417b270.png)

- On AWS EKS:

  ![image](https://user-images.githubusercontent.com/10358317/233097928-5db41f20-f491-491d-bf09-08c38df7ec66.png)
  
- Cluster Pod:

  ![image](https://user-images.githubusercontent.com/10358317/233098383-57785983-298a-41d6-8bdb-54f6f80eff47.png)
  
- Cluster Deployments:

  ![image](https://user-images.githubusercontent.com/10358317/233098742-86803d33-1565-4577-aee5-ef86f74b7717.png)
 
- By using kubectl, details can be viewed:

  ![image](https://user-images.githubusercontent.com/10358317/233099053-5087c41a-2366-42c8-8b0f-235edb7c8325.png)
  
- Cluster Nodes:

  ![image](https://user-images.githubusercontent.com/10358317/233099628-31296830-ef25-4d1b-b582-92f6cf936600.png)

- Because of the min_size=1, one of the managed node was terminated automatically.
```
eks_managed_node_groups = {
    initial = {
      instance_types = ["m5.large"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
```

- On AWS EKS:

  ![image](https://user-images.githubusercontent.com/10358317/233104836-bdc1a075-e27b-45b0-8fb2-262e73814f47.png)

- API Services: 

  ![image](https://user-images.githubusercontent.com/10358317/233100299-05267ceb-559b-4c11-9876-d427192b50bc.png)

- All details about the K8s can be viewed on AWS GUI:

  ![image](https://user-images.githubusercontent.com/10358317/233100875-4b47facd-a02e-4f93-9431-68556e3d7c52.png)

- On AWS VPC (1 VPC, 3 public subnets, 3 private subnets):

  ![image](https://user-images.githubusercontent.com/10358317/233101406-d1ec1fe1-0359-4b24-9d66-c3e45aa2a911.png)

- On AWS EC2 Instance: 

  ![image](https://user-images.githubusercontent.com/10358317/233101685-89e5780e-57d9-4720-bb16-ece80092060b.png)

- On AWS Elastic IP:

  ![image](https://user-images.githubusercontent.com/10358317/233102192-efce23f0-b2f0-48ec-9530-14210f6c6525.png)

- In addition, these are created: 3 Route Tables, 1 IGW, 1 NAT, 1 Elastic IP, 1 NACL, 1 ASG for managed nodes

  ![image](https://user-images.githubusercontent.com/10358317/233104088-376aa429-3502-4347-8cdd-a176ed3bdc74.png)

- To clean up your environment, destroy the Terraform modules in reverse order.
- Destroy the Kubernetes Add-ons, EKS cluster with Node groups and VPC:

```
terraform destroy -target="module.eks_blueprints_kubernetes_addons" -auto-approve
```

  ![image](https://user-images.githubusercontent.com/10358317/233106155-b4e43456-2852-4476-bb05-8e734abb3ba4.png)

- Destroy EKS (managed node) (takes ~12-15 mins):

```
terraform destroy -target="module.eks" -auto-approve
```

![image](https://user-images.githubusercontent.com/10358317/233111468-092cff32-9555-4814-8a80-10678b590d12.png)

- Destroy VPC:

```
terraform destroy -target="module.vpc" -auto-approve
```

![image](https://user-images.githubusercontent.com/10358317/233110739-72c833a1-6347-4e9a-be33-5f4d93f7990f.png)


- Finally, destroy any additional resources that are not in the above modules

```
terraform destroy -auto-approve
```

## References
- https://github.com/aws-ia/terraform-aws-eks-blueprints
- https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/examples/agones-game-controller
