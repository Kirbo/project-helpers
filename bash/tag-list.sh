#!/bin/bash

# Fetch all remotes, prune remote branches, prune remote tags, force fetch
git fetch --all -pPtf

TAG_MAX_LENGTH=20
HASH_MAX_LENGTH=12
TAGGED_ON_MAX_LENGTH=34
AUTHOR_MAX_LENGTH=20
MESSAGE_MAX_LENGTH=40
SHORTENED_TAGS=""

TOPIC=""
DIVIDER="-"

add_topic() {
  ADD_TOPIC=${1}
  LENGTH=${2}

  PADDED_TOPIC=$(printf "%s%*s%s" "${ADD_TOPIC}" $(expr ${LENGTH} - ${#ADD_TOPIC}) "")
  TOPIC="${TOPIC}${PADDED_TOPIC}"

  PADDED_DIVIDER=$(printf %${#PADDED_TOPIC}s |tr " " "-")
  DIVIDER="${DIVIDER}${PADDED_DIVIDER}"
}

output_topic() {
  echo "${TOPIC}"
  echo "${DIVIDER}"
}

add_topic "Tag" $(expr ${TAG_MAX_LENGTH} + 1)
add_topic "Commit SHA" ${HASH_MAX_LENGTH}
add_topic "Tagged on" ${TAGGED_ON_MAX_LENGTH}
add_topic "Tagger" ${AUTHOR_MAX_LENGTH}
add_topic "Commit Message" ${MESSAGE_MAX_LENGTH}

for STAGE in $(echo "dev test qa prod"); do
  REMOVE_OLD_TAGS=$(git tag --sort=-taggerdate | egrep "^${STAGE}-" | awk 'NR>3')
  if ! [[ -z "${REMOVE_OLD_TAGS}" ]]; then
    git tag -d ${REMOVE_OLD_TAGS}
    HUSKY_SKIP_HOOKS=true git push origin -d ${REMOVE_OLD_TAGS}
  fi
done

DEV_TAGS=$(git tag --sort=-taggerdate | egrep "^dev-")
TEST_TAGS=$(git tag --sort=-taggerdate | egrep "^test-")
QA_TAGS=$(git tag --sort=-taggerdate | egrep "^qa-")
PROD_TAGS=$(git tag --sort=-taggerdate | egrep "^prod-")
OTHER_TAGS=$(git tag --sort=-taggerdate | egrep -v "^(dev|test|qa|prod)-")

output_topic

for CATEGORY in $(echo "DEV TEST QA PROD OTHER"); do
  TAGS="${CATEGORY}_TAGS"
  if ! [[ -z "${!TAGS}" ]]; then
    for TAG in $(echo "${!TAGS}"); do
      HASH=$(git log ${TAG} -n 1 --pretty=%h 2>/dev/null)
      if ! [[ -z "${HASH}" ]]; then
        DATE=$(git tag -l --format='%(taggerdate)' ${TAG})
        PADDED_DATE=$(printf "%s%*s%s" "${DATE}" $(expr ${TAGGED_ON_MAX_LENGTH} - ${#DATE}) "")
        PADDED_HASH=$(printf "%s%*s%s" "${HASH}" $(expr ${HASH_MAX_LENGTH} - ${#HASH}) "")

        PADDED_TAG=$(printf "%s%*s%s" "${TAG}" $(expr ${TAG_MAX_LENGTH} - ${#TAG}) "")
        if [[ "${#PADDED_TAG}" > ${TAG_MAX_LENGTH} ]]; then
          PADDED_TAG="${PADDED_TAG:0:$(expr ${TAG_MAX_LENGTH} - 3)}..."
          if ! [[ "${TAG}" =~ "${SHORTENED_TAGS}" ]]; then
            SHORTENED_TAGS="${SHORTENED_TAGS} ${TAG}"
          fi
        fi

        AUTHOR=$(git tag -l --format='%(taggername)' ${TAG})
        PADDED_AUTHOR=$(printf "%s%*s%s" "${AUTHOR}" $(expr ${AUTHOR_MAX_LENGTH} - ${#AUTHOR}) "")

        MESSAGE=$(git show -s --pretty=format:"%s" ${HASH})
        if [[ "${#MESSAGE}" > $MESSAGE_MAX_LENGTH ]]; then
          MESSAGE="${MESSAGE:0:$(expr ${MESSAGE_MAX_LENGTH} - 3)}..."
        fi

        echo -e " ${PADDED_TAG}${PADDED_HASH}${PADDED_DATE}${PADDED_AUTHOR}${MESSAGE}"
      fi
    done
    echo
  fi
done

if ! [[ -z "${SHORTENED_TAGS}" ]]; then
  echo "Shortened tags:"
  for TAG in $SHORTENED_TAGS; do
    echo "  - ${TAG}"
  done

  echo
fi
