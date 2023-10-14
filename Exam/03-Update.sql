UPDATE 
	coaches
SET
	salary = salary * coach_level
FROM(
		SELECT
			COUNT(player_id) as "cnt"
		FROM
			players_coaches
		JOIN
			coaches
		ON
			players_coaches.coach_id = coaches.id
	) AS pc
WHERE
	SUBSTRING(first_name,1,1) = 'C' AND pc.cnt >= 1;