# Как подключить Loki к Grafana

## Текущая настройка Loki

- **Режим**: SingleBinary (проще для dev, не требует object storage)
- **Storage**: Filesystem с persistence (10Gi)
- **Auth**: Отключен (для простоты в dev)
- **Gateway**: Включен (нужен для доступа из Grafana)

## Подключение к Grafana

### Вариант 1: Автоматически через values (рекомендуется)

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

**Важно**: Проверь имя сервиса gateway командой:
```bash
kubectl get svc -n monitoring | grep loki
```

Используй правильное имя сервиса (обычно `loki-dev-gateway` или `loki-gateway`).

### Вариант 2: Вручную через UI Grafana

1. Открой Grafana: `http://grafana.dev2.veryred.ru` (или твой домен)
2. Логин: `admin`, пароль: `prom-operator` (или измени после первого входа)
3. Перейди: Configuration → Data Sources → Add data source
4. Выбери Loki
5. Укажи URL: `http://loki-dev-gateway.monitoring.svc.cluster.local:80`
6. Нажми "Save & Test"

## Проверка работы

После подключения в Grafana:

1. Перейди в Explore
2. Выбери datasource Loki
3. Выполни запрос: `{namespace="default"}`

Должны появиться логи из твоих приложений.

## Troubleshooting

### Loki недоступен

Проверь что Loki запущен:
```bash
kubectl get pods -n monitoring | grep loki
```

Проверь логи:
```bash
kubectl logs -n monitoring -l app.kubernetes.io/name=loki --tail=50
```

### Promtail не отправляет логи

Проверь что Promtail работает:
```bash
kubectl get pods -n monitoring | grep promtail
kubectl logs -n monitoring -l app.kubernetes.io/name=promtail --tail=50
```

### Service не найден

Проверь имя сервиса:
```bash
kubectl get svc -n monitoring | grep loki
```

Используй полное имя: `{service-name}.monitoring.svc.cluster.local`

