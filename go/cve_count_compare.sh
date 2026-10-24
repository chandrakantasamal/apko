echo "Original Single-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-single-original-scan.json)"
echo "Original Multi-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-multi-original-scan.json)"
echo "Patched Single-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-single-patched-scan.json)"
echo "Patched Multi-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-multi-patched-scan.json)"