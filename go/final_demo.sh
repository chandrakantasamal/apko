#!/bin/bash
set -e

echo "🔍 === SECURE SUPPLY CHAIN DEMO === "
echo "Registry: localhost:5001/hello-melange-apko"
echo ""

# 1. List all artifacts
echo "📦 1. All Artifacts in Registry:"
curl -s http://localhost:5001/v2/hello-melange-apko/tags/list | jq '.tags'

# 2. Verify an image signature
echo -e "\n🔐 2. Verify Image Signature (Tamper-Proofing):"
COSIGN_EXPERIMENTAL=1 cosign verify \
  --key cosign.pub \
  --allow-insecure-registry \
  localhost:5001/hello-melange-apko:v2-single-patched | grep -E "PASSED|FAILED"

# 3. Pull and inspect SBOM
echo -e "\n📋 3. SBOM for Patched Image (Transparency):"
oras pull localhost:5001/hello-melange-apko:sbom-v2-single-patched --insecure -o /tmp/sbom.json
echo "Total Packages: $(jq '.packages | length' /tmp/sbom.json)"
echo "Python Packages: $(jq -r '.packages[] | select(.type == "python") | .name' /tmp/sbom.json | tr '\n' ', ')"

# 4. Scan for CVEs
echo -e "\n🛡️ 4. CVE Scan (Safety):"
trivy image --severity HIGH,CRITICAL \
  --format json \
  localhost:5001/hello-melange-apko:v2-single-patched | \
  jq '[.Results[0].Vulnerabilities[] | select(.Severity | test("HIGH|CRITICAL"))] | length'

# 5. Compare original vs. patched
echo -e "\n📊 5. CVE Reduction (Improvement):"
ORIGINAL_CVES=$(trivy image --format json localhost:5001/hello-melange-apko:v1-single | jq '.Results[0].Vulnerabilities | length')
PATCHED_CVES=$(trivy image --format json localhost:5001/hello-melange-apko:v2-single-patched | jq '.Results[0].Vulnerabilities | length')
REDUCTION=$((ORIGINAL_CVES - PATCHED_CVES))
echo "Original CVEs: $ORIGINAL_CVES"
echo "Patched CVEs: $PATCHED_CVES"
echo "Reduction: $REDUCTION ($((REDUCTION * 100 / ORIGINAL_CVES))%)"

echo -e "\n✅ Demo Complete! All artifacts are verifiable."