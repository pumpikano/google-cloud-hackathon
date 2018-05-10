#!/bin/bash

if [ -z ${ACCOUNT_ID+x} ]; then
  echo "ACCOUNT_ID must be set to a billing account id"
  exit 1
fi

if [ -z ${EVENT_NAME+x} ]; then
  echo "EVENT_NAME must be set to the event name"
  exit 1
fi

USAGE="Usage: ./create_team_project.sh team-name user1@example.com user2@example.com ..."
if [ "$#" -lt 2 ]; then
  echo "$USAGE"
  exit 1
fi

TEAM_NAME="$1"
PROJECT_ID=${EVENT_NAME}-${TEAM_NAME}

echo "Creating project $PROJECT_ID"

# Create project
gcloud projects create ${PROJECT_ID} \
  --labels=event=${EVENT_NAME},team=${TEAM_NAME}

# Link to billing account (this will not grant access to change or view billing)
gcloud alpha billing projects link ${PROJECT_ID} --billing-account=${ACCOUNT_ID}

# Get the IAM policy for the project
IAM_DIR=/tmp/iams
IAM_FILE=${IAM_DIR}/${PROJECT_ID}.iam.json
mkdir -p ${IAM_DIR}
gcloud projects get-iam-policy ${PROJECT_ID} --format=json > ${IAM_FILE}

# Add each member to the policy as an Editor
shift
while (( "$#" )); do
  MEMBER="user:$1"
  python ./add_bindings.py --input ${IAM_FILE} --role roles/editor --members ${MEMBER}
  shift
done

# Update the policy
gcloud projects set-iam-policy ${PROJECT_ID} ${IAM_FILE}

# Project link
echo "Created project ${PROJECT_ID} on billing account ${ACCOUNT_ID}."
echo "Project IAM policy is here: ${IAM_FILE}"
echo "Project Console URL: https://console.cloud.google.com/home/dashboard?project=${PROJECT_ID}"

