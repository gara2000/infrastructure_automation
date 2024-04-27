#!/bin/bash

DIRNAME=$(dirname $0)
cd $DIRNAME/..

PROFILE="admin"

no_running_instance() {
    echo $1
    echo "Make sure that your instance is running."
    echo "Run 'make infra-build' to build your instance."
}

wait() {
    echo "Waiting for machine set up"
    for i in {1..8}; do
        echo .
        sleep 1
    done
}

if [ -e "resource_ids" ]; then
    I_ID=$(awk -F ':' '$1 == "i_id" {print $2}' resource_ids)
    KEY_FILE_NAME=$(awk -F ':' '$1 == "key_pair_file_name" {print $2}' resource_ids)

    STATE=$(aws ec2 describe-instances --query "Reservations[].Instances[?InstanceId=='$I_ID'].State.Name" --output text --profile $PROFILE)

    while [ $STATE = 'pending' ]; do
        echo "Pending Instance Start..."
        sleep 1
        STATE=$(aws ec2 describe-instances --query "Reservations[].Instances[?InstanceId=='$I_ID'].State.Name" --output text --profile $PROFILE)
    done


    if [ $STATE = 'running' ]; then
        IP=$(aws ec2 describe-instances --query "Reservations[].Instances[?InstanceId=='$I_ID'].PublicIpAddress" --output text --profile $PROFILE)
        USER=ubuntu
        ssh -i $KEY_FILE_NAME $USER@$IP
    else
        no_running_instance "Instance is not running, state is $STATE"
    fi
else
    no_running_instance "No 'resource_ids' file found!"
fi

