kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: default
type: Opaque
stringData:
  token: <your-token> 
EOF


# В папке resources:
- Лежит ClusterSecretStore. Он описывает как подключаться к vault. но ему нужно создать токен-секрет.
-(НЕ СМЕЙ ЗАПУШИТЬ В git) Секрет создаётся вручную: код в resources/vault-token.bash - скопируй код в терминал, вставь токен из vault и выполнить.