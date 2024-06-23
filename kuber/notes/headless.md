# Headless сервис

Ранее упоминался так называемый Headless сервис. Это отдельный вид сервиса, который создаётся без кластерного IP адреса. 
Такие сервисы нужны в первую очередь для распределённых систем, которые запускаются в нескольких репликах внутри Kubernetes.
Таким системам требуется периодически осуществлять синхронизацию между репликами. Поэтому нужен механизм для поиска реплик. 
Для этого и нужен Headless сервис. Он позволяет получить полный набор адресов подов, по селектору данного сервиса. 

Создадим описание сервиса без кластерного IP адреса. Обратите внимание на селектор. 
Этот сервис станет управлять нашим тестовым приложением, которое мы запустили на прошлом практическом занятии.

```yaml
$ nano kube-headless.yaml

apiVersion: v1
kind: Service
metadata:
     name: kube-headless
spec:
     clusterIP: None
     ports:
     - port: 80
        targetPort: 8080
     selector:
       app: nginx
```
Применим его к нашему кластеру Kubernetes

`$ kubectl create -f kube-headless.yaml`

`service/kube-headless created`

Изучим созданный сервис.

`$ kubectl get svc kube-headless -o yaml`

Видим на экране всё, что мы записали в файл и ещё стандартные поля, которые Kubernetes создаёт автоматически.
Теперь мы можем изучить конфигурацию DNS данного сервиса.

```bash
$ kubectl exec -it busybox -- nslookup kube-headless
…
Name:   kube-headless.default.svc.cluster.local
Address: 10.244.0.9
Name:   kube-headless.default.svc.cluster.local
Address: 10.244.0.12
```
Видно, что у него нет одного общего IP адреса, зато есть массив адресов для каждой из реплик данного деплоймента: