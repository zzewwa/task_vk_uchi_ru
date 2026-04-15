# API сервиса для тестового задания

## Запуск

1. Создать `.env` на основе `.env.example`.
2. Запустить сервис:

```bash
docker compose up -d --build
```

3. Swagger UI:

```text
http://localhost:3000/api-docs
```

## Роуты

- `POST /students` - регистрация студента (возвращает `X-Auth-Token` в заголовке).
- `POST /session` - генерация JWT для существующего студента.
- `DELETE /session` - инвалидировать текущий JWT.
- `DELETE /students/{user_id}` - удалить студента (требует Bearer JWT).
- `GET /schools/{school_id}/classes` - список классов школы (требует Bearer JWT).
- `GET /schools/{school_id}/classes/{class_id}/students` - список студентов класса (требует Bearer JWT).

## Как получить JWT через Swagger

1. Открыть `http://localhost:3000/api-docs`.
2. В сиды добавлен админ для быстрого входа:

```text
first_name: Admin
last_name: System
surname: User
```

3. Выполнить `POST /session` с телом:

```json
{
  "first_name": "Admin",
  "last_name": "System",
  "surname": "User"
}
```

4. Скопировать `token` из ответа.
5. Нажать `Authorize` и вставить значение в формате:

```text
Bearer <token>
```

## Проверка через curl

Регистрация (получение `X-Auth-Token` в заголовке):

```cmd
curl -i -X POST http://localhost:3000/students -H "Content-Type: application/json" -d "{\"first_name\":\"Ivan\",\"last_name\":\"Ivanovich\",\"surname\":\"Petrov\",\"school_id\":1,\"class_id\":1}"
```

Генерация JWT через сессию:

```cmd
curl -s -X POST http://localhost:3000/session -H "Content-Type: application/json" -d "{\"first_name\":\"Admin\",\"last_name\":\"System\",\"surname\":\"User\"}"
```

Примеры защищенных ручек (подставить `<TOKEN>`):

```cmd
curl -s http://localhost:3000/schools/1/classes -H "Authorization: Bearer <TOKEN>"
curl -s http://localhost:3000/schools/1/classes/1/students -H "Authorization: Bearer <TOKEN>"
curl -i -X DELETE http://localhost:3000/session -H "Authorization: Bearer <TOKEN>"
curl -i -X DELETE http://localhost:3000/students/1 -H "Authorization: Bearer <TOKEN>"
```

## Важно по OpenAPI из ТЗ

Для удобства разработки и более чистой слоистой структуры проекта OpenAPI из ТЗ слегка адаптирован.
Ключевое изменение: регистрация и схема ручек подогнаны под текущую архитектуру (в частности `POST /students` и добавленная сессионная ручка `POST /session`).
