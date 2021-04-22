-- 5 стран, лидирующих по суммарному числу разработчиков и издателей, причастных к выпуску хотя бы 7 популярных игр
select country, count(studio) as studio_count from (
    select max(ec.name) as country, ed.name as studio
    from ent_developers ed
    join ent_countries ec on ed.country_id = ec.country_id
    join rel_games_developers rgd on ed.developer_id = rgd.developer_id
    group by ed.developer_id
    having count(rgd.game_id) >= 7
    union
    select max(ec.name) as country, ep.name as studio
    from ent_publishers ep
    join ent_countries ec on ep.country_id = ec.country_id
    join rel_games_publishers rgp on ep.publisher_id = rgp.publisher_id
    group by ep.publisher_id
    having count(rgp.game_id) >= 7
) as country_studios
group by country
order by studio_count desc
limit(5);

-- Время между датами выхода платных игр от студии CD PROJEKT RED (в днях)
select game, release, release - lag(release, 1) over (
    order by release
) as difference from (
    select eg.name as game, eg.release_date as release from ent_developers ed
    join rel_games_developers rgd on ed.developer_id = rgd.developer_id
    join ent_games eg on rgd.game_id = eg.game_id
    join ent_games_finance egf on eg.game_id = egf.game_id
    where ed.name = 'CD PROJEKT RED' and not egf.is_free
) as game_release;

-- Отдельная и суммарная выручка от продажи игр разработчиков каждой скандинавских стран
select developer, country, revenue, sum(revenue) over (
    partition by country
) as sum from (
    select ed.name as developer, sum(egf.owners_count * egf.price) as revenue, max(ec.name) as country
    from ent_developers ed
    join ent_countries ec on ed.country_id = ec.country_id
    join rel_games_developers rgd on ed.developer_id = rgd.developer_id
    join ent_games eg on rgd.game_id = eg.game_id
    join ent_games_finance egf on eg.game_id = egf.game_id
    where ec.name in ('Finland', 'Denmark', 'Sweden', 'Norway') and egf.price is not null
    group by ed.developer_id
) as scand_devs
order by sum desc;

-- Рост суммарного число проданных копий с каждой новой игрой у разработчиков Valve, id Software и BioWare
select ed.name as developer, eg.name as game, release_date, sum(egf.owners_count) over (
    partition by ed.developer_id
    order by release_date
) as total_sells from ent_developers ed
join rel_games_developers rgd on ed.developer_id = rgd.developer_id
join ent_games eg on rgd.game_id = eg.game_id
join ent_games_finance egf on eg.game_id = egf.game_id
where ed.name in ('Valve', 'id Software', 'BioWare');

-- Распределение мест по степени "скандальности" игр с большим числом продаж, но низкими рейтингами
select game, owners_count, positivity, rank() over(
    order by positivity
) from (
    select eg.name as game, egf.owners_count, egr.positivity from ent_games eg
    join ent_games_finance egf on eg.game_id = egf.game_id
    join ent_games_reception egr on eg.game_id = egr.game_id
    where owners_count > 5000000 and positivity < 75
) as dubious_games;