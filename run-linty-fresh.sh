#!/bin/bash

# The following are provided by GitHub Actions environment:
# https://developer.github.com/actions/creating-github-actions/accessing-the-runtime-environment/
# - GITHUB_SHA
# - GITHUB_REPOSITORY
# - $URI
# - $NUMBER

set -e  # immediate exit on fail
set -o pipefail

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Set the GITHUB_TOKEN env variable."
    exit 1
fi

main() {
    echo "Linting!"
    # Validate the github token
    curl -o /dev/null -sSL -H "${AUTH_HEADER}" -H "${API_HEADER}" "${URI}/repos/${GITHUB_REPOSITORY}" || { echo "Error: Invalid repo, token or network issue!";  exit 1; }


    git --no-pager diff --name-only \
        FETCH_HEAD $(git merge-base FETCH_HEAD master) | \
        grep .py | \
        pylint > pylint.txt

    PR_URL="{$URI}/{$GITHUB_REPOSITORY}/pull/{$NUMBER}"

    linty_fresh --pr_url ${PR_URL} --commit "${GITHUB_SHA}" \
                --linter pylint pylint.txt

    echo "All done"
}

main
