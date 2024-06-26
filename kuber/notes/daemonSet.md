# DaemonSet

Перейдём к следующему типу контроллеров репликации, который называется DaemonSet. Он достаточно специфичен и применяется как правило для настройки каких-то кластерных средств на узлах Kubernetes. Такими средствами могут быть сетевые плагины, средства мониторинга или логирования и прочие сервисные приложения, необходимые для успешной работы кластера. По умолчанию (если не указан NodeSelector) DaemonSet создаёт экземпляры описанного в нём пода на всех узлах Kubernetes. Причём при добавлении и удалении узлов в кластере DaemonSet автоматически добавляет и удаляет поды на  них

`kubectl apply -f daemonset.yaml`

> daemonset.apps/fluentd-elasticsearch created

В данный момент у нас один узел в Kubernetes, поэтому будет создан один под нашего DaemonSet:

`$ kubectl get pods`
> NAME    READY        STATUS        RESTARTS         AGE
fluentd-elasticsearch-scjf6            1/1             Running                0                     28s

Посмотрим, какие у нас есть ноды (узлы). Список узлов доступен по следующей команде:

`$ minikube node list`

> minikube 192.168.49.2

Добавим узел в наш кластер Kubernetes и посмотрим, как изменится при этом состав подов. Добавляем виртуальный узел средствами Minikube:

`$ minikube node add`
> …
* Successfully added m02 to minikube!

Можем проверить, что узел был успешно добавлен:

`$ minikube node list`

> minikube                        192.168.49.2
> minikube-m02            192.168.49.3
После этого мы увидим, что для нового узла был создан дополнительный под и оба пода размещаются на различных узлах

`$ kubectl get pods -o wide`

> NAME                          READY       STATUS     RESTARTS         AGE             IP        NODE…
fluentd-…-65vmm    0/1           Running     2 (16s ago)        42s        10.244.1.2  minikube-m02…
fluentd-…-scjf6         1/1             Running     0                            3m        10.244.0.49        minikube…

Теперь удалим узел из кластера Kubernetes и посмотрим, как изменится при этом состав подов. Удаляем ранее созданный виртуальный узел средствами Minikube.

`$ minikube node delete $(minikube node list | grep '-' | awk '{print $1}')`
> ...
* Node minikube-m02 was successfully deleted.

Можем проверить, что узел был успешно удалён:

`$ minikube node list`

> minikube                  192.168.49.2

После этого мы увидим, что вместе со вторым узлом был удалён и второй под DaemonSet:

`$ kubectl get pods -o wide`

> NAME                         READY       STATUS     RESTARTS         AGE                  IP        NODE
fluentd-…-scjf6         1/1           Running            0                    9m14s    10.244.0.49         minikube

Удалим DaemonSet:

`$ kubectl delete daemonsets fluentd-elasticsearch`

> daemonset.apps "fluentd-elasticsearch" deleted

Итак, DaemonSet - это такой контроллер репликации, который запускает ровно по одной копии пода на каждой ноде в кластере. При помощи селектора, можно выбрать, на каких нодах его запускать не нужно.
При помощи Tolerations можно преодолеть ограничения нод на запуск подов.