DROP TABLE IF EXISTS `mete`;
CREATE TABLE IF NOT EXISTS `mete` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `cijena` int(11) NOT NULL,
  `ime` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`)
);
