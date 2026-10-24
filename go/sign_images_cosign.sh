# Sign Original Single-Stage
COSIGN_EXPERIMENTAL=1 cosign sign --key cosign.key --allow-insecure-registry localhost:5001/hello-melange-apko-go:v1-single

# Sign Original Multi-Stage
COSIGN_EXPERIMENTAL=1 cosign sign --key cosign.key --allow-insecure-registry localhost:5001/hello-melange-apko-go:v1-multi

# Sign Patched Single-Stage
COSIGN_EXPERIMENTAL=1 cosign sign --key cosign.key --allow-insecure-registry localhost:5001/hello-melange-apko-go:v2-single-patched

# Sign Patched Multi-Stage
COSIGN_EXPERIMENTAL=1 cosign sign --key cosign.key --allow-insecure-registry localhost:5001/hello-melange-apko-go:v2-multi-patched