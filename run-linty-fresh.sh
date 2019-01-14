#!/bin/bash

# The following are provided by GitHub Actions environment:
# https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/
# - GITHUB_SHA
# - GITHUB_REPOSITORY
# - $URI

set +e  # don't immediately exit on fail
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Set the GITHUB_TOKEN env variable."
    exit 1
fi

URI=https://api.github.com
API_VERSION=v3
API_HEADER="Accept: application/vnd.github.${API_VERSION}+json; application/vnd.github.antiope-preview+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"

main() {
    # Validate the github token
    curl -o /dev/null -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}" || { echo "Error: Invalid repo, token or network issue!";  exit 1; }

    echo "Linting!"

    # Revise master to be target branch eventually
    git fetch origin master

    # Get modified Python files and pass to pylint
    git --no-pager diff --name-only origin/master | grep .py | xargs pylint > pylint.txt

    # Get the pull request number.
    NUMBER=$(jq --raw-output .number "$GITHUB_EVENT_PATH")

    echo "running $GITHUB_ACTION for PR #${NUMBER}"

    PR_URL="${URI}/${GITHUB_REPOSITORY}/pull/${NUMBER}"

    LINT_RESULT=$?

    export GITHUB_AUTH_TOKEN="${GITHUB_TOKEN}"

    linty_fresh --pr_url ${PR_URL} --commit "${GITHUB_SHA}" \
                --linter pylint pylint.txt \
                --linter_name "A friendly helper"

    echo "All done"

    exit ${LINT_RESULT}
}

main
