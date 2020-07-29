INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_cartel','Cartel',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_cartel','Cartel',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_cartel', 'Cartel', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('cartel', 'Cartel', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('cartel', 0, 'pocetnik', 'Pocetnik', 1500, '{}', '{}'),
('cartel', 1, 'radnik', 'Radnik', 1800, '{}', '{}'),
('cartel', 2, 'boss', 'Sef', 2700, '{}', '{}');