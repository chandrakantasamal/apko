# Create namespace
kubectl apply -f namespace.yaml

# Deploy all 4 apps
kubectl apply -f deployment-v1-single.yaml
kubectl apply -f deployment-v1-multi.yaml
kubectl apply -f deployment-v2-single.yaml
kubectl apply -f deployment-v2-multi.yaml