﻿// MIT License

// Copyright (c) 2023 Anton Tsitavets

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
 
// https://github.com/Bayselonarrend/OpenIntegrations

// BSLLS:LatinAndCyrillicSymbolInWord-off
// BSLLS:IncorrectLineBreak-off

// Раскомментировать, если выполняется OneScript
#Использовать "../../tools"

#Область ПрограммныйИнтерфейс

#Область НастройкиИИнформация

// Установить Webhook
// ВАЖНО: Установка Webhook обязательна по правилам Viber. Для этого надо иметь свободный URL,
// который будет возвращать 200 и подлинный SSL сертификат. Если есть сертификат и база опубликована
// на сервере - можно использовать http-сервис. Туда же будет приходить и информация о новых сообщениях
// Viber периодически стучит по адресу Webhook, так что если он будет неактивен, то все перестанет работать
// 
// Параметры:
//  Токен - Строка - Токен Viber               - token
//  URL   - Строка - URL для установки Webhook - url
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция УстановитьWebhook(Знач Токен, Знач URL) Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Токен);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(URL);
    
    СтруктураПараметров = Новый Структура;
    СтруктураПараметров.Вставить("url"       , URL);
    СтруктураПараметров.Вставить("auth_token", Токен);
    
    Возврат OPI_Инструменты.Post("https://chatapi.viber.com/pa/set_webhook"
        , СтруктураПараметров);
    
КонецФункции

// Получить информацию о канале
// Тут можно получить ID пользователей канала. ID для бота необходимо получать из прилетов на Webhook
// ID пользователя из информации о канале не подойдет для отправки сообщений через бота - они разные
// 
// Параметры:
//  Токен - Строка - Токен - token
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ПолучитьИнформациюОКанале(Знач Токен) Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Токен);
    
    URL = "https://chatapi.viber.com/pa/get_account_info";   
    Возврат OPI_Инструменты.Get(URL, , ТокенВЗаголовки(Токен));
    
КонецФункции

// Получить данные пользователя
// Получает информацию о пользователе по ID
// 
// Параметры:
//  Токен          - Строка        - Токен                 - token
//  IDПользователя - Строка, Число - ID пользователя Viber - user
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ПолучитьДанныеПользователя(Знач Токен, Знач IDПользователя) Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Токен);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(IDПользователя);
    
    URL = "https://chatapi.viber.com/pa/get_user_details";
    
    СтруктураПараметров = Новый Структура;
    СтруктураПараметров.Вставить("id", IDПользователя);
    
    Ответ = OPI_Инструменты.Post(URL, СтруктураПараметров, ТокенВЗаголовки(Токен));

    Попытка
        Возврат OPI_Инструменты.JsonВСтруктуру(Ответ.ПолучитьТелоКакДвоичныеДанные());
    Исключение
        Возврат Ответ;
    КонецПопытки;
        
КонецФункции

// Получить онлайн пользователей
// Получает статус пользователя или нескольких пользователей по ID
// 
// Пример строки массива картинок:
// --users ""['1111111', '2222222']""
// 
// Параметры:
//  Токен           - Строка                              - Токен Viber                - token
//  IDПользователей - Строка,Число,Массив из Строка,Число - ID пользователей(я) Viber  - users
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ПолучитьОнлайнПользователей(Знач Токен, Знач IDПользователей) Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Токен);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(IDПользователей);
    
    URL = "https://chatapi.viber.com/pa/get_online";
    
    Если Не ТипЗнч(IDПользователей) = Тип("Массив") Тогда
        
        ОдиночныйID     = IDПользователей;
        IDПользователей = Новый Массив;
        IDПользователей.Добавить(ОдиночныйID);
        
    КонецЕсли;
    
    СтруктураПараметров = Новый Структура;
    СтруктураПараметров.Вставить("ids", IDПользователей);
    
    Ответ = OPI_Инструменты.Post(URL, СтруктураПараметров, ТокенВЗаголовки(Токен));
    
    Попытка
        Возврат OPI_Инструменты.JsonВСтруктуру(Ответ.ПолучитьТелоКакДвоичныеДанные());
    Исключение
        Возврат Ответ;
    КонецПопытки;

КонецФункции

