#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 5 ]; then
  echo "Usage: $0 <SLACK_WEBHOOK_URL> <REPOSITORY> <BRANCH> <RUN_ID> <STATUS>"
  exit 1
fi

# Assign the arguments to variables
SLACK_WEBHOOK_URL=$1
REPOSITORY=$2
BRANCH=$3
RUN_ID=$4
STATUS=$5
ICON=":white_check_mark:"

if [ $STATUS -e "Failed" ]; then
    ICON=":red_circle:"
fi

MESSAGE=$(cat <<EOF
{
  "blocks": [
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "${ICON} *GitHub Workflow ${STATUS}*"
      }
    },
    {
      "type": "section",
      "fields": [
        {
          "type": "mrkdwn",
          "text": "*Repository:*\n${REPOSITORY}"
        },
        {
          "type": "mrkdwn",
          "text": "*Branch:*\n${BRANCH}"
        }
      ]
    },
    {
      "type": "section",
      "text": {
        "type": "mrkdwn",
        "text": "<https://github.com/${REPOSITORY}/actions/runs/${RUN_ID}|View Details>"
      }
    }
  ]
}
EOF
)
curl -X POST -H 'Content-type: application/json' --data "$MESSAGE" $SLACK_WEBHOOK_URL
