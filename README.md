# Protocol infrastructure <!-- omit in toc -->

- [How to provision and remove networks](#how-to-provision-and-remove-networks)
    - [Scaling/configuration parameters](#scalingconfiguration-parameters)
    - [How to interact with a chain](#how-to-interact-with-a-chain)
      - [Run debug client](#run-debug-client)
      - [Shell into the](#shell-into-the)
  - [Directory structure](#directory-structure)


## Private PNI infrastructure

Though Protocol team develops software in public and all code is Open Source, we still utilize private infrastructure that belongs to PNI.

Core team members should refer to the internal documentation on how to gain access and related information [in Notion](https://www.notion.so/pocketnetwork/V1-networks-7d95c10c930c45c3823c871f21d44fca?pvs=4).

## DevNets

Developer Networks are v1 networks that can be deployed remotely and can be ephemeral. For example, if you need to test some sort of change on a large fleet of nodes and your LocalNet resources are not enough for that kind of load - DevNet is a good use case!

### Overview

Each DevNet is provisioned in its own Kubernetes namespace (`devnet-${networkName}`). If you need to interact with resources for particular devnet, you need to switch to this network kubernetes namespace. For example in case of DevNet with name `first`, namespace would be `devnet-first`:

```
kubectl config set-context --current --namespace=devnet-first
```

Verify correct network is selected by checking what pods are running in that namespace. It should contain validators and some other pods necessary for working DevNet:

```
kubectl get pod
```

Replace `devnet-first` with a network name you want to interact with.

# How to provision and remove networks

If you need to create a new network, duplicate [_TEMPLATE_YAML_](devnets-configs/_TEMPLATE_YAML_) in `devnets-configs` directory and modify it's values. Once the file is available in `main` branch, it will take a few minutes for deployment to complete.

When the network is no longer needed, just remove the file and resources are going to be cleaned up eventually.

### Scaling/configuration parameters

Configuration files for each DevNet can be found in `devnet-configs` directory.

### How to interact with a chain

Once the validators are online, the developer can interact with a chain in a similar to LocalNet way.

> <picture>
>   <source media="(prefers-color-scheme: light)" srcset="https://github.com/Mqxx/GitHub-Markdown/blob/main/blockquotes/badge/light-theme/warning.svg">
>   <img alt="Warning" src="https://github.com/Mqxx/GitHub-Markdown/blob/main/blockquotes/badge/dark-theme/warning.svg">
> </picture><br>
> Prior to executing any kubectl commands, make sure you're connected to VPN and you've switched to correct context. If unsure, please follow [internal documentation](https://www.notion.so/pocketnetwork/V1-networks-7d95c10c930c45c3823c871f21d44fca?pvs=4#7a3a56d47d174cb18037526acf2cc304).


#### Run debug client

```
kubectl exec --stdin --tty deployments/cli-client -- client debug
```

#### Shell into the

## Directory structure

```bash
charts # Helm charts that create/render the manifests necessary to provision and configure networks.
└── v1-network-base # Most, if not all of this should be moved to pocket-operator.
    ├── Chart.yaml
    ├── templates
    │   ├── DebugClient.yaml
    │   ├── PocketSet.yaml
    │   ├── PocketValidators.yaml
    │   ├── PostgresCluster.yaml
    │   ├── ServiceMonitors.yaml
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
```
