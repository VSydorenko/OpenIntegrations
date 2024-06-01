Перем ТаблицаСловаря;
Перем СоответствиеИсключаемых;

Процедура ПриСозданииОбъекта()

	Сообщить("Начало создания локализации...");

	КаталогСловарей = "./service/dictionaries";
	ФайлыСловарей   = НайтиФайлы(КаталогСловарей, "*.json");

	СоответствиеИсключаемых = Новый Соответствие();
	СоответствиеИсключаемых.Вставить("packagedef", Истина);

	ТаблицаСловаря = Новый ТаблицаЗначений();
	ТаблицаСловаря.Колонки.Добавить("Ключ");
	ТаблицаСловаря.Колонки.Добавить("Значение");
	ТаблицаСловаря.Колонки.Добавить("Длина");
	ТаблицаСловаря.Колонки.Добавить("ИмяМодуля");

	Для Каждого Словарь Из ФайлыСловарей Цикл

		Если Словарь.ИмяБезРасширения = "keywords"
			Или СтрНайти(Словарь.ИмяБезРасширения, "_")  <> 0 Тогда
			Продолжить;
		КонецЕсли;
		
		СоздатьЛокализацию(Словарь);
	КонецЦикла;

КонецПроцедуры

Процедура СоздатьЛокализацию(Знач Словарь)

	ПутьКСловарю = Словарь.ПолноеИмя;
	Язык         = Словарь.ИмяБезРасширения;

	Сообщить("Создание локализации " + Язык);

	ПолучитьТаблицуСловаря(ПутьКСловарю);

	КаталогИсточник = Новый Файл("./src/ru");
	КаталогПриемник = Новый Файл("./src/" + Язык + "");

	Если КаталогПриемник.Существует() Тогда
		УдалитьФайлы(КаталогПриемник.ПолноеИмя);
	КонецЕсли;

	Сообщить("Копирование Начало");
	СкопироватьФайлы(КаталогИсточник.ПолноеИмя, КаталогПриемник.ПолноеИмя);
	Сообщить("Копирование Окончание");
	Сообщить("Поиск модулей");
	ФайлыМодулей  = НайтиФайлы("./src/" + Язык + "/", "*", Истина);
	Сообщить("Найдено модулей: " + Строка(ФайлыМодулей.Количество()));

	Для Каждого ФайлМодуля Из ФайлыМодулей Цикл

		Если ФайлМодуля.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;

		Сообщить("Перевод модуля " + ФайлМодуля.Имя);
		ПеревестиМодуль(ФайлМодуля.ПолноеИмя);
	КонецЦикла;

	ВсеФайлыЛокализации     = НайтиФайлы("./src/" + Язык, "*", Истина);
	ОтборИменМодулей        = Новый Структура("ИмяМодуля", Истина);
	СтрокиИмен              = ТаблицаСловаря.НайтиСтроки(ОтборИменМодулей);
	УдаляемыеКаталоги       = Новый Массив;

	Для Каждого ФайлЛокализации Из ВсеФайлыЛокализации Цикл

		Если Не ФайлЛокализации.ЭтоКаталог() Или СоответствиеИсключаемых[ФайлЛокализации.Имя] <> Неопределено Тогда
			Продолжить;
		КонецЕсли;

		ТекущийПуть = ФайлЛокализации.ПолноеИмя;
		НовыйПуть   = ТекущийПуть;

		Для Каждого Имя Из СтрокиИмен Цикл
			НовыйПуть = СтрЗаменить(НовыйПуть, Имя.Ключ, Имя.Значение);
		КонецЦикла;

		ФайлНовогоПути = Новый Файл(НовыйПуть);

		Если Не ФайлНовогоПути.Существует() Тогда
			УдаляемыеКаталоги.Добавить(ТекущийПуть);
			СоздатьКаталог(НовыйПуть);
		КонецЕсли;

	КонецЦикла;
	
	Для Каждого ФайлЛокализации Из ВсеФайлыЛокализации Цикл

		Если ФайлЛокализации.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;

		ТекущийПуть = ФайлЛокализации.ПолноеИмя;
		НовыйПуть   = ТекущийПуть;

		Для Каждого Имя Из СтрокиИмен Цикл
			НовыйПуть = СтрЗаменить(НовыйПуть, Имя.Ключ, Имя.Значение);
		КонецЦикла;

		ФайлНовогоПути = Новый Файл(НовыйПуть);

		Если Не ФайлНовогоПути.Существует() Тогда
			ПереместитьФайл(ТекущийПуть, НовыйПуть);
		КонецЕсли;

	КонецЦикла;

	Для Каждого Каталог Из УдаляемыеКаталоги Цикл
		УдалитьФайлы(Каталог);
	КонецЦикла;

КонецПроцедуры

