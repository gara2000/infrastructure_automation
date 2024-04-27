# MLOps Pipeline
This is a full MLOps Pipeline, from model packaging to deployment

## Introduction
This repo can be run in different ways:
1. Locally in a Python virtual environment: you can run the application containing the model locally with python, for this we create a Python virtual environment.  
2. Locally with Docker: you can create the docker image of the flask-application running the model locally and test the model with the script "predict.sh" [TO BE IMPLEMENTED]  
3. Cloud Solutions:  
    3.1. AWS EC2 Instance: this will deploy the app on an EC2 instance that will be publicly available, the process is fully automated and we take 2 approaches to do the automation (IaC):  
        3.1.1. Using automation scripts: this uses shell scripts, that runs the AWS commands to set the Cloud architecture  
        3.1.2. Using Terraform: Terraform is a powerful toul that simplifies IaC, and makes it very organized  

1. Step 1
2. Step 2
3. Step 3
    1. Step 3.1
    2. Step 3.2
    3. Step 3.3