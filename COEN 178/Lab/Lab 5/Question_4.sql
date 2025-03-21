SELECT DISTINCT o.model, o.manufacturer
FROM Observer o, Observable ob
WHERE o.observer_id = ob.observer_id
  AND o.kind = 'smartwatch'
  AND ob.kind = 'bloodpressure'
  AND ob.diastolic = (
    SELECT MIN(diastolic)
    FROM Observable
    WHERE kind = 'bloodpressure'
  );
