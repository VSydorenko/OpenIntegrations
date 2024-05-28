﻿---
sidebar_position: 3
---

# Изменить свойства базы
 Изменяет свойства существующей базы


*Функция ИзменитьСвойстваБазы(Знач Токен, Знач База, Знач Свойства = "", Знач Заголовок = "", Знач Описание = "") Экспорт*

  | Параметр | CLI опция | Тип | Назначение |
  |-|-|-|-|
  | Токен | --token | Строка | Токен |
  | База | --base | Строка | ID целевой базы |
  | Свойства | --props | Соответствие из КлючИЗначение | Новые или изменяемые свойства базы данных |
  | Заголовок | --title | Строка | Новый заголовок базы |
  | Описание | --description | Строка | Новое описание базы |

  
  Вовзращаемое значение:   Соответствие Из КлючИЗначение - сериализованный JSON ответа от Notion

```bsl title="Пример кода"
	

	
```

```sh title="Пример команд CLI"
    
  oint notion ИзменитьСвойстваБазы --token %token% --base %base% --props %props% --title %title% --description %description%

```


```json title="Результат"



```