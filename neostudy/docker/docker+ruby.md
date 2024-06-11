# Ruby + Docker
Язык Ruby мало используется в Neoflex. Эту часть лекции можно рассматривать как необязательную
## Типичный стек
Типичный стек для запуска приложения на Ruby состоит из postgres, redis, sidekiq, nginx и самого приложения. Итого получится пять контейнеров.
## Можно запускать в одном контейнере с rails server ещё и guard
Это для отладки фронтэнда. Guard нужен для автоматической подгруздки некоторых типов файлов. С помощью него и плагина для браузера, можно добиться изменения текста на странице прямо в режиме онлайн. Вы исправили что-то в коде, браузер это сразу отобразил.
## Rails + Nginx может быть в одном контейнере.
Если у вас Production не в докере, то для приближения условий разработки к условиям в продакшн, можно запустить Rails сервер и Nginx в одном контейнере.
Но если продакшн работает в докере, то лучше держать Rails и Nginx в разных контейнерах. Всегда стремитесь следовать правилу "один контейнер - один процесс".
## Как ставить зависимости на Ruby
Такая хитрая команда установит зависимости на Ruby (bundle - утилита для сборки приложений на Ruby):
RUN bundle check || bundle install
Здесь сначала производится проверка зависимостей (check), а если проверка не успешна, то зависимости устанавливаются заново (install).
## Хранить pid-файл в tmpfs
Можно хранить pid-файл в tmpfs. Либо можно запускать bundle скриптом с проверкой, что PID-файл устарел.
PID-файл хранит номер процесса в операционной системе (Process ID).
По отзывам, иногда в контейнере остаётся старый PID-файл. По какой-то причине, он не удаляется вовремя. Тогда bundle будет ругаться, что есть старый PID, значит там что-то уже запущено.
Если его хранить в tmpfs, то он гарантированно удалится.
## Оптимизируйте размер образа - удаляйте статику и кэши
Размер образа можно уменьшить кардинально. Например, папки app/assets vendor/assets, tmp, cache не нужны для работы приложения. Разработчики на Ruby наверняка могут продолжить этот список. От всего этого нужно избавляться, чтобы оно не попадало в Продакшн. При запуске контейнера они будут созданы заново. А мы смогли сэкономить на размере образа.
## Ruby on Rails Dockerfile
```dockerfile
FROM ruby:2.3-alpine

RUN set -ex && apk add --update --virtual runtime-deps postgresql-client nodejs libffi-dev readline sqlite && rm -rf /var/cache/apk/*

WORKDIR /tmp
COPY Gemfile Gemfile.lock ./

RUN set -ex && apk add --virtual build-deps build-base openssl-dev postgresql-dev libc-dev linux-headers libxml2-dev libxslt-dev readline-dev && \
 
bundle install --clean --no-cache --without development --jobs=2 && \
rm -rf /var/cache/apk/* && \
apk del build-deps

ENV APP_HOME /app
COPY . $APP_HOME
WORKDIR $APP_HOME

ENV RAILS_ENV=production RACK_ENV=production
EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
```
Видим довольно сложный Докерфайл. Он отличается от того, что мы видели до сих пор. Давайте разберёмся, что тут происходит.

`FROM ruby:2.3-alpine`

Начинаем с Ruby на Alpine. Там есть минимальный набор инструментов, и он легковесный. То есть, здесь у нас не будет многоступенчатой сборки.

`RUN set -ex && apk add --update --virtual runtime-deps postgresql-client nodejs libffi-dev readline sqlite && rm -rf /var/cache/apk/*`

В этой длинной команде мы ставим основные пакеты, которые будут нужно для работы приложения. И сразу удаляем кеш пакетов.

`WORKDIR /tmp`

`COPY Gemfile Gemfile.lock ./`

Переходим в /tmp и копируем файл, в котором перечислены наши зависимости.

`RUN set -ex && apk add --virtual build-deps build-base openssl-dev postgresql-dev libc-dev linux-headers libxml2-dev libxslt-dev readline-dev && \`

`bundle install --clean --no-cache --without development --jobs=2 && \`
`rm -rf /var/cache/apk/* && \`
`apk del build-deps`

В этой огромной команде мы ставим другие пакеты, которые потребуются для сборки приложения. Потом начинаем компиляцию через bundle. В последних двух строчках снова удаляем все кеши.

Все остальные строчки в этом Докерфайле вам уже понятны без объяснений.