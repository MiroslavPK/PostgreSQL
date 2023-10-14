SELECT
	p.id,
	CONCAT(p.first_name, ' ', p.last_name) AS "full_name",
	p.age,
	p.position,
	p.salary,
	sd.pace,
	sd.shooting
FROM
	players AS p
JOIN
	skills_data AS sd
ON
	sd.id = p.skills_data_id
WHERE
	p.position = 'A' 
AND 
	(sd.pace + sd.shooting) > 130
AND
	team_id IS NULL;