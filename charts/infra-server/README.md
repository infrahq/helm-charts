# Infra Server Chart

A Helm chart for Infra server. This chart deploys only the server and its dependencies. To deploy Infra connector, use the [`infra`](https://github.com/infrahq/helm-charts/charts/infra) chart.

Source code for this chart and application can be found on GitHub:

- https://github.com/infrahq/helm-charts/charts/infra-server
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
helm upgrade --atomic infra-server infrahq/infra-server
```

## Uninstall

```bash
helm uninstall infra-server
```

## Customize

This chart can be customized by configuring Helm values. See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing) for details.

For a complete list of customization options, see `helm show values infrahq/infra-server`.

### External database

Configure an external PostgreSQL database instead of using the one deployed with the chart. Setting these options will omit the included database from being deployed.

```yaml
# example values.yaml
---
config:
  dbHost: postgres.example.com
  dbPort: 5432
  dbName: mydatabase
  dbUsername: myusername
  dbPassword: env:POSTGRES_DB_PASSWORD

server:
  env:
    - name: POSTGRES_DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: mysecret
          key: mypassword
```

## Migrate from `infra` chart

_Note: Ensure to back up the database and database encryption key before migrating from the `infra` chart._

Values for the `infra` chart are incompatible with values for this chart and must be updated before migrating.

* `connector` has been removed. Use the `infrahq/infra` chart instead
* `global.image` has been removed. Use `server.image`, `ui.image`, or `postgres.image` instead
* `server.config` has been renamed to `config`, e.g. `server.config.dbHost` is not `config.dbHost`
* `server.additionalUsers`, `server.additionalProviders`, `server.additionalGrants`, `server.additionalSecrets` has been removed
* `server.persistence` has been removed
* Default `server.service.type` value has been changed to `ClusterIP` instead of `LoadBalancer`
* `server.users`, `server.providers`, `server.grants`, `server.secrets` has been removed. Users are encouraged to move configurations over to [Terraform Infra provider](https://registry.terraform.io/providers/infrahq/infra). **Any users, grants, or identity provider created by server configurations _will be removed_**
    * An initial admin user can be enabled (default) with `config.admin.enabled`. This creates a user `admin@local` with a randomly generated password which can be used to bootstrap a deployment. Setting `config.admin.enabled=false` disables this user.

_Note: The label value for `app.kubernetes.io/name` has changed. Since this label is used as a selector, the field is immutable. In order to perform an in-place upgrade, the value must be set to match the previous value. This can be done by setting `nameOverride=infra`._

```bash
helm upgrade --atomic infra infrahq/infra-server -f values.yaml --set nameOverride=infra
```
