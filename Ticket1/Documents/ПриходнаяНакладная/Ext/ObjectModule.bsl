﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	ОбработкаПроведенияОУ();
	ОбработкаПроведенияБУ();
	                      
	//{{__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	//}}__КОНСТРУКТОР_ДВИЖЕНИЙ_РЕГИСТРОВ
	
КонецПроцедуры

Процедура ОбработкаПроведенияОУ()
	
	Движения.ОстаткиНоменклатуры.Записывать = Истина;
	Движения.ПартииНоменклатуры.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходнаяНакладнаяСписокНоменклатуры.Номенклатура КАК Номенклатура,
		|	СУММА(ПриходнаяНакладнаяСписокНоменклатуры.Количество) КАК Количество,
		|	СУММА(ПриходнаяНакладнаяСписокНоменклатуры.Сумма) КАК Сумма
		|ИЗ
		|	Документ.ПриходнаяНакладная.СписокНоменклатуры КАК ПриходнаяНакладнаяСписокНоменклатуры
		|ГДЕ
		|	ПриходнаяНакладнаяСписокНоменклатуры.Ссылка = &Ссылка
		|	И ПриходнаяНакладнаяСписокНоменклатуры.Номенклатура.ВидНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ВидыНоменклатуры.Товар)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяНакладнаяСписокНоменклатуры.Номенклатура";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Движение = Движения.ОстаткиНоменклатуры.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.Склад = Склад;
		Движение.Количество = ВыборкаДетальныеЗаписи.Количество;
		
		Движение = Движения.ПартииНоменклатуры.ДобавитьПриход();
		Движение.Период = Дата;
		Движение.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
		Движение.Партия = Ссылка;
		Движение.КоличествоПартии = ВыборкаДетальныеЗаписи.Количество;
		Движение.СуммаПартии = ВыборкаДетальныеЗаписи.Сумма;
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОбработкаПроведенияБУ()

	// регистр Управленческий 
	Движения.Управленческий.Записывать = Истина;
	Для Каждого ТекСтрокаСписокНоменклатуры Из СписокНоменклатуры Цикл
		Движение = Движения.Управленческий.Добавить();
		Движение.СчетДт = ПланыСчетов.Управленческий.Товары;
		Движение.СчетКт = ПланыСчетов.Управленческий.Поставщики;
		Движение.Период = Дата;
		Движение.СрокГодности = ТекСтрокаСписокНоменклатуры.СрокГодности;
		Движение.СуммаРуб = ТекСтрокаСписокНоменклатуры.Сумма;
		Движение.КоличествоДт = ТекСтрокаСписокНоменклатуры.Количество;
		Движение.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконто.Номенклатура] = ТекСтрокаСписокНоменклатуры.Номенклатура;
	КонецЦикла;

КонецПроцедуры
