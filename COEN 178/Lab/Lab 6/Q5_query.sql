CALL AddThought('1', 'alcoholism 0', 'PHLogger APP IS THE BEST!');

SELECT *
FROM About a, Thought t
WHERE a.phlid = 1
  AND t.phlid = a.phlid
  AND a.tnum = t.tnum
  AND t.text LIKE 'PHLogger%';
