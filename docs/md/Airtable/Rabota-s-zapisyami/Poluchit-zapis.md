﻿---
sidebar_position: 2
---

# Получить запись
 Получает данные строки таблицы по идентификатору


*Функция ПолучитьЗапись(Знач Токен, Знач База, Знач Таблица, Знач Запись) Экспорт*

  | Параметр | CLI опция | Тип | Назначение |
  |-|-|-|-|
  | Токен | --token | Строка | Токен |
  | База | --base | Строка | Идентификатор базы данных |
  | Таблица | --table | Строка | Идентификатор таблицы |
  | Запись | --record | Строка | Идентификатор записи в таблице |

  
  Вовзращаемое значение:   Соответствие Из КлючИЗначение - сериализованный JSON ответа от Airtable

```bsl title="Пример кода"
	

	
```

```sh title="Пример команд CLI"
    
  oint airtable ПолучитьЗапись --token %token% --base %base% --table %table% --record %record%

```


```json title="Результат"



```