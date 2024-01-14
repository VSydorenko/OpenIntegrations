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

//https://github.com/Bayselonarrend/OpenIntegrations

#Область ПрограммныйИнтерфейс

#Область ДанныеИНастройка

// Получить информацию бота.
// 
// Параметры:
//  Токен - Строка - Токен
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ПолучитьИнформациюБота(Знач Токен) Экспорт
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/getMe"); 
    Возврат Ответ;

Конецфункции

// Получить обновления.
// 
// Параметры:
//  Токен - Строка - Токен
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ПолучитьОбновления(Знач Токен) Экспорт
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/getUpdates");    
    Возврат Ответ;

КонецФункции

// Установить Webhook.
// 
// Параметры:
//  Токен - Строка - Токен
//  URL - Строка - Адрес обработки запросов от Telegram (с https://)
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция УстановитьWebhook(Знач Токен, Знач URL) Экспорт
	
	Параметры_ = Новый Структура;
	Параметры_.Вставить("url", URL);
	
	Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/setWebHook", Параметры_);    
    Возврат Ответ;

КонецФункции

// Обработать данные, полученные на Webhook.
// 
// Параметры:
//  Запрос - HTTPСервисЗапрос - Запрос на http-сервис от Telegram
// 
// Возвращаемое значение:
//  Структура -  Обработанный запрос на http-сервис от Telegram:
// * Вид - Строка 
// * Никнейм - Строка 
// * IDПользователя - Строка 
// * IDСообщения - Строка 
// * IDЧата - Строка 
// * Сообщение - Строка 
// * Дата - Дата 
// * БотОтключен - Булево 
// * Вид - Строка 
Функция ОбработатьДанные(Знач Запрос) Экспорт
	
	ЧтениеJSON 	= Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Запрос.ПолучитьТелоКакСтроку());
	
	СтруктураПараметровВходная  = ПрочитатьJSON(ЧтениеJSON);
	СтруктураПараметровВыходная = Новый Структура;
	
	Если СтруктураПараметровВходная.Свойство("message") Тогда
 
		СтруктураСообщения 	    = СтруктураПараметровВходная["message"];
		СтруктураПользователя 	= СтруктураСообщения["from"];
		СтруктураЧата		    = СтруктураСообщения["chat"];
		
		СтруктураПараметровВыходная.Вставить("Вид"			    , "Сообщение");
		СтруктураПараметровВыходная.Вставить("Никнейм"          , СтруктураПользователя["username"]);
		СтруктураПараметровВыходная.Вставить("IDПользователя"	, СтруктураПользователя["id"]);
		СтруктураПараметровВыходная.Вставить("IDСообщения"	    , СтруктураСообщения["message_id"]);
		СтруктураПараметровВыходная.Вставить("IDЧата"			, СтруктураЧата["id"]);
		СтруктураПараметровВыходная.Вставить("Сообщение"		, СтруктураСообщения["text"]);
		СтруктураПараметровВыходная.Вставить("Дата"			    , Дата(1970,1,1,1,0,0) + СтруктураСообщения["date"]);
		СтруктураПараметровВыходная.Вставить("БотОтключен"		, Ложь);
		
	ИначеЕсли СтруктураПараметровВходная.Свойство("my_chat_member") Тогда
		
		СтруктураСообщения      = СтруктураПараметровВходная["my_chat_member"];
		СтруктураПользователя 	= СтруктураСообщения["from"];
		СтруктураЧата		    = СтруктураСообщения["chat"];
		
		СтруктураПараметровВыходная.Вставить("Вид"			    , "Запуск/Остановка");
		СтруктураПараметровВыходная.Вставить("Никнейм"          , СтруктураПользователя["username"]);
		СтруктураПараметровВыходная.Вставить("IDПользователя"	, СтруктураПользователя["id"]);
		СтруктураПараметровВыходная.Вставить("IDСообщения"		, "");
		СтруктураПараметровВыходная.Вставить("IDЧата"			, СтруктураЧата["id"]);
		СтруктураПараметровВыходная.Вставить("Сообщение"		, СтруктураСообщения["new_chat_member"]["status"]);
		СтруктураПараметровВыходная.Вставить("Дата"			    , Дата(1970,1,1,1,0,0) + СтруктураСообщения["date"]);
		СтруктураПараметровВыходная.Вставить("БотОтключен"		
			, ?(СтруктураСообщения["new_chat_member"]["status"] = "kicked", Истина, Ложь));

	ИначеЕсли СтруктураПараметровВходная.Свойство("callback_query") Тогда
		
		
		СтруктураСообщения 	    = СтруктураПараметровВходная["callback_query"];
		СтруктураПользователя 	= СтруктураСообщения["from"];

		СтруктураПараметровВыходная.Вставить("Вид"			    , "Кнопка под сообщением");
		СтруктураПараметровВыходная.Вставить("Никнейм"          , СтруктураПользователя["username"]);
		СтруктураПараметровВыходная.Вставить("IDПользователя"   , СтруктураПользователя["id"]);
		СтруктураПараметровВыходная.Вставить("IDСообщения"		, СтруктураСообщения["message"]["message_id"]);
		СтруктураПараметровВыходная.Вставить("IDЧата"			, СтруктураСообщения["message"]["chat"]["id"]);
		СтруктураПараметровВыходная.Вставить("Сообщение"		, СтруктураСообщения["data"]);
		СтруктураПараметровВыходная.Вставить("БотОтключен"		, Ложь);
		СтруктураПараметровВыходная.Вставить("Дата"			    
			, Дата(1970,1,1,1,0,0) + СтруктураСообщения["message"]["date"]);
 
	Иначе
		
		СтруктураПараметровВыходная.Вставить("Вид", "");
		СтруктураПараметровВыходная.Вставить("Никнейм", "");
		СтруктураПараметровВыходная.Вставить("IDПользователя", "");
		СтруктураПараметровВыходная.Вставить("IDСообщения", "");
		СтруктураПараметровВыходная.Вставить("IDЧата", "");
		СтруктураПараметровВыходная.Вставить("Сообщение", "");
		СтруктураПараметровВыходная.Вставить("Дата", ТекущаяДатаСеанса());
		СтруктураПараметровВыходная.Вставить("БотОтключен", Ложь);
		
	КонецЕсли;
	
	Возврат СтруктураПараметровВыходная;
	                        
