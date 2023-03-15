#!/bin/bash -e
set -x
[[ -z "${PRIVATE_KEY}" ]] && echo "Usage: ${0} <private-key> <app-id>" && exit 1
[[ -z "${APP_ID}" ]] && echo "Usage: ${0} <private-key> <app-id>" && exit 1
repo=${GITHUB_REPOSITORY:?Missing required GITHUB_REPOSITORY environment variable}

[ -n "$INPUT_REPO" ] && repo="$INPUT_REPO"

jwt=$(python "$(dirname "$0")"/generate_jwt.py)
response=$(curl -s -H "Authorization: Bearer ${jwt}" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${repo}/installation")
installation_id=$(echo "$response" | jq -r .id)

if [ "$installation_id" = "null" ]; then
    echo "Unable to get installation ID. Is the GitHub App installed on ${repo}?"
    echo "$response" | jq -r .message
    exit 1
fi

token=$(curl -s -X POST \
             -H "Authorization: Bearer ${jwt}" \
             -H "Accept: application/vnd.github.v3+json" \
             https://api.github.com/app/installations/"${installation_id}"/access_tokens | jq -r .token)

if [ "$token" = "null" ]; then
    echo "Unable to generate installation access token"
    exit 1
fi

echo "token=${token}" >> "$GITHUB_OUTPUT"
