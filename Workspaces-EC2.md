## LAB: Terraform Workspace with EC2

This scenario shows:
- how to create, manage workspaces using EC2 and variables.

**Code:**  https://github.com/omerbsezer/Fast-Terraform/tree/main/labs/workspace

### Prerequisite

- You should have a look following lab: 
  - [LAB: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/Terraform-Install-AWS-Configuration.md)

## Steps

- With workspaces,
  - a parallel, distinct copy of your infrastructure which you can test and verify in the development, test, and staging 
  - like git, you are working on different workspaces (like branch)

- Workspace commands:

``` 
terraform workspace help                       # help for workspace commands
terraform workspace new [WorkspaceName]        # create new workspace
terraform workspace select [WorkspaceName]     # change/select another workspace
terraform workspace show                       # show current workspace
terraform workspace list                       # list all workspaces
terraform workspace delete [WorkspaceName]     # delete existed workspace
``` 

![image](https://user-images.githubusercontent.com/10358317/229855095-05b608f7-04aa-4603-9516-600d0c692d01.png)

