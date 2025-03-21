WITH
h1 AS (
  SELECT h1.phlid, h1.name, h1.kind, h1.manufacturer, 
    h1.model, h1.software_version,
         AVG(h1.rate) AS series_avg_rate
  FROM Heart_rate_view h1
  GROUP BY h1.phlid, h1.name, h1.kind, 
    h1.manufacturer, h1.model, h1.software_version
),
h2 AS (
  SELECT h2.phlid, AVG(h2.rate) AS overall_avg_rate
  FROM Heart_rate_view h2
  GROUP BY h2.phlid
)
SELECT h1.phlid, h1.name, h1.kind, h1.manufacturer, 
  h1.model, h1.software_version, h1.series_avg_rate, 
  h2.overall_avg_rate
FROM h1, h2
WHERE h1.phlid = h2.phlid
  AND h1.series_avg_rate < h2.overall_avg_rate * 0.8
ORDER BY h1.phlid;