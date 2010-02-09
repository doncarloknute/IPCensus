DROP TABLE IF EXISTS `ip_blocks`;
CREATE          TABLE  `ip_blocks` (
  `start_ip`      int(10)  unsigned NOT NULL,
  `end_ip`        int(10)  unsigned NOT NULL,
  `location_id`   int(11)           NOT NULL,
  `start_ip_8`    TINYINT  unsigned NOT NULL,
  `end_ip_8`      TINYINT  unsigned NOT NULL,
  `start_ip_12`   SMALLINT unsigned NOT NULL,
  `end_ip_12`     SMALLINT unsigned NOT NULL,
  INDEX       start_ip_8  (start_ip_8),
  INDEX       start_ip_12 (start_ip_12),
  PRIMARY KEY  (`start_ip`,`end_ip`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8
;

TRUNCATE TABLE ip_blocks;
ALTER TABLE ip_blocks DISABLE KEYS;
LOAD DATA INFILE '/Users/doncarlo/ics/Infochimps/IPCensus/geoip_ripd/GeoLiteCity-Blocks.csv' 
   INTO TABLE ip_blocks
   FIELDS TERMINATED BY "," ENCLOSED BY '"'
   IGNORE 2 LINES
   (start_ip, end_ip, location_id)
   SET
     start_ip_8  = start_ip >> 24,
     end_ip_8    = end_ip   >> 24,
     start_ip_12 = start_ip >> 20,
     end_ip_12   = end_ip   >> 20
;
SELECT COUNT(*), NOW(), 'ip_blocks', 'done load, enabling indexes' FROM ip_blocks ;
ALTER TABLE ip_blocks ENABLE KEYS;
SELECT COUNT(*), NOW(), 'ip_blocks', 'done import' FROM ip_blocks ;



-- DROP TABLE IF EXISTS `locations`;
-- CREATE          TABLE  `locations` (
--   `id`            int(11)          NOT NULL,
--   `country_code`  varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
--   `region_code`   varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
--   `city`          varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
--   `postal_code`   varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
--   `latitude`      float           default NULL,
--   `longitude`     float           default NULL,
--   `metro_code`    int(11)         default NULL,
--   `area_code`     int(11)         default NULL,
--   PRIMARY KEY  (`id`)
-- ) ENGINE=MYISAM DEFAULT CHARSET=utf8
-- ;

-- TRUNCATE TABLE locations;
-- ALTER TABLE locations DISABLE KEYS;
-- LOAD DATA INFILE '/Users/doncarlo/ics/Infochimps/IPCensus/geoip_ripd/GeoLiteCity-Location.csv' 
--    INTO TABLE locations
--    FIELDS TERMINATED BY "," ENCLOSED BY '"'
--    IGNORE 2 LINES
--    (id, country_code, region_code, city, postal_code, latitude, longitude, metro_code, area_code)
-- ;
-- SELECT COUNT(*), NOW(), 'locations', 'done load, enabling indexes' FROM locations ;
-- ALTER TABLE locations ENABLE KEYS;
-- SELECT COUNT(*), NOW(), 'locations', 'done import' FROM locations ;
