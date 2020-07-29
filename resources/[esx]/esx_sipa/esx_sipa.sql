USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_sipa', 'SIPA', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_sipa', 'SIPA', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_sipa', 'SIPA', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('sipa','SIPA')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('sipa',0,'intendent','SIPA',20,'{}','{}'),
	('sipa',1,'boss','Komandant',40,'{}','{}')
;
