SELECT p.phlid, p.name, ( 
    SELECT MAX(e.start) 
    FROM Event e 
    WHERE e.phlid = p.phlid
) AS recent_event_start
FROM PHLogger p
WHERE p.phlid IN (
    SELECT m.phlid
    FROM Member m, Interest i
    WHERE m.iname = i.iname
        AND i.topic = 'alcoholism'
)
AND p.phlid IN (
    SELECT t.phlid
    FROM Thought t, About a, Interest i2
    WHERE t.phlid = a.phlid
        AND t.tnum = a.tnum
        AND a.iname = i2.iname
        AND t.text LIKE '%wasted%'
        AND i2.topic = 'alcoholism'
)
AND p.phlid IN (
    SELECT e.phlid
    FROM Event e
)
ORDER BY p.phlid;