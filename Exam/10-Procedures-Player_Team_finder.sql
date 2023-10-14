CREATE OR REPLACE PROCEDURE sp_players_team_name(
	IN player_name VARCHAR(50),
	OUT team_name VARCHAR(45)
) AS
$$
	BEGIN
		team_name=COALESCE((
		SELECT
			t.name
		FROM
			teams AS t
		LEFT JOIN
			players AS p
		ON
			p.team_id = t.id
		WHERE
			player_name = CONCAT(p.first_name, ' ', p.last_name)), 'The player currently has no team');
	END;
$$
LANGUAGE plpgsql;