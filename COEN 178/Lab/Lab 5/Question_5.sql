SELECT *
FROM PHLogger p
WHERE p.phlid IN (
    SELECT m.phlid
    FROM Member m, Interest i
    WHERE m.iname = i.iname
        AND i.topic LIKE '%exercise%'
)
AND p.phlid IN (
    SELECT obs.phlid
    FROM Observation obs, PHLG_obs pobs, Event e
    WHERE obs.observation_id = pobs.observation_id
        AND pobs.text LIKE '%jet skiing%'
        AND obs.phlid = e.phlid
        AND e.ename = 'camping'
);
