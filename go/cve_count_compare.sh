echo "Original Single-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-single-original-scan.json)"
echo "Original Multi-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-multi-original-scan.json)"
echo "Patched Single-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-single-patched-scan.json)"
echo "Patched Multi-Stage CVEs: $(jq '.Results[0].Vulnerabilities | length' go-multi-patched-scan.json)"

echo "Original Single-Stage High/Critical CVEs: $(jq '.Results[0].Vulnerabilities | length' go-single-original-high-critical-scan.json)"
echo "Original Multi-Stage High/Critical CVEs: $(jq '.Results[0].Vulnerabilities | length' go-multi-original-high-critical-scan.json)"
echo "Patched Single-Stage High/Critical CVEs: $(jq '.Results[0].Vulnerabilities | length' go-single-patched-high-critical-scan.json)"  
echo "Patched Multi-Stage High/Critical CVEs: $(jq '.Results[0].Vulnerabilities | length' go-multi-patched-high-critical-scan.json)"
    