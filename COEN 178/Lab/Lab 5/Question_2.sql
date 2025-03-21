SELECT DISTINCT ph.name, u.email
FROM PHLogger ph, User u, Thought th, About ab, Interest i, Member m
WHERE ph.phlid = u.phlid
  AND ph.phlid = th.phlid
  AND th.phlid = ab.phlid 
  AND ab.iname = i.iname
  AND ph.phlid = m.phlid
  AND i.iname = m.iname
  AND i.topic = 'exercise';
