SELECT DISTINCT o1.phlid,
    bp.diastolic,
    bp.systolic,
    hr.rate,
    o1.start AS observation_start
FROM Observation o1, Observable bp, Observation o2, Observable hr
WHERE o1.observation_id = bp.observation_id
    AND bp.kind = 'bloodpressure'
    AND bp.diastolic > 97
    AND bp.systolic > 196
    AND o2.observation_id = hr.observation_id
    AND hr.kind = 'heartrate'
    AND o1.phlid = o2.phlid
    AND o1.start = o2.start;
