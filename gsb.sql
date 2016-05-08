-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Dim 08 Mai 2016 à 22:51
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `gsb`
--

-- --------------------------------------------------------

--
-- Structure de la table `carburant`
--

CREATE TABLE IF NOT EXISTS `carburant` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `LIBELLE` varchar(100) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Contenu de la table `carburant`
--

INSERT INTO `carburant` (`ID`, `LIBELLE`) VALUES
(1, 'Essence'),
(2, 'Diesel');

-- --------------------------------------------------------

--
-- Structure de la table `etat`
--

CREATE TABLE IF NOT EXISTS `etat` (
  `ID` char(2) NOT NULL,
  `LIBELLE` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `etat`
--

INSERT INTO `etat` (`ID`, `LIBELLE`) VALUES
('CL', 'Saisie clôturée'),
('CR', 'Fiche créée, saisie en cours'),
('RB', 'Remboursée'),
('VA', 'Validée et mise en paiement');

-- --------------------------------------------------------

--
-- Structure de la table `fichefrais`
--

CREATE TABLE IF NOT EXISTS `fichefrais` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `IDTARIF` int(10) NOT NULL,
  `KILOMETRES` int(10) NOT NULL,
  `DATEFICHE` date NOT NULL,
  `TOTAL` float NOT NULL,
  `IDVISITEUR` char(4) CHARACTER SET utf8 NOT NULL,
  `IDETAT` char(2) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `IDTARIF` (`IDTARIF`),
  KEY `IDVISITEUR` (`IDVISITEUR`),
  KEY `IDETAT` (`IDETAT`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Contenu de la table `fichefrais`
--

INSERT INTO `fichefrais` (`ID`, `IDTARIF`, `KILOMETRES`, `DATEFICHE`, `TOTAL`, `IDVISITEUR`, `IDETAT`) VALUES
(1, 1, 10, '2016-05-04', 3, 'a17', 'RB'),
(2, 3, 10, '2016-05-04', 4, 'a17', 'RB'),
(3, 3, 15, '2016-05-04', 6, 'a17', 'CL'),
(4, 4, 40, '2016-05-04', 20, 'a17', 'CL'),
(5, 4, 110, '2016-05-04', 55, 'a17', 'CR'),
(6, 3, 35, '2016-05-08', 14, 'a17', 'CR');

-- --------------------------------------------------------

--
-- Structure de la table `nouveautarif`
--

CREATE TABLE IF NOT EXISTS `nouveautarif` (
  `IDVERSION` int(10) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`IDVERSION`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=44 ;

--
-- Contenu de la table `nouveautarif`
--

INSERT INTO `nouveautarif` (`IDVERSION`) VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18),
(19),
(20),
(21),
(22),
(23),
(24),
(25),
(26),
(27),
(28),
(29),
(30),
(31),
(32),
(33),
(34),
(35),
(36),
(37),
(38),
(39),
(40),
(41),
(42),
(43);

-- --------------------------------------------------------

--
-- Structure de la table `puissance`
--

CREATE TABLE IF NOT EXISTS `puissance` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `LIBELLE` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Contenu de la table `puissance`
--

INSERT INTO `puissance` (`ID`, `LIBELLE`) VALUES
(1, '4CV'),
(3, '8V'),
(6, '14CV');

-- --------------------------------------------------------

--
-- Structure de la table `tarifs`
--

CREATE TABLE IF NOT EXISTS `tarifs` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IDPUISSANCE` int(100) NOT NULL,
  `IDCARBURANT` int(100) NOT NULL,
  `PRIX` float NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `tarifs`
--

INSERT INTO `tarifs` (`ID`, `IDPUISSANCE`, `IDCARBURANT`, `PRIX`) VALUES
(1, 1, 1, 0.3),
(2, 1, 2, 0.2),
(3, 2, 1, 0.4),
(4, 2, 2, 0.5);

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `ID` char(4) NOT NULL,
  `NOM` char(30) DEFAULT NULL,
  `PRENOM` char(30) DEFAULT NULL,
  `LOGIN` char(20) DEFAULT NULL,
  `AMDP` char(20) NOT NULL,
  `ADRESSE` char(30) DEFAULT NULL,
  `CP` char(5) DEFAULT NULL,
  `VILLE` char(30) DEFAULT NULL,
  `DATEEMBAUCHE` date DEFAULT NULL,
  `MDP` text,
  `METIER` char(20) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Contenu de la table `user`
--

INSERT INTO `user` (`ID`, `NOM`, `PRENOM`, `LOGIN`, `AMDP`, `ADRESSE`, `CP`, `VILLE`, `DATEEMBAUCHE`, `MDP`, `METIER`) VALUES
('a131', 'Villechalane', 'Louis', 'lvillachane', 'jux7g', '8 rue des Charmes', '46000', 'Cahors', '2005-12-21', '3abf9eb797afe468902101efe6b4b00f7d50802a', 'visiteur'),
('a17', 'Andre', 'David', 'dandre', 'oppg5', '1 rue Petit', '46200', 'Lalbenque', '1998-11-23', '12e0b9be32932a8028b0ef0432a0a0a99421f745', 'comptable'),
('a55', 'Bedos', 'Christian', 'cbedos', 'gmhxd', '1 rue Peranud', '46250', 'Montcuq', '1995-01-12', 'a34b9dfadee33917a63c3cdebdc9526230611f0b', 'visiteur'),
('a93', 'Tusseau', 'Louis', 'ltusseau', 'ktp3s', '22 rue des Ternes', '46123', 'Gramat', '2000-05-01', 'f1c1d39e9898f3202a2eaa3dc38ae61575cd77ad', 'visiteur'),
('b13', 'Bentot', 'Pascal', 'pbentot', 'doyw1', '11 allée des Cerises', '46512', 'Bessines', '1992-07-09', '178e1efaf000fdf2267edc43fad2a65197a0ab10', 'visiteur'),
('b16', 'Bioret', 'Luc', 'lbioret', 'hrjfs', '1 Avenue gambetta', '46000', 'Cahors', '1998-05-11', 'ab7fa51f9bf8fde35d9e5bcc5066d3b71dda00d2', 'visiteur'),
('b19', 'Bunisset', 'Francis', 'fbunisset', '4vbnd', '10 rue des Perles', '93100', 'Montreuil', '1987-10-21', 'aa710ca3a1f12234bc2872aa0a6f88d6cf896ae4', 'visiteur'),
('b25', 'Bunisset', 'Denise', 'dbunisset', 's1y1r', '23 rue Manin', '75019', 'paris', '2010-12-05', '40ff56dc0525aa08de29eba96271997a91e7d405', 'visiteur'),
('b28', 'Cacheux', 'Bernard', 'bcacheux', 'uf7r3', '114 rue Blanche', '75017', 'Paris', '2009-11-12', '51a4fac4890def1ef8605f0b2e6554c86b2eb919', 'visiteur'),
('b34', 'Cadic', 'Eric', 'ecadic', '6u8dc', '123 avenue de la République', '75011', 'Paris', '2008-09-23', '2ed5ee95d2588be3650a935ff7687dee46d70fc8', 'visiteur'),
('b4', 'Charoze', 'Catherine', 'ccharoze', 'u817o', '100 rue Petit', '75019', 'Paris', '2005-11-12', '8b16cf71ab0842bd871bce99a1ba61dd7e9d4423', 'visiteur'),
('b50', 'Clepkens', 'Christophe', 'cclepkens', 'bw1us', '12 allée des Anges', '93230', 'RomainVILLE', '2003-08-11', '7ddda57eca7a823c85ac0441adf56928b47ece76', 'visiteur'),
('b59', 'Cottin', 'Vincenne', 'vcottin', '2hoh9', '36 rue Des Roches', '93100', 'Monteuil', '2001-11-18', '2f95d1cac7b8e7459376bf36b93ae7333026282d', 'visiteur'),
('c14', 'Daburon', 'François', 'fdaburon', '7oqpv', '13 rue de Chanzy', '94000', 'Créteil', '2002-02-11', '5c7cc4a7f0123460c29c84d8f8a73bc86184adbb', 'visiteur'),
('c3', 'De', 'Philippe', 'pde', 'gk9kx', '13 rue Barthes', '94000', 'Créteil', '2010-12-14', '03b03872dd570959311f4fb9be01788e4d1a2abf', 'visiteur'),
('c54', 'Debelle', 'Michel', 'mdebelle', 'od5rt', '181 avenue Barbusse', '93210', 'Rosny', '2006-11-23', '1fa95c2fac5b14c6386b73cbe958b663fc66fdfa', 'visiteur'),
('d13', 'Debelle', 'Jeanne', 'jdebelle', 'nvwqq', '134 allée des Joncs', '44000', 'Nantes', '2000-05-11', '18c2cad6adb7cee7884f70108cfd0a9b448be9be', 'visiteur'),
('d51', 'Debroise', 'Michel', 'mdebroise', 'sghkb', '2 Bld Jourdain', '44000', 'Nantes', '2001-04-17', '46b609fe3aaa708f5606469b5bc1c0fa85010d76', 'visiteur'),
('e22', 'Desmarquest', 'Nathalie', 'ndesmarquest', 'f1fob', '14 Place d Arc', '45000', 'Orléans', '2005-11-12', 'abc20ea01dabd079ddd63fd9006e7232e442973c', 'visiteur'),
('e24', 'Desnost', 'Pierre', 'pdesnost', '4k2o5', '16 avenue des Cèdres', '23200', 'Guéret', '2001-02-05', '8eaa8011ec8aa8baa63231a21d12f4138ccc1a3d', 'visiteur'),
('e39', 'Dudouit', 'Frédéric', 'fdudouit', '44im8', '18 rue de l église', '23120', 'GrandBourg', '2000-08-01', '55072fa16c988da8f1fb31e40e4ac5f325ac145d', 'visiteur'),
('e49', 'Duncombe', 'Claude', 'cduncombe', 'qf77j', '19 rue de la tour', '23100', 'La souteraine', '1987-10-10', '577576f0b2c56c43b596f701b782870c8742c592', 'visiteur'),
('e5', 'Enault-Pascreau', 'Céline', 'cenault', 'y2qdu', '25 place de la gare', '23200', 'Gueret', '1995-09-01', 'cc0fb4115bb04c613fd1b95f4792fc44f07e9f4f', 'visiteur'),
('e52', 'Eynde', 'Valérie', 'veynde', 'i7sn3', '3 Grand Place', '13015', 'Marseille', '1999-11-01', 'd06ace8d729693904c304625e6a6fab6ab9e9746', 'visiteur'),
('f21', 'Finck', 'Jacques', 'jfinck', 'mpb3t', '10 avenue du Prado', '13002', 'Marseille', '2001-11-10', '6d8b2060b60132d9bdb09d37913fbef637b295f2', 'visiteur'),
('f39', 'Frémont', 'Fernande', 'ffremont', 'xs5tq', '4 route de la mer', '13012', 'Allauh', '1998-10-01', 'aa45efe9ecbf37db0089beeedea62ceb57db7f17', 'visiteur'),
('f4', 'Gest', 'Alain', 'agest', 'dywvt', '30 avenue de la mer', '13025', 'Berre', '1985-11-01', '1af7dedacbbe8ce324e316429a816daeff4c542f', 'visiteur');

--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `fichefrais`
--
ALTER TABLE `fichefrais`
  ADD CONSTRAINT `fichefrais_ibfk_3` FOREIGN KEY (`IDETAT`) REFERENCES `etat` (`ID`),
  ADD CONSTRAINT `fichefrais_ibfk_1` FOREIGN KEY (`IDTARIF`) REFERENCES `tarifs` (`ID`),
  ADD CONSTRAINT `fichefrais_ibfk_2` FOREIGN KEY (`IDVISITEUR`) REFERENCES `user` (`ID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