Процедура ПеревестиМодуль(ПутьКМодулю)

	Если СтрНайти(ПутьКМодулю, "packagedef") <> 0 Тогда
		Возврат;
	КонецЕсли;

	ДокументМодуля = Новый ТекстовыйДокумент();
	ДокументМодуля.Прочитать(ПутьКМодулю, "UTF-8");

	Для Н = 1 По ДокументМодуля.КоличествоСтрок() Цикл

		ТекущаяСтрока = СокрЛП(ДокументМодуля.ПолучитьСтроку(Н));

		Если Не ЗначениеЗаполнено(ТекущаяСтрока) Тогда
			Продолжить;
		КонецЕсли;

		Пока СтрНайти(ТекущаяСтрока, "  ") <> 0 Цикл
			ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "  ", " ");
		КонецЦикла;

		ВыводимаяСтрока = СтрЗаменить(ДокументМодуля.ПолучитьСтроку(Н), СокрЛП(ДокументМодуля.ПолучитьСтроку(Н)), ТекущаяСтрока);
		ДокументМодуля.ЗаменитьСтроку(Н, ВыводимаяСтрока);

	КонецЦикла;

	ТекстМодуля = ДокументМодуля.ПолучитьТекст();

	Для Каждого Элемент Из ТаблицаСловаря Цикл

		ТекущееЗначение = Элемент.Значение;

		Пока СтрДлина(ТекущееЗначение) < Элемент.Длина Цикл
			ТекущееЗначение = ТекущееЗначение + " ";
		КонецЦикла;

		ТекстМодуля = СтрЗаменить(ТекстМодуля, Элемент.Ключ, Элемент.Значение);
	КонецЦикла;

	ОбработатьНесовпаденияOneScript(ТекстМодуля, ПутьКМодулю);

	ДокументМодуля.УстановитьТекст(ТекстМодуля);
	ДокументМодуля.Записать(ПутьКМодулю);

КонецПроцедуры

Процедура ПолучитьТаблицуСловаря(ПутьКСловарю)

	Сообщить("Чтение словаря " + ПутьКСловарю);
	ТаблицаСловаря.Очистить();

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.ОткрытьФайл(ПутьКСловарю);
	ДанныеСловаря = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();

	Для Каждого Элемент Из ДанныеСловаря Цикл

		НоваяСтрокаСловаря = ТаблицаСловаря.Добавить();
		НоваяСтрокаСловаря.Ключ      = Элемент.Ключ;
		НоваяСтрокаСловаря.Значение  = Элемент.Значение;
		НоваяСтрокаСловаря.Длина     = СтрДлина(Элемент.Ключ);
		НоваяСтрокаСловаря.ИмяМодуля = СтрНайти(Элемент.Ключ, "OPI_") <> 0;

	КонецЦикла;

	ТаблицаСловаря.Сортировать("Длина УБЫВ");

	ПутьКСловарюКлючевыхСлов = "./service/dictionaries/keywords.json";
	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.ОткрытьФайл(ПутьКСловарюКлючевыхСлов);
	СоответствиеКС = ПрочитатьJSON(ЧтениеJSON, Истина);
	ЧтениеJSON.Закрыть();

	Для Каждого КлючевоеСлово Из СоответствиеКС Цикл
		НоваяСтрокаСловаря = ТаблицаСловаря.Добавить();
		НоваяСтрокаСловаря.Ключ      = КлючевоеСлово.Ключ;
		НоваяСтрокаСловаря.Значение  = КлючевоеСлово.Значение;
		НоваяСтрокаСловаря.Длина     = СтрДлина(Элемент.Ключ);
		НоваяСтрокаСловаря.ИмяМодуля = Ложь;
	КонецЦикла;

КонецПроцедуры

Процедура СкопироватьФайлы(Знач КаталогИсточник, Знач КаталогПриемник)
	
	Сообщить("Каталог источник: " + КаталогИсточник);
	Сообщить("Каталог приемника: " + КаталогПриемник);

	
	Сообщить("Создание каталога " + КаталогПриемник);
	СоздатьКаталог(КаталогПриемник);
	
	МассивФайлов = НайтиФайлы(КаталогИсточник, "*.*", Истина);
	
	Для Каждого Файл Из МассивФайлов Цикл

		Если СтрНайти(Файл.ПолноеИмя, "cli") <> 0 Тогда
			Продолжить;
		КонецЕсли;
		ПолноеИмяИсточник = Файл.ПолноеИмя;
		ПолноеИмяПриемник = КаталогПриемник + СтрЗаменить(Файл.ПолноеИмя, КаталогИсточник, "");
		
		Если Файл.ЭтоКаталог() Тогда
			СоздатьКаталог(ПолноеИмяПриемник);	
			Сообщить("Создание каталога " + ПолноеИмяПриемник);
		Иначе
			КопироватьФайл(ПолноеИмяИсточник, ПолноеИмяПриемник);
			Сообщить("Копирование файла" + ПолноеИмяИсточник + " в " + ПолноеИмяПриемник);
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Процедура ОбработатьНесовпаденияOneScript(ТекстМодуля, ПутьКМодулю)

	СоответствиеОшибок = Новый Соответствие();
	СоответствиеОшибок.Вставить("ConcatBinaryData", "ConcatenateBinaryData");
	СоответствиеОшибок.Вставить("GetTestList"     , "ПолучитьСписокТестов");
	СоответствиеОшибок.Вставить("Exists"          , "Exist");

	ФайлМодуля = Новый Файл(ПутьКМодулю);

	Если СтрНайти(ФайлМодуля.Имя, ".os") <> 0 Тогда
		Для Каждого Ошибка Из СоответствиеОшибок Цикл
			ТекстМодуля = СтрЗаменить(ТекстМодуля, Ошибка.Ключ, Ошибка.Значение);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

//ПриСозданииОбъекта();