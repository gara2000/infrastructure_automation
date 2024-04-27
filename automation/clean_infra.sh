#!/bin/bash

DIRNAME=$(dirname $0)
cd $DIRNAME/..

PROFILE="admin"
SG_ID=$(awk -F ':' '$1 == "sg_id" {print $2}' resource_ids)
SUBNET_ID=$(awk -F ':' '$1 == "subnet_id" {print $2}' resource_ids)
RTB_ID=$(awk -F ':' '$1 == "rtb_id" {print $2}' resource_ids)
IGW_ID=$(awk -F ':' '$1 == "igw_id" {print $2}' resource_ids)
VPC_ID=$(awk -F ':' '$1 == "vpc_id" {print $2}' resource_ids)
I_ID=$(awk -F ':' '$1 == "i_id" {print $2}' resource_ids)
KEY_PAIR_NAME=$(awk -F ':' '$1 == "key_pair_name" {print $2}' resource_ids)
ACL_ID=$(aws ec2 describe-network-acls --profile $PROFILE --query "NetworkAcls[?Associations[?SubnetId=='$SUBNET_ID']].NetworkAclId" --output text)

# Terminate the EC2 instance
echo "Terminating instance: $I_ID"
aws ec2 terminate-instances --instance-ids $I_ID --profile $PROFILE > /dev/null
state=$(aws ec2 describe-instances --query "Reservations[?Instances[?InstanceId=='$I_ID']].Instances[].State.Name" --output text --profile $PROFILE)
while [ $state != "terminated" ]; do
    sleep 0.5
    state=$(aws ec2 describe-instances --query "Reservations[?Instances[?InstanceId=='$I_ID']].Instances[].State.Name" --output text --profile $PROFILE)
    echo "."
done
echo "EC2 instance terminated"

# Delete the key-pair
aws ec2 delete-key-pair --key-name $KEY_PAIR_NAME --profile $PROFILE 
rm -f MlopsKeyPair.pem
echo "Key pair deleted"

# Delete the security group
aws ec2 delete-security-group --group-id $SG_ID --profile $PROFILE
echo "Security Group deleted"

# # Delete the network ACL
# aws ec2 delete-network-acl --network-acl-id $ACL_ID --profile $PROFILE
# echo "Network ACL deleted"

# Delete the subnet
aws ec2 delete-subnet --subnet-id $SUBNET_ID --profile $PROFILE 
echo "Subnet deleted"

#Delete Route table
# aws ec2 delete-route-table --route-table-id $RTB_ID --profile $PROFILE
# echo "Route table deleted"

# Detach the Internet Gateway from the VPC
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID --profile $PROFILE
echo "Internet Gateway detached from VPC"

# Delete the Internet Gateway 
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID --profile $PROFILE
echo "Internet Gateway deleted"

# Delete the VPC
aws ec2 delete-vpc --vpc-id $VPC_ID --profile $PROFILE
echo "VPC deleted"