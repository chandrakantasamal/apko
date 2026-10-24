# Original Single-Stage
syft localhost:5001/hello-melange-apko-go:v1-single -o spdx-json --file go-sbom-v1-single.json

# Original Multi-Stage
syft localhost:5001/hello-melange-apko-go:v1-multi -o spdx-json --file go-sbom-v1-multi.json

# Patched Single-Stage
syft localhost:5001/hello-melange-apko-go:v2-single-patched -o spdx-json --file go-sbom-v2-single-patched.json

# Patched Multi-Stage
syft localhost:5001/hello-melange-apko-go:v2-multi-patched -o spdx-json --file go-sbom-v2-multi-patched.json