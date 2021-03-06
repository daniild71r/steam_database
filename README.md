# steam_database
Добро пожаловать в репозиторий, посвященный моему семестровому проекту по курсу "Базы данных" :)

Предметной областью проекта является игровая индустрия. Одной из важнейших проблем современной игровой индустрии является растущая лояльность издательств, занимающихся обзорами новых продуктов, даже на фоне спорных решений крупных разработчиков, ведущая к дезинформации в среде игроков. Задача проекта - решить эту проблему, собирая статистику по разработчикам, издателям и их продуктам, а также аккумулируя мнение общественности о них в одном месте. Имея полный доступ к информации об игровом продукте, пользователь сможет принять взвешенное решение, покупать ли его или нет. Сервис также может быть использовать независимыми обозревателями, для которых не менее важно иметь информацию о продуктах, и работниками индустрии, следящими за тенденциями игрового рынка.

Ниже я опишу, что здесь можно найти.

- **data**: в этой папке хранятся таблицы, скопированные непосредственно из СУБД, с которыми я и работаю

- **sql**: в этой папке хранятся sql-скрипты по заданиям к проекту:

    - *3ddl.sql* - DDL-скрипты по созданию таблиц вместе со всеми ограничениями

    - *4indices.sql* - создание индексов к таблицам

    - *6-1crud.sql* - DML-скрипты по добавлению, изменению и обновлению данных, написанные в целях проверки работоспособности ограничений целостности

    - *6-2selects.sql* - примеры простых select-запросов

    - *7complex_selects.sql* - примеры сложных select-запросов

    - *8views.sql* - представления, дающие альтернативный вид некоторым игровым статистикам и инкапсулирующие join'ы по таблицам-связям
	
	- *9procedures.sql* - хранимые процедуры, обеспечивающие более безопасную работу с базой
	
	- *10triggers.sql* - триггеры, обеспечивающие более безопасную работу с базой

- **misc**: в этой папке хранятся файлы, не относящиеся к категориям выше:

    - *steam_database_diagram.png* - ER-диаграмма, описывающая структуру базы

    - *steam.ipynb* - jupyter-ноутбук, в котором можно посмотреть, через какие муки мне пришлось пройти, чтобы распарсить данные с API стима
