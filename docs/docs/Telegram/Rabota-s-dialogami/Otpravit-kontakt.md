---
sidebar_position: 9
---

# Отправить контакт
Отправляет контакт с именем и номером телефона


*Функция ОтправитьКонтакт(Знач Токен, Знач IDЧата, Знач Имя, Знач Фамилия, Знач Телефон, Знач Клавиатура = "") Экспорт*

  | Параметр | Тип | Назначение |
  |-|-|-|
  | Токен | Строка | Токен бота |
  | IDЧата | Строка/Число | ID целевого чата |
  | Имя | Строка | Имя контакта |
  | Фамилия | Строка | Фамилия контакта |
  | Телефон | Строка | Номер телефона |
  | Клавиатура | Строка (необяз.) | JSON клавиатуры. См. [Сформировать клавиатуру по массиву кнопок](./Sformirovat-klaviaturu-po-massivu-knopok) |
  
  Вовзращаемое значение: Соответствие - сериализованный JSON ответа от Telegram


```bsl title="Пример кода"
	
	Токен = "111111111:AACccNYOAFbuhAL5GAaaBbbbOjZYFvLZZZZ";
	
	Ответ = OPI_Telegram.ОтправитьКонтакт(Токен, 1234567890, "Петр", "Петров", "123123123")  //Соответствие
	Ответ = OPI_Инструменты.JSONСтрокой(Ответ);                                              //JSON строка
	
```

![Результат](img/12.png)

```json title="Результат"

{
 "result": {
  "contact": {
   "last_name": "Петров",
   "first_name": "Петр",
   "phone_number": "123123123"
  },
  "date": 1704549937,
  "chat": {
   "username": "JKIee",
   "type": "private",
   "last_name": "Titowets",
   "first_name": "Anton",
   "id": 1234567890
  },
  "from": {
   "username": "sicheebot",
   "first_name": "Sichee",
   "is_bot": true,
   "id": 0987654321
  },
  "message_id": 30
 },
 "ok": true
}

```