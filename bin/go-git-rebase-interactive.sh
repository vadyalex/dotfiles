#!/usr/bin/env sh

commits_threshold=99
commits_history_count=$(git rev-list --count HEAD)
if [ $commits_history_count -lt $commits_threshold ]; then
    git rebase --interactive --root
else
    git rebase --interactive HEAD~$commits_threshold
fi