КонецФункции

#КонецОбласти

#Область ОтправкаДанных

// Отправить текстовое сообщение.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Текст - Строка - Текст сообщения
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ОтправитьТекстовоеСообщение(Знач Токен, Знач IDЧата, Знач Текст, Знач Клавиатура = "") Экспорт
    
    OPI_Инструменты.ЗаменитьСпецСимволы(Текст);
    IDЧата = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"    , "Markdown");
    Параметры_.Вставить("text"          , Текст);
    Параметры_.Вставить("chat_id"       , IDЧата);
    Параметры_.Вставить("reply_markup"  , Клавиатура);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/sendMessage", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Отправить картинку.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - IDЧата
//  Текст - Строка - Текст
//  Картинка - ДвоичныеДанные,Строка - Двоичные данные или путь к картинке
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  Строка, Произвольный, HTTPОтвет -  Ответ сервера Telegram
Функция ОтправитьКартинку(Знач Токен, Знач IDЧата, Знач Текст, Знач Картинка, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Картинка, "photo", Клавиатура);
    
КонецФункции

// Отправить видео.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Текст - Строка - Текст
//  Видео - ДвоичныеДанные,Строка - Двоичные данные или путь к видео
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  Строка, Произвольный, HTTPОтвет -  Ответ сервера Telegram
Функция ОтправитьВидео(Знач Токен, Знач IDЧата, Знач Текст, Знач Видео, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Видео, "video", Клавиатура);
    
КонецФункции

// Отправить аудио.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Текст - Строка - Текст
//  Аудио - ДвоичныеДанные,Строка - Двоичные данные или путь к аудио
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  Строка, Произвольный, HTTPОтвет -  Ответ сервера Telegram
Функция ОтправитьАудио(Знач Токен, Знач IDЧата, Знач Текст, Знач Аудио, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Аудио, "audio", Клавиатура);
    
КонецФункции

// Отправить документ.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Текст - Строка - Текст
//  Документ - ДвоичныеДанные,Строка - Двоичные данные или путь к документу
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  Строка, Произвольный, HTTPОтвет -  Ответ сервера Telegram
Функция ОтправитьДокумент(Знач Токен, Знач IDЧата, Знач Текст, Знач Документ, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Документ, "document", Клавиатура);
    
КонецФункции

