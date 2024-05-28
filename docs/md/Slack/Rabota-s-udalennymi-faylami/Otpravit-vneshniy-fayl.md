﻿---
sidebar_position: 4
---

# Отправить внешний файл
 Отправляет внейшний файл по списку каналов


*Функция ОтправитьВнешнийФайл(Знач Токен, Знач ИдентификаторФайла, Знач МассивКаналов) Экспорт*

  | Параметр | CLI опция | Тип | Назначение |
  |-|-|-|-|
  | Токен | --token | Строка | Токен бота |
  | ИдентификаторФайла | --fileid | Строка | Идентификатор файла |
  | МассивКаналов | --channels | Массив Из Строка | Массив каналов для отправки |

  
  Вовзращаемое значение:   Соответствие Из КлючИЗначение - сериализованный JSON ответа от Slack

```bsl title="Пример кода"
	

	
```

```sh title="Пример команд CLI"
    
  oint slack ОтправитьВнешнийФайл --token %token% --fileid %fileid% --channels %channels%

```


```json title="Результат"



```