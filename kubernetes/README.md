## Kubernetes Declarative Manifests 

Place the Kubernetes declarative manifests in this directory.

To apply the manifests execute the following commands

```bash
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

To test the service in the browser you can create a port forwarding

```bash
kubectl port-forward -n sandbox svc/techtrends 8080:4111
``
