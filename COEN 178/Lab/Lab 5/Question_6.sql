SELECT e.ename, COUNT(i.observation_id) AS obs_count
FROM Event e, Indicate i
WHERE e.eid = i.eid
  AND e.ename LIKE '%ball%'
GROUP BY e.ename
HAVING COUNT(i.observation_id) > 3;