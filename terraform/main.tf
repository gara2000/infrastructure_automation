provider "aws" {
    region = "us-east-1"
    profile = var.profile
}

module "ec2_instance" {
    source = "./modules/ec2_instance"
}