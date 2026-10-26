cd /tmp/hello-melange-apko/go

# Original Single-Stage
docker build -t localhost:5001/hello-melange-apko-go:v1-single -f Dockerfile.single .

# Original Multi-Stage
docker build -t localhost:5001/hello-melange-apko-go:v1-multi -f Dockerfile.multi .

# Patched Single-Stage (upgraded base image)
docker build -t localhost:5001/hello-melange-apko-go:v2-single-patched -f Dockerfile.single.patched .

# Patched Multi-Stage (upgraded base image)
docker build -t localhost:5001/hello-melange-apko-go:v2-multi-patched -f Dockerfile.multi.patched .