# Push all SBOMs
oras push localhost:5001/hello-melange-apko-go:sbom-v1-single go-sbom-v1-single.json --insecure
oras push localhost:5001/hello-melange-apko-go:sbom-v1-multi go-sbom-v1-multi.json --insecure
oras push localhost:5001/hello-melange-apko-go:sbom-v2-single-patched go-sbom-v2-single-patched.json --insecure
oras push localhost:5001/hello-melange-apko-go:sbom-v2-multi-patched go-sbom-v2-multi-patched.json --insecure