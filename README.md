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

# Set an optional bucket to grant read access
export SHARED_BUCKET=gs://<bucket>

# Create a team project with a team name and one or more members.
./create_team_project.sh team1 foo@example.com bar@example.com

# View all projects linked to the hackathon.
gcloud projects list --filter="labels.event=${EVENT_NAME}"
```

## Colors

In many cases, it is convenient to create a number of projects upfront and assign them to participants. The file `colors.txt` is a list of common color names that can be used to create project names e.g. by adding a prefix. They are a little more interesting than simply numbering projects.


