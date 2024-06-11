# Go + Docker
Go - это самый новый язык программирования из всех, что есть в этой лекции. Докер сам написан на Go, но это не значит, что с этим языком будет меньше проблем. У него есть свои подводные камни.

## Можно запускать собранный бинарный файл в образе FROM scratch

Go упаковывает все зависимости в один бинарный файл. Поэтому его можно запускать в пустом окружении. Для этого в Dockerfile есть инструкция   FROM scratch. При этом, конечно, будут доступны все возможности ядра Linux, только не будет создана файловая система. Конечно, размер образа при этом будет минимальным.
Помимо такого способа компиляции, есть ещё вариант при помощи makefile. Это очень старый инструмент, но он по-прежнему активно используется.
Многоступенчатая сборка для Go очень актуальна. На первом этапе компилируется приложение. Получившийся бинарный файл копируется на вторую стадию, где запускается на образе FROM scratch.

## Goroutines

Это киллерфича языка Go, но замечено, что под большой нагрузкой в контейнерах ведёт себя неправильно. Может выходить из-под контроля cgroups, проникать не в тот namespace. С этим нужно быть аккуратными в производственном окружении. Можно ограничивать производительность Goroutines, уменьшая число одновременных потоков.
Но чаще всего эта проблема проявляется только под очень большими нагрузками. В маленьких проектах эта проблема скорее всего не проявится.

## Пример Dockerfile

```dockerfile
# Первый шаг сборки
FROM golang:alpine AS builder

# Ставим git, это нужно для установки зависимостей
RUN apk update && apk add --no-cache git
ENV USER=appuser
ENV UID=10001

# Создаём пользователя максимально безопасно
RUN adduser \
--disabled-password \
--gecos "" \
--home "/nonexistent" \
--shell "/sbin/nologin" \
--no-create-home \
--uid "${UID}" \
"${USER}"WORKDIR $GOPATH/src/mypackage/myapp/

# Копируем код в образ и ставим зависимости
COPY . .
RUN go mod download
RUN go mod verify

# Запускаем оптимизированную сборку
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/hello

# Второй шаг сборки
FROM scratch

# Копируем всё необходимое из первого шага
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --from=builder /go/bin/hello /go/bin/hello

# Простой пользователь
USER appuser:appuser

# Порт с номером более 1024
EXPOSE 9292
ENTRYPOINT ["/go/bin/hello"]
```

Разберёмся, что тут происходит. Новое для нас - это особенности работы в образе `FROM:scratch`

Начинаем сборку в тонком образе alpine.

`FROM golang:alpine AS builder`

Во время сборки на первом этапе получается бинарный файл.

`RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /go/bin/hello`

И он копируется во второй этап.

`COPY --from=builder /go/bin/hello /go/bin/hello`

Здесь очень много внимания уделено созданию пользователя. Сначала он создаётся на первом этапе.

`ENV USER=appuser`

`ENV UID=10001`

`RUN adduser \`

`--disabled-password \`

`--gecos "" \`

`--home "/nonexistent" \`

`--shell "/sbin/nologin" \`

`--no-create-home \`

`--uid "${UID}" \`

`"${USER}"WORKDIR $GOPATH/src/mypackage/myapp/`

А потом его параметры копируются во второй этап.

`COPY --from=builder /etc/passwd /etc/passwd`

`COPY --from=builder /etc/group /etc/group`

Наконец, переключаемся на этого пользователя. Все следующие команды уже будут выполняться с низкими привилегиями.

`USER appuser:appuser`

Под рядовым пользователем можно открыть только порт с номером, больше, чем 1024, поэтому пишем

`EXPOSE 9292`

А запустить его очень просто - нужно выполнить наш бинарный файл

`ENTRYPOINT ["/go/bin/hello"]`
​