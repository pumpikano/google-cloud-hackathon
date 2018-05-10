# Creating a team

```
# Switch to the correct account used to administer the hackathon.
gcloud config set account admin@hackathon.com

# First, set the event name that will be used to construct project names
# and tag the projects so that can be easily filtered later.
export EVENT_NAME=<event-name>

# Get the billing account id to use.
gcloud beta billing accounts list

# Set the billing account id to link any projects subsequently created.
export ACCOUNT_ID=<account-id>

# Create a team project with a team name and one or more members.
./create_team_project.sh team1 foo@example.com bar@example.com

# View all projects linked to the hackathon.
gcloud projects list --filter="labels.event=${EVENT_NAME}"
```
