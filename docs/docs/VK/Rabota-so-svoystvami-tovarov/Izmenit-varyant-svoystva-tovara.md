---
sidebar_position: 6
---

# Изменить вариант свойства товара
Изменяет значение варианта свойства товара

*Функция ИзменитьВариантСвойстваТовара(Знач Значение, Знач Свойство, Знач Вариант, Знач Параметры = "") Экспорт*

  | Параметр | Тип | Назначение |
  |-|-|-|
  | Значение | Строка | Значение свойства|
  | Свойство | Число, Строка | ID свойства изменяемого варианта |
  | Вариант | Число, Строка | ID изменяемого варианта|
  | Параметры | Структура (необяз.) | Параметры / перезапись стандартных параметров (см. [Получение необходимых данных](../)) |
  
  Вовзращаемое значение: Соответствие - сериализованный JSON ответа от VK

```bsl title="Пример кода"
	
    Ответ = OPI_VK.ИзменитьВариантСвойстваТовара("Желтый", 260, 980 Параметры);       
    Ответ = OPI_Инструменты.JSONСтрокой(Ответ);

```

```json title="Результат"

{
 "response": 1
}

```