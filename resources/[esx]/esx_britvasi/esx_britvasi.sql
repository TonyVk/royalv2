INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_britvasi','Britvasi',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_britvasi','Britvasi',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_britvasi', 'Britvasi', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('britvasi', 'Britvasi', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('britvasi', 0, 'pocetnik', 'Pocetnik', 1500, '{}', '{}'),
('britvasi', 1, 'clan', 'Clan', 1800, '{}', '{}'),
('britvasi', 2, 'zamjenik', 'Zamjenik sefa', 2700, '{}', '{}'),
('britvasi', 3, 'boss', 'Glavni baja', 2900, '{}', '{}'),
('britvasi', 4, 'vlasnik', 'Vlasnik', 3000, '{}', '{}');