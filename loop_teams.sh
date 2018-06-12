#!/bin/bash

# This is an example of looping over team names for
# performing repeated operations on team projects.

TEAM_NAMES=all_teams.txt

while read TEAM; do
  echo ${TEAM}
done < ${TEAM_NAMES}