#КонецОбласти

#Область ОтправкаСообщений

// Отправить текстовое сообщение
// Отправляет текстовое сообщение в чат или канал
// 
// Параметры:
//  Токен          - Строка       - Токен                                                               - token
//  Текст          - Строка       - Текст сообщения                                                     - text
//  IDПользователя - Строка,Число - ID пользователя. Для канала > администратора, для бота > получателя - user
//  ОтправкаВКанал - Булево       - Отправка в канал или в чат бота                                     - ischannel
//  Клавиатура     - Структура из Строка -  См. СформироватьКлавиатуруИзМассиваКнопок - keyboard
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ОтправитьТекстовоеСообщение(Знач Токен
    , Знач Текст
    , Знач IDПользователя
    , Знач ОтправкаВКанал
    , Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьСообщение(Токен, "text", IDПользователя, ОтправкаВКанал, , Текст, Клавиатура); 
    
КонецФункции

// Отправить картинку
// Отправляет картинку в чат или канал
// 
// Параметры:
//  Токен          - Строка       - Токен                                                                - token
//  URL            - Строка       - URL картинки                                                         - picture
//  IDПользователя - Строка,Число - ID пользователя. Для канала > администратора, для бота > получателя  - user
//  ОтправкаВКанал - булево       - Отправка в канал или в чат бота                                      - ischannel
//  Описание       - Строка       - Аннотация к картинке                                                 - description
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ОтправитьКартинку(Знач Токен, Знач URL, Знач IDПользователя, Знач ОтправкаВКанал, Знач Описание = "") Экспорт
    
    Возврат ОтправитьСообщение(Токен, "picture", IDПользователя, ОтправкаВКанал, URL, Описание);
    
КонецФункции

// Отправить файл
// Отправляет файл (документ) в чат или канал
// 
// Параметры:
//  Токен          - Строка       - Токен                                                                - token
//  URL            - Строка       - URL файла                                                            - file 
//  IDПользователя - Строка,Число - ID пользователя. Для канала > администратора, для бота > получателя  - user   
//  ОтправкаВКанал - Булево       - Отправка в канал или в чат бота                                      - ischannel
//  Расширение     - Строка       - Расширение файла                                                     - ext
//  Размер         - Число        - Размер файла. Если не заполнен > определяется автоматически скачиванием файла - size
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ОтправитьФайл(Знач Токен
    , Знач URL
    , Знач IDПользователя
    , Знач ОтправкаВКанал
    , Знач Расширение
    , Знач Размер = "") Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(URL);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Расширение);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Размер);
    
    Если Не ЗначениеЗаполнено(Размер) Тогда
        
        Ответ = OPI_Инструменты.Get(URL);
        ИВФ   = ПолучитьИмяВременногоФайла(Расширение);
        Ответ.Записать(ИВФ);

        ВремФайл    = Новый Файл(ИВФ);
        Размер      = ВремФайл.Размер();
        УдалитьФайлы(ИВФ);
        
    КонецЕсли;
    
    Расширение = СтрЗаменить(Расширение, ".", "");
    
    СтруктураЗначения = Новый Структура;
    СтруктураЗначения.Вставить("URL"        , URL);
    СтруктураЗначения.Вставить("Размер"     , Размер);
    СтруктураЗначения.Вставить("Расширение" , Расширение);
    
    Возврат ОтправитьСообщение(Токен, "file", IDПользователя, ОтправкаВКанал, СтруктураЗначения);
    
КонецФункции

// Отправить контакт
// Отправляет контакт с номером телефона в чат или канал
// 
// Параметры:
//  Токен          - Строка       - Токен                                                                - token
//  ИмяКонтакта    - Строка       - Имя контакта                                                         - name
//  НомерТелефона  - Строка       - Номер телефона                                                       - phone
//  IDПользователя - Строка,Число - ID пользователя. Для канала > администратора, для бота > получателя  - user  
//  ОтправкаВКанал - Булево       - Отправка в канал или в чат бота                                      - ischannel
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ОтправитьКонтакт(Знач Токен
    , Знач ИмяКонтакта
    , Знач НомерТелефона
    , Знач IDПользователя
    , Знач ОтправкаВКанал) Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(ИмяКонтакта);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(НомерТелефона);
    
    СтруктураКонтакта = Новый Структура;
    СтруктураКонтакта.Вставить("name", ИмяКонтакта);
    СтруктураКонтакта.Вставить("phone_number", НомерТелефона);
    
    Возврат ОтправитьСообщение(Токен, "contact", IDПользователя, ОтправкаВКанал, СтруктураКонтакта); 
    
