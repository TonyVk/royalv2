USE `essentialmode`;

CREATE TABLE `shops2` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`store` varchar(100) NOT NULL,
	`owner` varchar(60) NULL,
	`sef` int(11) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `shops2` (store, owner, sef) VALUES
	('TwentyFourSeven1',null,0),
	('TwentyFourSeven2',null,0),
	('TwentyFourSeven3',null,0),
	('TwentyFourSeven4',null,0),
	('TwentyFourSeven5',null,0),
	('TwentyFourSeven6',null,0),
	('TwentyFourSeven7',null,0),
	('TwentyFourSeven8',null,0),
	('RobsLiquor1',null,0),
	('RobsLiquor2',null,0),
	('RobsLiquor3',null,0),
	('RobsLiquor4',null,0),
	('RobsLiquor5',null,0),
	('RobsLiquor6',null,0),
	('LTDgasoline1',null,0),
	('LTDgasoline2',null,0),
	('LTDgasoline3',null,0),
	('LTDgasoline4',null,0),
	('LTDgasoline5',null,0)
;