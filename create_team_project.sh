#!/bin/bash

BUCKET_LOCATION=us
BUCKET_CLASS=multi_regional

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

# Add project members
shift
./add_project_members.sh ${PROJECT_ID} "$@"

# Add read access to shared hackathon data
if [ -z ${SHARED_BUCKET+x} ]; then
  echo "SHARED_BUCKET is not set, so no bucket access will be granted."
else
  gsutil -m acl ch -r -p editors-${PROJECT_ID}:R ${SHARED_BUCKET}
fi

# Create a team bucket
gsutil mb -p ${PROJECT_ID} -c ${BUCKET_CLASS} -l ${BUCKET_LOCATION} gs://${PROJECT_ID}/

# Project link
echo "Created project ${PROJECT_ID} on billing account ${ACCOUNT_ID}."
echo "Project Console URL: https://console.cloud.google.com/home/dashboard?project=${PROJECT_ID}"

