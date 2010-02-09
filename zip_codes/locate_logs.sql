DROP TABLE IF EXISTS log_denormalized ;
CREATE TABLE log_denormalized (
  `ip_address`    INTEGER UNSIGNED NOT NULL,
  `ua_hash`       CHAR(32)        CHARACTER SET `ascii` COLLATE `ascii_general_ci` NOT NULL,
  `counts`        INTEGER         DEFAULT NULL,
  `user_agent`    VARCHAR(300),
  `location_id`   INT(11)         NOT NULL,    
  `country_code`  varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `region_code`   varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `city`          varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `postal_code`   varchar(50)     CHARACTER SET `ascii` COLLATE `ascii_general_ci` default NULL,
  `latitude`      float           default NULL,
  `longitude`     float           default NULL,
  `metro_code`    int(11)         default NULL,
  `area_code`     int(11)         default NULL,
INDEX           (`location_id`),
PRIMARY KEY (ip_address, ua_hash)
) ENGINE=MYISAM DEFAULT CHARSET=utf8
;

SELECT 'log_denormalized', 'created table, crossloading', COUNT(*), NOW() FROM log_denormalized ;

INSERT INTO log_denormalized (
  ip_address,  ua_hash
  ,  counts, user_agent
  , location_id
  -- , country_code, region_code, city, postal_code, latitude, longitude, metro_code, area_code
  )
SELECT 
  lg.ip_address, lg.ua_hash
  , lg.counts, lg.user_agent
  , b.location_id
FROM      ip_log_entries lg 
LEFT JOIN ip_blocks      b   ON ( (lg.ip_address_12 = b.start_ip_12) AND (lg.ip_address BETWEEN b.start_ip AND b.end_ip) )
;

SELECT 'log_denormalized', 'crossload done', COUNT(*), NOW() FROM log_denormalized ;

UPDATE
 log_denormalized lgd, locations l
  SET
    lgd.country_code 	= l.country_code,
    lgd.region_code 	= l.region_code,
    lgd.city     	= l.city,
    lgd.postal_code 	= l.postal_code,
    lgd.latitude 	= l.latitude,
    lgd.longitude 	= l.longitude,
    lgd.metro_code 	= l.metro_code,
    lgd.area_code       = l.area_code
  WHERE lgd.location_id = l.id
    ;

SELECT 'log_denormalized', 'created table, updated location', COUNT(*), NOW() FROM log_denormalized ;
