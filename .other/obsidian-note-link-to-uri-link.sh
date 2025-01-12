#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <vault_path> <input_file>"
  exit 1
fi

cd $1
vn=$(pwd | xargs basename)
content=$(cat "$2")

while IFS= read -r match; do
  safe=$(printf '%s' "$match" | sed 's/[.[\*^$(){}|?&+]/\\&/g')
  path=$(fd -F -e md "$match" . | grep "/$match.md$" | tr -d '\n' | sed 's|^\./||;s|\.md$||g' | jq -s -R -r @uri)
  if [ -n "$path" ]; then
    content=$(echo "$content" | sed -E "s|\[\[${safe}\]\]|[${safe}](obsidian://open?vault=$vn\&file=${path})|g")
  fi
done < <(echo "$content" | grep -oP '(?<=\[\[).*(?=\]\])')

echo "$content"
