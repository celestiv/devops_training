# centos notes

## installation

Ошибка Failed to download metadata for repo 'AppStream' характерна для установок CentOS 8, выполненных в 2022 году. Дело в том, что эта версия ОС перестала поддерживаться 31 декабря 2021 года. Это означает, что CentOS 8 больше не будет получать ресурсы для разработки (пакеты) от официального проекта CentOS. Теперь, если вам нужно обновить CentOS, вам необходимо изменить зеркала на vault.centos.org, где они будут постоянно заархивированы. В качестве альтернативы вы можете перейти на CentOS Stream.

Они во всех файлах со списков репозиториев, начинающих на CentOS- , заменяют mirror.centos.org на vault.centos.org.

```bash
cd /etc/yum.repos.d/

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
sudo yum update -y`
```

