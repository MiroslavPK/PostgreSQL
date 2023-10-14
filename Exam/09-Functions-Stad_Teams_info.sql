CREATE OR REPLACE FUNCTION fn_stadium_team_name(
	stadium_name VARCHAR(30)
) RETURNS SETOF VARCHAR (30)
AS
$$
	BEGIN
		RETURN QUERY(
			SELECT 
				t.name 
			FROM 
				teams AS t
			JOIN
				stadiums AS s
			ON
				t.stadium_id = s.id
			WHERE 
				stadium_name = s.name
			ORDER BY
				t.name
            );
	END;
$$
LANGUAGE plpgsql;