SELECT name
FROM PHLogger
WHERE phlid IN (
  SELECT phlid
  FROM Member
  GROUP BY phlid
  HAVING COUNT(*) > 4
);
