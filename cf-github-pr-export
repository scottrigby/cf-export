#!/bin/sh

if [ -z "${GITHUB_TOKEN}" ]; then
  echo "Required ENV var GITHUB_TOKEN must be set"
  exit 1
fi

HEADER="Authorization: token $GITHUB_TOKEN"
URL="https://api.github.com/graphql"

# Get the triggering PR number from CF_REVISION, and set CF_PR_NUMBER.
cat << EOF > DATA.txt
{ "query": "query {search (first: 100, type: ISSUE, query: \"type:pr repo:$CF_REPO_OWNER/$CF_REPO_NAME $CF_REVISION\") {nodes {... on PullRequest {id, number, title}}}}" }
EOF
PR_NUMBER=$(curl --silent $URL -H "$HEADER" -d @DATA.txt | jq --raw-output '.data.search.nodes | .[].number')
if [ ! -z "$PR_NUMBER" ];then
  echo "CF_PR_NUMBER=${PR_NUMBER}" >> ${CF_VOLUME_PATH}/env_vars_to_export
  echo 'Exported CF_PR_NUMBER'
fi
rm DATA.txt

# Get the triggering PR state from PR_NUMBER, and set CF_PR_STATE.
cat << EOF > DATA.txt
{ "query": "query {repository(owner: \"$CF_REPO_OWNER\", name: \"$CF_REPO_NAME\") {pullRequest(number: $PR_NUMBER) {state}}}" }
EOF
STATE=$(curl --silent $URL -H "$HEADER" -d @DATA.txt | jq --raw-output .data.repository.pullRequest.state)
if [ ! -z "$STATE" ];then
  echo "CF_PR_STATE=${STATE}" >> ${CF_VOLUME_PATH}/env_vars_to_export
  echo 'Exported CF_PR_STATE'
fi
rm DATA.txt
