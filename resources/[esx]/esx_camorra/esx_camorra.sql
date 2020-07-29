INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_camorra','Camorra',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_camorra','Camorra',1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES 
	('society_camorra', 'Camorra', 1)
;

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('camorra', 'Camorra', 1);

--
-- Déchargement des données de la table `jobs_grades`
--

INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
('camorra', 0, 'soldato', 'Soldato', 1500, '{}', '{}'),
('camorra', 1, 'capo', 'Capo', 1800, '{}', '{}'),
('camorra', 2, 'sottocapo', 'Sottocapo', 2700, '{}', '{}'),
('camorra', 3, 'boss', 'Boss', 2900, '{}', '{}'),
('camorra', 4, 'vlasnik', 'GodFather', 3000, '{}', '{}');