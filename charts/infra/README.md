# Infra Chart

A Helm chart for Infra connector. This chart deploys only the connector. To deploy Infra server, use the [`infra-server`](https://github.com/infrahq/helm-charts/charts/infra-server) chart.

Source code for this chart and application can be found on GitHub:

- https://github.com/infrahq/helm-charts/tree/main/charts/infra
- https://github.com/infrahq/infra

## Prerequisites

- Kubernetes 1.14+
- Helm 3+

## Install

```bash
helm repo add infrahq https://infrahq.github.io/helm-charts
helm repo update
```

```bash
helm upgrade --install infra-connector infrahq/infra --set config.accessKey=xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
```

_See [Connecting a cluster](https://infrahq.com/docs/manage/connectors/kubernetes?group-default=Dashboard#connecting-a-cluster) for documentation on generating an access key._

## Upgrade

```bash
helm repo update
helm upgrade --atomic infra-connector infrahq/infra --set config.accessKey=xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
```

## Uninstall

```bash
helm uninstall infra-connector
```

## Customize

This chart can be customized by configuring Helm values. See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing) for details.

For a complete list of customization options, see `helm show values infrahq/infra`.

## Migrate from [infrahq/infra][1] chart

Values for the [infrahq/infra][1] chart are incompatible with values for this chart and must be updated before migrating.

- `connector` has been removed and child keys have been moved up one level, e.g. `connector.service` is now `service`, `connector.config` is now `config`, etc.
- `connector.config.accessKey` has been renamed to `config.accessKey`
- `config.accessKeySecret` has been added to simplify loading access keys from an existing Kubernetes secret
- `connector.config.server` has been renamed to `config.server.url` with a default value of `api.infrahq.com`

```yaml
# before: infra chart values.yaml
connector:
  image:
    tag: 0.16.0

  service:
    type: NodePort

  config:
    name: my-cluster
    accessKey: xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
    server: api.infrahq.com
```

```yaml
# after: connector chart values.yaml
image:
  tag: 0.16.0

service:
  type: NodePort

config:
  name: my-cluster
  accessKey: xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
```

_Note: The label value for `app.kubernetes.io/name` has changed. Since this label is used as a selector, the field is immutable. In order to perform an in-place upgrade, the value must be set to match the previous value. This can be done by setting `nameOverride=infra-connector`._

```bash
helm upgrade --atomic infra-connector infrahq/infra -f values.yaml --set nameOverride=infra-connector
```

[1]: https://github.com/infrahq/infra/tree/main/helm
