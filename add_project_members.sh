#!/bin/bash

USAGE="Usage: ./create_team_project.sh project_id user1@example.com user2@example.com ..."
if [ "$#" -lt 2 ]; then
  echo "$USAGE"
  exit 1
fi

PROJECT_ID="$1"

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

echo "Project IAM policy updated. A local copy is here: ${IAM_FILE}"