# Ingress

Ingress controller - это http прокси, который прнимает запросы от пользователей и маршрутизирует их внутрь kubernetes по заданным правилам

Для ingress controller действует схема анлогичная [Service], а именно, существуют конечные точки(endpoints), и контроллер на их основе настраивает правила маршрутизации

```bash
minikube addons enable ingress
kubectl get pods -n ingress-nginx

```



Можно настроить ingress на локальной машине, но чтобы открыть доступ к сайту во внешний мир, нужен полноценый DNS сервер
Пример:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
  - host: nginx.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
            service:
                name: nginx-nodeport
                port:
                    number: 80
```

Сохраняем в файл и создаем ingress сервис на основе этого файла

```bash
kubectl apply -f service-ingress.yaml
```

Добавляем запись с ip адресом и названием сайта `nginx.example.com` в файл `/etc/hosts`

```bash
sudo sh -c "echo \"$(minikube ip) nginx.example.com\" >> /etc/hosts"
```

Проверяем что все работает

```bash
curl http://nginx.example.com
```

Более сложный файл с несколькими эндпойнтами:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dummy-ingress
spec:
  rules:
    - host: kubeserve.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: kubeserve
                port:
                  number: 80
  
    - host: app.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx
                port:
                  number: 80
    - http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: httpd
                port:
                  number: 80

```