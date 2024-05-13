Репозиторий = "https://github.com/Bayselonarrend/OpenIntegrations";
Версия   = "1.9.0";
Режим    = "CONFIG";

//Локальные данные
Файл1С           = """C:\Program Files\1cv8\8.3.18.1208\bin\1cv8.exe""";
ПутьКРепозиторию = "C:\Repos\OPI";
Сервер           = "AIONIOTISCORE";
База             = "OpenIntegrations";
ПутьВыгрузки     = "G:\Мой диск\Проекты\ОПИ\Релизы\" + Версия + "\";
//----------------

ПутьКEDT = ПутьКРепозиторию + "\OPI";
ПутьOS   = ПутьКРепозиторию + "\OInt";
ПутьCLI  = ПутьКРепозиторию + "\cli\core\Classes\Приложение.os";
ПутьISS  = ПутьКРепозиторию + "\.github\workflows\main.iss";

КаталогВыгрузки = Новый Файл(ПутьВыгрузки);
Если КаталогВыгрузки.Существует() Тогда
	УдалитьФайлы(ПутьВыгрузки);
КонецЕсли;

СоздатьКаталог(ПутьВыгрузки);
Приостановить(1000);

Основа = Файл1С + " " + Режим + " /S " + Сервер + "\" + База + " ";

//CFE
ВыгрузкаВФайл = Основа + "/DumpCfg """ + ПутьВыгрузки + "OpenIntegrations_" + Версия + ".cfe" + """ -Extension OpenIntegrations";
ЗапуститьПриложение(ВыгрузкаВФайл, , Истина);

// XML
ПапкаXML = ПутьВыгрузки + "XML";

КаталогXML = Новый Файл(ПапкаXML);
Если Не КаталогXML.Существует() Тогда
	СоздатьКаталог(ПапкаXML);
КонецЕсли;

ВыгрузкаВXML = Основа + "/DumpConfigToFiles """ + ПапкаXML + """ -Extension OpenIntegrations";
ЗапуститьПриложение(ВыгрузкаВXML, , Истина);

ПутьZIP = ПутьВыгрузки + "XML.zip";
ZipXML = Новый ЗаписьZipФайла(ПутьZIP);

ZipXML.Добавить(ПапкаXML + "\*.*" , РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
ZipXML.Записать();

ПутьZIP = ПутьВыгрузки + "EDT.zip";
ZipEDT = Новый ЗаписьZipФайла(ПутьZIP);

УдалитьФайлы(ПапкаXML);

//EDT
ZipEDT.Добавить(ПутьКEDT + "\*.*" , РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
ZipEDT.Записать();

//OSPX
КонечныйПутьOSPX = ПутьВыгрузки + "oint-" + Версия + ".ospx";
СборкаOS         = "opm b -o ""C:/"" """ + ПутьOS + """";

ЗапуститьПриложение(СборкаOS, , Истина);
ПереместитьФайл("C:\oint-" + Версия + ".ospx", КонечныйПутьOSPX);

Приостановить(1000);
ЗапуститьПриложение("opm install -f """ + КонечныйПутьOSPX + """");
Приостановить(1000);

//EXE
СборкаEXE = "oscript -make """ + ПутьCLI + """ """ + ПутьВыгрузки + "oint.exe""";
ЗапуститьПриложение(СборкаEXE, , Истина);

//Setup

ТекстISS = Новый ТекстовыйДокумент();
ТекстISS.Прочитать(ПутьISS);

Для Н = 1 По ТекстISS.КоличествоСтрок() Цикл

	ТекущаяСтрока = СокрЛП(ТекстISS.ПолучитьСтроку(Н));

	Если СтрНайти(ТекущаяСтрока, "#define MyAppVersion") Тогда
		ТекстISS.ЗаменитьСтроку(Н, "#define MyAppVersion """ + Версия + """");
		Прервать;
	КонецЕсли;

КонецЦикла;

ТекстISS.Записать(ПутьISS);

СборкаSetup = """C:\Program Files (x86)\Inno Setup 6\Compil32.exe"" /cc """ + ПутьISS + """";
ЗапуститьПриложение(СборкаSetup, , Истина);

//Draft

ФайлыРелиза = НайтиФайлы(ПутьВыгрузки, "*", Истина);

Для Каждого ФайлРелиза Из ФайлыРелиза Цикл
	ЗапуститьПриложение("""C:\Program Files\GitHub CLI\gh.exe"" release upload draft --repo " + Репозиторий + " """ + ФайлРелиза.ПолноеИмя + """");
КонецЦикла;
