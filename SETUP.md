# Setup

## OpenShift Platform

* Install the OpenShift Pipeline operator
* Install the OpenShift Virtualization operator
* Install the Red Hat OpenShift GitOps operator
* Install the Red Hat OpenShift Serverless operator
* Create a KnativeServing CR in the knative-serving namespace
* Deploy Let's Encrypt public certificates on your router
* Create an HyperConverged CR in the openshift-cnv namespace
* Create/update the StorageProfile

```yaml
apiVersion: cdi.kubevirt.io/v1beta1
kind: StorageProfile
metadata: 
  name: managed-nfs-storage
spec:
  claimPropertySets: 
  - accessModes:
    - ReadWriteOnce
    - ReadWriteMany
    - ReadOnlyMany
    volumeMode: Filesystem
  cloneStrategy: copy
  storageClass: managed-nfs-storage
```

* Fix ArgoCD configuration

```sh
oc patch argocd openshift-gitops -n openshift-gitops -p '{"spec":{"server":{"insecure":true,"route":{"enabled": true,"tls":{"termination":"edge","insecureEdgeTerminationPolicy":"Redirect"}}}}}' --type=merge
```

## GitHub

* Create a personal access token with access to all your public repos
* Store the personal access token in a secret

```sh
m4 -D__GITHUB_TOKEN__=REDACTED secret.yaml | oc apply -f - -n demo-appdev
```

* Get the route hostname of your Tekton Listener

```sh
oc get route -n demo-appdev el-demo-appdev -o jsonpath='https://{.spec.host}'
```

* Add a webhook to your GitHub repo

  * Payload URL: *url above*
  * Content-Type: Application/json
  * Secret: `secret`

* Get the route hostname of your OpenShift Gitops installation

```sh
oc get route -n openshift-gitops openshift-gitops-server -o jsonpath='https://{.spec.host}'
```

* Add a webhook to your GitHub repo

  * Payload URL: *url above*
  * Content-Type: Application/json

## Demo

* Create a new project

```sh
oc new-project demo-appdev
oc label namespace demo-appdev argocd.argoproj.io/managed-by=openshift-gitops
```

