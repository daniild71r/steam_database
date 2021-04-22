-- 10 разработчиков, создавших больше всего популярных игр
select name, count(game_id) as game_count from ent_developers ed
    join rel_games_developers rgd on ed.developer_id = rgd.developer_id
    group by ed.developer_id
    order by game_count desc
    limit 10;

-- Все разработчики из России и Украины
select ed.name, ec.name from ent_developers ed
    join ent_countries ec on ed.country_id = ec.country_id
    where ec.name in ('Russia', 'Ukraine');

-- Разработчики, открывшиеся не раньше 2012 года
select name, foundation_year from ent_developers
    where foundation_year >= 2012;

-- 10 издателей, выпустивших больше всего популярных игр
select name, count(game_id) as game_count from ent_publishers ep
    join rel_games_publishers rgp on ep.publisher_id = rgp.publisher_id
    group by ep.publisher_id
    order by game_count desc
    limit 10;

-- Издатели, открывшиеся раньше 1980 года
select name, foundation_year from ent_publishers
    where foundation_year < 1980;

-- 5 игр с наибольшим числом игроков
select name, owners_count from ent_games eg
    join ent_games_finance egf on eg.game_id = egf.game_id
    where owners_count is not null
    order by owners_count desc
    limit 5;

-- 5 самых высокооцененных игр с 5 миллионами игроков и более
select name, metacritic, owners_count from ent_games eg
    join ent_games_finance egf on eg.game_id = egf.game_id
    join ent_games_reception egr on eg.game_id = egr.game_id
    where owners_count > 5000000 and metacritic is not null
    order by metacritic desc
    limit 5;

-- 10 игр, принесших больше всего денег
select name, owners_count * price as revenue from ent_games eg
    join ent_games_finance egf on eg.game_id = egf.game_id
    order by owners_count * price desc
    limit 10;

-- 5 платных игр с наибольшим числом игроков
select name, owners_count from ent_games eg
    join ent_games_finance egf on eg.game_id = egf.game_id
    where not is_free
    order by owners_count desc
    limit 5;

-- 5 игр с поддержкой Linux с наибольшим числом игроков
select name, owners_count from ent_games eg
    join ent_games_finance egf on eg.game_id = egf.game_id
    join ent_games_platforms egp on eg.game_id = egp.game_id
    where linux_support
    order by owners_count desc
    limit 5;