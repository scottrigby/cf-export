#!/bin/sh

# Get the triggering PR number from the commit: CF_REVISION
cat << EOF > DATA.txt
{ "query": "query {search (first: 100, type: ISSUE, query: \"type:pr repo:$CF_COMMIT_AUTHOR/$CF_REPO_NAME $CF_REVISION\") {nodes {... on PullRequest {id, number, title}}}}" }
EOF
HEADER="Authorization: token $GITHUB_TOKEN"
URL="https://api.github.com/graphql"
RESPONSE=$(curl --silent $URL -H "$HEADER" -d @DATA.txt)
PR_NUMBER=$(echo $RESPONSE | jq '.data.search.nodes | .[].number')
# Set a new CF ENV var: CF_PR_NUMBER
if [ ! -z "$PR_NUMBER" ];then
  echo "CF_PR_NUMBER=${PR_NUMBER}" >> ${CF_VOLUME_PATH}/env_vars_to_export
  echo 'Exported CF_PR_NUMBER var'
fi
rm DATA.txt
