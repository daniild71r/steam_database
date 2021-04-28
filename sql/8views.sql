-- перевод числа в строку диапазона, в который оно входит
create or replace function to_range_string(
    number int
)
returns text as $$
declare
    lower int := 1;
    upper int := 1;
    result text := '';
begin
    while number >= 10 loop
        number := number / 10;
        lower := lower * 10;
        upper := upper * 10;
    end loop;

    case
        when (number < 2) then begin
            lower := lower * 1;
            upper := upper * 2;
        end;
        when (number < 5) then begin
            lower := lower * 2;
            upper := upper * 5;
        end;
        else begin
            lower := lower * 5;
            upper := upper * 10;
        end;
    end case;

    result := concat(lower, ' - ', upper);
    return result;
end;
$$ language plpgsql;

-- перевод цены и числа владельцев в форматированную строку прибыли с продаж
create or replace function to_revenue_string(
    price int,
    owners_count int
)
returns text as $$
declare
    revenue double precision := (owners_count / 1000.0) * price;
    suffix text := '';
    result text := '';
begin
    case
        when (revenue < 1000) then begin
            revenue := round(revenue);
            suffix := 'K';
        end;
        when (revenue < 1000000) then begin
            revenue := round(revenue / 100.0) / 10.0;
            suffix := 'M';
        end;
        else begin
            revenue := round(revenue / 100000.0) / 10.0;
            suffix := 'B';
        end;
    end case;

    result := concat(revenue, suffix, ' RUB');
    return result;
end;
$$ language plpgsql;

-- замена точного числа владельцев на диапазон для пользователей с ограниченным доступом
create or replace view view_games_finance_limited as
select game_id, to_range_string(owners_count) as owners_range
from ent_games_finance;

-- замена цены и числа владельцев на форматированную строку прибыли с продаж
create or replace view view_games_revenues as
select game_id, to_revenue_string(price, owners_count) as owners_range
from ent_games_finance;

-- игры, у которых известен разработчик
create or replace view view_games_with_developers as
select eg.game_id, eg.name game_name, release_date, ed.developer_id, ed.name developer_name
from ent_games eg
join rel_games_developers rgd on eg.game_id = rgd.game_id
join ent_developers ed on rgd.developer_id = ed.developer_id;

-- игры, у которых известен издатель
create or replace view view_games_with_publishers as
select eg.game_id, eg.name game_name, release_date, ep.publisher_id, ep.name publisher_name
from ent_games eg
join rel_games_publishers rgp on eg.game_id = rgp.game_id
join ent_publishers ep on rgp.publisher_id = ep.publisher_id;

-- игры, у которых известен жанр
create or replace view view_games_with_genres as
select eg.game_id, eg.name game_name, release_date, egn.genre_id, egn.name genre_name
from ent_games eg
join rel_games_genres rgg on eg.game_id = rgg.game_id
join ent_genres egn on rgg.genre_id = egn.genre_id;

-- числовые характеристики игр
create or replace view view_games_numeric_statistics as
select eg.game_id, name, release_date, peak_activity, price, owners_count, positivity, metacritic
from ent_games eg
left join ent_games_activity ega on eg.game_id = ega.game_id
left join ent_games_finance egf on eg.game_id = egf.game_id
left join ent_games_reception egr on eg.game_id = egr.game_id;

select * from view_games_finance_limited;
select * from view_games_revenues;
select * from view_games_with_developers;
select * from view_games_with_publishers;
select * from view_games_with_genres;
select * from view_games_numeric_statistics;