ПутьКСловарю  = "./service/dictionaries/en.json";

ЧтениеJSON = Новый ЧтениеJSON();
ЧтениеJSON.ОткрытьФайл(ПутьКСловарю);
Словарь = ПрочитатьJSON(ЧтениеJSON, Истина);
ЧтениеJSON.Закрыть();

ТаблицаСловаря = Новый ТаблицаЗначений();
ТаблицаСловаря.Колонки.Добавить("Ключ");
ТаблицаСловаря.Колонки.Добавить("Значение");
ТаблицаСловаря.Колонки.Добавить("Длина");

Для Каждого КлючевоеСлово Из Словарь Цикл
	НоваяСтрокаСловаря = ТаблицаСловаря.Добавить();
	НоваяСтрокаСловаря.Ключ      = КлючевоеСлово.Ключ;
	НоваяСтрокаСловаря.Значение  = КлючевоеСлово.Значение;
	НоваяСтрокаСловаря.Длина     = СтрДлина(КлючевоеСлово.Ключ);
КонецЦикла;

ТаблицаСловаря.Сортировать("Длина УБЫВ");

ПутьДокозавра = "./docs/docusaurus/";
МассивФайлов = Новый Массив;
МассивФайлов.Добавить(Новый Файл(ПутьДокозавра + "src/components/HomepageFeatures/index.js"));
МассивФайлов.Добавить(Новый Файл(ПутьДокозавра + "src/pages/index.js"));
МассивФайлов.Добавить(Новый Файл(ПутьДокозавра + "docusaurus.config.js"));

Для Каждого Файл Из МассивФайлов Цикл

	ТекущийПуть = Файл.ПолноеИмя;
	ТекущийДокумент = Новый ТекстовыйДокумент();
	ТекущийДокумент.Прочитать(ТекущийПуть, "UTF-8");

	ТекущийТекст = ТекущийДокумент.ПолучитьТекст();


	Для Каждого Слово Из ТаблицаСловаря Цикл
		ТекущийТекст = СтрЗаменить(ТекущийТекст, Слово.Ключ, Слово.Значение);
	КонецЦикла;

	ТекущийТекст = СтрЗаменить(ТекущийТекст, "English version", "Документация на русском языке");
	ТекущийТекст = СтрЗаменить(ТекущийТекст, "href: 'https://en.openintegrations.dev'", "href: 'https://openintegrations.dev'");
	ТекущийТекст = СтрЗаменить(ТекущийТекст, "defaultLocale: 'ru',", "defaultLocale: 'en',");
	ТекущийТекст = СтрЗаменить(ТекущийТекст, "locales: ['ru'],", "locales: ['en'],");
	ТекущийТекст = СтрЗаменить(ТекущийТекст, "url: 'https://openintegrations.dev',", "url: 'https://en.openintegrations.dev',");

	ТекущийДокумент.УстановитьТекст(ТекущийТекст);
	ТекущийДокумент.Записать(Файл.ПолноеИмя);

КонецЦикла;