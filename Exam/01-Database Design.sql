-- CREATE DATABASE soccer_talents_db;

CREATE TABLE towns(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL
);

CREATE TABLE stadiums(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	capacity INT NOT NULL,
	town_id INT NOT NULL,
	
	CONSTRAINT ck_capacity 
		CHECK (capacity > 0),
	
	CONSTRAINT fk_stadiums_towns
		FOREIGN KEY (town_id)
			REFERENCES towns(id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE TABLE teams(
	id SERIAL PRIMARY KEY,
	name VARCHAR(45) NOT NULL,
	established DATE NOT NULL,
	fan_base INT DEFAULT 0 NOT NULL,
	stadium_id INT NOT NULL,
	
	CONSTRAINT ck_fan_base
		CHECK (fan_base >= 0),
	
	CONSTRAINT fk_teams_stadiums
		FOREIGN KEY (stadium_id)
			REFERENCES stadiums(id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);


CREATE TABLE coaches(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	salary NUMERIC(10,2) DEFAULT 0 NOT NULL,
	coach_level INT DEFAULT 0 NOT NULL

	CONSTRAINT ck_salary
		CHECK (salary >= 0),
	CONSTRAINT ck_coach_level
		CHECK (coach_level >= 0)
);

CREATE TABLE skills_data(
	id SERIAL PRIMARY KEY,
	dribbling INT DEFAULT 0,
	pace INT DEFAULT 0,
	passing INT DEFAULT 0,
	shooting INT DEFAULT 0,
	speed INT DEFAULT 0,
	strength INT DEFAULT 0,
	
	CONSTRAINT ck_dribbling CHECK (dribbling >= 0),
	CONSTRAINT ck_pace CHECK (pace >= 0),
	CONSTRAINT ck_passing CHECK (passing >= 0),
	CONSTRAINT ck_shooting CHECK (shooting >= 0),
	CONSTRAINT ck_speed CHECK (speed >= 0),
	CONSTRAINT ck_strength CHECK (strength >= 0)
);

CREATE TABLE players(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(10) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	age INT DEFAULT 0 NOT NULL,
	position CHAR(1) NOT NULL,
	salary NUMERIC(10,2) DEFAULT 0 NOT NULL,
	hire_date TIMESTAMP,
	skills_data_id INT NOT NULL,
	team_id INT,

	CONSTRAINT ck_age CHECK (age >= 0),
	CONSTRAINT ck_salary CHECK (salary >= 0),

	CONSTRAINT fk_players_skills_data
		FOREIGN KEY (skills_data_id)
			REFERENCES skills_data(id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	
	CONSTRAINT fk_players_teams
		FOREIGN KEY (team_id)
			REFERENCES teams(id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);

CREATE TABLE players_coaches(
	player_id INT,
	coach_id INT,
	
	CONSTRAINT pk_players_coaches
		PRIMARY KEY (player_id, coach_id),
	CONSTRAINT fk_players_coaches_players
		FOREIGN KEY (player_id)
			REFERENCES players(id)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
	CONSTRAINT fk_players_coaches_coaches
		FOREIGN KEY (coach_id)
			REFERENCES coaches(id)
			ON UPDATE CASCADE
			ON DELETE CASCADE
);