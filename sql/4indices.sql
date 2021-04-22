create unique index ent_countries_name_uindex
	on games.ent_countries (name);

create unique index ent_developers_name_uindex
	on games.ent_developers (name);

create index ent_games_name_index
    on games.ent_games (name);

create index ent_games_release_date_index
    on games.ent_games (release_date);

create index ent_games_activity_peak_activity_index
    on games.ent_games_activity (peak_activity desc);

create index ent_games_finance_owners_count_index
	on games.ent_games_finance (owners_count desc);

create index ent_games_reception_metacritic_index
	on games.ent_games_reception (metacritic desc);

create index ent_games_reception_positivity_index
	on games.ent_games_reception (positivity desc);

create unique index ent_genres_name_uindex
	on games.ent_genres (name);

create unique index ent_publishers_name_uindex
                	on games.ent_publishers (name);