# Лекция "системы управления кластерами и конфигиурациями"

![stack](./img/config/config_stack.png)

![compare](./img/config/comparison.png)

## ansible

![ansible](./img/config/ansible.png)

Пример конфига ansible

```yaml
- name: set up webserver
  hosts: all
  become: yes
  tasks:
    - name: ensure nginx is at latest version
      apt:
        name: nginx
        state: latest
        update_cache: true
    - name: start nginx
      service:
        name: nginx
        state: started
        enabled: yes
    - name: copy our awesome landing
      copy:
        src: files/index.nginx-debian.html
        dest: /var/www/html/index.nginx-debian.html
        force: true
```

![roles](./img/config/ansible_roles.png)

## chef

![chef](./img/config/chef.png)

## puppet

![puppet](./img/config/puppet.png)

## SaltStack

![salt](./img/config/salt_stack.png)

