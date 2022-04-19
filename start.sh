#!/bin/bash
  
# ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN
# REG_TOKEN=$REG_TOKEN
REPO=$REPO
OWNER=$OWNER
HOSTNAME=$(hostname)

# Organization Runner
# REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)

# Repo Runner
REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token | jq .token --raw-output)
# REG_TOKEN="curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" https://api.github.com/repos/${OWNER}/${REPO}/actions/runners/registration-token | jq .token --raw-output"


echo $REG_TOKEN

cd /home/runner/actions-runner

# cd actions-runner

# ./config.sh --url https://github.com/${ORGANIZATION} --token ${REG_TOKEN} --labels self-hosted,Linux,X64,${HOSTNAME}
./config.sh --url https://github.com/${OWNER}/${REPO} --token ${REG_TOKEN} --labels self-hosted,Linux,X64,${HOSTNAME}
# ./config.sh --url https://github.com/SujanSharma07/Docker-celery-postgresql-rabbitmq-django --token AMD332T3ZMPQL7RTDIUQ3FDCJQ7ZE


cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!