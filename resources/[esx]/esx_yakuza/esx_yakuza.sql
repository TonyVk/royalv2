INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_yakuza','Yakuza',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_yakuza','Yakuza',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_yakuza', 'Yakuza', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('yakuza', 'Yakuza', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('yakuza', 0, 'shinmai', 'Shinmai', 1500, '{}', '{}'),
('yakuza', 1, 'gadoman', 'Gadoman', 1800, '{}', '{}'),
('yakuza', 2, 'kyodai', 'Kyodai', 2100, '{}', '{}'),
('yakuza', 3, 'wakagashira', 'Wakagashira', 2100, '{}', '{}'),
('yakuza', 4, 'boss', 'Inagawa', 2700, '{}', '{}');