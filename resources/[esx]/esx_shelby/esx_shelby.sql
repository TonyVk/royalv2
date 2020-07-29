INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_shelby','Shelby',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_shelby','Shelby',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_shelby', 'Shelby', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('shelby', 'Shelby', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('shelby', 0, 'pocetnik', 'Pocetnik', 1500, '{}', '{}'),
('shelby', 1, 'clan', 'Clan', 1800, '{}', '{}'),
('shelby', 2, 'zamjenik', 'Zamjenik sefa', 2700, '{}', '{}'),
('shelby', 3, 'boss', 'Sef', 2900, '{}', '{}'),
('shelby', 4, 'vlasnik', 'Vlasnik', 3000, '{}', '{}');