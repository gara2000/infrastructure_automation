#!/bin/bash

DIRNAME=$(dirname $0)
cd $DIRNAME/..

AMI_ID="ami-04b70fa74e45c3917"

# All the resource ids will be put in the resource_ids file

# Create VPC
vpc_id=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query Vpc.VpcId --output text --profile admin)
echo "VPC Created: $vpc_id"
echo "vpc_id:$vpc_id" > resource_ids

# Create Subnet
subnet_id=$(aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text --profile admin )
echo "Subnet Created: $subnet_id"
echo "subnet_id:$subnet_id" >> resource_ids

# Create Security Group
sg_id=$(aws ec2 create-security-group --description "security group for mlops vpc" --group-name "mlops_sg" --vpc-id $vpc_id --query 'GroupId' --output text --profile admin)
echo "Security Group Created: $sg_id"
echo "sg_id:$sg_id" >> resource_ids

# Set Security Group Rules
# Allow ssh connections 
rule_id=$(aws ec2 authorize-security-group-ingress --group-id $sg_id --protocol tcp --port 22 --cidr 0.0.0.0/0 --profile admin)
echo "Rule set: Allow ingress SSH connections"

# Create an Internet Gateway
igw_id=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text --profile admin )
echo "Internet Gateway Created: $igw_id"
echo "igw_id:$igw_id" >> resource_ids

# Attach Internet Gateway to my VPC
aws ec2 attach-internet-gateway --internet-gateway-id $igw_id --vpc-id $vpc_id --profile admin 
echo "Internet Gateway Attached to VPC"

# Get the route table associated with my VPC
rtb_id=$(aws ec2 describe-route-tables --query "RouteTables[?VpcId=='${vpc_id}'].RouteTableId" --output text --profile admin )
echo "Route table: $rtb_id"
echo "rtb_id:$rtb_id" >> resource_ids

# Add route to route table: route all traffic to the internet gateway
route_id=$(aws ec2 create-route --destination-cidr-block 0.0.0.0/0 --gateway-id $igw_id --route-table-id $rtb_id --profile admin)
echo "Route Added: Route all traffic to the Internet Gateway ($route_id)"

# Create a Key-Pair for the EC2 instance
KEY_NAME="MlopsKeyPair"
FILE_NAME="MlopsKeyPair.pem"
aws ec2 create-key-pair --key-name MlopsKeyPair --query 'KeyMaterial' --output text --profile admin > $FILE_NAME
echo "Key-pair Created in file: $FILE_NAME"
chmod 400 $FILE_NAME
echo "Permission Set"
echo "key_pair_name:$KEY_NAME" >> resource_ids
echo "key_pair_file_name:$FILE_NAME" >> resource_ids

# Create EC2 instance
i_id=$(aws ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $sg_id --subnet-id $subnet_id --count 1 --associate-public-ip-address --key-name MlopsKeyPair --query 'Instances[].InstanceId' --output text --profile admin)
echo "EC2 Instance Created: $i_id"
echo "i_id:$i_id" >> resource_ids

# Add tags to all the resources to find them with ease
aws ec2 create-tags --resources $i_id $rtb_id $igw_id $sg_id $subnet_id $vpc_id --tags Key=Repository,Value=mlops_pipeline Key=Name,Value=MLOps --profile admin
echo "Tags Set"

cat resource_ids