﻿#Использовать logos

Перем Лог;
Перем мПараметры;
Перем мПозиционныеПараметры;

Перем мКоманды;

Перем мПозицияВСпискеТокенов;
Перем мПозицияПозиционныхПараметров;
Перем мМассивВходныхПараметров;

Процедура ДобавитьПараметр(ИмяПараметра) Экспорт
	Лог.Отладка("ДобавитьПараметр: ИмяПараметра <"+ИмяПараметра+">");		
	
	Ключ = Строка(ИмяПараметра);
	мПозиционныеПараметры.Добавить(Ключ);
КонецПроцедуры

Процедура ДобавитьИменованныйПараметр(ИмяПараметра) Экспорт
	Лог.Отладка("ДобавитьИменованныйПараметр: ИмяПараметра <"+ИмяПараметра+">");		
	
	Ключ = Строка(ИмяПараметра);
	мПараметры.Вставить(Ключ, Ключ);
КонецПроцедуры

Функция ОписаниеКоманды(Знач ИмяКоманды) Экспорт
	
	НовоеОписание = Новый Структура;
	НовоеОписание.Вставить("Команда", ИмяКоманды);
	НовоеОписание.Вставить("ПозиционныеПараметры", Новый Массив);
	НовоеОписание.Вставить("ИменованныеПараметры", Новый Соответствие);
	
	Возврат НовоеОписание;
	
КонецФункции

Процедура ДобавитьКоманду(Знач ОписаниеКоманды) Экспорт
	
	мКоманды.Вставить(ОписаниеКоманды.Команда, ОписаниеКоманды);
	
КонецПроцедуры

Процедура ДобавитьПозиционныйПараметрКоманды(Знач ОписаниеКоманды, Знач ИмяПараметра) Экспорт
	ОписаниеКоманды.ПозиционныеПараметры.Добавить(ИмяПараметра);
КонецПроцедуры

Процедура ДобавитьИменованныйПараметрКоманды(Знач ОписаниеКоманды, Знач ИмяПараметра) Экспорт
	ОписаниеКоманды.ИменованныеПараметры.Вставить(ИмяПараметра, ИмяПараметра);
КонецПроцедуры

Функция РазобратьКоманду(Знач МассивПараметров) Экспорт
	
	Если МассивПараметров.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ОписаниеКоманды = мКоманды[МассивПараметров[0]];
	Если ОписаниеКоманды = Неопределено Тогда
		ВызватьИсключение "Неизвестная команда: " + МассивПараметров[0];
	КонецЕсли;
	
	РезультатКоманды = Новый Структура;
	РезультатКоманды.Вставить("Команда", ОписаниеКоманды.Команда);
	РезультатКоманды.Вставить("ЗначенияПараметров", Новый Соответствие);
	
	мМассивВходныхПараметров = МассивПараметров;
	мПозицияВСпискеТокенов = 1;
	мПозицияПозиционныхПараметров = 0;
	
	РезультатКоманды.ЗначенияПараметров = РазобратьАргументы(ОписаниеКоманды.ИменованныеПараметры, ОписаниеКоманды.ПозиционныеПараметры);
	Возврат РезультатКоманды;
	
КонецФункции

Функция Разобрать(Знач ВходнойМассивПараметров) Экспорт
	
	Если ВходнойМассивПараметров.Количество() = 0 Тогда 
		Возврат Новый Соответствие;
	КонецЕсли;
	
	ОписаниеКоманды = мКоманды[ВходнойМассивПараметров[0]];
	Если ОписаниеКоманды <> Неопределено Тогда
		Лог.Отладка("Первый параметр совпадает с именем команды. Переход в режим обработки команд");
		Возврат РазобратьКоманду(ВходнойМассивПараметров);
	Иначе
		мМассивВходныхПараметров = Новый Массив;
		Для Каждого Элемент Из ВходнойМассивПараметров Цикл
			мМассивВходныхПараметров.Добавить(Элемент);
		КонецЦикла;
		
		мПозицияПозиционныхПараметров = 0;
		мПозицияВСпискеТокенов        = 0;
		
		Возврат РазобратьАргументы(мПараметры, мПозиционныеПараметры);
	КонецЕсли;
	
КонецФункции


Функция РазобратьАргументы(Знач ИменованныеПараметры, Знач ПозиционныеПараметры)
	
	РезультатРазбора = Новый Соответствие;
	
	Если Лог.Уровень() = УровниЛога.Отладка Тогда
		Строка = "";
		Для Каждого Параметр Из мМассивВходныхПараметров Цикл
			Строка = Строка + Параметр + " ";
		КонецЦикла;
		Лог.Отладка("ВходнойМассивПараметров <"+СокрЛП(Строка)+">");
	КонецЕсли;
	
	Пока Истина Цикл
		
		Токен = СледующийТокен();
		Лог.Отладка("Выбран токен: " + Токен);
		Если Токен = Неопределено Тогда
			Лог.Отладка("Закончились токены");
			Прервать;
		КонецЕсли;
		
		Если ЭтоИменованныйПараметр(Токен, ИменованныеПараметры) Тогда
			Лог.Отладка("Это именованный параметр: " + Токен);
			РезультатРазбора[Токен] = СледующийОбязательныйТокен();
			Лог.Отладка("Нашли значение именованного параметра: " + РезультатРазбора[Токен]);
		Иначе
			ИмяПараметра = ВыбратьСледующееИмяПозиционногоПараметра(ПозиционныеПараметры);
			Лог.Отладка("Установлено значение позиционного параметра <" + ИмяПараметра + " = " + Токен + ">");
			РезультатРазбора[ИмяПараметра] = Токен;
		КонецЕсли
		
	КонецЦикла;
	
	Возврат РезультатРазбора;
	
КонецФункции

Функция СледующийТокен()
	Если мПозицияВСпискеТокенов = мМассивВходныхПараметров.Количество() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Токен = мМассивВходныхПараметров[мПозицияВСпискеТокенов];
	мПозицияВСпискеТокенов = мПозицияВСпискеТокенов + 1;
	
	Возврат Токен;
КонецФункции

Функция СледующийОбязательныйТокен()
	Токен = СледующийТокен();
	Если Токен = Неопределено Тогда
		ВызватьИсключение "Ожидается значение параметра, хз какого";
	КонецЕсли;
	Возврат Токен;
КонецФункции

Функция ЭтоИменованныйПараметр(Знач Токен, Знач ИменованныеПараметры)
	Возврат ИменованныеПараметры[Токен] <> Неопределено;
КонецФункции

Функция ВыбратьСледующееИмяПозиционногоПараметра(Знач ПозиционныеПараметры)
	Если мПозицияПозиционныхПараметров = ПозиционныеПараметры.Количество() Тогда
		ВызватьИсключение "Ожидается наличие позиционного параметра";
	КонецЕсли;
	
	Имя = ПозиционныеПараметры[мПозицияПозиционныхПараметров];
	мПозицияПозиционныхПараметров = мПозицияПозиционныхПараметров + 1;
	Возврат Имя;
КонецФункции

Процедура Инит()
	Лог = Логирование.ПолучитьЛог("oscript.lib.cmdline");
	
	мПараметры = Новый Соответствие;
	мПозиционныеПараметры = Новый Массив;
	мКоманды   = Новый Соответствие;
КонецПроцедуры

Инит();
