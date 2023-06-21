## SAMPLE-10: Implementing MLOps Pipeline using GitHub, AWS CodePipeline, AWS CodeBuild, AWS CodeDeploy, and AWS Sagemaker (Endpoint)

This sample shows:
- how to create MLOps Pipeline 
- how to use GitHub Hooks (Getting Source Code from Github to CodePipeline)
- how to create Build CodePipeline (Source, Build), CodeBuild (modelbuild_buildspec.yml), Deploy CodePipeline (Source, Build, DeployStaging, DeployProd), CodeBuild (modeldeploy_buildspec.yml)
- how to save the model and artifacts on S3
- how to create and test models using Notebooks

**Notes:**
- Source code was pulled from and updated:
  - https://github.com/aws-samples/aws-mlops-pipelines-terraform


**Code:** 

**Architecture:**
- **Model Build Pipeline Source Code, modelbuild_pipeline:**:  https://github.com/omerbsezer/modelbuild_pipeline 
- **Model Deploy Pipeline Source Code, modeldeploy_pipeline:**: https://github.com/omerbsezer/modeldeploy_pipeline
- AWS Code Pipeline for **Model Build** (CI)
  - AWS Code Pipeline (**modelbuild_ci_pipeline.tf**)
    - Stage: Source (Hook from GitHub: **modelbuild_hooks.tf**)
    - Stage: Build (**modelbuild_codebuild.tf: artifacts, environment, source (modelbuild_buildspec.yml: run build pipeline)**)
  - Sagemaker Data Pipeline (**modelbuild_pipeline project: pipeline.py**):
    - Preprocessing Step (**modelbuild_pipeline project: pipeline.py => preprocess.py**)
    - Model Training Step (**modelbuild_pipeline project: pipeline.py => XGB BuiltIn Container**)
    - Evaluation Step (**modelbuild_pipeline project: pipeline.py => evaluate.py, ConditionStep to evaluate model quality**)
    - Registering Model Step (**modelbuild_pipeline project: pipeline.py => RegisterModel**)
- AWS Code Pipeline for **Model Deploy** (CD)
  - AWS Code Pipeline (**modeldeploy_cd_pipeline.tf**)
    - Stage: Source (Hook from GitHub: **modeldeploy_hooks.tf**)
    - Stage: Build (**modeldeploy_codebuild.tf: artifacts, environment, source (modeldeploy_buildspec.yml: run deploy pipeline => modeldeploy_pipeline project: build.py,  cloud formation to create endpoint)**)  
    - Stage: DeployStaging:
      - Action: Deploy (**Cloudformation, DeployResourcesStaging: modeldeploy_pipeline project => endpoint-config-template.yml**)
      - Action: Build (**Test Staging: modeldeploy_testbuild.tf => modeldeploy_pipeline project: test/test_buildspec.yml**)
      - Action: Approval (**Manual Approval by User**)
    - Stage: DeployProd:
      - Action: Deploy (**Cloudformation, DeployResourcesProd: modeldeploy_pipeline project => endpoint-config-template.yml**)
- Notebooks (for testing)
  - End2end.ipynb
  - Pipeline.ipynb 
    
   ![image](https://github.com/omerbsezer/Fast-Terraform/assets/10358317/09c0ac8a-0fe5-4877-8440-b29a22bad5cf)


### Prerequisite

- You should have a look following lab: 
  - [LAB-00: Terraform Install, AWS Configuration with Terraform](https://github.com/omerbsezer/Fast-Terraform/blob/main/LAB00-Terraform-Install-AWS-Configuration.md)


## Steps

- Run

```
```