КонецФункции

// Отправить локацию
// Отправляет географические координаты в чат или канал
// 
// Параметры:
//  Токен          - Строка       - Токен                                                                - token
//  Широта         - Строка,Число - Географическая широта                                                - lat
//  Долгота        - Строка,Число - Географическая долгота                                               - long
//  IDПользователя - Строка,Число - ID пользователя. Для канала > администратора, для бота > получателя  - user  
//  ОтправкаВКанал - Булево       - Отправка в канал или в чат бота                                      - ischannel
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ОтправитьЛокацию(Знач Токен, Знач Широта, Знач Долгота, Знач IDПользователя, Знач ОтправкаВКанал) Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Широта);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Долгота);
    
    СтруктураЛокации = Новый Структура;
    СтруктураЛокации.Вставить("lat", Широта);
    СтруктураЛокации.Вставить("lon", Долгота);
    
    Возврат ОтправитьСообщение(Токен, "location", IDПользователя, ОтправкаВКанал, СтруктураЛокации);
    
КонецФункции

// Отправить ссылку
// Отправляет URL с предпросмотром в чат или канал
// 
// Параметры:
//  Токен          - Строка       - Токен                                                                - token
//  URL            - Строка       - Отправляемая ссылка                                                  - url
//  IDПользователя - Строка,Число - ID пользователя. Для канала > администратора, для бота > получателя  - user  
//  ОтправкаВКанал - Булево       - Отправка в канал или в чат бота                                      - ischannel
// 
// Возвращаемое значение:
//  Соответствие Из КлючИЗначение - сериализованный JSON ответа от Viber
Функция ОтправитьСсылку(Знач Токен, Знач URL, Знач IDПользователя, Знач ОтправкаВКанал) Экспорт
    
    Возврат ОтправитьСообщение(Токен, "url", IDПользователя, ОтправкаВКанал, URL);
    
КонецФункции

