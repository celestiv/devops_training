# Начало работы с yandex cloud

## instance group

```
name: my-group

# yc iam service-account list
service_account_id: ajeu495h1s9tn1rorulb

instance_template:
    platform_id: standard-v1
    resources_spec:
        memory: 2g
        cores: 2
    boot_disk_spec:
        mode: READ_WRITE
        disk_spec:
        #  yc compute image list --folder-id standard-images
            image_id: fd8fosbegvnhj5haiuoq
            type_id: network-hdd
            size: 32g
    network_interface_specs:
        - network_id: enpnr4onfs6ihtoao32u
          primary_v4_address_spec: { one_to_one_nat_spec: { ip_version: IPV4 }}
    scheduling_policy:
        preemptible: false
    metadata:
      user-data: |-
        #cloud-config
          package_update: true
          runcmd:
            - [ apt-get, install, -y, nginx ]
            - [/bin/bash, -c, 'source /etc/lsb-release; sed -i "s/Welcome to nginx/It is $(hostname) on $DISTRIB_DESCRIPTION/" /var/www/html/index.nginx-debian.html']

deploy_policy:
    max_unavailable: 1
    max_expansion: 0
scale_policy:
    fixed_scale:
        size: 3
allocation_policy:
    zones:
        - zone_id: ru-central1-a

load_balancer_spec:
    target_group_spec:
        name: my-target-group

```

`yc compute instance-group create --file instance-group.yaml`

`yc compute instance-group list`

## load balancer


```
yc load-balancer network-load-balancer create \
  --region-id ru-central1 \
  --name my-load-balancer \
  --listener name=my-listener,external-ip-version=ipv4,port=80
```

`yc load-balancer target-group list`

```
yc load-balancer network-load-balancer attach-target-group my-load-balancer \
  --target-group target-group-id=<идентификатор целевой группы>,healthcheck-name=test-health-check,healthcheck-interval=2s,healthcheck-timeout=1s,healthcheck-unhealthythreshold=2,healthcheck-healthythreshold=2,healthcheck-http-port=80
```

 Проверьте состояние машин группы. Для этого запросите список машин и дождитесь статуса HEALTHY.

```
yc load-balancer network-load-balancer target-states my-load-balancer \
    --target-group-id <идентификатор_целевой_группы>
```

Можно обновить что-то в спецификации целевой группы и обновить также саму целевую группу:

```
yc compute instance-group update \
  --id <instance_group_id> \
  --file instance-group.yaml
```

Теперь можно проверить работает ли целевая группа, и балансировщик нагрузки. Можно удалить одну из машин, и на ее замену будет создана новая, при этом применятся обновления, то есть машина будет создана с новой конфигурацией. Такую мы задали стратегию обновления

`yc compute instance delete <имя_ВМ>`


Не забываем очистить ресурсы после работы

```
yc compute instance-group delete --name my-group

yc load-balancer network-load-balancer delete --name my-load-balancer
```

##