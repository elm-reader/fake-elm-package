#!/bin/bash

if [[ ! -d reader ]]; then
  echo "Clone the appropriate version of the reader elm package to ./reader so I can ZIP it"
  exit 1
fi

echo "ZIPing reader/ to reader.zip (following symlinks; excluding .git/ and elm-stuff/)"
zip --exclude '*.git*' --exclude '*elm-stuff*' --symlinks -r reader.zip reader/

echo "Printing SHA1 hash of reader.zip:"
shasum reader.zip

echo "Write that hash to the appropriate field in reader-data/endpoint.json"
