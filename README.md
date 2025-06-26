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
  - 20 запросов на оставление реакции
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

Capacity: 230Mb/s * 86 400 * 365 = 7 253 280 000 Мб = 7 253 280 Гб = 7 253 Тб

Disk:

SSD:
Cap: 7 253 / 100 = 73 диска
Throughput: 230 Мб/с / 500 Мб/с = 1 диск
iops = 4000 / 1000 = 4 диска
max: 73 диска

HDD:
Cap: 7 253 / 32 = 227 диска
Throughput: 230 Мб/с / 100 Мб/с = 3 диска
iops = 4000 / 100 = 40 дисков
max: 227 диска

Вывод: HDD дисков требуется в 3 раза больше чем SSD. Если нет возможности закупить SSD, HDD будет приемлимо
```

#### Comments:
```
RPS(write): 10 000 000 * 10 / 86 400 = 1158
RPS(read):  10 000 000 * 15 / 86 400 = 1737

Traffic(write): 1158 * 3Kb = 3,5 Mb/s
Traffic(read):  3473 * 3Kb = 10 Mb/s

Capacity: 15Mb/s * 86 400 * 365 = 473 040 000 Мб = 473 040 Гб = 473 Тб

Disk:

SSD:
Cap: 473 / 100 = 5 дисков
Throughput: 15Мб/с / 500 = 1 диск
iops: 3000(rps) / 1000 = 3 диска
max: 5 дисков

HDD: 
Cap: 473 / 32 = 15 дисков
Throughput: 15Мб/с / 100 Мб/с = 1 диск
iops: 3000(rps) / 100 = 30 дисков
max: 30 дисков

Вывод: HDD дисков требуется больше в 6 раз, лучше выбрать SSD.
```

#### Reactions:
```
RPS(write): 10 000 000 * 20 / 86 400 = 2315

Traffic(write): 2315 * 40Kb = 93 Kb/s
```

Capacity: 93Kb/s * 86 400 * 365 = 2 932 848 Мб = 2 933 Гб = 3 Тб

Disk: 

SSD:
Cap: 3 / 100 = 1 диск
Throughput: 93 Kb/s / 500 Мб/с = 1 диск
iops: 2315 / 1000 = 3 диска
max: 3 диска

HDD:
Cap: 3 / 32 = 1 диск
Throughput: 93 Kb/s / 100 Мб/с = 1 диск
iops: 2315 / 100 = 24 диска
max: 24 диска

Вывод: HDD дисков требуется в 7 раз больше, лучше выбрать SSD.