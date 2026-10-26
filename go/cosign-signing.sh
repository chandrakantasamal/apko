#!/bin/bash
set -e

# Images to sign
IMAGES=(
  "localhost:5001/hello-melange-apko-go:v1-single"
  "localhost:5001/hello-melange-apko-go:v1-multi"
  "localhost:5001/hello-melange-apko-go:v2-single-patched"
  "localhost:5001/hello-melange-apko-go:v2-multi-patched"
)

# Sign all images
for img in "${IMAGES[@]}"; do
  echo "🔐 Signing $img..."
  COSIGN_EXPERIMENTAL=1 cosign sign \
    --key cosign.key \
    --allow-insecure-registry \
    "$img"
  echo "✅ Signed $img"
done

# Verify all images
for img in "${IMAGES[@]}"; do
  echo -e "\n🔍 Verifying $img..."
  COSIGN_EXPERIMENTAL=1 cosign verify \
    --key cosign.pub \
    --allow-insecure-registry \
    "$img"
done

echo -e "\n✅ All images signed and verified!"