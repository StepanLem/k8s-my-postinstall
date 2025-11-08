
Добавь в `envs/dev2/apps/monitoring/prometheus-stack/values-of-prometheus-stack.yaml`:

```yaml
grafana:
  additionalDataSources:
    - name: Loki
      type: loki
      access: proxy
      url: http://loki-dev-gateway.monitoring.svc.cluster.local:80
      isDefault: false
      jsonData:
        maxLines: 1000
```