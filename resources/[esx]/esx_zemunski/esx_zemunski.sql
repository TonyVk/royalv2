INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_zemunski','Zemunski',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_zemunski','Zemunski',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_zemunski', 'Zemunski', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('zemunski', 'Zemunski', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('zemunski', 0, 'zemunci', 'Zemunci', 1500, '{}', '{}'),
('zemunski', 1, 'menager', 'Menager', 1800, '{}', '{}'),
('zemunski', 2, 'podsef', 'Pod sef', 2700, '{}', '{}'),
('zemunski', 3, 'boss', 'Sef', 2900, '{}', '{}'),
('zemunski', 4, 'vlasnik', 'Vlasnik', 3000, '{}', '{}');