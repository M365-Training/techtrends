## Helm Chart 

Place the Helm Chart files in this directory.

### Differences between environments

| Parameter                     | sandbox              | staging              | prod                 | same  |
| ----------------------------- | -------------------- | -------------------- | -------------------- | ----- |
| **namespace**                 | `sandbox`            | `staging`            | `prod`               | false |
| **service.port**              | `4111`               | `5111`               | `7111`               | false |
| **service.targetPort**        | `3111`               | `3111`               | `3111`               | true  |
| **service.protocol**          | `TCP`                | `TCP`                | `TCP`                | true  |
| **service.type**              | `ClusterIP`          | `ClusterIP`          | `ClusterIP`          | true  |
| **image.repository**          | `m365svc/techtrends` | `m365svc/techtrends` | `m365svc/techtrends` | true  |
| **image.tag**                 | `latest`             | `latest`             | `latest`             | true  |
| **image.pullPolicy**          | `IfNotPresent`       | `IfNotPresent`       | `Always`             | false |
| **replicaCount**              | `1`                  | `3`                  | `5`                  | false |
| **resources.requests.memory** | `64Mi`               | `90Mi`               | `128Mi`              | false |
| **resources.requests.cpu**    | `250m`               | `300m`               | `350m`               | false |
| **resources.limits.memory**   | `128Mi`              | `128Mi`              | `256Mi`              | false |
| **resources.limits.cpu**      | `500m`               | `500m`               | `500m`               | true  |
| **containerPort**             | `3111`               | `3111`               | `3111`               | true  |
| **livenessProbe.path**        | `/healthz`           | `/healthz`           | `/healthz`           | true  |
| **livenessProbe.port**        | `3111`               | `3111`               | `3111`               | true  |
| **readinessProbe.path**       | `/healthz`           | `/healthz`           | `/healthz`           | true  |
| **readinessProbe.port**       | `3111`               | `3111`               | `3111`               | true  |


### How to install with Helm

You need to be in the `helm` folder to run the following commands.

| Action                    | Command                                                    |
| ------------------------- | ---------------------------------------------------------- |
| Install default values    | `helm install techtrends-sandbox .`                        |
| Install staging values    | `helm install techtrends-staging . -f values-staging.yaml` |
| Install production values | `helm install techtrends-prod . -f values-prod.yaml`       |
| Upgrade existing release  | `helm upgrade techtrends . -f values-prod.yaml`            |
| Uninstall                 | `helm uninstall techtrends-sandbox`                        |

> **Note:** Usually, namespaces should not be created by Helm charts. Instead, create the namespace during installation using the Helm command with `--namespace <name> --create-namespace`. This avoids issues with resource management and best practices.

For example:

```bash
helm install techtrends . --namespace sandbox --create-namespace
helm install techtrends . -f values-staging.yaml --namespace staging --create-namespace
helm install techtrends . -f values-prod.yaml --namespace prod --create-namespace
```

### Results after installation

Results of installing `techtrends` for all environments

```bash
helm install techtrends-sandbox .
# NAME: techtrends-sandbox
# LAST DEPLOYED: Sat Nov 22 09:09:00 2025
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None

helm install techtrends-staging . -f values-staging.yaml
# NAME: techtrends-staging
# LAST DEPLOYED: Sat Nov 22 09:09:22 2025
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None

helm install techtrends-prod . -f values-prod.yaml
# NAME: techtrends-prod
# LAST DEPLOYED: Sat Nov 22 09:09:37 2025
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# TEST SUITE: None
```

The resulting resources for the deployed namespaces

```bash
kubectl get all -n sandbox
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/techtrends-7d97465bb6-tnzl4   1/1     Running   0          7m14s

# NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
# service/techtrends   ClusterIP   10.43.156.194   <none>        4111/TCP   7m14s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/techtrends   1/1     1            1           7m14s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/techtrends-7d97465bb6   1         1         1       7m14s

kubectl get all -n staging
# NAME                             READY   STATUS    RESTARTS   AGE
# pod/techtrends-86947c4ff-2d72p   1/1     Running   0          7m6s
# pod/techtrends-86947c4ff-6sn6s   1/1     Running   0          7m6s
# pod/techtrends-86947c4ff-bdl24   1/1     Running   0          7m6s

# NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
# service/techtrends   ClusterIP   10.43.41.125   <none>        5111/TCP   7m7s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/techtrends   3/3     3            3           7m6s

# NAME                                   DESIRED   CURRENT   READY   AGE
# replicaset.apps/techtrends-86947c4ff   3         3         3       7m6s

kubectl get all -n prod
# NAME                              READY   STATUS    RESTARTS   AGE
# pod/techtrends-858d4dbbbf-2w6c4   1/1     Running   0          3m25s
# pod/techtrends-858d4dbbbf-bhvrg   1/1     Running   0          3m25s
# pod/techtrends-858d4dbbbf-ccmqc   1/1     Running   0          3m25s
# pod/techtrends-858d4dbbbf-dtptk   1/1     Running   0          3m25s
# pod/techtrends-858d4dbbbf-xklkv   1/1     Running   0          3m25s

# NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE
# service/techtrends   ClusterIP   10.43.16.185   <none>        7111/TCP   3m25s

# NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
# deployment.apps/techtrends   5/5     5            5           3m25s

# NAME                                    DESIRED   CURRENT   READY   AGE
# replicaset.apps/techtrends-858d4dbbbf   5         5         5       3m25s
```

### Testing a Helm deployment

As usual a kubernetes deployment can be tested easily with a port forwarding.

```bash
kubectl port-forward -n prod svc/techtrends 8080:7111
```