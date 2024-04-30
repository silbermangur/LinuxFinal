#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
CSV_FILE="$SCRIPT_DIR/commit.csv"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: commit.csv not found in $SCRIPT_DIR!"
    exit 1
fi

tail -n +2 "$CSV_FILE" | while IFS=, read -r BugId Description branch DeveloperName BugPriority GITHUBURL; do
    if [ "$branch" == "$(git branch --show-current)" ]; then
        commit_message="$BugId:$(date +%Y-%m-%d-%H-%M-%S):$branch:$DeveloperName:$BugPriority:$Description"

        git add *.txt
        git commit -m "$commit_message"
        git remote add origin "$GITHUBURL"
        git push origin "$branch" || echo "Error: Push failed for branch $branch"
    fi
done
