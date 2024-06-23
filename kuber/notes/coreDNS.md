# CoreDNS

Ранее мы узнали, что сервисы внутри кластера также доступны по DNS именам. Это обеспечивается отдельной DNS подсистемой, 
которая развёрнута в системном пространстве имён с другими сервисными компонентами кластера. 
Называется она CoreDNS и отвечает за хранение DNS записей для всех созданных в Kubernetes сервисов. 
Записи публикуются туда контроллером сервисов при их создании и по умолчанию имеют стандартную структуру: ..svc.cluster.local. 
При этом “.cluster.local” в принципе может быть опущен, а “..svc” можно не указывать при обращении в рамках одного пространства имён.

Изучим состав компонентов управления кластером. Для этого посмотрим все деплойменты в пространстве имён kube-system

```bash
$ kubectl get deployments -n kube-system
```


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - image: quay.io/shdn/nslookup:v1
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
```

## Настройка DNS-записей вручную
При этом конфигурацию DNS можно настраивать на уровне шаблона подов при определении их конфигурации. 

Создадим описание тестового пода с пользовательской конфигурацией DNS:

```yaml
apiVersion: v1
kind: Pod
metadata:
  namespace: default
  name: dns-example
spec:
  containers:
  - name: test
    image: quay.io/jitesoft/nginx
  dnsPolicy: "None"
  dnsConfig:
    nameservers:
      - 8.8.8.8
    searches:
      - ns1.svc.cluster.local
      - my.dns.search.suffix
    options:
      - name: ndots
        value: "2"
      - name: edns0
```

Теперь вот такой командой можно увидеть конфигурацию этого пода, а конкретнее, его айпи адрес:

```bash
kubectl get pods -o wide
```

Посмотрим на DNS записи об этом поде:

```bash
kubectl exec -ti busybox -- \
nslookup $(kubectl get po dns-example \
-o jsonpath='{.status.podIP}' \
| sed 's/\./-/g').default.pod.cluster.local
```

Видим, что запись о новом поде уже создана.

А теперь посмотрим на DNS записи изнутри пода dns-example:

`$ kubectl exec -it dns-example -- cat /etc/resolv.conf`