// Отправить гифку.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Текст - Строка - Текст
//  Гифка - ДвоичныеДанные,Строка - Двоичные данные или путь к гифке
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  Строка, Произвольный, HTTPОтвет -  Ответ сервера Telegram
Функция ОтправитьГифку(Знач Токен, Знач IDЧата, Знач Текст, Знач Гифка, Знач Клавиатура = "") Экспорт
    
    Возврат ОтправитьФайл(Токен, IDЧата, Текст, Гифка, "animation", Клавиатура);
    
КонецФункции

// Отправить набор любых файлов.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Текст - Строка - Текст
//  СоответствиеФайлов - Соответствие из Строка,ДвоичныеДанные:
//	* Ключ - Строка
//  * Значение - ДвоичныеДанные,Строка 
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  Произвольный, HTTPОтвет -  Ответ сервера Telegram
Функция ОтправитьМедиагруппу(Знач Токен
	, Знач IDЧата
	, Знач Текст
	, Знач СоответствиеФайлов
	, Знач Клавиатура = "") Экспорт
    
    //СоответствиеФайлов
    //Ключ - Файл, Значение - Тип
    //Типы: audio, document, photo, video
    //Нельзя замешивать разные типы!
    
    OPI_Инструменты.ЗаменитьСпецсимволы(Текст);
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    СтруктураФайлов = Новый Структура;
    Медиа           = Новый Массив; 
    Счетчик         = 0;
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"    , "Markdown");
    Параметры_.Вставить("caption"       , Текст);
    Параметры_.Вставить("chat_id"       , IDЧата);
    Параметры_.Вставить("reply_markup"  , Клавиатура);
    
    
    Для Каждого ТекущийФайл Из СоответствиеФайлов Цикл
        
        Если Не ТипЗнч(ТекущийФайл.Ключ) = Тип("ДвоичныеДанные") Тогда      
            ДД              = Новый ДвоичныеДанные(ТекущийФайл.Ключ);   
            ЭтотФайл        = Новый Файл(ТекущийФайл.Ключ);
            ИмяМедиа        = ТекущийФайл.Значение 
                    + Строка(Счетчик) 
                    + ?(ТекущийФайл.Значение = "document", ЭтотФайл.Расширение, "");
            ПолноеИмяМедиа  = СтрЗаменить(ИмяМедиа, ".", "___");
        Иначе
            ДД              = ТекущийФайл.Ключ;
            ИмяМедиа        = ТекущийФайл.Значение + Строка(Счетчик);
            ПолноеИмяМедиа  = ИмяМедиа;
        КонецЕсли;
        
        СтруктураФайлов.Вставить(ПолноеИмяМедиа ,  ДД);
        
        СтруктураМедиа = Новый Структура;
        СтруктураМедиа.Вставить("type", ТекущийФайл.Значение);
        СтруктураМедиа.Вставить("media", "attach://" + ИмяМедиа);
        
        Если Счетчик = 0 Тогда
            СтруктураМедиа.Вставить("caption", Текст);
        КонецЕсли;
        
        Медиа.Добавить(СтруктураМедиа);
        
        Счетчик = Счетчик + 1;
        
    КонецЦикла;
    
    Параметры_.Вставить("media", OPI_Инструменты.JSONСтрокой(Медиа));
    
    Ответ = OPI_Инструменты.PostMultipart("api.telegram.org/bot" 
        + Токен 
        + "/sendMediaGroup", Параметры_, СтруктураФайлов, "mixed"); 

    
    Возврат Ответ;
    
КонецФункции

// Отправить местоположение.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Широта - Строка,Число - Географическая широта
//  Долгота - Строка,Число - Географическая долгота
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ОтправитьМестоположение(Знач Токен, Знач IDЧата, Знач Широта, Знач Долгота, Знач Клавиатура = "") Экспорт
    
    IDЧата = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"    , "Markdown");
    Параметры_.Вставить("chat_id"       , IDЧата);
    Параметры_.Вставить("latitude"      , OPI_Инструменты.ЧислоВСтроку(Широта));
    Параметры_.Вставить("longitude"     , OPI_Инструменты.ЧислоВСтроку(Долгота));
    Параметры_.Вставить("reply_markup"  , Клавиатура);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/sendLocation", Параметры_);
    
    Возврат Ответ;
   
КонецФункции

