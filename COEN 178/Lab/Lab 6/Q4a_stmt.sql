DROP VIEW IF EXISTS Heart_rate_view;
CREATE VIEW Heart_rate_view AS
  SELECT ob.observation_id, p.phlid, 
    p.name, ob.rate, obs.kind, obs.software_version, 
    obs.manufacturer, obs.model
  FROM PHLogger p, Observer obs, Observable ob, Observation o
  WHERE p.phlid = obs.phlid
    AND ob.observer_id = obs.observer_id
    AND ob.kind = 'heartrate';
