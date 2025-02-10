
# Как работает http/3

## Генерация ключей для Certificate authorithy и сервера

### Генерируем приватный ключ для СА

`openssl genrsa -out ca-key.pem -aes256`

Запрашиваем сертификат, сгенерированный на основе ключа СА

`openssl req -new -x509 -sha256 -days 365 -key ca-key.pem -out ca-cert.crt`

Генерируем публичный ключ на основе приватного

`openssl rsa -in ca-key.pem -pubout -out ca-public-key.pem`

Генерируем запрос (certificate signing request) к CA

`openssl req -new -key server-key.key -config config.cnf -out server-csr.csr `


Подписываем сертификат

`openssl x509 -req -in server-cs
r.csr -CA ca-cert.crt -CAkey ca-key.pem -out server-cert.crt -days 365 -sha256 -copy_extensions copy`

В браузере открывается страница index.html, но горит предупреждение о том, что сертификат не валиден. Чтобы его убрать, нужно скопировать файл ca-cert.crt в хранилище сертификатов в браузере или в операционной системе