// Отправить контакт.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Имя - Строка - Имя контакта
//  Фамилия - Строка - Фамилия контакта
//  Телефон - Строка - Телефон контакта
//  Клавиатура - Строка -  См. СформироватьКлавиатуруПоМассивуКнопок
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ОтправитьКонтакт(Знач Токен, Знач IDЧата, Знач Имя, Знач Фамилия, Знач Телефон, Знач Клавиатура = "") Экспорт
    
    IDЧата = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"    , "Markdown");
    Параметры_.Вставить("chat_id"       , IDЧата);
    Параметры_.Вставить("first_name"    , Имя);
    Параметры_.Вставить("last_name"     , Фамилия);
    Параметры_.Вставить("phone_number"  , Строка(Телефон));
    Параметры_.Вставить("reply_markup"  , Клавиатура);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/sendContact", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Отправить опрос.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Вопрос - Строка - Вопрос опроса
//  МассивОтветов - Массив из строка - Массив вариантов ответа
//  Анонимный - Булево -  Анонимность опроса
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ОтправитьОпрос(Знач Токен, Знач IDЧата, Знач Вопрос, Знач МассивОтветов, Знач Анонимный = Истина) Экспорт
    
    IDЧата = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    Ответы = OPI_Инструменты.JSONСтрокой(МассивОтветов);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"        , "Markdown");
    Параметры_.Вставить("chat_id"           , IDЧата);
    Параметры_.Вставить("question"          , Вопрос);
    Параметры_.Вставить("options"           , Ответы);
	
	Если Не Анонимный Тогда
    	Параметры_.Вставить("is_anonymous"      , Ложь);
	КонецЕсли;
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/sendPoll", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Переслать сообщение.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDОригинала - Строка,Число - ID оригинального сообщения
//  ОткудаID - Строка,Число - ID чата оригинального сообщения
//  КудаID - Строка,Число - ID целевого чата
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ПереслатьСообщение(Знач Токен, Знач IDОригинала, Знач ОткудаID, Знач КудаID) Экспорт
    
    IDОригинала     = OPI_Инструменты.ЧислоВСтроку(IDОригинала);
    ОткудаID        = OPI_Инструменты.ЧислоВСтроку(ОткудаID);
    КудаID          = OPI_Инструменты.ЧислоВСтроку(КудаID);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("chat_id"       , КудаID);
    Параметры_.Вставить("from_chat_id"  , ОткудаID);
    Параметры_.Вставить("message_id"    , IDОригинала);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/forwardMessage", Параметры_);
    
    Возврат Ответ;

КонецФункции

#КонецОбласти

#Область Администрирование

// Бан.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  IDПользователя - Строка,Число - ID целевого пользователя
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция Бан(Знач Токен, Знач IDЧата, Знач IDПользователя) Экспорт
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    IDПользователя  = OPI_Инструменты.ЧислоВСтроку(IDПользователя);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"    , "Markdown");
    Параметры_.Вставить("chat_id"       , IDЧата);
    Параметры_.Вставить("user_id"       , IDПользователя);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/banChatMember", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Разбан.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  IDПользователя - Строка,Число - ID целевого пользователя
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция Разбан(Знач Токен, Знач IDЧата, Знач IDПользователя) Экспорт
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    IDПользователя  = OPI_Инструменты.ЧислоВСтроку(IDПользователя);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"        , "Markdown");
    Параметры_.Вставить("chat_id"           , IDЧата);
    Параметры_.Вставить("user_id"           , IDПользователя);
    Параметры_.Вставить("only_if_banned"    , Истина);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/unbanChatMember", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Создать ссылку приглашение.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  Заголовок - Строка -  Заголовок приглашения
//  ДатаИстечения - Дата -  Дата окончания жизни ссылки (безсрочно, если не указано)
//  ЛимитПользователей - Число -  Лимит пользователей (бесконечно, если не указано)
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция СоздатьСсылкуПриглашение(Знач Токен
	, Знач IDЧата
	, Знач Заголовок = ""
	, Знач ДатаИстечения = ""
	, Знач ЛимитПользователей = 0) Экспорт
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"        , "Markdown");
    Параметры_.Вставить("chat_id"           , IDЧата);
    Параметры_.Вставить("name"              , Заголовок);
	
	Если ЗначениеЗаполнено(ДатаИстечения) Тогда
        Параметры_.Вставить("expire_date"       , Формат(ДатаИстечения - Дата(1970,1,1,1,0,0), "ЧГ=0"));
	КонецЕсли;
	
    Параметры_.Вставить("member_limit", ЛимитПользователей);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/createChatInviteLink", Параметры_);
    
    Возврат Ответ;

КонецФункции

