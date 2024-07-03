# units

## Создаем простой сервис 

Напишем простой скрипт, который делает dnf update автоматически после входа в систему под пользователем root

```bash
#!/usr/bin/env bash
 
if [ ${EUID} -ne 0 ] then
      exit 1 # this is meant to be run as root
fi

dnf update -y &>>/root/logs/sys-update.log
```

`sudo -s`

`mkdir /root/.scripts/ mkdir /root/logs`

`nano /root/.scripts/sys-update.sh`

Давайте сначала разберемся, что делает этот скрипт. 

Во-первых, он проверит, является ли пользователь root или нет. Если пользователь является пользователем root, будет выполнена команда обновления dnf update. Весь вывод этой команды будет добавлен в файл /root/logs/sysupdate.log.

Давайте создадим для этого служебный файл systemd. Но прежде чем это сделать, нужно знать, где разместить служебный файл systemd, для которого требуются привилегии суперпользователя.

Обычно считается хорошей практикой помещать служебные файлы systemd в каталог /etc/systemd/system/.

Поэтому я создам файл update-on-boot.service; его полный путь: /etc/systemd/system/update-on-boot.service; Ниже приведено содержимое этого служебного файла:

`nano /etc/systemd/system/update-on-boot.service`

```shell
[Unit]
Description=Keeping my sources fresh
After=multi-user.target

[Service]
ExecStart=/usr/bin/bash /root/.scripts/sys-update.sh
Type=simple

[Install]
WantedBy=multi-user.target
```

## Включение сервиса

Теперь, когда файл службы systemd готов и помещен в каталог `/etc/systemd/system/`, давайте посмотрим, как его включить.

Чтобы указать systemd, что нужно прочитать наш служебный файл, нам нужно выполнить следующую команду:

`$ systemctl daemon-reload`

Это позволит systemd узнать о нашем недавно созданном юните systemd.
Теперь мы можем включить нашу службу systemd. Синтаксис для этого следующий:

`$ systemctl enable update-on-boot.service`

Теперь наш сервис включен. Но как мы можем это проверить?

`$ systemctl is-enabled update-on-boot.service`

> enabled

Судя по выходным данным, наша служба — update-on-boot.service — включена. Проверим. Для этого перезагрузим систему. Но, так как у нас отключен root login через ssh, зайдём в систему не через PuTTY, а напрямую. Заходим как root. Перезагружаем систему при помощи команды

`$ reboot`

`cat /root/logs/sys-update.log`


## Сервис systemd для обычного пользователя

Теперь, когда мы только что увидели, как создать сервис, который запускается суперпользователем, давайте сделаем то же самое для сервиса, который сработает для любого пользователя.

Поскольку предыдущая служба запускается при старте системы, давайте создадим сценарий, предназначенный для запуска перед завершением работы. Я создал скрипт с именем big-uptime.sh, его полный путь — `/home/neoflex/.scripts/big-uptime.sh`

Чтобы создать его введём следующие команды, работая под пользователем admin. После ввода этих команд нужно будет скопировать скрипт в открывшийся файл.

`$ mkdir /home/neoflex/logs mkdir /home/neoflex/.scripts`

`$ nano /home/neoflex/.scripts/big-uptime.sh`

Cодержимое скрипта — следующее:

```shell
#!/usr/bin/env bash
uptime | tee -a /home/neoflex/logs/uptime.log
```

Это простой скрипт, добавляющий время безотказной работы системы в файл `/home/neoflex/logs/uptime.log`

Хорошо, теперь давайте создадим для него служебный файл systemd.
Я сохраню этот файл службы systemd как `/etc/systemd/system/scoreboard.service`

`$ sudo nano /etc/systemd/system/scoreboard.service`

Ниже приведено содержимое моего служебного файла systemd для пользователя
neoflex:

```
[Unit]
Description=Log uptime in scoreboard
DefaultDependencies=no
Before=shutdown.target

[Service]
Type=oneshot
ExecStart=/usr/bin/bash /home/neoflex/.scripts/big-uptime.sh
TimeoutStartSec=0

[Install]
WantedBy=shutdown.target
```

Между этим сервисным файлом systemd и предыдущими есть несколько ключевых отличий. Самым большим из них является тип этого сервиса «oneshot». Если Type=oneshot, то systemd следит за тем, чтобы никакие службы не запускались/не останавливались до тех пор, пока наша служба не будет полностью инициализирована или пока наша служба не запустится.

## Включаем сервис

`sudo systemctl daemon-reload`

`$ sudo systemctl enable scoreboard.service`

`sudo systemctl is-enabled scoreboard.service`

`cat logs/uptime.log`

>  02:59:56 up 1 min,  1 user,  load average: 0.29, 0.11, 0.04

>  03:00:15 up 1 min,  1 user,  load average: 0.21, 0.10, 0.04