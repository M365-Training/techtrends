## ArgoCD Manifests 

Place the ArgoCD manifests in this directory.

### Install ArgoCD

Instructions can be found [here](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd).

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### Add `NodePort`-Service

Add a `NodePort`-service based on argocd-server so that it can be accessed on the host system via `localhost`.

File `argocd-server-nodeport.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app.kubernetes.io/component: server
    app.kubernetes.io/name: argocd-server
    app.kubernetes.io/part-of: argocd
  name: argocd-server-nodeport
  namespace: argocd
spec:
  ports:
  - name: http
    port: 80
    protocol: TCP
    targetPort: 8080
    nodePort: 30007
  - name: https
    port: 443
    protocol: TCP
    targetPort: 8080
    nodePort: 30008
  selector:
    app.kubernetes.io/name: argocd-server
  sessionAffinity: None
  type: NodePort
```

Apply the file so that the change becomes effecive and execute a test

```bash
# Apply NodePort-service
kubectl apply -f argocd-server-nodeport.yaml

# Check service
kubectl get svc -n argocd argocd-server-nodeport
# NAME                     TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
# argocd-server-nodeport   NodePort   10.43.24.166   <none>        80:30007/TCP,443:30008/TCP   16m

# Check if curl results in the `html`-output
curl --insecure https://localhost:30008
```

### Install ArgoCD CLI
As preparation for the next step the ArgoCD CLI can be installed to make thigs easier. I have chosen Homebrew on my Linux system as proposed in the [official documentation](https://argo-cd.readthedocs.io/en/stable/cli_installation/?utm_source=chatgpt.com):

```bash
brew install argocd
```

### Configure Initial Password

Instruction have been taken from [Login Using The CLI](https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)

```bash
argocd admin initial-password -n argocd
# R1qVSf2oPt4p3Bk3
# This password must be only used for first time login.
# We strongly recommend you update the password using `argocd account update-password`
```

Instead of using the ArgoCD CLI the initial password can also retrieved from the command taken from the project description

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Now you are able to login with the `admin`-user and the password.

The IP-address in the screenshot `argocd-ui.png` differs from the project description because the project has been developed with Rancher Desktop with it's own cluster without Vagrant
- Vagrant IP from project description: `192.168.50.4`
- IP the Rancher Desktop host: `192.168.178.150`

### Deploy TechTrends with ArgoCD

To deploy TechTrends to staging and production environments using ArgoCD, apply the respective application manifests:

```bash
kubectl apply -f helm-techtrends-staging.yaml
# application.argoproj.io/techtrends-staging created

kubectl apply -f helm-techtrends-prod.yaml
#

# In case that an applcation needs to be deleted again
kubectl delete application techtrends-staging -n argocd
kubectl delete application techtrends-prod -n argocd
```

This will create ArgoCD Application resources for both environments. Make sure you are in the `argocd` folder when running these commands.