// Закрепить сообщение.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
//  IDСообщения - Строка,Число - ID целевого сообщения
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ЗакрепитьСообщение(Знач Токен, Знач IDЧата, Знач IDСообщения) Экспорт
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    IDСообщения     = OPI_Инструменты.ЧислоВСтроку(IDСообщения);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"            , "Markdown");
    Параметры_.Вставить("chat_id"               , IDЧата);
    Параметры_.Вставить("message_id"            , IDСообщения);
    Параметры_.Вставить("disable_notification"  , Истина);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/pinChatMessage", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Открепить сообщение.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка - ID целевого чата
//  IDСообщения - Строка,Число - ID целевого сообщения
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Ответ сервера Telegram
Функция ОткрепитьСообщение(Знач Токен, Знач IDЧата, Знач IDСообщения) Экспорт
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    IDСообщения     = OPI_Инструменты.ЧислоВСтроку(IDСообщения);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"            , "Markdown");
    Параметры_.Вставить("chat_id"               , IDЧата);
    Параметры_.Вставить("message_id"            , IDСообщения);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/unpinChatMessage", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

// Получить число участников.
// 
// Параметры:
//  Токен - Строка - Токен
//  IDЧата - Строка,Число - ID целевого чата
// 
// Возвращаемое значение:
//  ДвоичныеДанные, Неопределено, Произвольный -  Получить число участников
Функция ПолучитьЧислоУчастников(Знач Токен, Знач IDЧата) Экспорт
    
    IDЧата          = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"            , "Markdown");
    Параметры_.Вставить("chat_id"               , IDЧата);
    
    Ответ = OPI_Инструменты.Get("api.telegram.org/bot" + Токен + "/getChatMemberCount", Параметры_);
    
    Возврат Ответ;
    
КонецФункции

#КонецОбласти

#Область TelegramMiniApp

// Обработать данные TMA и определить их достоверность
// 
// Параметры:
//  СтрокаДанных - Строка - querry из Telegram.WebApp.initData
//  Токен - Строка - Токен бота
// 
// Возвращаемое значение:
//  Соответствие из Строка -  Обработанные данные с признаком достоверности
Функция ОбработатьДанныеTMA(Знач СтрокаДанных, Знач Токен) Экспорт    
	
	СтрокаДанных    = РаскодироватьСтроку(СтрокаДанных, СпособКодированияСтроки.КодировкаURL);
	СтруктураДанных = OPI_Инструменты.ПараметрыЗапросаВСоответствие(СтрокаДанных);
	Ключ            = "WebAppData";
	Хэш             = "";
	
	Результат = OPI_Криптография.HMACSHA256(ПолучитьДвоичныеДанныеИзСтроки(Ключ)
	   , ПолучитьДвоичныеДанныеИзСтроки(Токен)); 
	
	ТЗнач = Новый ТаблицаЗначений;
	ТЗнач.Колонки.Добавить("Ключ");
	ТЗнач.Колонки.Добавить("Значение");
	
	Для Каждого Данные Из СтруктураДанных Цикл
		
		НоваяСтрока 	        = ТЗнач.Добавить();		
		НоваяСтрока.Ключ 		= Данные.Ключ;
		НоваяСтрока.Значение 	= Данные.Значение;
		
	КонецЦикла;
	
	ТЗнач.Сортировать("Ключ");
	
	СоответствиеВозврата = Новый Соответствие;
	DCS 			  	 = "";
	
	Для Каждого СтрокаТЗ Из ТЗнач Цикл
		
		Если СтрокаТЗ.Ключ <> "hash" Тогда
			DCS = DCS + СтрокаТЗ.Ключ + "=" + СтрокаТЗ.Значение + Символы.ПС;
			СоответствиеВозврата.Вставить(СтрокаТЗ.Ключ, СтрокаТЗ.Значение); 
		Иначе
			Хэш = СтрокаТЗ.Значение;
		КонецЕсли;
		
	КонецЦикла;
	
	DCS 	= Лев(DCS, СтрДлина(DCS) - 1);
	Подпись = OPI_Криптография.HMACSHA256(Результат, ПолучитьДвоичныеДанныеИзСтроки(DCS));
	
	Финал = ПолучитьHexСтрокуИзДвоичныхДанных(Подпись);
	
	Если Финал = вРег(Хэш) Тогда
		Ответ = Истина;
	Иначе
		Ответ = Ложь;
	КонецЕсли;
	
	СоответствиеВозврата.Вставить("passed", Ответ);
	
	Возврат СоответствиеВозврата;
	
