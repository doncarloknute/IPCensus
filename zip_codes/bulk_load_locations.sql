
DROP TABLE IF EXISTS `locations`;
CREATE          TABLE  `locations` (
  `id`            int(11)          NOT NULL,
  `country_code`  varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `region_code`   varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `city`          varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `postal_code`   varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `latitude`      float           default NULL,
  `longitude`     float           default NULL,
  `metro_code`    int(11)         default NULL,
  `area_code`     int(11)         default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8
;

TRUNCATE TABLE locations;
ALTER TABLE locations DISABLE KEYS;
LOAD DATA INFILE '/Users/flip/ics/projects/IPCensus/geoip_ripd//GeoLiteCity-Location.csv' 
   INTO TABLE locations
   FIELDS TERMINATED BY "," ENCLOSED BY '"'
   IGNORE 2 LINES
   (id, country_code, region_code, city, postal_code, latitude, longitude, metro_code, area_code)
;
SELECT COUNT(*), NOW(), 'locations', 'done load, enabling indexes' FROM locations ;
ALTER TABLE locations ENABLE KEYS;
SELECT COUNT(*), NOW(), 'locations', 'done import' FROM locations ;
