SELECT COUNT(DISTINCT m.phlid) as num_users_no_post
FROM Member m
WHERE NOT EXISTS (
  SELECT *
    FROM About a, Thought t
    WHERE a.phlid = t.phlid
    And t.phlid = m.phlid
    AND a.iname = m.iname
    AND a.tnum = t.tnum
)