﻿Функция ПолучитьСостав() Экспорт

    ТаблицаСостава = Новый ТаблицаЗначений();
    ТаблицаСостава.Колонки.Добавить("Библиотека");
    ТаблицаСостава.Колонки.Добавить("Модуль");
    ТаблицаСостава.Колонки.Добавить("Метод");
    ТаблицаСостава.Колонки.Добавить("МетодПоиска");
    ТаблицаСостава.Колонки.Добавить("Параметр");
    ТаблицаСостава.Колонки.Добавить("Описание");
    ТаблицаСостава.Колонки.Добавить("ОписаниеМетода");
    ТаблицаСостава.Колонки.Добавить("Область");

    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "ПолучитьСсылкуАвторизации";
    НоваяСтрока.МетодПоиска = "ПОЛУЧИТЬССЫЛКУАВТОРИЗАЦИИ";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Данные и настройка";
    НоваяСтрока.ОписаниеМетода   = "Формирует ссылку для авторизации через браузер
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "ПолучитьТокен";
    НоваяСтрока.МетодПоиска = "ПОЛУЧИТЬТОКЕН";
    НоваяСтрока.Параметр    = "--code";
    НоваяСтрока.Описание    = "Код, полученный из авторизации См.ПолучитьСсылкуАвторизации";
    НоваяСтрока.Область     = "Данные и настройка";
    НоваяСтрока.ОписаниеМетода   = "Получает токен по коду, полученному при авторизации по ссылке из ПолучитьСсылкуАвторизации
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "ПолучитьТокен";
    НоваяСтрока.МетодПоиска = "ПОЛУЧИТЬТОКЕН";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Данные и настройка";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "ОбновитьТокен";
    НоваяСтрока.МетодПоиска = "ОБНОВИТЬТОКЕН";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Данные и настройка";
    НоваяСтрока.ОписаниеМетода   = "Обновляет v2 токен при помощи refresh_token
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТекстовыйТвит";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТЕКСТОВЫЙТВИТ";
    НоваяСтрока.Параметр    = "--text";
    НоваяСтрока.Описание    = "Текст твита";
    НоваяСтрока.Область     = "Твиты";
    НоваяСтрока.ОписаниеМетода   = "Создает твит без вложений
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТекстовыйТвит";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТЕКСТОВЫЙТВИТ";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитКартинки";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТКАРТИНКИ";
    НоваяСтрока.Параметр    = "--text";
    НоваяСтрока.Описание    = "Текст твита";
    НоваяСтрока.Область     = "Твиты";
    НоваяСтрока.ОписаниеМетода   = "Создает твит с картинкой вложением
    |
    |    Пример указания параметра типа массив:
    |    --param ""['Val1','Val2','Val3']""
    |
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитКартинки";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТКАРТИНКИ";
    НоваяСтрока.Параметр    = "--pictures";
    НоваяСтрока.Описание    = "Массив файлов картинок";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитКартинки";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТКАРТИНКИ";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитГифки";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТГИФКИ";
    НоваяСтрока.Параметр    = "--text";
    НоваяСтрока.Описание    = "Текст твита";
    НоваяСтрока.Область     = "Твиты";
    НоваяСтрока.ОписаниеМетода   = "Создает твит с вложением-гифкой
    |
    |    Пример указания параметра типа массив:
    |    --param ""['Val1','Val2','Val3']""
    |
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитГифки";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТГИФКИ";
    НоваяСтрока.Параметр    = "--gifs";
    НоваяСтрока.Описание    = "Массив файлов гифок";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитГифки";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТГИФКИ";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитВидео";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТВИДЕО";
    НоваяСтрока.Параметр    = "--text";
    НоваяСтрока.Описание    = "Текст твита";
    НоваяСтрока.Область     = "Твиты";
    НоваяСтрока.ОписаниеМетода   = "Создает твит с видеовложением
    |
    |    Пример указания параметра типа массив:
    |    --param ""['Val1','Val2','Val3']""
    |
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитВидео";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТВИДЕО";
    НоваяСтрока.Параметр    = "--videos";
    НоваяСтрока.Описание    = "Массив файлов видео";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитВидео";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТВИДЕО";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитОпрос";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТОПРОС";
    НоваяСтрока.Параметр    = "--text";
    НоваяСтрока.Описание    = "Текст твита";
    НоваяСтрока.Область     = "Твиты";
    НоваяСтрока.ОписаниеМетода   = "Создает твит с опросом
    |
    |    Пример указания параметра типа массив:
    |    --param ""['Val1','Val2','Val3']""
    |
    |
    |    Структура JSON данных авторизации (параметр --auth):
    |    {
    |     ""redirect_uri""            : """",  
    |     ""client_id""               : """",  
    |     ""client_secret""           : """",  
    |     ""access_token""            : """",  
    |     ""refresh_token""           : """",  
    |     ""oauth_token""             : """",  
    |     ""oauth_token_secret""      : """",  
    |     ""oauth_consumer_key""      : """", 
    |     ""oauth_consumer_secret""   : """"  
    |    }
    |";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитОпрос";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТОПРОС";
    НоваяСтрока.Параметр    = "--options";
    НоваяСтрока.Описание    = "Массив вариантов опроса";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитОпрос";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТОПРОС";
    НоваяСтрока.Параметр    = "--duration";
    НоваяСтрока.Описание    = "Длительность опроса";
    НоваяСтрока.Область     = "Твиты";


    НоваяСтрока = ТаблицаСостава.Добавить();
    НоваяСтрока.Библиотека  = "twitter";
    НоваяСтрока.Модуль      = "OPI_Twitter";
    НоваяСтрока.Метод       = "СоздатьТвитОпрос";
    НоваяСтрока.МетодПоиска = "СОЗДАТЬТВИТОПРОС";
    НоваяСтрока.Параметр    = "--auth";
    НоваяСтрока.Описание    = "JSON авторизации или путь к .json (необяз. по ум. - Пустое значение)";
    НоваяСтрока.Область     = "Твиты";

    Возврат ТаблицаСостава;
КонецФункции

