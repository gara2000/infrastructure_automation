# MLOps Pipeline
This is a full MLOps Pipeline, from model packaging to deployment

## Introduction
This repo can be run in different ways:
1. **Locally in a Python virtual environment:** you can run the application containing the model locally with python, for this we create a Python virtual environment.  
2. **Locally with Docker:** you can create the docker image of the flask-application running the model locally and test the model with the script "predict.sh" [TO BE IMPLEMENTED]  
3. **Cloud Solutions:**  
    1. **AWS EC2 Instance:** this will deploy the app on an EC2 instance that will be publicly available, the process is fully automated and we take 2 approaches to do the automation (IaC):  
        1. **Using automation scripts:** this uses shell scripts, that runs the AWS commands to set the Cloud architecture  
        2. **Using Terraform:** Terraform is a powerful toul that simplifies IaC, and makes it very organized [TO BE IMPLEMENTED] 

** Provisioning with ansible **
-> needs ansible, and openssh-server installation

## Authentication
### Authentication to AWS account
In order to be able to create and manage AWS resources you have to authenticate to your AWS account  
1. AWS CLI installation: refer to the [AWS CLI installation guide](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-install.html)
2. AWS authentication: refer to the [AWS Authentication with short-term credentials guide](https://docs.aws.amazon.com/cli/v1/userguide/cli-chap-authentication.html) (this is the recommended authentication method)  
**Note:** For conformity with this GitHub repository please choose "admin" as profile-name
3. Verify authentication: Once the authentication is complete you can verify with the following command
```bash
aws s3 ls --profile admin
```
**Note:** all of the actions performed in this repository are **Free-Tier elligible**
### Authentication to GitHub
1. GitHub CLI installation: refer to the [GitHub installation guide](https://github.com/cli/cli#installation)
2. GitHub authentication: refer to this [GitHub authentication guide](https://cli.github.com/manual/gh_auth_login)

**Side Note**
generate a token for the runner:
```bash
gh api   --method POST   -H "Accept: application/vnd.githu+json"   -H "X-GitHub-Api-Version: 2022-11-28"   /repos/gara2000/mlops_pipeline/actions/runners/registration-token
```

**Resources**
[Nohup Command](https://www.digitalocean.com/community/tutorials/nohup-command-in-linux)