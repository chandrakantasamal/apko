# Port-forward and test each service
kubectl port-forward -n hello-melange-go svc/app-v1-single 8080:8080 &
curl -s http://localhost:8080
# Expected: "Hello World!"

kubectl port-forward -n hello-melange-go svc/app-v1-multi 8081:8080 &
curl -s http://localhost:8081
# Expected: "Hello World!"

kubectl port-forward -n hello-melange-go svc/app-v2-single 8082:8080 &
curl -s http://localhost:8082
# Expected: "Hello World!"

kubectl port-forward -n hello-melange-go svc/app-v2-multi 8083:8080 &
curl -s http://localhost:8083
# Expected: "Hello World!"