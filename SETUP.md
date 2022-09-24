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

## GitHub

* Create a personal access token with access to all your public repos
* Store the personal access token in a secret

```sh
m4 -D__GITHUB_TOKEN__=REDACTED secret.yaml | oc apply -f - -n demo-appdev
```

* Get the route hostname of your Tekton Listener

```sh
oc get route -n demo-appdev el-demo-appdev -o jsonpath='{.spec.host}'
```

* Add a webhook to your GitHub repo

  * Payload URL: `https://<route hostname>`
  * Content-Type: Application/json
  * Secret: `secret`

## Demo

* Create a new project

```sh
oc new-project demo-appdev
oc label namespace demo-appdev argocd.argoproj.io/managed-by=openshift-gitops
```

