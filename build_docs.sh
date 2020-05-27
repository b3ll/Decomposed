#!/bin/bash

# Parse swift docs.

sourcekitten doc -- -project ./Decomposed.xcodeproj -scheme Decomposed -sdk iphonesimulator > swiftDocs.json

# Fix directory structure for sourcekitten.

# Find files to copy (all headers are currently public).

headers_to_copy=()

OLD_IFS=$IFS
IFS=$(echo -en "\n\b")
for tmp_copied_file in $(find Sources/Decomposed -name "*.h")
do
  destination_url="Sources/Decomposed/$(basename $tmp_copied_file)"
  headers_to_copy+=( $destination_url )
  cp "$tmp_copied_file" "$destination_url"
done

sourcekitten doc --objc Sources/Decomposed.h -- -x objective-c -isysroot $(xcrun --show-sdk-path) -I $(pwd)/Sources > objcDocs.json

# Cleanup directory structure after sourcekitten.

for tmp_copied_file in $headers_to_copy
do 
  rm "$destination_url"
done
IFS=$OLD_IFS

# Merge swift and objc docs with jazzy.

jazzy --sourcekitten-sourcefile swiftDocs.json,objcDocs.json --author "Adam Bell" --author_url "https://twitter.com/b3ll" --undocumented-text "No overview available." --theme apple --clean

# Cleanup 

rm swiftDocs.json
rm objcDocs.json