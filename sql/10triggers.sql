-- оповещение о подмене данных при ручной вставке
create or replace function check_game_reception_with_notification()
returns trigger
language plpgsql
as $$
    declare
        verb1 text := '';
        verb2 text := '';
    begin
        new.positivity = round(100.0 * new.positive_reviews / (new.positive_reviews + new.negative_reviews), 2);
        if tg_op = 'INSERT' then
            verb1 = 'inserted';
            verb2 = 'insert';
        elsif tg_op = 'UPDATE' then
            verb1 = 'updated';
            verb2 = 'update';
        end if;
        raise notice 'You % into the receptions table manually and your data were automatically corrected', verb1;
        raise notice 'Next time please use %_game_reception procedure', verb2;
        return new;
    end;
$$;

create trigger check_game_reception
before insert or update on ent_games_reception
for each row
execute procedure check_game_reception_with_notification();

-- обновление данных о разработчике при получении данных о нем как об издателе
create or replace function update_developer_on_updating_publisher()
returns trigger
language plpgsql
as $$
    begin
        if tg_op = 'INSERT' then
            update ent_developers
            set
                country_id = new.country_id,
                foundation_year = new.foundation_year
            where name = new.name;
        elsif tg_op = 'UPDATE' then
            update ent_developers
            set
                name = new.name,
                country_id = new.country_id,
                foundation_year = new.foundation_year
            where name = old.name;
        end if;
    end;
$$;

-- обновление данных об издателе при получении данных о нем как о разработчике
create or replace function update_publisher_on_updating_developer()
returns trigger
language plpgsql
as $$
    begin
        if tg_op = 'INSERT' then
            update ent_publishers
            set
                country_id = new.country_id,
                foundation_year = new.foundation_year
            where name = new.name;
        elsif tg_op = 'UPDATE' then
            update ent_publishers
            set
                name = new.name,
                country_id = new.country_id,
                foundation_year = new.foundation_year
            where name = old.name;
        end if;
    end;
$$;

create trigger update_developer
before insert or update on ent_publishers
for each row
execute procedure update_developer_on_updating_publisher();

create trigger update_publisher
before insert or update on ent_developers
for each row
execute procedure update_publisher_on_updating_developer();