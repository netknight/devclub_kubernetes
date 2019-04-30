# devclub_kubernetes
Demo deployment

kubectl create namespace vote
kubectl create -f app-specs/
kubectl port-forward -n vote svc/vote 9001:5000
kubectl port-forward -n vote svc/result 9002:5001
kubectl -n vote scale deployment/vote --replicas 3
kubectl -n vote get deployments