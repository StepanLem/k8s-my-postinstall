
# Сделать dns subdomain для кластера.
В reg.ru (dns-провайдер) надо сделать для кластера отдельный поддомен:
Например "*.dev2.veryred.ru". Таким образом все subdomain *.dev2 будет на кластер ссылаться. 
Будет синхронизирован через 20 минут. 



# Первичная настройка кластера:
```bash
# активировать окружение
# python -m venv .venv # создать если ещё не создвал
# pip install -r requirements.txt # добавить зависимости в venv 
source ~/.venvs/ansible-k8s-postinstall/bin/activate


# запустить плейбуки, предварительно смотри и настраивай values

# ingress:
ansible-playbook -i hosts.yaml  00-nginx-ingress/00-install-ingress-nginx.yml

# cert-manager:
ansible-playbook -i hosts.yaml 01-cert-manager/01-install-cert-manager.yml
# lets-ecnrypt issuer:
kubectl apply -f 01-cert-manager/letsencrypt-prod-clusterissuer.yaml
# - k get clusterIssuer -A

# argocd:
# - надо в values обновить host на свой. Например argocd.dev2.veryred.ru
ansible-playbook -i hosts.yaml 02-argocd/02-install-argocd.yml 

# local-path-provisioner(надо бы заменить на серп или лонгхорн):
ansible-playbook -i hosts.yaml  03-local-path-provisioner/03-install-local-path-provisioner-manifests.yml 

```