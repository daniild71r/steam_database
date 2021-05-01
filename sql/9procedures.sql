-- безопасная вставка оценок для игры
create or replace procedure insert_game_reception(
    new_game_id int,
    new_positive_reviews int,
    new_negative_reviews int,
    new_metacritic int
)
language sql
as $$
    insert into ent_games_reception (game_id, positive_reviews, negative_reviews, positivity, metacritic)
    values (
        new_game_id,
        new_positive_reviews,
        new_negative_reviews,
        round(100.0 * new_positive_reviews / (new_positive_reviews + new_negative_reviews), 2),
        new_metacritic
    );
$$;

-- безопасное обновление оценок для игры
create or replace procedure update_game_reception(
    new_game_id int,
    new_positive_reviews int,
    new_negative_reviews int,
    new_metacritic int
)
language sql
as $$
    update ent_games_reception
    set
        positive_reviews = new_positive_reviews,
        negative_reviews = new_negative_reviews,
        positivity = round(100.0 * new_positive_reviews / (new_positive_reviews + new_negative_reviews), 2),
        metacritic = new_metacritic
    where game_id = new_game_id;
$$;

-- безопасная привязка игры к разработчику, издателю или жанру
create or replace procedure link_game(
    new_game_id int,
    new_developer_id int,
    new_publisher_id int,
    new_genre_id int
)
language plpgsql
as $$
    begin
        if new_developer_id is not null then
            insert into rel_games_developers
            values (new_game_id, new_developer_id);
        end if;
        if new_publisher_id is not null then
            insert into rel_games_publishers
            values (new_game_id, new_publisher_id);
        end if;
        if new_genre_id is not null then
            insert into rel_games_genres
            values (new_game_id, new_genre_id);
        end if;
    end;
$$;