# Infra Connector Chart

A Helm chart for Infra connector. This chart deploys only the connector. To deploy Infra server, use the [server](https://github.com/infrahq/helm-charts/charts/server) chart.

Source code for this chart and application can be found on GitHub:

- https://github.com/infrahq/helm-charts/charts/connector
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
helm upgrade --install infra-connector infrahq/infra --set accessKey=xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
```

_See [Connecting a cluster](https://infrahq.com/docs/manage/connectors/kubernetes?group-default=Dashboard#connecting-a-cluster) for documentation on generating an access key._

## Upgrade

```bash
helm repo update
helm upgrade --install infra-connector infrahq/infra --set accessKey=xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
```

## Migrate from `infra` chart

Values for the `infra` chart are incompatible with values for this chart and must be updated before migrating.

* `connector` has been removed and child keys have been moved up one level, e.g. `connector.service` is now `service`, `connector.config` is now `config`, etc.
* `connector.config.accessKey` has been renamed to `accessKey`
* `connector.config.server` has been renamed to `config.server.url` with a default value of `api.infrahq.com`

```yaml
# before: infra chart values.yaml
connector:
  image:
    tag: 0.15.2

  service:
    type: NodePort

  config:
    name: my-cluster
    accessKey: xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy
    server: api.infrahq.com
```

```yaml
# after: connector chart values.yaml
accessKey: xxxxxxxxxx.yyyyyyyyyyyyyyyyyyyyyyyy

image:
  tag: 0.15.2

service:
  type: NodePort

config:
  name: my-cluster
```

_Note: The label value for `app.kubernetes.io/name` has changed. Since this label is used as a selector, the field is immutable. In order to perform an in-place upgrade, the value must be set to match the previous value. This can be done by setting `nameOverride=infra-connector`._

```bash
helm upgrade --install infra-connector infrahq/infra -f values.yaml --set nameOverride=infra-connector
```
