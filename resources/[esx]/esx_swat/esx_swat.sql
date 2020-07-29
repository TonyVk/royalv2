USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_swat', 'swat', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_swat', 'swat', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_swat', 'swat', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('swat','S.W.A.T')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('swat',0,'recruit','Kadet',5000,'{}','{}'),
	('swat',1,'officer','Intervent',6500,'{}','{}'),
	('swat',2,'sergeant','Vodja',8000,'{}','{}'),
	('swat',3,'lieutenant','Kapetan',9000,'{}','{}'),
	('swat',4,'boss','Komandant',10000,'{}','{}')
;
