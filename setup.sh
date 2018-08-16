#!/bin/bash

# Generic error handling header, credit to https://stelfox.net/blog/2013/11/fail-fast-in-bash-scripts/
function error_handler() {
  echo "Error occurred in script at line: ${1}."
  echo "Line exited with status: ${2}"
}
trap 'error_handler ${LINENO} $?' ERR
set -o errexit
set -o errtrace
set -o pipefail
set -o nounset

function setupFor {
  if [[ ! -d "$1" ]]; then
    echo "Clone the appropriate version of the $1 elm package to ./$1 so I can ZIP it"
    exit 1
  fi

  echo "ZIPing $1/ to $1.zip (following symlinks; excluding .git/ and elm-stuff/)"
  zip --exclude '*.git*' --exclude '*elm-stuff*' -r -FS "$1.zip" "$1"


  # Hash it
  echo # space after `zip` output
  echo "Hashing the ZIP"
  if command -v shasum &> /dev/null; then
    shacmd=shasum
  elif command -v sha1sum &> /dev/null; then
    shacmd=sha1sum
  else
    echo
    echo "Oh no, neither 'shasum' nor 'sha1sum' are available programs."
    echo "Quitting without updating $1-data/endpoint.json"
    exit 1
  fi
  ziphash=$($shacmd "$1.zip" | cut -f 1 -d " ")
  echo "SHA-1 hash of $1.zip is $ziphash"


  # Update endpoint.json
  echo "Updating $1-data/endpoint.json"
  echo "{
      \"url\": \"http://localhost:8080/$1.zip\",
      \"hash\": \"$ziphash\"
  }" > "$1-data/endpoint.json"
  echo
  echo
}

setupFor browser
