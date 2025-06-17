#!/bin/bash

# chmod main.sh
# screen -dmS moshi ./main.sh

DATA_URL="https://www.kickstarter.com/projects/mindcandy/moshi-monsters/stats.json?v=1"
WEBHOOK_TOKEN="TOKEN"
WEBHOOK_ID=""
MESSAGE_ID=""

while true; do
  response=$(curl -s "$DATA_URL")
  state=$(echo "$response" | jq -r '.project.state')
  backers=$(echo "$response" | jq -r '.project.backers_count')
  pledged=$(echo "$response" | jq -r '.project.pledged')
  comments=$(echo "$response" | jq -r '.project.comments_count')

  curl -s -X PATCH \
    -H "Content-Type: application/json" \
    -d @- "https://discord.com/api/webhooks/$WEBHOOK_ID/$WEBHOOK_TOKEN/messages/$MESSAGE_ID" <<EOF
{
  "embeds": [
    {
      "title": "moshi monsters is back!!!!",
      "color": 16776960,
      "fields": [
        { "name": "State", "value": "$state", "inline": true },
        { "name": "Backers", "value": "$backers", "inline": true },
        { "name": "Pledged", "value": "\$$pledged", "inline": true },
        { "name": "Comments", "value": "$comments", "inline": true }
      ],
      "timestamp": "$(date -Iseconds)"
    }
  ]
}
EOF

  sleep 10
done
