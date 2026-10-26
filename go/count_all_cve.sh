```bash
#!/bin/bash

set -euo pipefail

IMAGES=(
  "localhost:5001/hello-melange-apko-go:v1-single"
  "localhost:5001/hello-melange-apko-go:v1-multi"
  "localhost:5001/hello-melange-apko-go:v2-single-patched"
  "localhost:5001/hello-melange-apko-go:v2-multi-patched"
)

printf "%-45s %10s %10s %10s\n" \
  "IMAGE" "HIGH" "CRITICAL" "TOTAL"

for IMAGE in "${IMAGES[@]}"; do
  echo "Scanning: $IMAGE" >&2

  RESULT=$(trivy image \
    --format json \
    --quiet \
    "$IMAGE")

  COUNTS=$(echo "$RESULT" | jq -r '
    [
      ([.Results[]?.Vulnerabilities[]? |
        select(.Severity == "HIGH")] | length),
      ([.Results[]?.Vulnerabilities[]? |
        select(.Severity == "CRITICAL")] | length)
    ] | @tsv
  ')

  HIGH=$(echo "$COUNTS" | cut -f1)
  CRITICAL=$(echo "$COUNTS" | cut -f2)
  TOTAL=$((HIGH + CRITICAL))

  printf "%-45s %10s %10s %10s\n" \
    "$IMAGE" "$HIGH" "$CRITICAL" "$TOTAL"
done
```