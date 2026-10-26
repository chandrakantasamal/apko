# List all attestations
curl -s http://localhost:5001/v2/hello-melange-apko-go/tags/list | \
  jq '[.tags[] | select(test("attestation"))]'

# Expected Output:
# [
#   "sha256-abc123...-attestation",
#   "sha256-def456...-attestation",
#   ...
# ]