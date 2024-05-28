---
sidebar_position: 3
---

# Создать комментарий
Создает комментарий к файлу или каталогу

*Функция СоздатьКомментарий(Знач Токен, Знач Идентификатор, Знач Комментарий) Экспорт*

  | Параметр | CLI опция | Тип | Назначение |
  |-|-|-|-|
  | Токен | --token | Строка | Токен доступа |
  | Идентификатор | --object | Строка | Идентификатор объекта для комментария |
  | Комментарий | --text | Строка | Текст комментария |
  
  Вовзращаемое значение: Соответствие - сериализованный JSON ответа от Google

```bsl title="Пример кода"
			
    Идентификатор = "1rCyOc4A8VYw7DM3HV55P9BuKWayJOSvW";
    Комментарий   = "Новый комментарий"; 

    Ответ = OPI_GoogleDrive.СоздатьКомментарий(Токен, Идентификатор, Комментарий);  //Соответствие
    Ответ = OPI_Инструменты.JSONСтрокой(Ответ);                                     //Строка

```

```sh title="Пример команд CLI"

    oint google ОбновитьТокен --id %clientid% --secret %clientsecret% --refresh %refreshtoken% > token.json
    oint tools РазложитьJSON --json token.json --name access_token > token.tmp
    set /p token=<token.tmp
    oint gdrive СоздатьКомментарий --token "%token%" --object "1rCyOc4A8VYw7DM3HV55P9BuKWayJOSvW" --text "Новый комментарий"

```

![Результат](img/1.png)

```json title="Результат"

{
 "content": "Новый комментарий",
 "htmlContent": "Новый комментарий",
 "author": {
  "photoLink": "//lh3.googleusercontent.com/a/ACg8ocLx8JGurt0UjXFwwTiB6ZoDPWslW1EnfCTahrwrIllM6Q=s50-c-k-no",
  "me": true,
  "kind": "drive#user",
  "displayName": "Антон Титовец"
 },
 "replies": [],
 "modifiedTime": "2024-03-17T12:53:45.469Z",
 "createdTime": "2024-03-17T12:53:45.469Z",
 "kind": "drive#comment",
 "deleted": false,
 "id": "AAABI3NNNAY"
}

```