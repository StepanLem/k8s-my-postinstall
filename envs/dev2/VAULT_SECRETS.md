# Инструкция по созданию секретов в Vault для dev2 окружения

Все секреты должны быть созданы в Vault по пути `kv/veryred` (указан в ClusterSecretStore).

## Структура путей и ключей в Vault

### 1. PostgreSQL (`postgres/credentials`)

**Путь в Vault:** `kv/veryred/postgres/credentials`

**Ключи (properties):**
- `password` - пароль для пользователя PostgreSQL (используется и для admin, и для user)
- `username` - имя пользователя PostgreSQL (необязательно, т.к. в values указано "a")
- `database` - имя базы данных (необязательно, т.к. в values указано "a")

**External Secret:** `envs/dev2/apps/postgres/resources/postgres-external-secret.yaml`

**Использование:** Создаёт секрет `postgres-credentials` в namespace `postgres` с ключами:
- `postgres-password` → из Vault `password`
- `postgres-username` → из Vault `username`
- `postgres-database` → из Vault `database`

---

### 2. Keycloak (`keycloak/credentials`)

**Путь в Vault:** `kv/veryred/keycloak/credentials`

**Ключи (properties):**
- `admin-password` - пароль администратора Keycloak

**External Secret:** `envs/dev2/apps/keycloak/resources/keycloak-external-secret.yaml`

**Использование:** Создаёт секрет `keycloak-credentials` в namespace `keycloak` с ключом:
- `admin-password` → из Vault `admin-password`

---

### 3. RabbitMQ (`rabbitmq/credentials`)

**Путь в Vault:** `kv/veryred/rabbitmq/credentials`

**Ключи (properties):**
- `password` - пароль для пользователя RabbitMQ

**External Secret:** `envs/dev2/apps/rabbitmq/resources/rabbitmq-external-secret.yaml`

**Использование:** Создаёт секрет `rabbitmq-credentials` в namespace `rabbitmq` с ключом:
- `password` → из Vault `password`

---

### 4. GitLab Runner (`gitlab-runner/credentials`)

**Путь в Vault:** `kv/veryred/gitlab-runner/credentials`

**Ключи (properties):**
- `runner-registration-token` - токен регистрации runner'а из GitLab UI (может быть пустым)
- `runner-token` - токен runner'а, который берётся при создании нового runner'а в GitLab UI

**External Secret:** `envs/dev2/apps/gitlab-runner/resources/gitlab-runner-external-secret.yaml`

**Использование:** Создаёт секрет `gitlab-runner-credentials` в namespace `gitlab-runner` с ключами:
- `runner-registration-token` → из Vault `runner-registration-token`
- `runner-token` → из Vault `runner-token`

---

## Команды для создания секретов в Vault

### PostgreSQL
```bash
vault kv put kv/veryred/postgres/credentials \
  password="your-secure-password" \
  username="a" \
  database="a"
```

### Keycloak
```bash
vault kv put kv/veryred/keycloak/credentials \
  admin-password="your-secure-admin-password"
```

### RabbitMQ
```bash
vault kv put kv/veryred/rabbitmq/credentials \
  password="your-secure-password"
```

### GitLab Runner
```bash
vault kv put kv/veryred/gitlab-runner/credentials \
  runner-registration-token="" \
  runner-token="your-runner-token-from-gitlab"
```

---

## Проверка секретов в Vault

```bash
# PostgreSQL
vault kv get kv/veryred/postgres/credentials

# Keycloak
vault kv get kv/veryred/keycloak/credentials

# RabbitMQ
vault kv get kv/veryred/rabbitmq/credentials

# GitLab Runner
vault kv get kv/veryred/gitlab-runner/credentials
```

---

## Примечания

1. Все пути указаны относительно базового пути `kv/veryred`, который настроен в `ClusterSecretStore` (`04-external-secrets-operator/cluster-secret-store.yaml`).

2. External Secrets Operator автоматически синхронизирует секреты из Vault в Kubernetes каждую минуту (`refreshInterval: 1m`).

3. После создания секретов в Vault, External Secrets автоматически создадут соответствующие Kubernetes Secrets в нужных namespace'ах.

4. Если секрет не создаётся, проверьте:
   - Существует ли путь в Vault
   - Правильны ли имена ключей (properties)
   - Работает ли External Secrets Operator
   - Правильно ли настроен ClusterSecretStore

