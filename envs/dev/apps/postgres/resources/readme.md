1. Создаёшь эти ресурсы чтобы разрабам был доступ к:
   - PostgreSQL в namespace postgres (только port-forward)
   - Приложениям transcriber в namespace default (просмотр и port-forward)
k apply -f envs/dev/apps/postgres/resources/.

2. через create token с точно таким же именем, как as получаешь токен:
Если ты безбашенный(на пол года):
kubectl -n postgres create token dev-access --duration=4320h > dev-token.txt
По-нормальном(на час=дефолтное значение):
kubectl -n postgres create token dev-access --duration=1h > dev-token.txt

3. Делаешь kubeconf для разраба с этим токеном:
```yaml
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: https://YOUR-API-SERVER:6443
    certificate-authority-data: BASE64_CA_DATA
  name: my-cluster

users:
- name: dev-access
  user:
    token: PASTE_TOKEN_HERE

contexts:
- context:
    cluster: my-cluster
    namespace: my-namespace
    user: dev-access
  name: dev-access-context

current-context: dev-access-context
```


4. Этот токен истчёт через время. Обычно их делают для разовых отладок разработчиками. 
А норм доступ девопсам через oidic.
То есть по сути разраб запросил в маленькой компании - ты дал доступ на час например.

## Что может делать разработчик с этим токеном:

### В namespace postgres:
- Просматривать поды и сервисы PostgreSQL
- Делать port-forward к PostgreSQL

### В namespace default (transcriber приложения):
- Просматривать поды, сервисы, конфиги, секреты
- Просматривать deployments, replicasets, ingresses
- Делать port-forward к любым подам в namespace default

### Примеры команд:
```bash
# Просмотр подов PostgreSQL
kubectl get pods -n postgres

# Port-forward к PostgreSQL
kubectl port-forward -n postgres pod/postgresql-0 5432:5432

# Просмотр приложений transcriber
kubectl get pods -n default
kubectl get services -n default
kubectl get deployments -n default

# Port-forward к любому приложению transcriber
kubectl port-forward -n default pod/main-backend-xxx 8080:8080
kubectl port-forward -n default pod/frontend-xxx 3000:80
```

