
ALTER TABLE ip_blocks DISABLE KEYS;

LOAD DATA INFILE '/Users/doncarlo/ics/Infochimps/IPCensus/geoip_ripd/GeoLiteCity-Blocks.csv' 
   REPLACE INTO TABLE ip_blocks
   FIELDS TERMINATED BY "," ENCLOSED BY '"'
   IGNORE 2 LINES
   (start_ip, end_ip, location_id)
;

ALTER TABLE ip_blocks ENABLE KEYS;

SELECT COUNT(*), 'ip_blocks' FROM ip_blocks ;


ALTER TABLE locations DISABLE KEYS;

LOAD DATA INFILE '/Users/doncarlo/ics/Infochimps/IPCensus/geoip_ripd/GeoLiteCity-Location.csv' 
   REPLACE INTO TABLE locations
   FIELDS TERMINATED BY "," ENCLOSED BY '"'
   IGNORE 2 LINES
   (location_id, country_code, region_code, city, postal_code, latitude, longitude, metro_code, area_code)
;

ALTER TABLE locations ENABLE KEYS;

SELECT COUNT(*), 'locations' FROM locations ;