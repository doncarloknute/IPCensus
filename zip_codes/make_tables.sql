
DROP TABLE IF EXISTS `ip_log_entries`;
CREATE          TABLE  `ip_log_entries` (
  `counts`        int(11)            default NULL,
  `ip_address`    int(10) unsigned   NOT NULL,
  `ua_hash`       char(32)           CHARACTER SET `ascii` COLLATE `ascii_general_ci` NOT NULL,
  `user_agent`    varchar(300),
  ip_address_8    TINYINT  UNSIGNED  NOT NULL,
  ip_address_12   SMALLINT UNSIGNED  NOT NULL,
  INDEX ip_address    (`ip_address`),
  INDEX ip_address_8  (`ip_address_8`),
  INDEX ip_address_12 (`ip_address_12`),
  PRIMARY KEY  (`ip_address`,`ua_hash`)
) ENGINE=MYISAM DEFAULT CHARSET=utf8
;
