#!/bin/bash
originContent=$(cat $1)
hasTags=$(jq 'has("tags")' <<< "$originContent")
hasSwagger="true"

yq eval 'del(.tags)' -i destination.yaml
yq eval ".tags.has_swagger = [\"$hasSwagger\"]" -i destination.yaml

if [ "$hasTags" = "true" ]; then
    tags=$(echo "$originContent" | jq -r '.tags | map({(.name): .description}) | add')

    for key in $(echo "$tags" | jq -r 'keys[]'); do
        value=$(echo "$tags" | jq -r --arg key "$key" '.[$key]')
        yq eval ".tags.$key = [\"$value\"]" -i destination.yaml
    done
fi
