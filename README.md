hashbash-infrastructure
=======================

This codebase houses the terraform/kubernetes configs for deploying the hashbash application.
In order to use this codebase, you will need the following installed:

* [docker](https://www.docker.com)
* [helm](https://github.com/helm/helm)
* [helm-diff](https://github.com/databus23/helm-diff)
* [helm-secrets](https://github.com/futuresimple/helm-secrets)
* [helmfile](https://github.com/roboll/helmfile)
* [kubectl](https://kubernetes.io)
* [sops](https://github.com/mozilla/sops)
* [terraform](https://www.terraform.io)
* [terragrunt](https://github.com/gruntwork-io/terragrunt)

This codebase has the configuration necessary to deploy to one of two kubernetes clusters

* local - The cluster run on your local machine by enabling docker-for-mac's kubernetes integration
* production - The real deployment cluster, which for me is the EKS cluster created by the terraform here

The sops-encrypted secrets here are necessary for standing up either cluster, however, they're encrypted
with my PGP private key and I am **not** giving that to you. You're going to need to create your own and
reencrypt each of the secrets.yaml files with new secrets.

## Deploy to local kubernetes
If you've enabled your [local kubernetes instance](https://docs.docker.com/docker-for-mac/kubernetes/), you
should have a running kubernetes cluster as well as the kubeconfig file necessary to connect to its apiserver.

From there, if you can successfully decrypt the secrets.yaml files in the codebase (you've replaced mine right?),
you should be able to run:
```

```
