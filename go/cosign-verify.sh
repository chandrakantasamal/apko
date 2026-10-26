# 1. Verify Original Single-Stage
COSIGN_EXPERIMENTAL=1 cosign verify \
  --key cosign.pub \
  --allow-insecure-registry \
  localhost:5001/hello-melange-apko-go:v1-single

# 2. Verify Original Multi-Stage
COSIGN_EXPERIMENTAL=1 cosign verify \
  --key cosign.pub \
  --allow-insecure-registry \
  localhost:5001/hello-melange-apko-go:v1-multi

# 3. Verify Patched Single-Stage
COSIGN_EXPERIMENTAL=1 cosign verify \
  --key cosign.pub \
  --allow-insecure-registry \
  localhost:5001/hello-melange-apko-go:v2-single-patched

# 4. Verify Patched Multi-Stage
COSIGN_EXPERIMENTAL=1 cosign verify \
  --key cosign.pub \
  --allow-insecure-registry \
  localhost:5001/hello-melange-apko-go:v2-multi-patched