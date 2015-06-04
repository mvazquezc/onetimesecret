SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `onetimesecret`
--

CREATE TABLE IF NOT EXISTS `data` (
  `token` char(32) COLLATE utf8_unicode_ci NOT NULL,
  `secret` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(3358) COLLATE utf8_unicode_ci NOT NULL,
  `creationtime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `timetolive` timestamp NULL DEFAULT NULL,
  `status` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `stats` (
`operationNumber` int(11) NOT NULL,
  `passwordProtected` tinyint(1) NOT NULL,
  `operation` char(6) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `tokens` (
  `token` char(32) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `data`
 ADD PRIMARY KEY (`token`);

ALTER TABLE `stats`
 ADD PRIMARY KEY (`operationNumber`);

ALTER TABLE `tokens`
 ADD PRIMARY KEY (`token`);

ALTER TABLE `stats`
MODIFY `operationNumber` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=0;