// Сформировать клавиатуру из массива кнопок
// Возвращает структура клавиатуры для сообщений
// 
// Параметры:
//  МассивКнопок - Массив из Строка - Массив кнопок                - buttons
//  ЦветКнопок   - Строка           - HEX цвет кнопок с # в начале - color
// 
// Возвращаемое значение:
//  Структура -  Сформировать клавиатуру из массива кнопок:
// * Buttons - Массив из Структура - Массив сформированных кнопок 
// * Type - Строка - Тип клавиатуры 
Функция СформироватьКлавиатуруИзМассиваКнопок(Знач МассивКнопок, Знач ЦветКнопок = "") Экспорт
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(ЦветКнопок);
    OPI_ПреобразованиеТипов.ПолучитьКоллекцию(МассивКнопок);
    
    МассивСтруктурКнопок = Новый Массив;
    СтруктураКлавиатуры  = Новый Структура;
    ЦветКнопок           = ?(ЗначениеЗаполнено(ЦветКнопок), ЦветКнопок, "#2db9b9");
    
    Для Каждого ТекстКнопки Из МассивКнопок Цикл
        
        СтруктураКнопки = Новый Структура;
        СтруктураКнопки.Вставить("ActionType", "reply");
        СтруктураКнопки.Вставить("ActionBody", ТекстКнопки);
        СтруктураКнопки.Вставить("Text"      , ТекстКнопки);
        СтруктураКнопки.Вставить("BgColor"   , ЦветКнопок);
        СтруктураКнопки.Вставить("Coloumns"  , 3);
    
        МассивСтруктурКнопок.Добавить(СтруктураКнопки);
        
    КонецЦикла;
    
    СтруктураКлавиатуры.Вставить("Buttons", МассивСтруктурКнопок);
    СтруктураКлавиатуры.Вставить("Type"   , "keyboard");
    
    Возврат СтруктураКлавиатуры;
    
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Отправить сообщение.
// 
// Параметры:
//  Токен - Строка - Токен
//  Тип - Строка -  Тип отправляемого сообщения
//  IDПользователя - Строка,Число - ID пользователя Viber
//  ЭтоКанал - Булево - Отправка в канал или чат с ботом
//  Значение - Строка, Структура -  Значение:
// * URL - Строка - При отправке  URL
// * Размер - Число, Строка - Размер файла в случае отправке
// * Расширение - Строка - Расширение файла в случае отправки
//  Текст - Строка -  Текст сообщения
//  Клавиатура - Структура из Строка -  Клавиатура, если нужна, см. СформироватьКлавиатуруИзМассиваКнопок 
// 
// Возвращаемое значение:
//  Произвольный, HTTPОтвет -  Отправить сообщение
Функция ОтправитьСообщение(Знач Токен
    , Знач Тип
    , Знач IDПользователя
    , Знач ЭтоКанал
    , Знач Значение = ""
    , Знач Текст = ""
    , Знач Клавиатура = "")
    
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Токен);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Тип);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(IDПользователя);
    OPI_ПреобразованиеТипов.ПолучитьСтроку(Текст);
    OPI_ПреобразованиеТипов.ПолучитьБулево(ЭтоКанал);
    OPI_ПреобразованиеТипов.ПолучитьКоллекцию(Клавиатура);
    
    СтруктураПараметров = ВернутьСтандартныеПараметры();
    СтруктураПараметров.Вставить("type", Тип);  
    
    Если (Тип = "text" Или Тип = "picture") И ЗначениеЗаполнено(Текст) Тогда
        СтруктураПараметров.Вставить("text", Текст);
    КонецЕсли;
    
    Если ТипЗнч(Клавиатура) = Тип("Структура") Тогда
        СтруктураПараметров.Вставить("keyboard", Клавиатура);
    КонецЕсли;
    
    Если ЗначениеЗаполнено(Значение) Тогда
        
        Если Тип = "file" Тогда
            СтруктураПараметров.Вставить("media"    , Значение["URL"]);
            СтруктураПараметров.Вставить("size"     , Значение["Размер"]);
            СтруктураПараметров.Вставить("file_name", "Файл." + Значение["Расширение"]);
        ИначеЕсли Тип = "contact" Тогда
            СтруктураПараметров.Вставить("contact"  , Значение);
        ИначеЕсли Тип = "location" Тогда
            СтруктураПараметров.Вставить("location" , Значение);
        Иначе
            СтруктураПараметров.Вставить("media"    , Значение);
        КонецЕсли;
        
    КонецЕсли;
    
    Если ЭтоКанал Тогда
        СтруктураПараметров.Вставить("from", IDПользователя);
        URL = "https://chatapi.viber.com/pa/post";
    Иначе   
        СтруктураПараметров.Вставить("receiver", IDПользователя);
        URL = "https://chatapi.viber.com/pa/send_message";
    КонецЕсли;
    
    Ответ = OPI_Инструменты.Post(URL
        , СтруктураПараметров
        , ТокенВЗаголовки(Токен));
    
    Попытка
        Возврат OPI_Инструменты.JsonВСтруктуру(Ответ.ПолучитьТелоКакДвоичныеДанные());
    Исключение
        Возврат Ответ;
    КонецПопытки;
    
КонецФункции

Функция ВернутьСтандартныеПараметры() 
    
    СтруктураОтправителя = Новый Структура;
    СтруктураОтправителя.Вставить("name"  , "Bot");
    СтруктураОтправителя.Вставить("avatar", "");
    
    СтруктураПараметров  = Новый Структура;
    СтруктураПараметров.Вставить("sender", СтруктураОтправителя);
    СтруктураПараметров.Вставить("min_api_version", 1);
    
    Возврат СтруктураПараметров;
    
КонецФункции

Функция ТокенВЗаголовки(Знач Токен)
    
    СтруктураЗаголовков = Новый Соответствие;
    СтруктураЗаголовков.Вставить("X-Viber-Auth-Token", Токен);
    Возврат СтруктураЗаголовков;
    
КонецФункции

#КонецОбласти
