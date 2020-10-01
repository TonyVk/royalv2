USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_zastitar', 'Zastitar', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_zastitar', 'Zastitar', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_zastitar', 'Zastitar', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('zastitar','Zastitar')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('zastitar',0,'zastitar','zastitar',20,'{}','{}'),
	('zastitar',1,'sekretar','Sekretar',40,'{}','{}'),
	('zastitar',2,'Komandant','Komandant',60,'{}','{}'),
	('zastitar',3,'boss','Gazda',85,'{}','{}')
;
