# Infra Server Chart

A Helm chart for Infra server. This chart deploys only the server. To deploy Infra connector, use the [connectro](https://github.com/infrahq/helm-charts/charts/connector) chart.

Source code for this chart and application can be found on GitHub:

- https://github.com/infrahq/helm-charts/charts/server
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
helm upgrade --install infra-server infrahq/infra-server
```

## Upgrade

```bash
helm repo update
helm upgrade --install infra-server infrahq/infra-server
```

## Migrate from `infra` chart

Values for the `infra` chart are incompatible with values for this chart and must be updated before migrating.

* `connector` has been removed. Use the `infrahq/infra` chart instead
* `global.image` has been removed. Use `server.image`, `ui.image`, or `postgres.image` instead
* `server.config` has been renamed to `config`, e.g. `server.config.dbHost` is not `config.dbHost`
* `server.additionalUsers`, `server.additionalProviders`, `server.additionalGrants` has been removed
* `server.persistence` has been removed
* Default `server.service.type` value has been changed to `ClusterIP` instead of `LoadBalancer`

_Note: The label value for `app.kubernetes.io/name` has changed. Since this label is used as a selector, the field is immutable. In order to perform an in-place upgrade, the value must be set to match the previous value. This can be done by setting `nameOverride=infra`._

```bash
helm upgrade --install infra infrahq/infra-server -f values.yaml --set nameOverride=infra
```
