# Kubernetes Post-Install Setup

Модульный Ansible проект для настройки Kubernetes кластера после установки через kubespray.

## Что устанавливается

- **nginx-ingress** - контроллер входящего трафика
- **Helm** - менеджер пакетов для Kubernetes
- **cert-manager** - автоматическое управление TLS сертификатами
- **ArgoCD** - GitOps инструмент для непрерывного развертывания

## Структура проекта

```
├── main.yml                           # Главный playbook (вызывает все остальные)
├── 00-nginx-ingress/
│   ├── 00-install-ingress-nginx.yml  # Установка nginx-ingress
│   └── ingress-nginx-controller-values.yaml
├── 01-cert-manager/
│   ├── 01-install-cert-manager.yml   # Установка cert-manager
│   ├── cert-manager-values.yaml      # Настройки cert-manager
│   └── letsencrypt-prod-issuer.yaml  # ClusterIssuer для Let's Encrypt
├── 02-argocd/
│   ├── 02-install-argocd.yml         # Установка ArgoCD
│   ├── argocd-values.yaml           # Настройки ArgoCD
│   └── argocd-ingress.yaml          # Ingress для ArgoCD
├── hosts.yaml                        # Инвентарь и переменные
├── requirements.txt                  # Python зависимости
└── README.md                        # Документация
```

## Требования

- Ansible >= 8.0.0
- kubectl настроен и подключен к кластеру
- Helm установлен локально (для работы с Helm charts)

## Установка зависимостей

```bash
# Установка Ansible
pip install -r requirements.txt

# Установка Helm (если еще не установлен)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

## Запуск

### Полная установка всех компонентов
```bash
ansible-playbook -i hosts.yaml main.yml
```

### Установка отдельных компонентов
```bash
# Только nginx-ingress
ansible-playbook -i hosts.yaml 00-nginx-ingress/00-install-ingress-nginx.yml

# Только cert-manager
ansible-playbook -i hosts.yaml 01-cert-manager/01-install-cert-manager.yml

# Только ArgoCD
ansible-playbook -i hosts.yaml 02-argocd/02-install-argocd.yml
```

## Доступ к ArgoCD

После установки ArgoCD будет доступен через Ingress:
- HTTPS: `https://argocd.example.com`
- Пользователь: `admin`
- Пароль будет выведен в конце выполнения playbook

**Важно:** Обновите DNS запись для `argocd.example.com` на IP адрес вашего кластера.

## Порядок установки

1. **nginx-ingress** - контроллер входящего трафика
2. **cert-manager** - управление TLS сертификатами  
3. **ArgoCD** - GitOps с автоматическим TLS

## Настройка

### Основные настройки
Все настройки находятся в файле `hosts.yaml` в секции `vars`:
- `kubernetes_version` - версия Kubernetes
- `helm_version` - версия Helm
- `argocd_version` - версия ArgoCD

### Настройки компонентов
Конфигурация компонентов находится в отдельных файлах:

**`argocd-values.yaml`** - настройки ArgoCD:
- Порты для доступа (NodePort)
- Настройки безопасности
- Конфигурация OIDC (если нужна)
- Настройки мониторинга

**`cert-manager-values.yaml`** - настройки cert-manager:
- Ресурсы и реплики
- Настройки безопасности
- Конфигурация мониторинга
- Параметры CRDs

## Преимущества модульной структуры

✅ **Гибкость** - можно устанавливать компоненты по отдельности  
✅ **Переиспользование** - каждый playbook можно использовать независимо  
✅ **Отладка** - легко найти и исправить проблемы в конкретном компоненте  
✅ **Версионирование** - можно обновлять компоненты независимо  
✅ **Тестирование** - можно тестировать каждый компонент отдельно
