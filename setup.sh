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

# Check the reader/ directory exists
if [[ ! -d reader ]]; then
  echo "Clone the appropriate version of the reader elm package to ./reader so I can ZIP it"
  exit 1
fi

# ZIP it. Follow the symlink if there is one because otherwise `zip` returns 18 (an error),
# despite working, warning that there is a directory and file with the same name.
echo "ZIPing reader/ to reader.zip (following symlinks; excluding .git/ and elm-stuff/)"
if [[ -L reader ]]; then
  readerpath=$(readlink reader)
else
  readerpath=reader
fi
zip --exclude '*.git*' --exclude '*elm-stuff*' --symlinks -r reader.zip "$readerpath"


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
  echo "Quitting without updating reader-data/endpoint.json"
  exit 1
fi
readerhash=$($shacmd reader.zip | cut -f 1 -d " ")
echo "SHA-1 hash of reader.zip is $readerhash"


# Update endpoint.json
echo "Updating reader-data/endpoint.json"
echo "{
    \"url\": \"http://localhost:8080/reader.zip\",
    \"hash\": \"$readerhash\"
}" > reader-data/endpoint.json
