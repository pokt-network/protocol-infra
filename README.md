# Protocol infrastructure <!-- omit in toc -->

- [Private PNI infrastructure](#private-pni-infrastructure)
- [DevNets](#devnets)
  - [Overview](#overview)
  - [Scaling/configuration parameters](#scalingconfiguration-parameters)
- [Directory structure](#directory-structure)


## Private PNI infrastructure

Though Protocol team develops software in public and all code is Open Source, we still utilize private infrastructure that belongs to PNI.

Core team members should refer to the internal documentation on how to gain access and related information [in Notion](https://www.notion.so/pocketnetwork/V1-networks-7d95c10c930c45c3823c871f21d44fca?pvs=4).

## DevNets

Developer Networks are v1 networks that can be deployed remotely and can be ephemeral. For example, if you need to test some sort of change on a large fleet of nodes and your LocalNet resources are not enough for that kind of load - DevNet is a good use case!

### Overview

Each DevNet is provisioned in its own Kubernetes namespace (`devnet-${networkName}`).

### Scaling/configuration parameters

Configuration files for each DevNet can be found in `devnet-configs` directory.

## Directory structure

```bash
├── README.md # This file
├── charts # helm charts that create/render the manifests necessary to provision and configure networks. Most, if not all of this should be moved to pocket-operator.
│   └── v1-network-base
│       ├── Chart.yaml
│       ├── templates
│       │   ├── PocketSet.yaml
│       │   ├── PocketValidators.yaml
│       │   ├── PostgresCluster.yaml
│       │   ├── ServiceMonitors.yaml
│       │   └── pregeneratedKeys.yaml
│       └── values.yaml
└── devnets-configs # a list of v1 devnets and their configurations.
    ├── first.yaml # devnet with a name "first"
    └── broken.yaml # devnet with a name "broken"
```
