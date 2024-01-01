//MIT License

//Copyright (c) 2023 Anton Tsitavets

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:

//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.

//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#Область ПрограммныйИнтерфейс

#Область ПолучениеТокена

// Получение ссылки для интерактивного получения токена (access_token), который необходим
// для дальнейших действий
// 
// Параметры:
//  app_id - Строка,Число - app_id из настроек приложения
// 
// Возвращаемое значение:
// Строка - URL, по которому необходимо перейти в браузере 
Функция СоздатьСсылкуПолученияТокена(Знач App_id) Экспорт
    
    //access_token нужно будет забрать из параметра в строке адреса браузера
    Возврат "https://oauth.vk.com/authorize?client_id=" + OPI_Инструменты.ЧислоВСтроку(App_id)
        + "&scope=offline,wall,groups,photos,stats,stories,ads"
        + "&v=5.131&response_type=token&redirect_uri=https://api.vk.com/blank.html";
        
КонецФункции
 
#КонецОбласти

#Область РаботаСГруппой

// Создать пост.
// 
// Параметры:
//  Текст - Строка - Текст
//  МассивКартинок - Массив из Строка,ДвоичныеДанные - Массив картинок
//  Рекламный - Булево -  Признак "Это реклама"
//  СсылкаПодЗаписью - Строка -  Ссылка под записью, если нужна
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СоздатьПост(Знач Текст
	, Знач МассивКартинок
	, Знач Рекламный = Ложь
	, Знач СсылкаПодЗаписью = ""
	, Знач Параметры = "") Экспорт
        
    Параметры_      = ПолучитьСтандартныеПараметры(Параметры);
    СтрокаВложений  = "";    
        
    Для Каждого КартинкаПоста Из МассивКартинок Цикл
        
        Файлы = Новый Соответствие;
        
        Если ТипЗнч(КартинкаПоста) = Тип("Строка") Тогда
            КлючКартинка        = СтрЗаменить(КартинкаПоста, ".", "___");
            ЗначениеКартинка    = Новый ДвоичныеДанные(КартинкаПоста);
        Иначе
            //@skip-check missing-temporary-file-deletion
            КлючКартинка        = СтрЗаменить(ПолучитьИмяВременногоФайла("jpeg"), ".", "___");
            ЗначениеКартинка    = КартинкаПоста;
        КонецЕсли;
            
        
        Файлы.Вставить(КлючКартинка, ЗначениеКартинка);
        
        Ответ     = OPI_Инструменты.Get("api.vk.com/method/photos.getWallUploadServer", Параметры_);
        URL       = Ответ["response"]["upload_url"];
        
        Параметры_.Вставить("upload_url", URL);
                
        Ответ        = OPI_Инструменты.Post(URL, Параметры_, Файлы);
        СерверФото   = OPI_Инструменты.ЧислоВСтроку(Ответ["server"]);
        
        Параметры_.Вставить("hash"        , Ответ["hash"]);
        Параметры_.Вставить("photo"       , Ответ["photo"]);
        Параметры_.Вставить("server"      , СерверФото);
        
        Ответ                  = OPI_Инструменты.Get("api.vk.com/method/photos.saveWallPhoto", Параметры_);
        ОтветСоответствие      = Ответ.Получить("response")[0];
        
        Параметры_.Удалить("hash");
        Параметры_.Удалить("photo");
        Параметры_.Удалить("server");
        
        ФотоID = "photo" 
        +  OPI_Инструменты.ЧислоВСтроку(ОтветСоответствие.Получить("owner_id"))
        + "_" 
        +     OPI_Инструменты.ЧислоВСтроку(ОтветСоответствие.Получить("id"));
        
        СтрокаВложений = СтрокаВложений + ФотоID + ",";
        
    КонецЦикла;

    СтрокаВложений = СтрокаВложений + СсылкаПодЗаписью;
    
    Параметры_.Вставить("message"            , Текст);
    Параметры_.Вставить("attachments"        , СтрокаВложений);
    Параметры_.Вставить("mark_as_ads"        , ?(Рекламный, 1, 0));
    Параметры_.Вставить("close_comments"     , ?(Рекламный, 1, 0));

    Ответ = OPI_Инструменты.Get("api.vk.com/method/wall.post", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Удалить пост.
// 
// Параметры:
//  IDПоста - Строка,Число - ID поста
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция УдалитьПост(Знач IDПоста, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);    
    Параметры_.Вставить("post_id", OPI_Инструменты.ЧислоВСтроку(IDПоста));
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/wall.delete", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Создать опрос.
// 
// Параметры:
//  Вопрос - Строка - Вопрос опроса
//  МассивОтветов - Массив из Строка - Массив вариантов ответа
//  Картинка - Строка,ДвоичныеДанные -  Картинка опроса
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СоздатьОпрос(Знач Вопрос, Знач МассивОтветов, Знач Картинка = "", Знач Параметры = "") Экспорт
    
    Параметры_    = ПолучитьСтандартныеПараметры(Параметры);
    Ответ         = OPI_Инструменты.Get("api.vk.com/method/polls.getPhotoUploadServer", Параметры_);
    URL           = Ответ["response"]["upload_url"];  
	IDФото		  = "";
    
    Параметры_.Вставить("upload_url", URL);

    Если Не Картинка = "" Тогда
        
		Если ТипЗнч(Картинка) = Тип("Строка") Тогда
			Путь        = Картинка;
			Картинка    = Новый ДвоичныеДанные(Картинка);
		Иначе
			//@skip-check missing-temporary-file-deletion
			Путь        = ПолучитьИмяВременногоФайла("jpeg");
		КонецЕсли;
		
		Файлы = Новый Соответствие;
		Файлы.Вставить(Путь, Картинка);
		
		Ответ = OPI_Инструменты.Post(URL, Параметры_, Файлы);
		
		Параметры_.Вставить("hash"         , Ответ["hash"]);
		Параметры_.Вставить("photo"        , Ответ["photo"]);
		
		Ответ       = OPI_Инструменты.Get("api.vk.com/method/polls.savePhoto", Параметры_);
		IDФото      = Ответ.Получить("response")["id"];
	
	КонецЕсли;
	
    Параметры_.Вставить("is_anonymous"    , 1);
    Параметры_.Вставить("is_multiple"     , 0);
        
    Ответы     = "[";
    Первый     = Истина;
    
    Для Каждого Ответ Из МассивОтветов Цикл
        
        Если Первый Тогда 
            Первый = Ложь 
        Иначе 
            Ответы = Ответы + ", "; 
        КонецЕсли;
        
        Ответы = Ответы + """"+ Ответ + """";
        
    КонецЦикла;
    
    Ответы = Ответы + "]";
    
    Параметры_.Вставить("add_answers"     , Ответы);
    Параметры_.Вставить("photo_id"        , OPI_Инструменты.ЧислоВСтроку(IDФото));
    Параметры_.Вставить("question"        , Вопрос);
    
    Опрос                 = OPI_Инструменты.Get("api.vk.com/method/polls.create", Параметры_);
    ОпросСоответствие     = Опрос.Получить("response");
    
    ОпросID = "poll"
    + OPI_Инструменты.ЧислоВСтроку(ОпросСоответствие.Получить("owner_id"))
    + "_" 
    + OPI_Инструменты.ЧислоВСтроку(ОпросСоответствие.Получить("id"));

    
    Параметры_.Вставить("attachments", ОпросID);
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/wall.post", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Создать альбом.
// 
// Параметры:
//  Наименование - Строка - Наименование альбома
//  Описание - Строка -  Описание альбома
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СоздатьАльбом(Знач Наименование, Знач Описание = "", Знач Параметры = "") Экспорт
    
    Параметры_      = ПолучитьСтандартныеПараметры(Параметры);
    
    Параметры_.Вставить("title"                , Наименование);
    Параметры_.Вставить("description"          , Описание);
    Параметры_.Вставить("upload_by_admins_only", 1);
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/photos.createAlbum", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Создать историю.
// 
// Параметры:
//  Картинка - Строка,ДвоичныеДанные - Фон истории
//  URL - Строка -  URL для кнопки под историей
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СоздатьИсторию(Знач Картинка, Знач URL = "", Знач Параметры = "") Экспорт
        
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("link_text"        , "more");
    Параметры_.Вставить("link_url"         , URL);
    Параметры_.Вставить("add_to_news"      , "1");
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/stories.getPhotoUploadServer", Параметры_);    
    URL      = Ответ["response"]["upload_url"];
        
    Параметры_.Вставить("upload_url", URL);
    
    Если ТипЗнч(Картинка) = Тип("Строка") Тогда
        Путь        = Картинка;
        Картинка    = Новый ДвоичныеДанные(Картинка);
    Иначе
        //@skip-check missing-temporary-file-deletion
        Путь        = ПолучитьИмяВременногоФайла("jpeg");
    КонецЕсли;

    
    Файлы = Новый Соответствие;
    Файлы.Вставить(Путь, Картинка);

    Ответ = OPI_Инструменты.Post(URL, Параметры_, Файлы);    
    Параметры_.Вставить("upload_results", Ответ["response"]["upload_result"]);
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/stories.save", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Сохранить картинку в альбом.
// 
// Параметры:
//  IDАльбома - Строка,Число - ID альбома
//  Картинка - ДвоичныеДанные,Строка - Двоичные данные или путь к картинке
//  Описание - Строка -  Описание картинки
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СохранитьКартинкуВАльбом(Знач IDАльбома, Знач Картинка, Знач Описание = "", Знач Параметры = "") Экспорт
    
    Параметры_      = ПолучитьСтандартныеПараметры(Параметры);
    
    Параметры_.Вставить("album_id"        , OPI_Инструменты.ЧислоВСтроку(IDАльбома));
    Параметры_.Вставить("caption"         , Описание);
    
    Ответ     = OPI_Инструменты.Get("api.vk.com/method/photos.getUploadServer", Параметры_);
    URL       = Ответ["response"]["upload_url"];
    
    Если ТипЗнч(Картинка) = Тип("Строка") Тогда
        Путь        = Картинка;
        Картинка    = Новый ДвоичныеДанные(Картинка);
    Иначе
        //@skip-check missing-temporary-file-deletion
        Путь        = ПолучитьИмяВременногоФайла("jpeg");
    КонецЕсли;

    
    Файлы = Новый Соответствие;
    Файлы.Вставить(Путь, Картинка);

    ОтветАльбома = OPI_Инструменты.Post(URL, Параметры_, Файлы);    

    Параметры_.Вставить("server"          , OPI_Инструменты.ЧислоВСтроку(ОтветАльбома["server"]));
    Параметры_.Вставить("photos_list"     , ОтветАльбома["photos_list"]);
    Параметры_.Вставить("hash"            , ОтветАльбома["hash"]);
    Параметры_.Вставить("aid"             , ОтветАльбома["aid"]);
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/photos.save", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Удалить картинку.
// 
// Параметры:
//  IDКартинки - Строка,Число - ID картинки
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция УдалитьКартинку(Знач IDКартинки, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("photo_id", OPI_Инструменты.ЧислоВСтроку(IDКартинки));
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/photos.delete", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

#КонецОбласти

#Область РаботаСОбсуждениями

// Создать обсуждение.
// 
// Параметры:
//  Наименование - Строка - Наименование обсуждения
//  ТекстПервогоСообщения - Строка - Текст первого сообщения
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СоздатьОбсуждение(Знач Наименование, Знач ТекстПервогоСообщения, Знач Параметры = "") Экспорт
    
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("title"    , Наименование);
    Параметры_.Вставить("text"     , ТекстПервогоСообщения);
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/board.addTopic", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Закрыть обсуждение.
// 
// Параметры:
//  IDОбсуждения - Строка,Число - ID обсуждения
//  УдалитьПолностью - Булево -  Удалить полностью или закрыть (сделать неактивным)
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Закрыть обсуждение
Функция ЗакрытьОбсуждение(Знач IDОбсуждения, Знач УдалитьПолностью = Ложь, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("topic_id", OPI_Инструменты.ЧислоВСтроку(IDОбсуждения));
    
    Метод = ?(УдалитьПолностью, "deleteTopic", "closeTopic");   
    Ответ = OPI_Инструменты.Get("api.vk.com/method/board." + Метод, Параметры_);
    
    Возврат Ответ;

КонецФункции

// Открыть обсуждение.
// 
// Параметры:
//  IDОбсуждения - Строка,Число - ID обсуждения
//  Параметры - Структура из Строка -  См. ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция ОткрытьОбсуждение(Знач IDОбсуждения, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("topic_id", OPI_Инструменты.ЧислоВСтроку(IDОбсуждения));
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/board.openTopic", Параметры_);
    
    Возврат Ответ;

КонецФункции

// Написать в обсуждение.
// 
// Параметры:
//  IDОбсуждения - Строка,Число - ID обсуждения
//  Текст - Строка - Текст сообщения
//  Параметры - Структура из Строка - См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция НаписатьВОбсуждение(Знач IDОбсуждения, Знач Текст, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("topic_id"    , OPI_Инструменты.ЧислоВСтроку(IDОбсуждения));
    Параметры_.Вставить("message"     , Текст);
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/board.createComment", Параметры_);
    
    Возврат Ответ;

КонецФункции

#КонецОбласти

#Область ИнтерактивныеДействия

// Поставить лайк.
// 
// Параметры:
//  IDПоста - Строка,Число - ID поста
//  IDСтены - Строка,Число -  ID стены расположения поста
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция ПоставитьЛайк(Знач IDПоста, Знач IDСтены = "", Знач Параметры = "") Экспорт
    
    Параметры_      = ПолучитьСтандартныеПараметры(Параметры);
    IDСтены         = ?(ЗначениеЗаполнено(IDСтены), IDСтены, Параметры_["group_id"]);
    
    Параметры_.Вставить("type"        , "post");
    Параметры_.Вставить("object"      , "wall" + OPI_Инструменты.ЧислоВСтроку(IDСтены) + "_" + OPI_Инструменты.ЧислоВСтроку(IDПоста));
    Параметры_.Вставить("item_id"     , OPI_Инструменты.ЧислоВСтроку(IDПоста));
    Параметры_.Вставить("owner_id"    , OPI_Инструменты.ЧислоВСтроку(IDСтены));
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/likes.add", Параметры_);
    
    Возврат Ответ;

КонецФункции

// Сделать репост.
// 
// Параметры:
//  IDПоста - Строка,Число - ID поста
//  IDСтены - Строка,Число -  ID стены расположения поста
//  ЦелеваяСтена - Строка,Число -  ID целевой стены/группы
//  Рекламный - Булево -  Признак рекламного поста
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
//@skip-check method-too-many-params
Функция СделатьРепост(Знач IDПоста
	, Знач IDСтены = ""
	, Знач ЦелеваяСтена = ""
	, Знач Рекламный = Ложь
	, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);

    Источник = ?(ЗначениеЗаполнено(IDСтены)     
    	, OPI_Инструменты.ЧислоВСтроку(IDСтены)
    	, OPI_Инструменты.ЧислоВСтроку(Параметры_["owner_id"]));
    	
    Приемник = ?(ЗначениеЗаполнено(ЦелеваяСтена)
    	, СтрЗаменить(OPI_Инструменты.ЧислоВСтроку(ЦелеваяСтена), "-", "")
    	, OPI_Инструменты.ЧислоВСтроку(Параметры_["group_id"]));

    Параметры_.Вставить("object"          , "wall" + Источник + "_" + OPI_Инструменты.ЧислоВСтроку(IDПоста));
    Параметры_.Вставить("group_id"        , Приемник);
    Параметры_.Вставить("mark_as_ads"     , ?(Рекламный, 1, 0));
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/wall.repost", Параметры_);
    
    Возврат Ответ;

КонецФункции

// Написать сообщение.
// 
// Параметры:
//  Текст - Строка - Текст сообщения
//  IDПользователя - Строка - ID пользователя-адресата
//  Communitytoken - Строка - Токен бота чата сообщества, котрый можно получить в настройках
//  Клавиатура - Строка - JSON клавиатуры. См.СформироватьКлавиатуру
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция НаписатьСообщение(Знач Текст
	, Знач IDПользователя
	, Знач Communitytoken
	, Знач Клавиатура = ""
	, Знач Параметры = "") Экспорт
    
    Параметры_  = ПолучитьСтандартныеПараметры(Параметры);
    Параметры_.Вставить("access_token", Communitytoken);
    
    Параметры_.Вставить("user_id"     , OPI_Инструменты.ЧислоВСтроку(IDПользователя));
    Параметры_.Вставить("peer_id"     , OPI_Инструменты.ЧислоВСтроку(IDПользователя));
    Параметры_.Вставить("parse_mode"  , "Markdown"); 
    Параметры_.Вставить("random_id"   , 0);
    Параметры_.Вставить("message"     , Текст);
    
    Если ЗначениеЗаполнено(Клавиатура) Тогда
        Параметры_.Вставить("keyboard", Клавиатура);
    КонецЕсли;
    
    Ответ = OPI_Инструменты.Get("api.vk.com/method/messages.send", Параметры_);
    
    Возврат Ответ;

КонецФункции

// Написать комментарий.
// 
// Параметры:
//  IDПоста - Строка,Число - ID целевого поста
//  IDСтены - Строка,Число -  ID стены расположения поста
//  Текст - Строка - Текст комментария
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера
Функция НаписатьКомментарий(Знач IDПоста, Знач IDСтены, Знач Текст, Знач Параметры = "") Экспорт
    
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);
    
    Параметры_.Вставить("owner_id", OPI_Инструменты.ЧислоВСтроку(IDСтены)); 
    Параметры_.Вставить("from_group" , OPI_Инструменты.ЧислоВСтроку(Параметры_["group_id"]));
    Параметры_.Вставить("post_id"    , OPI_Инструменты.ЧислоВСтроку(IDПоста));
    Параметры_.Вставить("message"    , Текст);
    
    Параметры_.Удалить("group_id");
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/wall.createComment", Параметры_);
    
    Возврат Ответ;

КонецФункции

#КонецОбласти

#Область Статистика

// Получить статистику.
// 
// Параметры:
//  ДатаНачала - Дата - Дата начала периода
//  ДатаОкончания - Дата - Дата окончания периода
//  Параметры - Структура из Строка -  Параметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция ПолучитьСтатистику(Знач ДатаНачала, Знач ДатаОкончания, Знач Параметры = "") Экспорт
    
    Параметры_         = ПолучитьСтандартныеПараметры(Параметры);
    
    ДатаНачала         = Формат(ДатаНачала        - Дата(1970,1,1,1,0,0), "ЧГ=0");
    ДатаОкончания      = Формат(ДатаОкончания     - дата(1970,1,1,1,0,0), "ЧГ=0");
    
    Параметры_.Вставить("timestamp_from"      , ДатаНачала);
    Параметры_.Вставить("timestamp_to"        , ДатаОкончания);
    Параметры_.Вставить("stats_groups"        , "visitors, reach, activity");
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/stats.get", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Получить статистику постов.
// 
// Параметры:
//  МассивIDПостов - Массив из Строка,Число - Массив ID постов
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  Массив из Произвольный -  Массив данных статистики по постам
Функция ПолучитьСтатистикуПостов(Знач МассивIDПостов, Знач Параметры = "") Экспорт
    
    Параметры_       = ПолучитьСтандартныеПараметры(Параметры);
    МассивОтветов    = Новый Массив;
    МассивНабора     = Новый Массив;
    
    Для Каждого Пост Из МассивIDПостов Цикл
        
        МассивНабора.Добавить(OPI_Инструменты.ЧислоВСтроку(Пост));
        
        Если МассивНабора.Количество() = 30 Тогда
            
            СтрокаНомеров = СтрСоединить(МассивНабора, ",");
            Параметры_.Вставить("post_ids", СтрокаНомеров);
            
            Статистика             = OPI_Инструменты.Get("api.vk.com/method/stats.getPostReach", Параметры_);
            МассивСтатистики       = Статистика["response"];
            
            Для Каждого ЭлементСтатистики Из МассивСтатистики Цикл
                МассивОтветов.Добавить(ЭлементСтатистики);
            КонецЦикла;
            
            МассивНабора = Новый Массив
        КонецЕсли;
        
    КонецЦикла;
    
    СтрокаНомеров = СтрСоединить(МассивНабора, ",");
    Параметры_.Вставить("post_ids", СтрокаНомеров);
    
    Статистика             = OPI_Инструменты.Get("api.vk.com/method/stats.getPostReach", Параметры_);
    МассивСтатистики       = Статистика["response"];
    
    Для Каждого ЭлементСтатистики Из МассивСтатистики Цикл
        МассивОтветов.Добавить(ЭлементСтатистики);
    КонецЦикла;

    Возврат МассивОтветов;
    
КонецФункции
        
#КонецОбласти

#Область РаботаСРекламнымКабинетом

// Создать рекламную кампанию.
// 
// Параметры:
//  IDКабинета - Строка,Число - ID рекламного кабинета
//  Наименование - Строка - Наименование кампании
//  Параметры - Структура из Строка - См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера
Функция СоздатьРекламнуюКампанию(Знач IDКабинета, Знач Наименование, Знач Параметры = "") Экспорт
    
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);    
    Параметры_.Вставить("account_id", OPI_Инструменты.ЧислоВСтроку(IDКабинета));
    
    МассивСтруктур = Новый Массив;
    
    СтруктураКампании = Новый Структура;
    СтруктураКампании.Вставить("type"            , "promoted_posts");
    СтруктураКампании.Вставить("name"            , Наименование);
    СтруктураКампании.Вставить("day_limit"       , 0);
    СтруктураКампании.Вставить("all_limit"       , 0);
    СтруктураКампании.Вставить("start_time"      , Формат(ТекущаяДатаСеанса() - Дата(1970,1,1,1,0,0), "ЧГ=0"));
    СтруктураКампании.Вставить("stop_time"       , Формат('2120.01.01' - Дата(1970,1,1,1,0,0), "ЧГ=0"));
    СтруктураКампании.Вставить("status"          , 1);
    
    МассивСтруктур.Добавить(СтруктураКампании);
    
    JSONДата = OPI_Инструменты.JSONСтрокой(МассивСтруктур);
    
    Параметры_.Вставить("data", JSONДата);
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/ads.createCampaigns", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Создать рекламное объявление.
// 
// Параметры:
//  НомерКампании - Строка,Число - ID рекламной кампании
//  ДневнойЛимит - Строка,Число - Дневной лимит в рублях
//  НомерКатегории - Строка,Число - Номер рекламной категории
//  IDПоста - Строка,Число - ID поста, используемого в качетсве рекламы
//  IDКабинета - Строка,Число - ID рекламного кабинета
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция СоздатьРекламноеОбъявление(Знач НомерКампании
	, Знач ДневнойЛимит
	, Знач НомерКатегории
	, Знач IDПоста
	, Знач IDКабинета
	, Знач Параметры = "") Экспорт
    
    Параметры_            = ПолучитьСтандартныеПараметры(Параметры);
    Линк                  = "https://vk.com/wall-" 
    	+ Параметры_["group_id"] 
    	+ "_" 
    	+ OPI_Инструменты.ЧислоВСтроку(IDПоста);
    
    МассивСтруктур        = Новый Массив;    
    СтруктураКампании     = Новый Структура;
    СтруктураКампании.Вставить("campaign_id"                , OPI_Инструменты.ЧислоВСтроку(НомерКампании));
    СтруктураКампании.Вставить("ad_format"                  , 9);
    СтруктураКампании.Вставить("conversion_event_id"        , 1);
    СтруктураКампании.Вставить("autobidding"                , 1);
    СтруктураКампании.Вставить("cost_type"                  , 3);
    СтруктураКампании.Вставить("goal_type"                  , 2);
    СтруктураКампании.Вставить("ad_platform"                , "all");
    СтруктураКампании.Вставить("publisher_platforms"        , "vk");
    СтруктураКампании.Вставить("publisher_platforms_auto"   , "1");
    СтруктураКампании.Вставить("day_limit"                  , OPI_Инструменты.ЧислоВСтроку(ДневнойЛимит));
    СтруктураКампании.Вставить("all_limit"                  , "0");
    СтруктураКампании.Вставить("category1_id"               , OPI_Инструменты.ЧислоВСтроку(НомерКатегории));
    СтруктураКампании.Вставить("age_restriction"            , 0);
    СтруктураКампании.Вставить("status"                     , 1);
    СтруктураКампании.Вставить("name"                       , "Объявление");
    СтруктураКампании.Вставить("link_url"                   , Линк);
    
    МассивСтруктур.Добавить(СтруктураКампании);
    
    JSONДата = OPI_Инструменты.JSONСтрокой(МассивСтруктур);
    
    Параметры_.Вставить("data"        , JSONДата);
    Параметры_.Вставить("account_id"  , OPI_Инструменты.ЧислоВСтроку(IDКабинета));
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/ads.createAds", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Приостановить рекламное объявление.
// 
// Параметры:
//  IDКабинета - Строка,Число - ID рекламного кабинета
//  IDОбъявления - Строка,Число - ID объявления
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера ВК
Функция ПриостановитьРекламноеОбъявление(Знач IDКабинета, Знач IDОбъявления, Знач Параметры = "") Экспорт
    
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);

    Параметры_.Вставить("account_id", OPI_Инструменты.ЧислоВСтроку(IDКабинета));
    
    МассивСтруктур         = Новый Массив;    
    СтруктураКампании      = Новый Структура;
    СтруктураКампании.Вставить("ad_id"  , OPI_Инструменты.ЧислоВСтроку(IDОбъявления));
    СтруктураКампании.Вставить("status" , 0);
    
    МассивСтруктур.Добавить(СтруктураКампании);
    
    JSONДата = OPI_Инструменты.JSONСтрокой(МассивСтруктур);
    
    Параметры_.Вставить("data", JSONДата);
        
    Ответ = OPI_Инструменты.Get("api.vk.com/method/ads.updateAds", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Изменить запись рекламного объявления.
// 
// Параметры:
//  IDПоста - Строка,Число - ID поста на замену
//  IDКабинета - Строка,Число - ID рекламного кабинета
//  IDОбъявления - Строка,Число - ID рекламного объявления
//  Параметры - Структура из Строка -  См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный - Ответ сервера ВК
Функция ИзменитьЗаписьРекламногоОбъявления(Знач IDПоста, Знач IDКабинета, Знач IDОбъявления, Знач Параметры = "") Экспорт
    
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);
    Линк       = "https://vk.com/wall-" + Параметры_["group_id"] + "_" + OPI_Инструменты.ЧислоВСтроку(IDПоста);
    
    Параметры_.Вставить("account_id", OPI_Инструменты.ЧислоВСтроку(IDКабинета));
    
    МассивСтруктур         = Новый Массив;    
    СтруктураКампании      = Новый Структура;
    СтруктураКампании.Вставить("ad_id"         , OPI_Инструменты.ЧислоВСтроку(IDОбъявления));
    СтруктураКампании.Вставить("status"        , 1);
    СтруктураКампании.Вставить("link_url"      , Линк);
    
    МассивСтруктур.Добавить(СтруктураКампании);
    
    JSONДата = OPI_Инструменты.JSONСтрокой(МассивСтруктур);
    
    Параметры_.Вставить("data", JSONДата);
    
    Ответ    = OPI_Инструменты.Get("api.vk.com/method/ads.updateAds", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

#КонецОбласти

#Область Прочие

// Сократить ссылку.
// 
// Параметры:
//  URL - Строка - URL для сокращения
//  Параметры - Структура из Строка - См.ПолучитьСтандартныеПараметры
// 
// Возвращаемое значение:
// Строка - Сокращенный URL 
Функция СократитьСсылку(Знач URL, Знач Параметры = "") Экспорт
    
    Параметры_ = Новый Структура;
    Параметры_ = ПолучитьСтандартныеПараметры(Параметры);    
    Параметры_.Вставить("url", URL);
    
    Ответ = OPI_Инструменты.Get("https://api.vk.com/method/utils.getShortLink", Параметры_);
    
    Возврат Ответ["response"]["short_url"];
    
КонецФункции

// Сформировать клавиатуру.
// 
// Параметры:
//  МассивКнопок - Массив из Строка - Массив заголовков кнопок
// 
// Возвращаемое значение:
//  Строка -  JSON клавиатуры
Функция СформироватьКлавиатуру(Знач МассивКнопок) Экспорт
        
    Клавиатура          = Новый Структура;
    МассивКлавиатуры    = Новый Массив;
    МассивБлока         = Новый Массив;
    
    Для Каждого Действие Из МассивКнопок Цикл
        
        Кнопка      = Новый Структура;
        Выражение   = Новый Структура;
        
        Выражение.Вставить("type" , "text");
        Выражение.Вставить("label", Действие);
        
        Кнопка.Вставить("action", Выражение);
        МассивБлока.Добавить(Кнопка);
        
    КонецЦикла;
    
    МассивКлавиатуры.Добавить(МассивБлока);
    
    Клавиатура.Вставить("buttons" , МассивКлавиатуры);   
    Клавиатура.Вставить("one_time", Ложь);
    
    Возврат OPI_Инструменты.JSONСтрокой(Клавиатура);
    
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтандартныеПараметры(Знач Параметры = "")
    
    Параметры_ = Новый Структура;
    
    Параметры_.Вставить("access_token"  , "");
    Параметры_.Вставить("from_group"    , "");
    Параметры_.Вставить("owner_id"      , "");
    Параметры_.Вставить("v"             , "");
    Параметры_.Вставить("app_id"        , "");
    Параметры_.Вставить("group_id"      , "");
    
    Если ТипЗнч(Параметры) = Тип("Структура") Тогда
        Для Каждого ПереданныйПараметр Из Параметры Цикл
            Параметры_.Вставить(ПереданныйПараметр.Ключ, OPI_Инструменты.ЧислоВСтроку(ПереданныйПараметр.Значение));
        КонецЦикла;
    КонецЕсли;

    Возврат Параметры_;

КонецФункции

#КонецОбласти