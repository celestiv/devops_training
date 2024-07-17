# Как починить интернет

![видео](https://www.youtube.com/watch?v=ScSfNwxBU7A)

## Как починить интернет

Потенциальные источники проблем, которые надо проверить при "починке"

![potential causes](./img/fix_internet/potential_causes.png)

## Internet protocol

![ipv4 headers](./img/fix_internet/ipv4_headers.png)

![ipv6 headers](./img/fix_internet/ipv6_headers.png)

## Routing

Вот так можно посмотреть таблицы маршрутизации

`ip route show table local`

`ip route show table main`

`ip route show table default`

### Policy based routing

`ip rule`

`ip rule help`

Добавляем IP адрес на интерфейс

`'ip addr add <ip address with mask> dev <interface>`

## Sockets

Что такое сокет? Пара IP - port, число, структура, файл?

Существует два вида

### message based sockets

UDP, ICMP протоколы работают поверх таких сокетов

### stream-oriented sockets

TCP

## TCP protocol

придумали в 1974 году

![tcp header](./img/fix_internet/tcp_header.png)

MSS - mx segnment size - максимальный размер сегмента. Определятеся в таблице маршрутзации

MTU

### TCP handshake

Установка сообщения занимает 3 шага

![tcp 1](./img/fix_internet/tcp_1.png)

window scaling = число на которое нужно умножить 64кб, чтобы получить реальное значение MSS

sequence(offset) - псеводслучайное число, которое выбирается чтобы начать отсчет номера сегмента. Оно нужно для безопасности, чтобы не стартовать отсчет с 0 и сделать передачу данных безопаснее

![tcp 2](./img/fix_internet/tcp_2.png)

![tcp 3](./img/fix_internet/tcp_3.png)

### TCP congestion control

КОмпромисс между целостностью передачи данных и скоростью передачи

![congestion control](./img/fix_internet/tcp_congestion_control.png)

TCP Reno, Cubic, BBR(google)

## Traffic dumps

### traffic Source

утилиты для генерации трафика, при помощи которых можно имитировать нагрузку

* nc

* curl

* ping / traceroute

* iperf

* scapy

* dig / nslookup

### Observability

Утилиты для анализа трафика

* tcpdump

* wireshark

* ss / ip / ethtool

* strace

