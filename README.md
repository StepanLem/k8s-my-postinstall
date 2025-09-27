# Frontend Application с Kubernetes

Современное фронтенд приложение с React, развернутое в Kubernetes с nginx.

## 🏗️ Архитектура

### Правильная структура проекта:
```
├── frontend/                 # Фронтенд приложение
│   ├── frontend/            # Исходный код
│   │   ├── src/             # React код
│   │   ├── public/          # Статические файлы
│   │   ├── package.json     # Зависимости
│   │   ├── vite.config.js   # Конфигурация Vite
│   │   └── .eslintrc.cjs    # ESLint конфигурация
│   ├── charts/              # Helm charts
│   │   └── frontend/        # Chart для фронтенда
│   ├── argocd/              # ArgoCD Applications
│   ├── Dockerfile           # Docker образ
│   ├── nginx.conf           # nginx конфигурация
│   └── .gitlab-ci.yml       # CI/CD
└── README.md
```

## 🚀 Почему именно так?

### ❌ Что было неправильно:
- Helm chart и фронтенд код в одной папке
- ArgoCD Application в папке Helm chart'а
- Файлы фронтенда разбросаны по корню проекта
- Сложная конфигурация nginx через ConfigMap
- Избыточные файлы и шаблоны

### ✅ Как делают в реальности:

**Большие компании (Google, Netflix, Uber):**
- Отдельные репозитории для каждого сервиса
- Простые Docker образы с готовой конфигурацией
- Helm charts в отдельных репозиториях
- GitOps с ArgoCD

**Средние компании:**
- Монорепо с правильной структурой
- `charts/` папка для Helm charts
- Простые Docker образы
- CI/CD пайплайны

## 🐳 Docker образ

**Простой и эффективный подход:**
```dockerfile
# Сборка фронтенда
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Production с nginx
FROM nginx:1.25-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
USER nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Преимущества:**
- ✅ Готовая nginx конфигурация внутри образа
- ✅ Нет лишних ConfigMap'ов
- ✅ Простой и понятный
- ✅ Быстрая сборка

## ☸️ Kubernetes

### Helm Chart в `charts/frontend/`:
- Простые templates без избыточности
- Минимальная конфигурация
- Готов к продакшену

### Деплой:
```bash
# Локально
helm install frontend charts/frontend \
  --set image.repository=your-registry.com/frontend \
  --set image.tag=latest

# Через ArgoCD
kubectl apply -f argocd/frontend-application.yaml
```

## 🔄 CI/CD

### GitLab CI пайплайн:
1. **Build** - сборка фронтенда
2. **Test** - запуск тестов
3. **Package** - создание Docker образа
4. **Deploy** - деплой через Helm

### Переменные окружения:
- `KUBECONFIG_DEV` - kubeconfig для dev
- `KUBECONFIG_PROD` - kubeconfig для prod
- `CI_REGISTRY_*` - Docker registry

## 🛠️ Разработка

```bash
# Установка зависимостей
cd frontend
npm install

# Запуск dev сервера
npm run dev

# Сборка
npm run build

# Тесты
npm run test

# Docker сборка (из папки frontend)
cd frontend
docker build -t frontend:latest .
```

## 📊 Мониторинг

- Health check: `/health` endpoint
- Автоматическое масштабирование (HPA)
- Метрики CPU/Memory
- Логирование

## 🔒 Безопасность

- Non-root пользователь в контейнере
- Security headers в nginx
- TLS через cert-manager
- Минимальные привилегии

## 🎯 Итог

Теперь у нас есть:
- ✅ Правильная структура проекта
- ✅ Простой Docker образ с готовой конфигурацией
- ✅ Чистый Helm chart
- ✅ Эффективный CI/CD
- ✅ Готовность к продакшену

**Это именно то, как делают в реальных проектах!** 🚀