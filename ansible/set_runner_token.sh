#!/bin/bash

DIRNAME=$(dirname $0)

GH_USER=$(gh api /user --jq '.login')
REPO="mlops_pipeline"
DEST="$DIRNAME/playbooks/roles/runner/vars/main.yml"
TOKEN=$(gh api   --method POST  \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    /repos/$GH_USER/$REPO/actions/runners/registration-token \
    --jq '.token')

echo "!!!Going to Override File $DEST!!!"
echo "TOKEN : $TOKEN" > $DEST