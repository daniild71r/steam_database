-- Попытка вставить безымянную страну
insert into ent_countries
    values (50, null);

-- Попытка вставить студию времен Наполеона
insert into ent_developers
    values (9000, 'Valera Studios', 1812, 5);

-- Попытка вставить статистику отзывов об игре с неправильным значением positivity
insert into ent_games_reception
    values (2600, 516, 301, 99, null);

-- Попытка вставить издателя из будущего
insert into ent_publishers
    values (9000, 'Gena Entertainment', 2005, 322);

-- Попытка приписать разработчику Valve несуществующую игру
insert into rel_games_developers
    values (505, 0);

-- Попытка удалить название игре Dota 2
update ent_games
    set name = null
    where game_id = 570;

-- Попытка насильственно поставить Cyberpunk 2077 оценку 101 на metacritic
update ent_games_reception
    set metacritic = 101
    where game_id = 1091500;

-- Вставка нового разработчика и его игры
insert into ent_developers
    values (9000, 'Korovan Software', 2005, 5);

insert into ent_games
    values (1, 'Korovan Robbing', 12, 0, '2006-12-30');

insert into rel_games_developers
    values(1, 9000);

-- Удаление разработчика, ведущее к удалению связи с игрой
delete from ent_developers
    where developer_id = 9000;

-- Удаление игры, не имеющей связей
delete from ent_games
    where game_id = 1;