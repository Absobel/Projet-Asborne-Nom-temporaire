#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <vault_path>"
  exit 1
fi

cd $1 || { echo "Error: vault path invalid"; exit 1; }
vn=$(pwd | xargs basename)

if read -t 0; then
  content=$(cat -)
else
  echo "error: no content provided via stdin."
  exit 1
fi

while IFS= read -r match; do
  safe=$(printf '%s' "$match" | sed 's/[.[\*^$(){}|?&+]/\\&/g')
  path=$(fd -F -e md "$match" . | grep "/$match.md$" | tr -d '\n' | sed 's|^\./||;s|\.md$||g' | jq -s -R -r @uri)
  if [ -n "$path" ]; then
    content=$(echo "$content" | sed -E "s|\[\[${safe}\]\]|[${safe}](obsidian://open?vault=$vn\&file=${path})|g")
  fi
done < <(echo "$content" | grep -oP '(?<=\[\[)[^\]]+(?=\]\])')

echo "$content"
