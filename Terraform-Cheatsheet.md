## Terraform Cheatsheet

### Table of Contents
- [Help, Version](#help)
- [Formatting](#formatting)
- [Initialization](#init)
- [Download and Install Modules](#download)
- [Validation](#validation)
- [Plan Your Infrastructure](#plan)
- [Deploy Your Infrastructure](#deploy)
- [Destroy Your Infrastructure](#destroy)
- ['Taint' or 'Untaint' Your Resources](#taint)
- [Refresh the State File](#refresh)
- [Show Your State File](#show)
- [Manipulate Your State File](#state)
- [Import Existing Infrastructure](#import)
- [Get Provider Information](#provider)
- [Manage Your Workspaces](#workspace)
- [View Your Outputs](#output)
- [Release a Lock on Your Workspace](#release)
- [Log In and Out to a Remote Host (Terraform Cloud)](#login)
- [Produce a Dependency Diagram](#graph)
- [Test Your Expressions](#test)

### 1. Help, Version <a name="help"></a>

#### Get the general help for Terraform

```
terraform -help
```

#### Get the 'fmt' help for Terraform

```
terraform fmt -help
```

#### Get the Terraform version

```
terraform version
```

### 2. Formatting <a name="formatting"></a>

#### Format your Terraform configuration files using the HCL language standard

```
terraform fmt
```

#### Format files in subdirectories

```
terraform fmt --recursive
```

#### Display differences between original configuration files and formatting changes

```
terraform fmt --diff
```

#### Format Check (If files are formatted correctly, the exit status will be zero)

```
terraform fmt --check
```
 
### 3. Initialization <a name="init"></a>

#### Terraform Init Command (performs Backend Initialization, Child Module Installation, and Plugin Installation)

```
terraform init
```

#### Initialize the working directory, do not download plugins

```
terraform init -get-plugins=false
```

#### Initialize the working directory, don’t hold a state lock during backend migration

```
terraform init -lock=false
```

#### Initialize the working directory, and disable interactive prompts

```
terraform init -input=false
```

#### Reconfigure a backend, and attempt to migrate any existing state

```
terraform init -migrate-state
```

#### Initialize the working directory, do not verify plugins for Hashicorp signature

```
terraform init -verify-plugins=false
```

### 4. Download and Install Modules <a name="download"></a>

Note this is usually not required as this is part of the terraform init command.

#### Download and installs modules needed for the configuration

```
terraform get
```

#### Check the versions of the already installed modules against the available modules and installs the newer versions if available

```
terraform get -update
```

### 5. Validation <a name="validation"></a>

#### Validate the configuration files in your directory and does not access any remote state or services
- Terraform init should be run before 'validate' command.

```
terraform validate
```

#### To see easier the number of errors and warnings that you have

```
terraform validate -json
```

### 6. Plan Your Infrastructure <a name="plan"></a>

#### Plan will generate an execution plan

```
terraform plan
```

#### Save the plan file to a given path
- Saved file can then be passed to the terraform apply command.

```
terraform plan -out=<path>
```

#### Create a plan to destroy all objects rather than the usual actions

```
terraform plan -destroy
```

### 7. Deploy Your Infrastructure <a name="deploy"></a>

#### Create or update infrastructure depending on the configuration files
- By default, a plan will be generated first and will need to be approved (yes/no) before it is applied.

```
terraform apply
```

#### Apply changes without having to interactively type ‘yes’ to the plan
- Useful in automation CI/CD pipelines.

```
terraform apply -auto-approve
```

#### Provide the file generated using the terraform plan -out command
- If provided, Terraform will take the actions in the plan without any confirmation prompts.

```
terraform apply <planfilename>
```

#### Do not hold a state lock during the Terraform apply operation
- Use with caution if other engineers might run concurrent commands against the same workspace.

```
terraform apply -lock=false
```

#### Specify the number of operations run in parallel

```
terraform apply -parallelism=<n>
```

#### Pass in a variable value

```
terraform apply -var="environment=dev"
```

#### Pass in variables contained in a file

```
terraform apply -var-file="varfile.tfvars"
```

#### Apply changes only to the targeted resource

```
terraform apply -target="module.appgw.0"
```

### 8. Destroy Your Infrastructure <a name="destroy"></a>

#### Destroy the infrastructure managed by Terraform

```
terraform destroy
```

#### Destroy only the targeted resource

```
terraform destroy -target="module.appgw.0"
```

#### Destroy the infrastructure without having to interactively type ‘yes’ to the plan
- Useful in automation CI/CD pipelines.

```
terraform destroy --auto-approve
```

#### Destroy an instance of a resource created with for_each

```
terraform destroy -target="module.appgw.resource[\"key\"]"
```

### 9. 'Taint' or 'Untaint' Your Resources  <a name="taint"></a>
- Use the taint command to mark a resource as not fully functional. It will be deleted and re-created.

#### Taint a specified resource instance

```
terraform taint vm1.name
```

#### Untaint the already tainted resource instance

```
terraform untaint vm1.name
```

### 10. Refresh the State File <a name="refresh"></a>

#### Modify the state file with updated metadata containing information on the resources being managed in Terraform
- Will not modify your infrastructure.

```
terraform refresh
```

### 11. Show Your State File <a name="show"></a>

#### Show the state file in a human-readable format

```
terraform show
```

#### Show the specific state file 
- If you want to read a specific state file, you can provide the path to it. If no path is provided, the current state file is shown.

```
terraform show <path to statefile>
```

### 12. Manipulate Your State File <a name="state"></a>

#### Lists out all the resources that are tracked in the current state file

```
terraform state list
```

#### Move an item in the state
- Move an item in the state, for example, this is useful when you need to tell Terraform that an item has been renamed, e.g. terraform state mv vm1.oldname vm1.newname

```
terraform state mv
```

#### Get the current state and outputs it to a local file

```
terraform state pull > state.tfstate
```

#### Update remote state from the local state file

```
terraform state push 
```

#### Replace a provider, useful when switching to using a custom provider registry

```
terraform state replace-provider hashicorp/azurerm customproviderregistry/azurerm
```

#### Remove the specified instance from the state file
- Useful when a resource has been manually deleted outside of Terraform

```
terraform state rm
```

#### Show the specified resource in the state file

```
terraform state show <resourcename>
```

### 13. Import Existing Infrastructure <a name="import"></a>

#### Import Existing Infrastructure into Your Terraform State

- Import a VM with id123 into the configuration defined in the configuration files under vm1.name

```
terraform import vm1.name -i id123
```

### 14. Get Provider Information <a name="provider"></a>

#### Display a tree of providers used in the configuration files and their requirements

```
terraform providers
```

### 15. Manage Your Workspaces <a name="workspace"></a>

#### Show the name of the current workspace

```
terraform workspace show
```

#### List your workspaces

```
terraform workspace list
```

#### Select a specified workspace

```
terraform workspace select <workspace name>
```

#### Create a new workspace with a specified name

```
terraform workspace new <workspace name>
```

#### Delete a specified workspace

```
terraform workspace delete <workspace name>
```

### 16. View Your Outputs <a name="output"></a>

#### List all the outputs currently held in your state file
- These are displayed by default at the end of a terraform apply, this command can be useful if you want to view them independently.

```
terraform output
```

#### List the outputs held in the specified state file
- '-state' option is ignored when the remote state is used.

```
terraform output -state=<path to state file>
```

#### List the outputs held in your state file in JSON format to make them machine-readable

```
terraform output -json
```

#### List a specific output held in your state file

```
terraform output vm1_public_ip
```

### 17. Release a Lock on Your Workspace <a name="release"></a>

#### Remove the lock with the specified lock ID from your workspace
- Useful when a lock has become ‘stuck’, usually after an incomplete Terraform run.

```
terraform force-unlock <lock_id>
```

### 18. Log In and Out to a Remote Host (Terraform Cloud) <a name="login"></a>

#### Grab an API token for Terraform cloud (app.terraform.io) using your browser

```
terraform login
```

#### Log in to a specified host

```
terraform login <hostname>
```

#### Remove the credentials that are stored locally after logging in, by default for Terraform Cloud (app.terraform.io)

```
terraform logout
```

#### Remove the credentials that are stored locally after logging in for the specified hostname

```
terraform logout <hostname>
```
 
### 19. Produce a Dependency Diagram <a name="graph"></a>

#### Produce a graph in DOT language showing the dependencies between objects in the state file
- This can then be rendered by a program called Graphwiz (amongst others).

```
terraform graph
```

#### Produce a dependency graph using a specified plan file (generated using terraform plan -out=tfplan)

```
terraform graph -plan=tfplan
```

#### Specify the type of graph to output, either plan, plan-refresh-only, plan-destroy, or apply

```
terraform graph -type=plan
```

#### You can see if there are any dependency cycles between the resources

```
terraform graph -draw-cycles
```

### 20. Test Your Expressions <a name="test"></a>

#### Allow testing and exploration of expressions on the interactive console using the command line

```
terraform console
```

## Reference
- https://spacelift.io/blog/terraform-commands-cheat-sheet
