curl -s http://localhost:5001/v2/hello-melange-apko-go/tags/list | jq
# Expected: Tags include sbom-*, and sha256-* (signatures)