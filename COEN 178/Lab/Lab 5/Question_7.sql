SELECT e.eid, e.ename
FROM Event e, Indicate i
WHERE e.eid = i.eid
    AND TIMEDIFF(e.end, e.start) > '00:45:00'
GROUP BY e.eid, e.ename
HAVING COUNT(i.observation_id) > 3;
