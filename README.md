# RISKEN kubernetes sample

This is kubernetes manifest sample for RISKEN system.

## RISKEN

`RISKEN` is the monitoring tool for your cloud, web-site, source-code...

For more information, please check [RISKEN Documentation](https://docs.security-hub.jp/).

## Architecture

The detailed flow can be found [here](https://docs.security-hub.jp/admin/infra_architecture/)

![Architecture](https://user-images.githubusercontent.com/25426601/139044505-308e49ed-9fc5-4656-bd4e-59db7f65b61f.png "Architecture")

## Run

### Required

- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

### On Docker Descktop (MAC)

The detailed flow can be found [here](https://docs.security-hub.jp/admin/infra_local/)

1. Run kubernetes cluster with `docker-desktop`
2. Deploy RISKEN application
```shell
$ make local-apply
```

### On EKS

The detailed flow can be found [here](https://docs.security-hub.jp/admin/infra_aws/)

1. Create EKS cluster & Node group
2. Create ALB & Set OIDC Authentication
3. Deploy RISKEN application
    - Logged in your cluster
    ```shell
    $ aws eks --region <region_code> update-kubeconfig --name <cluster_name>
    ```
    - Copy template manifest & fix your cluster name
    ```shell
    $ cp -r overlays/eks-template overlays/eks
    $ sed -i "" -e 's/your-cluster/<cluster_name>/g' overlays/eks/*.yaml
    ```
    - Deploy 
    ```shell
    $ kustomize build overlays/eks | kubectl apply -f -
    ```

## Use Enabled Generative AI

You can enable the generative AI.

1. First, obtain the OpenAI API token.
2. Then, modify the specified location in the generate_confimap_properties.sh file.

```shell
## Core
OPEN_AI_TOKEN=sk-xxxx # Overwrite here
CHAT_GPT_MODEL=gpt-3.5-turbo # you can fix gpt model
```
