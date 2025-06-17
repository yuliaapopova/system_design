# System Design социальная сеть для путешественников

## Требования

### Функциональные требования
- Загрузка фотографий
- Добавление описания
- Привязка к географии
- Комментирование постов
- Оценивание постов
- Подписка на других пользователей
- Поиск постов по географии
- Просмотр ленты подписок
- Просмотр ленты других путешественников
- Авторизация/аутентификация пользователей

### Нефункциональные требования
- DAU = 10млн
- Аудитория — страны СНГ
- Один пользователь в среднем в день создает:
  - 30 запросов на просмотр постов
  - 5 запросов на создание постов
  - 15 запросов на просмотр комментариев (загружаются по 20 штук)
  - 10 запросов на создание комментариев
- Сезонность - нет
- Все данные храним всегда
- Лимиты
  - Публикация поста: ~2сек
  - Просмотр ленты: ~1сек
  - Фотография (1шт): ~500Kb
  - Длина описания(max): 200 символов
  - Количество фотографий к посту(max): 5 шт
  - Количество подписчиков(max): 10тыс
  - Количество комментариев(max): 1тыс
  - Количество постов к локации(max): 5тыс

#Таблицы

Posts
```
id integer 8b
user_id integer 8b
description string 2Kb
photo []string [url, len(5)] 10kB
location {longitude, latitude float64} 40Kb
created_at timestamp 8b
updated_at timestamp 8b

total: 55Kb
```

Comments
```
id integer 8b
post_id integer 8b
user_id integer 8b
text string 2kB
created_at timestamp 8b
updated_at timestamp 8b

total: 3Kb
```

Reactions
```
id integer 8b
post_id integer 8b
user_id integer 8b
created_at timestamp 8b
updated_at timestamp 8b

total: 40b
```

Users
```
id integer 8b
avatar string (url) 2Kb
username string 2Kb
email string 2Kb
phone string 2Kb
description string 2Kb
created_at timestamp 8b
updated_at timestamp 8b

total: 11Kb
```

Subscribers
```
user_id integer 8b
subscribe_id integer_8b
created_at timestamp 8b
updated_at timestamp 8b

total: 16b * 1000 (макисмум подписчиков на пользователя) = 16Kb
```


#### Posts:
```
RPS(write): 10 000 000 * 5 / 86 400 = 578
RPS(read):  10 000 000 * 30 / 86 400 = 3473

Traffic(write): 578 * 55Kb = 32Mb/s
Traffic(read):  3473 * 55Kb  = 192 Mb/s
```

#### Comments:
```
RPS(write): 10 000 000 * 10 / 86 400 = 1158
RPS(read):  10 000 000 * 15 / 86 400 = 1737

#### Traffic(write): 1158 * 3Kb = 3,5 Mb/s
Traffic(read):  3473 * 3Kb = 10 Mb/s
```