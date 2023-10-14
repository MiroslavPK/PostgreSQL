SELECT 
	t.id AS "team_id",
	t.name AS "team_name",
	COUNT(p.id) AS "players_count",
	t.fan_base
FROM
	teams AS t
LEFT JOIN
	players AS p
ON
	p.team_id = t.id
WHERE
	t.fan_base > 30000
GROUP BY
	t.id,t."name",t.fan_base
ORDER BY
	"players_count" DESC,
	t.fan_base DESC;