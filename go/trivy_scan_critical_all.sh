# Original Single-Stage
trivy image --format json --output go-single-original-scan.json localhost:5001/hello-melange-apko-go:v1-single
trivy image --format json --severity HIGH,CRITICAL --output go-single-original-high-critical-scan.json localhost:5001/hello-melange-apko-go:v1-single

# Original Multi-Stage
trivy image --format json --output go-multi-original-scan.json localhost:5001/hello-melange-apko-go:v1-multi
trivy image --format json --severity HIGH,CRITICAL --output go-multi-original-high-critical-scan.json localhost:5001/hello-melange-apko-go:v1-multi

# Patched Single-Stage
trivy image --format json --output go-single-patched-scan.json localhost:5001/hello-melange-apko-go:v2-single-patched
trivy image --format json --severity HIGH,CRITICAL --output go-single-patched-high-critical-scan.json localhost:5001/hello-melange-apko-go:v2-single-patched
# Patched Multi-Stage
trivy image --format json --output go-multi-patched-scan.json localhost:5001/hello-melange-apko-go:v2-multi-patched
trivy image --format json --severity HIGH,CRITICAL --output go-multi-patched-high-critical-scan.json localhost:5001/hello-melange-apko-go:v2-multi-patched