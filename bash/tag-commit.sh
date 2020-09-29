#!/bin/bash

STAGE=${1}

if [[ -z "${STAGE}" ]]; then
  echo "STAGE was empty, you need to provide the stage as first argument."
  exit 1
fi

DATE=$(date "+%s")

# Fetch all remotes, prune remote branches, prune remote tags, force fetch
git fetch --all -pPtf

# Get older tags for given stage
REMOVE_OLD_TAGS=$(git tag --sort=-taggerdate | egrep "^${STAGE}-" | awk 'NR>2')

# Remove older than latest 2
if ! [[ -z "${REMOVE_OLD_TAGS}" ]]; then
  git tag -d ${REMOVE_OLD_TAGS}
  HUSKY_SKIP_HOOKS=true git push origin -d ${REMOVE_OLD_TAGS}
fi

# Tag current commit
git tag -a "${STAGE}-${DATE}" -m "Deployed to ${STAGE}"

# Push tags to remote
HUSKY_SKIP_HOOKS=true git push --tags
