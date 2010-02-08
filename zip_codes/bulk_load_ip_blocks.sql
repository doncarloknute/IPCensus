
ALTER TABLE ip_blocks DISABLE KEYS;

LOAD DATA INFILE '/Users/doncarlo/ics/Infochimps/IPCensus/geoip_ripd/GeoLiteCity-Blocks.csv' 
   REPLACE INTO TABLE ip_blocks
   FIELDS TERMINATED BY "," ENCLOSED BY '"'
   IGNORE 2 LINES
   (start_ip, end_ip, location_id)
;

ALTER TABLE ip_blocks ENABLE KEYS;

SELECT COUNT(*), 'ip_blocks' FROM ip_blocks ;