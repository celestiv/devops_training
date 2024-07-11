# Внутренности Linux

[Видео](https://www.youtube.com/watch?v=kJG2V48L-IE)

## Процессы

Процессы - абстракция, которая имеет свою область памяти

## Межпроцессное взаимодействие

- семафоры

![semaphore](./img/linux_internals/semaphore.png)

- сокеты

- каналы(pipe). бывают именованные и неименованные

![pipe](./img/linux_internals/pipe.png)

`mkfifo`

- общая память

![shared memory](./img/linux_internals/shared_memory.png)

- файлы

- сигналы

![signals](./img/linux_internals/signals.png)

Есть команда `ipcs`, которая показывает семафоры, разделяемую память

## Состояния процессов

- R running

- S sleep

- T stopped

- D uninterruptible sleep

- Z zombie

- X terminated

## Планировщик

 Отвечает за правильное распределение процессорного времени между процессами

### Типы задач

- IO bound

- CPU bound

### Приоритеты задач

- realtime

`0-99` - realtime

Выше значение - выше приоритет

- normal

`100-139` - not realtime

Ниже значение - выше приритет

![priority](./img/linux_internals/priority.png)

### Планировщики 

- FIFO

- Round robin

- Sched_normal

- O(1)

- CFS

![cfs](./img/linux_internals/CFS.png)

- red-black tree

- EECDV (Earliest eligible virtual deadline first)

## Прерывания

Оборудование обращается к процессору с просьбой выделить ресурсы для выполнения каких-то действий

![interrupts](./img/linux_internals/interrupts.png)

![interrupts 2](./img/linux_internals/interrupts_2.png)

![halves](./img/linux_internals/halves.png)

## системные вызовы

Это API к ядру Линукса

![syscalls](./img/linux_internals/syscalls.png)

![virt](./img/linux_internals/virt.png)