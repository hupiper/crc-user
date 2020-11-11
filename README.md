# CRC USER

This is a script and some commands to set up the htpasswd identity provider when using CRC (CodeReady Containers).
It will work with any OpenShift cluster.

I took what had been done in this [blog post](https://developers.redhat.com/blog/2020/07/03/automate-workshop-setup-with-ansible-playbooks-and-codeready-workspaces/). The script wasn't working for me, and the htpasswd module in ansible has been removed for a community version, so I'm doing it manually. It's quick and doesn't really need to be automated.
***
Run the `usersetup.sh` script. I assume that you are logged into your cluster as admin and have access to the oc command line tool. The script creates the user-secret secret, which contains your user entries. I use the username as the password for each entry. Change this for your needs.

Edit the oauth file to use the secret with the htpasswd identity provider.  

The command to edit that file is:

`oc -n openshift-config edit oauth cluster`

It should end up looking like this (look for fileData.name for htpasswd). **The only thing I changed was the name of the secret to match the secret I created**:

```bash
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"config.openshift.io/v1","kind":"OAuth","metadata":{"annotations":{},"name":"cluster"},"spec":{"identityProviders":[{"htpasswd":{"fileData":{"name":"htpass-secret"}},>
    release.openshift.io/create-only: "true"
  creationTimestamp: "2020-10-26T04:09:08Z"
  generation: 3
  name: cluster
  resourceVersion: "265573"
  selfLink: /apis/config.openshift.io/v1/oauths/cluster
  uid: 76c4c382-c099-43b1-963d-41630096ea43
spec:
  identityProviders:
  - htpasswd:
      fileData:
        name: user-secret
    mappingMethod: claim
    name: htpasswd_provider
    type: HTPasswd

```

Give the oauth operator a minute to update, then run:

`oc adm policy add-cluster-role-to-user cluster-admin admin`

to give your administrator cluster-admin privileges.

You should receive this message if successful:
`clusterrole.rbac.authorization.k8s.io/cluster-admin added: "admin"`

If you receive a message saying the admin user is not found, wait 10-20 seconds and try it again.
