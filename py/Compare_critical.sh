#!/bin/bash
set -e

# Images to scan
SINGLE_IMAGE="localhost:5001/hello-melange-apko:v1-single"
MULTI_IMAGE="localhost:5001/hello-melange-apko:v1-multi"

# Pull images
echo "📥 Pulling images..."
docker pull $SINGLE_IMAGE
docker pull $MULTI_IMAGE

# Scan and save reports
echo "🔍 Scanning single-stage image..."
trivy image --format json --output single-stage-scan.json $SINGLE_IMAGE
trivy image --severity CRITICAL $SINGLE_IMAGE > single-stage-summary.txt
# trivy image --severity HIGH,CRITICAL $SINGLE_IMAGE > single-stage-summary.txt

echo "🔍 Scanning multi-stage image..."
trivy image --format json --output multi-stage-scan.json $MULTI_IMAGE
trivy image --severity CRITICAL $MULTI_IMAGE > multi-stage-summary.txt

# Generate comparison
echo "📊 Generating comparison..."
{
  echo "=== Vulnerability Comparison ==="
  echo -e "\nMetric\t\tSingle-Stage\tMulti-Stage"
  echo "----------------------------------------"
  echo -e "Total Vulns\t$(jq '.Results[0].Vulnerabilities | length' single-stage-scan.json)\t\t$(jq '.Results[0].Vulnerabilities | length' multi-stage-scan.json)"
  echo -e "Critical\t\t$(jq '[.Results[0].Vulnerabilities[] | select(.Severity == "CRITICAL")] | length' single-stage-scan.json)\t\t$(jq '[.Results[0].Vulnerabilities[] | select(.Severity == "CRITICAL")] | length' multi-stage-scan.json)"
  echo -e "High\t\t$(jq '[.Results[0].Vulnerabilities[] | select(.Severity == "HIGH")] | length' single-stage-scan.json)\t\t$(jq '[.Results[0].Vulnerabilities[] | select(.Severity == "HIGH")] | length' multi-stage-scan.json)"
} > comparison.txt

echo "✅ Scan complete! Reports saved to:"
echo "   - single-stage-scan.json"
echo "   - multi-stage-scan.json"
echo "   - single-stage-summary.txt"
echo "   - multi-stage-summary.txt"
echo "   - comparison.txt"