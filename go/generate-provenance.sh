#!/bin/bash
set -e

# Define images and their Dockerfiles
declare -A DOCKERFILES=(
  ["v1-single"]="Dockerfile.single"
  ["v1-multi"]="Dockerfile.multi"
  ["v2-single-patched"]="Dockerfile.single.patched"
  ["v2-multi-patched"]="Dockerfile.multi.patched"
)

# Define base images
declare -A BASE_IMAGES=(
  ["v1-single"]="golang:1.21.13-bookworm"
  ["v1-multi"]="golang:1.21.13-bookworm"
  ["v2-single-patched"]="golang:1.22.3-bookworm"
  ["v2-multi-patched"]="golang:1.22.3-bookworm"
)

echo "===== GENERATING BUILD PROVENANCE ====="

for tag in "${!DOCKERFILES[@]}"; do
  echo -e "\n🏗️ Generating provenance for $tag..."
  COSIGN_EXPERIMENTAL=1 cosign attest \
    --key cosign.key \
    --allow-insecure-registry \
    --type slsaprovenance \
    --predicate-type https://slsa.dev/provenance/v1 \
    --payload <(echo '{
      "buildType": "https://slsa.dev/provenance/v1",
      "buildConfig": {
        "dockerfile": "'"${DOCKERFILES[$tag]}"'",
        "baseImage": "'"${BASE_IMAGES[$tag]}"'"
      },
      "metadata": {
        "buildInvocationID": "'$(uuidgen)'",
        "buildStartedOn": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
        "buildFinishedOn": "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'",
        "completeness": { "parameters": true, "environment": false, "materials": true }
      },
      "materials": [
        {
          "uri": "git+https://github.com/chainguard-dev/hello-melange-apko@ref:main",
          "digest": { "sha1": "'$(git rev-parse HEAD)'" }
        }
      ]
    }' | jq -c) \
    localhost:5001/hello-melange-apko-go:$tag
  echo "✅ Provenance generated for $tag"
done

echo -e "\n✅ All provenance attestations generated!"