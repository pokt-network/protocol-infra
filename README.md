# Protocol infrastructure <!-- omit in toc -->

- [Private PNI infrastructure](#private-pni-infrastructure)
- [DevNets](#devnets)
  - [Overview](#overview)
  - [How to provision and remove networks](#how-to-provision-and-remove-networks)
    - [Ephemeral DevNets](#ephemeral-devnets)
    - [Long-lived DevNets](#long-lived-devnets)
  - [Developer Dashboard](#developer-dashboard)
  - [Scaling](#scaling)
  - [Configuration parameters](#configuration-parameters)
  - [How to run a pocket version from the developer's branch](#how-to-run-a-pocket-version-from-the-developers-branch)
  - [How to interact with DevNet on Kubernetes](#how-to-interact-with-devnet-on-kubernetes)
    - [Run debug client](#run-debug-client)
    - [Shell into the validator pod](#shell-into-the-validator-pod)
  - [Observability](#observability)
    - [How to query logs](#how-to-query-logs)
- [Directory structure](#directory-structure)


## Private PNI infrastructure

Although the Protocol team develops software in public and all code is open-source, we still utilize private infrastructure that belongs to PNI.

Core team members should refer to the internal documentation on how to gain access and related information [in Notion](https://www.notion.so/pocketnetwork/V1-networks-7d95c10c930c45c3823c871f21d44fca?pvs=4).

## DevNets

Developer Networks are v1 networks that can be deployed remotely and can be ephemeral. For example, if you need to test some sort of change on a large fleet of nodes and your LocalNet resources are not enough for that kind of load, a DevNet is a good use case!

### Overview

Each DevNet is provisioned in its own Kubernetes namespace (`devnet-${networkName}`). If you need to interact with resources for a particular devnet, you need to switch to this network's Kubernetes namespace. For example, in the case of a DevNet with the name `first`, the namespace would be `devnet-first`:

```bash
kubectl config set-context --current --namespace=devnet-first
```

Verify the correct network is selected by checking what pods are running in that namespace. It should contain validators and some other pods necessary for a working DevNet:

```bash
kubectl get pod
```

Replace `devnet-first` with the network name you want to interact with.

### How to provision and remove networks

#### Ephemeral DevNets

We provision DevNets automatically for Pull Requests in [pocket](https://github.com/pokt-network/pocket) repo. Simply attach `devnet-e2e-test` label to the PR and it will be deployed automatically.

#### Long-lived DevNets

If you need to create a new network that has to exist longer than just to test one PR, duplicate [_TEMPLATE_YAML_](devnets-configs/_TEMPLATE_YAML_) in the `devnets-configs` directory and modify its values. Once the file is available in the `main` branch, it will take a few minutes for deployment to complete.

When the network is no longer needed, just remove the file and resources will be cleaned up eventually.

### Developer Dashboard

We deploy a dashboard to each DevNet, which shows what actors are staked on the network, latest height, etc. It also allows executing commands against the network, and scale different actors up and down.

The dashboard can be found on:

```
https://devnet-$(DEVNET_NAME)-dashboard.dev-us-east4-1.poktnodes.network:8443/
```

### Scaling

The [dashboard](#developer-dashboard) allows scaling up and down different actors.

<img width="1422" alt="image" src="https://github.com/pokt-network/pocket/assets/4950477/62b6c89f-7bbd-4539-ad0e-8aa3000cbfd3">

### Configuration parameters

Configuration files for each DevNet can be found in the `devnet-configs` directory.

### How to run a pocket version from the developer's branch

On DevNets, you might want to run a version of blockchain actors that have not been released yet. For that, you can resort to this guide https://github.com/pokt-network/pocket/blob/okdas/devnet-tweaks/docs/development/README.md#creating-a-container-image-from-developers-branches to create a container image from your branch. Once the CI on pocket side finished, update the DevNet configuration YAML file in the `devnet-configs` directory.

### How to interact with DevNet on Kubernetes

There are many different tools one can utilize to work with Kubernetes. They all allow switching contexts and namespaces, watching for logs, shelling into containers, restarting, etc.

- standard `kubectl` CLI
- [VSCode extension](https://marketplace.visualstudio.com/items?itemName=ms-kubernetes-tools.vscode-kubernetes-tools)
- [k9s](https://github.com/derailed/k9s) - terminal UI

The examples supplied with `kubectl` but any Kubernetes client will work similarly.

Once the validators are online, the developer can interact with a chain in a similar way to LocalNet.

> <picture>
>   <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mqxx/GitHub-Markdown/blob/main/blockquotes/badge/light-theme/warning.svg">
>   <img alt="Warning" src="https://github.com/Mqxx/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/warning.svg">
> </picture><br>
> Prior to executing any kubectl commands, make sure you're connected to VPN and you've switched to correct context. If unsure, please follow [internal documentation](https://www.notion.so/pocketnetwork/V1-networks-7d95c10c930c45c3823c871f21d44fca?pvs=4#7a3a56d47d174cb18037526acf2cc304).


#### Run debug client

```bash
kubectl exec --stdin --tty deployments/cli-client -- client debug
```

#### Shell into the validator pod

Name of the validator pod has the following template: `devnet-${networkName}-validator${validatorId}-0`, for example validator №003 in network with name `first` will have a pod name `devnet-first-validator003-0`. It is possible to shell into that container with following command:

```bash
kubectl exec --stdin --tty devnet-first-validator003-0 -- /bin/bash
```

Make sure the command is executed in the correct namespace.

### Observability

Important feature of DevNets is an ability to get insight of what is going on with the network - look at logs, metrics, network health, etc.

Information on how to access PNI private Grafana instance: https://www.notion.so/pocketnetwork/V1-networks-7d95c10c930c45c3823c871f21d44fca?pvs=4#468618dfd8304336ab5a58f4f264091e

#### How to query logs

In the Explore tab, you can query logs provided by Loki - [example](https://pokt.grafana.net/explore?orgId=1&left=%7B%22datasource%22%3A%22i9csiD4Vz%22%2C%22queries%22%3A%5B%7B%22refId%22%3A%22A%22%2C%22expr%22%3A%22%7Bnamespace%3D%5C%22devnet-first%5C%22%2C+purpose%3D%5C%22validator%5C%22%7D+%7C%3D+%60%60%22%2C%22queryType%22%3A%22range%22%2C%22datasource%22%3A%7B%22type%22%3A%22loki%22%2C%22uid%22%3A%22i9csiD4Vz%22%7D%2C%22editorMode%22%3A%22builder%22%7D%5D%2C%22range%22%3A%7B%22from%22%3A%22now-6h%22%2C%22to%22%3A%22now%22%7D%7D).

We supply additional labels to make it easier to drill down to a particular actor on the network. For example, the following query will return validator logs for `devnet-first` network.
```logql
{namespace="devnet-first", purpose="validator"} |= ``
```

## Directory structure

```bash
charts # Helm charts that create/render the manifests necessary to provision and configure networks.
└── v1-network-base # Most, if not all of this should be moved to pocket-operator.
    ├── Chart.yaml
    ├── templates
    │   ├── DebugClient.yaml
    │   ├── PocketSet.yaml
   ... ...
    │   ├── _helpers.tpl
    │   └── pregeneratedKeys.yaml
    └── values.yaml
clusters # Manifests applied directly on clusters
└── gcp-dev-us-east4-1 # The development cluster
    ├── postgres-operator.yaml # Postgres-operator deployment
    ├── v1-devnets.yaml # ArgoCD ApplicationSet that produces Applications for each file in `devnet-configs` directory
    └── v1-pocket-operator.yaml # Pocket-operator deployment
devnets-configs # A list of v1 DevNets and their configurations.
├── e2e-onboard.yaml
└── first.yaml
tmp-grafana-dashboards # temporary place to store Grafana dashboard json definitions to not lose progress during observability infrastructure migrations
```
