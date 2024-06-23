# Service

Отбирает подконтрольные поды по селекторам - меткам на подах.

Для каждого пода, соответствующего требованиям сервиса, он создает endpoint. 

Далее при обращении к сервису происходит маршрутизация именно на эти конечные точки.

kube-proxy, устанавливаемый на каждый узел кластера, настраивает таблицу маршрутизации таким образом, чтобы при обращении к сервису по имени или адресу сервиса мы попадали на поды из 
актуального набора конечных точек

```shell
$ sudo iptables-save | grep KUBE | grep nginx
…
-A KUBE-SEP-IEG2I7U346FDGXTL -p tcp -m comment --comment "default/nginx-nodeport" -m tcp -j DNAT --to-destination 10.244.0.9:80
…
-A KUBE-SEP-XYOZFPYJBT5C4O5J -p tcp -m comment --comment "default/nginx-nodeport" -m tcp -j DNAT --to-destination 10.244.0.12:80
…
```

