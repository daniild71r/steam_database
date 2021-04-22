create table games.ent_countries (
	name text unique not null,
	country_id serial not null
		constraint ent_countries_pk primary key
);

create table games.ent_developers (
	developer_id integer not null
		constraint ent_developers_pk primary key,
	name text unique not null,
	foundation_year integer
	    check (1900 <= foundation_year and foundation_year <= 2021),
	country_id integer
		constraint ent_developers_ent_countries_country_id_fk references games.ent_countries
			on update cascade on delete cascade
);

create table games.ent_games (
	game_id serial not null
	    constraint ent_games_pk primary key,
	name text not null,
	required_age integer,
	dlc_count integer,
	release_date date
);

create table games.ent_games_activity (
	game_id integer not null
		constraint ent_games_activity_pk primary key
		constraint ent_games_activity_ent_games_game_id_fk references games.ent_games
			on update cascade on delete cascade,
	average_playtime integer,
	median_playtime integer,
	peak_activity integer
);

create table games.ent_games_finance (
	game_id integer not null
		constraint ent_games_finance_pk primary key
		constraint ent_games_finance_ent_games_game_id_fk references games.ent_games
			on update cascade on delete cascade,
	is_free boolean,
	price double precision,
	owners_count double precision
);

create table games.ent_games_platforms (
	game_id integer not null
		constraint ent_games_platforms_pk primary key
		constraint ent_games_platforms_ent_games_game_id_fk references games.ent_games
		    on update cascade on delete cascade,
	controller_support boolean,
	windows_support boolean,
	mac_support boolean,
	linux_support boolean
);

create table games.ent_games_reception (
	game_id integer not null
	    constraint ent_games_reception_pk primary key
		constraint ent_games_reception_ent_games_game_id_fk references games.ent_games
		    on update cascade on delete cascade,
	positive_reviews integer,
	negative_reviews integer,
	positivity double precision
	    check (abs(positivity - 100.0 * positive_reviews / (positive_reviews + negative_reviews)) < 0.1),
	metacritic integer
        check (0 <= metacritic and metacritic <= 100)
);

create table games.ent_genres (
	genre_id serial not null
		constraint ent_genres_pk primary key,
	name text unique not null
);

create table games.ent_publishers (
	publisher_id integer not null
		constraint ent_publishers_pk primary key,
	name text unique not null,
	foundation_year integer
	    check (1900 <= foundation_year and foundation_year <= 2021),
	country_id integer
		constraint ent_publishers_ent_countries_country_id_fk references games.ent_countries
			on update cascade on delete cascade
);

create table games.rel_games_developers (
	game_id integer not null
		constraint rel_games_developers_ent_games_game_id_fk references games.ent_games
			on update cascade on delete cascade,
	developer_id integer not null
		constraint rel_games_developers_ent_developers_developer_id_fk references games.ent_developers
			on update cascade on delete cascade,
	constraint rel_games_developers_pk primary key (game_id, developer_id)
);

create table games.rel_games_genres (
	game_id integer not null
		constraint rel_games_genres_ent_games_game_id_fk references games.ent_games
			on update cascade on delete cascade,
	genre_id integer not null
		constraint rel_games_genres_ent_genres_genre_id_fk references games.ent_genres
			on update cascade on delete cascade,
	    constraint rel_games_genres_pk primary key (game_id, genre_id)
);

create table games.rel_games_publishers (
	game_id integer not null
		constraint rel_games_publishers_ent_games_game_id_fk references games.ent_games
			on update cascade on delete cascade,
	publisher_id integer not null
		constraint rel_games_publishers_ent_publishers_publisher_id_fk references games.ent_publishers
			on update cascade on delete cascade,
	constraint rel_games_publishers_pk primary key (game_id, publisher_id)
);

alter table games.ent_countries owner to postgres;
alter table games.ent_developers owner to postgres;
alter table games.ent_games owner to postgres;
alter table games.ent_games_activity owner to postgres;
alter table games.ent_games_finance owner to postgres;
alter table games.ent_games_platforms owner to postgres;
alter table games.ent_games_reception owner to postgres;
alter table games.ent_genres owner to postgres;
alter table games.ent_publishers owner to postgres;

alter table games.rel_games_developers owner to postgres;
alter table games.rel_games_genres owner to postgres;
alter table games.rel_games_publishers owner to postgres;