КонецФункции

#КонецОбласти

#Область Прочее

// Сформировать клавиатуру по массиву кнопок.
// 
// Параметры:
//  МассивКнопок - Массив из Строка - Массив кнопок
//  ПодСообщением - Булево -  Клавиатура под сообщением или на нижней панели
//  ОднаПодОдной - Булево - Истина - кнопки выводятся в столбик, Ложь - в строку
// 
// Возвращаемое значение:
//  Строка -  JSON клавиатуры
Функция СформироватьКлавиатуруПоМассивуКнопок(Знач МассивКнопок, Знач ПодСообщением = Ложь, Знач ОднаПодОдной = Истина) Экспорт
	
	Если ОднаПодОдной Тогда
		
		Строки = Новый Массив;
		
		Для Каждого Кнопка Из МассивКнопок Цикл
			Кнопки = Новый Массив;
			Кнопка = OPI_Инструменты.ЧислоВСтроку(Кнопка);
			Кнопки.Добавить(Новый Структура("text,callback_data", Кнопка, Кнопка));
			Строки.Добавить(Кнопки);		
		КонецЦикла;
		
	Иначе
		
		Строки = Новый Массив;
		Кнопки = Новый Массив;
		
		Для Каждого Кнопка Из МассивКнопок Цикл		
			Кнопка = OPI_Инструменты.ЧислоВСтроку(Кнопка);
			Кнопки.Добавить(Новый Структура("text,callback_data", Кнопка, Кнопка));		
		КонецЦикла;
		
		Строки.Добавить(Кнопки);
	КонецЕсли;
	 
    Если ПодСообщением Тогда
        СтруктураПараметра = Новый Структура("inline_keyboard,rows", Строки, 1);
    Иначе
        СтруктураПараметра = Новый Структура("keyboard,resize_keyboard", Строки, Истина);
    КонецЕсли;
        
    ЗаписьJSON    = Новый ЗаписьJSON;
    ПЗJSON        = Новый ПараметрыЗаписиJSON(ПереносСтрокJSON.Нет, , , ЭкранированиеСимволовJSON.СимволыВнеASCII);
    ЗаписьJSON.УстановитьСтроку(ПЗJSON);
        
    ЗаписатьJSON(ЗаписьJSON, СтруктураПараметра);
    
    Возврат ЗаписьJSON.Закрыть();
    
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ОтправитьФайл(Знач Токен, Знач IDЧата, Знач Текст, Знач Файл, Знач Вид, Знач Клавиатура)
    
    Если Вид = "photo" Тогда
        Метод = "/sendPhoto";
    ИначеЕсли Вид = "video" Тогда
        Метод = "/sendVideo";
    ИначеЕсли Вид = "audio" Тогда
        Метод = "/sendAudio";
    ИначеЕсли Вид = "document" Тогда
        Метод   = "/sendDocument";
    ИначеЕсли Вид = "animation" Тогда
        Метод = "/sendAnimation";
    Иначе 
        Возврат "";
    КонецЕсли;
    
    OPI_Инструменты.ЗаменитьСпецсимволы(Текст);
    IDЧата = OPI_Инструменты.ЧислоВСтроку(IDЧата);
    
    Если Не ТипЗнч(Файл) = Тип("ДвоичныеДанные") Тогда      
        ТекущийФайл = Новый Файл(Файл);
        Расширение  = ?(Вид = "document" или Вид = "animation", ТекущийФайл.Расширение, "");
        Файл        = Новый ДвоичныеДанные(Файл);   
    Иначе
        Расширение  = "";
    КонецЕсли;
    
    Расширение = СтрЗаменить(Расширение, ".", "___");
    
    Параметры_ = Новый Структура;
    Параметры_.Вставить("parse_mode"    , "Markdown");
    Параметры_.Вставить("caption"       , Текст);
    Параметры_.Вставить("chat_id"       , IDЧата);
    Параметры_.Вставить("reply_markup"  , Клавиатура);
    
    СтруктураФайлов = Новый Структура;
    СтруктураФайлов.Вставить(Вид + Расширение,  Файл);
    
    Ответ = OPI_Инструменты.PostMultipart("api.telegram.org/bot" 
    + Токен 
    + Метод, Параметры_, СтруктураФайлов, "mixed"); 
    
    
    Возврат Ответ;
    
КонецФункции

#КонецОбласти
