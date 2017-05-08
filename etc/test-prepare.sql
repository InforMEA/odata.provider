-- MySQL dump 10.13  Distrib 5.5.44, for osx10.11 (x86_64)
--
-- Host: localhost    Database: informea_odata_test
-- ------------------------------------------------------
-- Server version	5.5.44-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `informea_contacts`
--

DROP VIEW IF EXISTS `informea_contacts`;
DROP TABLE IF EXISTS `informea_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_contacts` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `country` char(2) NOT NULL DEFAULT '' COMMENT 'Represented country (ISO code)',
  `prefix` varchar(255) DEFAULT NULL COMMENT 'Addressing (ex. Mr, Ms., H.R.H. etc.)',
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `institution` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL COMMENT 'See API doc for possible values',
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL COMMENT 'Single e-mail address',
  `phoneNumber` varchar(255) DEFAULT NULL,
  `fax` varchar(255) DEFAULT NULL,
  `primary` int(1) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Date of last update. If not leave to default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_contacts`
--

LOCK TABLES `informea_contacts` WRITE;
/*!40000 ALTER TABLE `informea_contacts` DISABLE KEYS */;
INSERT INTO `informea_contacts` VALUES ('471d81c2-4a22-4574-9fd1-0341797ec6de','AL','Mr.','John','Doe','Director','Biodiversity Directorate','department 1','Primary','address 1','email1@moe.gov.al','+4 224 3578','+355',1,'2016-03-29 17:21:54'),('c6626713-3a16-485c-952c-718802a21b5b','AD','Mrs.','Josep','Christiansen','Desk Officer de l\'Environnement','Département du Patrimoine naturel','department 3',NULL,NULL,'email2@govern.ad','+ 875 700','+376 869',0,'2016-03-30 13:21:54'),('c9b98891-6347-4755-9cdb-a08268849abb','DZ','Ms.','Chorn','Mali','Sous directrice','Direction Générale des Forêts','department 2',NULL,'address 2','email3@dgf.gov.dz','','',0,'2016-02-10 14:21:54'),('e949e7b9-4a45-4ed0-b06e-679e55c31e5e','AR',NULL,'Seren Janir',NULL,'Subdirectora General de Medio Ambiente','Dirección General de Asuntos Ambientales,',NULL,NULL,NULL,'email4@mrecic.gov.ar','','',0,'2016-03-30 13:21:54'),('ec8b6c87-aa11-4297-9c89-b25320a54827','AG',NULL,NULL,'Philm A. JAMES','Deputy Chief Fisheries Officer','Fisheries Division','department 4',NULL,NULL,'email5@gmail.com','','',0,'2016-03-30 13:21:54');
/*!40000 ALTER TABLE `informea_contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_contacts_treaties`
--

DROP VIEW IF EXISTS `informea_contacts_treaties`;
DROP TABLE IF EXISTS `informea_contacts_treaties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_contacts_treaties` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `contact_id` varchar(64) NOT NULL DEFAULT '',
  `treaty` varchar(32) NOT NULL DEFAULT '' COMMENT 'Treaty machine name (See API doc for enumerations)',
  PRIMARY KEY (`id`),
  KEY `fk_contact_treaties` (`contact_id`),
  CONSTRAINT `fk_contact_treaties` FOREIGN KEY (`contact_id`) REFERENCES `informea_contacts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_contacts_treaties`
--

LOCK TABLES `informea_contacts_treaties` WRITE;
/*!40000 ALTER TABLE `informea_contacts_treaties` DISABLE KEYS */;
INSERT INTO `informea_contacts_treaties` VALUES ('471d81c2-4a22-4574-9fd1-0341797ec6de-cites','471d81c2-4a22-4574-9fd1-0341797ec6de','cites'),('471d81c2-4a22-4574-9fd1-0341797ec6de-cms','471d81c2-4a22-4574-9fd1-0341797ec6de','cms'),('c6626713-3a16-485c-952c-718802a21b5b-cms','c6626713-3a16-485c-952c-718802a21b5b','cms'),('c9b98891-6347-4755-9cdb-a08268849abb-cms','c9b98891-6347-4755-9cdb-a08268849abb','cms'),('e949e7b9-4a45-4ed0-b06e-679e55c31e5e-cms','e949e7b9-4a45-4ed0-b06e-679e55c31e5e','cms'),('ec8b6c87-aa11-4297-9c89-b25320a54827-cms','ec8b6c87-aa11-4297-9c89-b25320a54827','cms');
/*!40000 ALTER TABLE `informea_contacts_treaties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_country_reports`
--
DROP VIEW IF EXISTS `informea_country_reports`;
DROP TABLE IF EXISTS `informea_country_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_country_reports` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `treaty` varchar(32) NOT NULL DEFAULT '' COMMENT 'Treaty machine name (See API doc for enumerations)',
  `country` char(2) NOT NULL DEFAULT '' COMMENT 'ISO 3166-1 code (ex. RO)',
  `submission` date NOT NULL COMMENT 'Report publishing date',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'HTTP public URL where document is available to view',
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date of last update. If not leave to default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_country_reports`
--

LOCK TABLES `informea_country_reports` WRITE;
/*!40000 ALTER TABLE `informea_country_reports` DISABLE KEYS */;
INSERT INTO `informea_country_reports` VALUES ('96e420cc-fb81-426b-a0e1-4571c255a5d0','ramsar','AL','2012-01-01','http://www.ramsar.org/node/14398','2015-05-27 08:07:01'),('e802070d-eece-4348-ae0a-aba6d1dcd58e','ramsar','AL','2012-01-01','http://www.ramsar.org/node/14399','2015-05-27 08:06:24'),('f2e868e6-ed35-45b2-8a2a-602fe1d6aa12','ramsar','AG','2008-01-01','http://www.ramsar.org/node/14408','2015-05-27 08:17:06');
/*!40000 ALTER TABLE `informea_country_reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_country_reports_documents`
--
DROP VIEW IF EXISTS `informea_country_reports_documents`;
DROP TABLE IF EXISTS `informea_country_reports_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_country_reports_documents` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `country_report_id` varchar(64) NOT NULL DEFAULT '',
  `diskPath` text COMMENT 'DEPRECATED. Set to NULL',
  `url` text NOT NULL COMMENT 'HTTP public URL where document is available for download',
  `mimeType` varchar(16) DEFAULT NULL COMMENT 'Internet MIME type (ex. application/pdf)',
  `language` varchar(5) DEFAULT NULL COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `filename` varchar(64) DEFAULT NULL COMMENT 'Preffered filename (ex. 12.1-meeting-ar.doc)',
  PRIMARY KEY (`id`),
  KEY `fk_country_reports_documents` (`country_report_id`),
  CONSTRAINT `fk_country_reports_documents` FOREIGN KEY (`country_report_id`) REFERENCES `informea_country_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_country_reports_documents`
--

LOCK TABLES `informea_country_reports_documents` WRITE;
/*!40000 ALTER TABLE `informea_country_reports_documents` DISABLE KEYS */;
INSERT INTO `informea_country_reports_documents` VALUES ('14408-1','96e420cc-fb81-426b-a0e1-4571c255a5d0',NULL,'http://www.ramsar.org/sites/default/files/documents/pdf/cop10/cop10_nr_antigua.pdf','application/pdf','en','cop10_nr_antigua.pdf'),('17659-2','96e420cc-fb81-426b-a0e1-4571c255a5d0',NULL,'http://www.ramsar.org/sites/default/files/documents/pdf/cop10/cop10_nr_algeria.pdf','application/pdf','fr','cop10_nr_algeria.pdf');
/*!40000 ALTER TABLE `informea_country_reports_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_country_reports_title`
--
DROP VIEW IF EXISTS `informea_country_reports_title`;
DROP TABLE IF EXISTS `informea_country_reports_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_country_reports_title` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `country_report_id` varchar(64) DEFAULT NULL,
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `title` text NOT NULL COMMENT 'Localized title',
  PRIMARY KEY (`id`),
  KEY `fk_country_reports_title` (`country_report_id`),
  CONSTRAINT `fk_country_reports_title` FOREIGN KEY (`country_report_id`) REFERENCES `informea_country_reports` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_country_reports_title`
--

LOCK TABLES `informea_country_reports_title` WRITE;
/*!40000 ALTER TABLE `informea_country_reports_title` DISABLE KEYS */;
INSERT INTO `informea_country_reports_title` VALUES ('96e420cc-fb81-426b-a0e1-4571c255a5d0-en','96e420cc-fb81-426b-a0e1-4571c255a5d0','en','COP11 National Reports: Albania - Section 4'),('96e420cc-fb81-426b-a0e1-4571c255a5d0-fr','96e420cc-fb81-426b-a0e1-4571c255a5d0','fr','Rapports nationaux COP11 : Algérie'),('e802070d-eece-4348-ae0a-aba6d1dcd58e-en','e802070d-eece-4348-ae0a-aba6d1dcd58e','en','COP10 National reports: Antigua and Barbuda');
/*!40000 ALTER TABLE `informea_country_reports_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions`
--
DROP VIEW IF EXISTS `informea_decisions`;
DROP TABLE IF EXISTS `informea_decisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `link` varchar(255) DEFAULT NULL COMMENT 'HTTP public URL where document is available to view',
  `type` varchar(64) DEFAULT NULL COMMENT 'ex. Decision, Recommendation etc.',
  `status` varchar(64) DEFAULT NULL COMMENT 'ex. Active, Retired, Amended etc.',
  `number` varchar(64) DEFAULT '' COMMENT 'ex. COP12/23.1',
  `treaty` varchar(32) NOT NULL DEFAULT '' COMMENT 'Treaty machine name (See API doc for enumerations)',
  `published` timestamp NULL DEFAULT NULL COMMENT 'Report publishing date',
  `meetingId` varchar(64) DEFAULT NULL COMMENT 'Reference to informea_meetings table',
  `meetingTitle` varchar(64) DEFAULT NULL COMMENT 'One of meetingTitle or meetingId must be non-null',
  `meetingUrl` varchar(255) DEFAULT NULL COMMENT 'Public HTTP URL to the meeting page',
  `displayOrder` int(11) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date of last update. If not leave to default',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_meeting` (`meetingId`),
  CONSTRAINT `fk_decisions_meeting` FOREIGN KEY (`meetingId`) REFERENCES `informea_meetings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions`
--

LOCK TABLES `informea_decisions` WRITE;
/*!40000 ALTER TABLE `informea_decisions` DISABLE KEYS */;
INSERT INTO `informea_decisions` VALUES ('2c776b76-57d3-4a46-a1be-c254976a0ee2','http://www.ramsar.org/node/31099','resolution','active','1234','ramsar','2015-07-03 10:45:00','af2078a9-357d-4b12-8f44-fdd1e63ea63f','meeting1','http://chm.pops.int/linkclick.aspx?link=404&amp;amp;tabid=276&amp;amp;language=en-us',3,'2015-12-14 17:21:55'),('55e618ce-a88d-4e35-9ae2-08c6bccbb9c6','http://www.ramsar.org/node/31100','resolution','active','n/a','ramsar','2015-07-03 11:00:00','af2078a9-357d-4b12-8f44-fdd1e63ea63f',NULL,NULL,2,'2016-03-03 10:22:38'),('95d1ad86-5a21-46a7-a963-cde0d844d0fb','http://www.ramsar.org/node/31101','resolution','active','n/a','ramsar','2015-07-03 11:00:00','af2078a9-357d-4b12-8f44-fdd1e63ea63f',NULL,NULL,1,'2015-12-14 17:21:41');
/*!40000 ALTER TABLE `informea_decisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions_content`
--
DROP VIEW IF EXISTS `informea_decisions_content`;
DROP TABLE IF EXISTS `informea_decisions_content`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions_content` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `decision_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `content` text NOT NULL COMMENT 'Localized content',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_content` (`decision_id`),
  CONSTRAINT `fk_decisions_content` FOREIGN KEY (`decision_id`) REFERENCES `informea_decisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions_content`
--

LOCK TABLES `informea_decisions_content` WRITE;
/*!40000 ALTER TABLE `informea_decisions_content` DISABLE KEYS */;
INSERT INTO `informea_decisions_content` VALUES ('16285','2c776b76-57d3-4a46-a1be-c254976a0ee2','en','<p>Resolution on the Framework for the implementation of the Convention and priorities for attention 1991-1993</p>'),('19532','2c776b76-57d3-4a46-a1be-c254976a0ee2','fr','<p>adoptées par la Convention sur la diversité biologique (CDB), et leur pertinence pour la Convention de Ramsar</p>');
/*!40000 ALTER TABLE `informea_decisions_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions_documents`
--
DROP VIEW IF EXISTS `informea_decisions_documents`;
DROP TABLE IF EXISTS `informea_decisions_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions_documents` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `decision_id` varchar(64) NOT NULL DEFAULT '',
  `diskPath` varchar(64) DEFAULT NULL COMMENT 'DEPRECATED. Set to NULL',
  `url` varchar(256) DEFAULT NULL COMMENT 'HTTP public URL where document is available for download',
  `mimeType` varchar(64) DEFAULT NULL COMMENT 'Internet MIME type (ex. application/pdf)',
  `language` varchar(5) DEFAULT NULL COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `filename` varchar(64) DEFAULT NULL COMMENT 'Preffered filename (ex. 12.1-meeting-ar.doc)',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_documents` (`decision_id`),
  CONSTRAINT `fk_decisions_documents` FOREIGN KEY (`decision_id`) REFERENCES `informea_decisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions_documents`
--

LOCK TABLES `informea_decisions_documents` WRITE;
/*!40000 ALTER TABLE `informea_decisions_documents` DISABLE KEYS */;
INSERT INTO `informea_decisions_documents` VALUES ('14408-1','2c776b76-57d3-4a46-a1be-c254976a0ee2',NULL,'http://chm.pops.int/Portals/0/download.aspx?d=UNEP-POPS-COP.4-SC-4-28.Spanish.doc','application/msword','en','UNEP-POPS-COP.4-SC-4-28.Spanish.doc'),('17659-2','2c776b76-57d3-4a46-a1be-c254976a0ee2',NULL,'http://chm.pops.int/Portals/0/download.aspx?d=UNEP-POPS-COP.4-SC-4-28.French.doc','application/msword','fr','UNEP-POPS-COP.4-SC-4-28.French.doc');
/*!40000 ALTER TABLE `informea_decisions_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions_keywords`
--
DROP VIEW IF EXISTS `informea_decisions_keywords`;
DROP TABLE IF EXISTS `informea_decisions_keywords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions_keywords` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `decision_id` varchar(64) NOT NULL DEFAULT '',
  `namespace` varchar(255) NOT NULL DEFAULT '' COMMENT 'Unique vocabulary namespace (ex. http://www.mea.org/terms)',
  `term` varchar(255) NOT NULL DEFAULT '' COMMENT 'English term name',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_keywords` (`decision_id`),
  CONSTRAINT `fk_decisions_keywords` FOREIGN KEY (`decision_id`) REFERENCES `informea_decisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions_keywords`
--

LOCK TABLES `informea_decisions_keywords` WRITE;
/*!40000 ALTER TABLE `informea_decisions_keywords` DISABLE KEYS */;
INSERT INTO `informea_decisions_keywords` VALUES ('1','2c776b76-57d3-4a46-a1be-c254976a0ee2','http://www.ramsar.org/taxonoomy/term/','Wetland values'),('2','2c776b76-57d3-4a46-a1be-c254976a0ee2','http://www.ramsar.org/taxonoomy/term/','Urbanization');
/*!40000 ALTER TABLE `informea_decisions_keywords` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions_longtitle`
--
DROP VIEW IF EXISTS `informea_decisions_longtitle`;
DROP TABLE IF EXISTS `informea_decisions_longtitle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions_longtitle` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `decision_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `long_title` text NOT NULL COMMENT 'Localized title',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_longtitle` (`decision_id`),
  CONSTRAINT `fk_decisions_longtitle` FOREIGN KEY (`decision_id`) REFERENCES `informea_decisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions_longtitle`
--

LOCK TABLES `informea_decisions_longtitle` WRITE;
/*!40000 ALTER TABLE `informea_decisions_longtitle` DISABLE KEYS */;
INSERT INTO `informea_decisions_longtitle` VALUES ('1','2c776b76-57d3-4a46-a1be-c254976a0ee2','en','Annex to Doc.C.4.15'),('2','2c776b76-57d3-4a46-a1be-c254976a0ee2','fr','Annex to Doc.C.4.14');
/*!40000 ALTER TABLE `informea_decisions_longtitle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions_summary`
--
DROP VIEW IF EXISTS `informea_decisions_summary`;
DROP TABLE IF EXISTS `informea_decisions_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions_summary` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `decision_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `summary` text NOT NULL COMMENT 'Localized summary',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_summary` (`decision_id`),
  CONSTRAINT `fk_decisions_summary` FOREIGN KEY (`decision_id`) REFERENCES `informea_decisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions_summary`
--

LOCK TABLES `informea_decisions_summary` WRITE;
/*!40000 ALTER TABLE `informea_decisions_summary` DISABLE KEYS */;
INSERT INTO `informea_decisions_summary` VALUES ('16285','2c776b76-57d3-4a46-a1be-c254976a0ee2','en','<p>Resolution on the Framework</p>'),('19532','2c776b76-57d3-4a46-a1be-c254976a0ee2','fr','<p>adoptées par la Convention sur la diversité biologique (CDB)');
/*!40000 ALTER TABLE `informea_decisions_summary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_decisions_title`
--
DROP VIEW IF EXISTS `informea_decisions_title`;
DROP TABLE IF EXISTS `informea_decisions_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_decisions_title` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `decision_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `title` text NOT NULL COMMENT 'Localized title',
  PRIMARY KEY (`id`),
  KEY `fk_decisions_title` (`decision_id`),
  CONSTRAINT `fk_decisions_title` FOREIGN KEY (`decision_id`) REFERENCES `informea_decisions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_decisions_title`
--

LOCK TABLES `informea_decisions_title` WRITE;
/*!40000 ALTER TABLE `informea_decisions_title` DISABLE KEYS */;
INSERT INTO `informea_decisions_title` VALUES ('1','2c776b76-57d3-4a46-a1be-c254976a0ee2','en','Doc.C.4.15'),('2','2c776b76-57d3-4a46-a1be-c254976a0ee2','fr','Doc.C.4.14');
/*!40000 ALTER TABLE `informea_decisions_title` ENABLE KEYS */;
UNLOCK TABLES;


--
--
-- Table structure for table `informea_meetings`
--
DROP VIEW IF EXISTS `informea_meetings`;
DROP TABLE IF EXISTS `informea_meetings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_meetings` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `treaty` varchar(32) NOT NULL DEFAULT '' COMMENT 'Treaty machine name (See API doc for enumerations)',
  `url` varchar(255) DEFAULT NULL,
  `start` datetime NOT NULL,
  `end` datetime DEFAULT NULL,
  `repetition` varchar(64) DEFAULT NULL,
  `kind` varchar(64) DEFAULT NULL,
  `type` varchar(64) DEFAULT NULL,
  `access` varchar(64) DEFAULT NULL,
  `status` varchar(64) DEFAULT NULL,
  `imageUrl` varchar(64) DEFAULT NULL COMMENT 'HTTP public URL where image is available to reference',
  `imageCopyright` varchar(64) DEFAULT NULL,
  `location` varchar(64) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `country` char(2) NOT NULL DEFAULT '' COMMENT 'ISO 3166-1 code (ex. RO)',
  `latitude` decimal(12,9) DEFAULT NULL,
  `longitude` decimal(12,9) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date of last update. If not leave to default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_meetings`
--

LOCK TABLES `informea_meetings` WRITE;
/*!40000 ALTER TABLE `informea_meetings` DISABLE KEYS */;
INSERT INTO `informea_meetings` VALUES ('5bdb02b0-debe-4689-852d-9d9a96fd63eb','ramsar','http://www.ramsar.org/node/39893','2012-07-05 22:00:00','2012-07-12 22:00:00',NULL,NULL,'cop',NULL,NULL,NULL,NULL,NULL,NULL,'RO',NULL,NULL,'2016-01-13 15:31:44'),('af2078a9-357d-4b12-8f44-fdd1e63ea63f','ramsar','http://www.ramsar.org/node/23897','2015-05-31 22:00:00','2015-06-08 22:00:00','repetition','kind','cop','access','status','url1','copy1','Punta del Este, Uruguay','city','UY',23.230000000,33.440000000,'2016-01-14 16:26:59');
/*!40000 ALTER TABLE `informea_meetings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_meetings_description`
--
DROP VIEW IF EXISTS `informea_meetings_description`;
DROP TABLE IF EXISTS `informea_meetings_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_meetings_description` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `meeting_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meetings_description` (`meeting_id`),
  CONSTRAINT `fk_meetings_description` FOREIGN KEY (`meeting_id`) REFERENCES `informea_meetings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_meetings_description`
--

LOCK TABLES `informea_meetings_description` WRITE;
/*!40000 ALTER TABLE `informea_meetings_description` DISABLE KEYS */;
INSERT INTO `informea_meetings_description` VALUES ('af2078a9-357d-4b12-8f44-fdd1e63ea63f-en','af2078a9-357d-4b12-8f44-fdd1e63ea63f','en','<p>The 12th Meeting of the Conference of the Contracting Parties to the Ramsar Convention on Wetlands (COP12)</p>'),('af2078a9-357d-4b12-8f44-fdd1e63ea63f-es','af2078a9-357d-4b12-8f44-fdd1e63ea63f','es','<p>La 12ª Reunión de la Conferencia de las Partes Contratantes de la Convención de Ramsar sobre los Humedales (COP12)</p>'),('af2078a9-357d-4b12-8f44-fdd1e63ea63f-fr','af2078a9-357d-4b12-8f44-fdd1e63ea63f','fr','<p>La 12e Session de la Conférence des Parties contractantes à la Convention de Ramsar sur les zones humides (COP12)</p>');
/*!40000 ALTER TABLE `informea_meetings_description` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_meetings_title`
--
DROP VIEW IF EXISTS `informea_meetings_title`;
DROP TABLE IF EXISTS `informea_meetings_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_meetings_title` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `meeting_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `title` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_meetings_title` (`meeting_id`),
  CONSTRAINT `fk_meetings_title` FOREIGN KEY (`meeting_id`) REFERENCES `informea_meetings` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_meetings_title`
--

LOCK TABLES `informea_meetings_title` WRITE;
/*!40000 ALTER TABLE `informea_meetings_title` DISABLE KEYS */;
INSERT INTO `informea_meetings_title` VALUES ('5bdb02b0-debe-4689-852d-9d9a96fd63eb-en','5bdb02b0-debe-4689-852d-9d9a96fd63eb','en','11th Meeting of the Conference of the Parties'),('5bdb02b0-debe-4689-852d-9d9a96fd63eb-es','5bdb02b0-debe-4689-852d-9d9a96fd63eb','es','11ª Reunión de la Conferencia de las Partes'),('5bdb02b0-debe-4689-852d-9d9a96fd63eb-fr','5bdb02b0-debe-4689-852d-9d9a96fd63eb','fr','11e Session de la Conférence des Parties'),('af2078a9-357d-4b12-8f44-fdd1e63ea63f-en','af2078a9-357d-4b12-8f44-fdd1e63ea63f','en','12th Meeting of the Conference of the Parties'),('af2078a9-357d-4b12-8f44-fdd1e63ea63f-es','af2078a9-357d-4b12-8f44-fdd1e63ea63f','es','12ª Reunión de la Conferencia de las Partes'),('af2078a9-357d-4b12-8f44-fdd1e63ea63f-fr','af2078a9-357d-4b12-8f44-fdd1e63ea63f','fr','12e Session de la Conférence des Parties');
/*!40000 ALTER TABLE `informea_meetings_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_national_plans`
--
DROP VIEW IF EXISTS `informea_national_plans`;
DROP TABLE IF EXISTS `informea_national_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_national_plans` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `treaty` varchar(32) NOT NULL DEFAULT '' COMMENT 'Treaty machine name (See API doc for enumerations)',
  `country` char(2) NOT NULL DEFAULT '' COMMENT 'ISO 3166-1 code (ex. RO)',
  `submission` date DEFAULT NULL COMMENT 'Report publishing date',
  `url` varchar(64) NOT NULL DEFAULT '' COMMENT 'HTTP public URL where document is available to view',
  `type` varchar(64) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date of last update. If not leave to default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_national_plans`
--

LOCK TABLES `informea_national_plans` WRITE;
/*!40000 ALTER TABLE `informea_national_plans` DISABLE KEYS */;
INSERT INTO `informea_national_plans` VALUES ('4298e0ab-c687-4cbe-b849-f3a16d63284e','stockholm','AL','2007-02-12','http://www.cbd.int/doc/world/ve/ve-nbsap-01-es.pdf','nip','2015-04-22 09:21:43'),('a6f6ecc6-7a39-4aac-b488-f3618fd3d882','stockholm','TZ','2006-06-12','url1','nip','2015-08-28 15:03:50');
/*!40000 ALTER TABLE `informea_national_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_national_plans_documents`
--
DROP VIEW IF EXISTS `informea_national_plans_documents`;
DROP TABLE IF EXISTS `informea_national_plans_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_national_plans_documents` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `national_plan_id` varchar(64) NOT NULL DEFAULT '',
  `diskPath` varchar(64) DEFAULT NULL COMMENT 'DEPRECATED. Set to NULL',
  `url` varchar(256) NOT NULL DEFAULT '' COMMENT 'HTTP public URL where document is available for download',
  `mimeType` varchar(64) DEFAULT NULL COMMENT 'Internet MIME type (ex. application/pdf)',
  `language` varchar(5) DEFAULT NULL COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `filename` varchar(64) DEFAULT NULL COMMENT 'Preffered filename (ex. 12.1-meeting-ar.doc)',
  PRIMARY KEY (`id`),
  KEY `fk_national_plans_documents` (`national_plan_id`),
  CONSTRAINT `fk_national_plans_documents` FOREIGN KEY (`national_plan_id`) REFERENCES `informea_national_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_national_plans_documents`
--

LOCK TABLES `informea_national_plans_documents` WRITE;
/*!40000 ALTER TABLE `informea_national_plans_documents` DISABLE KEYS */;
INSERT INTO `informea_national_plans_documents` VALUES ('1','4298e0ab-c687-4cbe-b849-f3a16d63284e','path1','http://chm.pops.int/Portals/0/download.aspx?d=UNEP-POPS-NIP-Algeria-1.French.pdf','application/pdf','en','UNEP-POPS-NIP-Algeria-1.French.pdf'),('2','4298e0ab-c687-4cbe-b849-f3a16d63284e','path2','http://chm.pops.int/Portals/0/download.aspx?d=UNEP-POPS-NIP-Albania-1.English.pdf','application/pdf','fr','UNEP-POPS-NIP-Albania-1.English.pdf');
/*!40000 ALTER TABLE `informea_national_plans_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_national_plans_title`
--
DROP VIEW IF EXISTS `informea_national_plans_title`;
DROP TABLE IF EXISTS `informea_national_plans_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_national_plans_title` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `national_plan_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `title` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_national_plans_title` (`national_plan_id`),
  CONSTRAINT `fk_national_plans_title` FOREIGN KEY (`national_plan_id`) REFERENCES `informea_national_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_national_plans_title`
--

LOCK TABLES `informea_national_plans_title` WRITE;
/*!40000 ALTER TABLE `informea_national_plans_title` DISABLE KEYS */;
INSERT INTO `informea_national_plans_title` VALUES ('1','4298e0ab-c687-4cbe-b849-f3a16d63284e','fr','Plan National de Mise en oeuvre – Convention de Stockholm'),('2','4298e0ab-c687-4cbe-b849-f3a16d63284e','es','Plan nacional de Aplicación del Convenio de Estocolmo'),('3','4298e0ab-c687-4cbe-b849-f3a16d63284e','en','NATIONAL IMPLEMENTATION PLAN (NIP) FOR POLLUTANTS (POPs)');
/*!40000 ALTER TABLE `informea_national_plans_title` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_sites`
--
DROP VIEW IF EXISTS `informea_sites`;
DROP TABLE IF EXISTS `informea_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_sites` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `type` varchar(64) DEFAULT NULL,
  `country` char(2) DEFAULT NULL COMMENT 'ISO 3166-1 code (ex. RO)',
  `treaty` varchar(32) NOT NULL DEFAULT '' COMMENT 'Treaty machine name (See API doc for enumerations)',
  `url` varchar(255) NOT NULL DEFAULT '' COMMENT 'HTTP public URL where document is available to visit',
  `latitude` decimal(12,9) DEFAULT NULL,
  `longitude` decimal(12,9) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date of last update. If not leave to default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_sites`
--

LOCK TABLES `informea_sites` WRITE;
/*!40000 ALTER TABLE `informea_sites` DISABLE KEYS */;
INSERT INTO `informea_sites` VALUES ('4cbc51ee-1b32-49eb-bbf0-6c7b15d33f0f','whc','AT','whc','http://whc.unesco.org/en/list/1363',47.278333333,8.207500000,'2012-05-14 11:04:45'),('bdf4045a-ecad-42d8-a856-f1e90f0632ec','whc','BR','whc','http://whc.unesco.org/en/list/275',-28.543333330,-54.265833330,'2012-05-14 11:04:45');
/*!40000 ALTER TABLE `informea_sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `informea_sites_name`
--
DROP VIEW IF EXISTS `informea_sites_name`;
DROP TABLE IF EXISTS `informea_sites_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `informea_sites_name` (
  `id` varchar(64) NOT NULL DEFAULT '',
  `site_id` varchar(64) NOT NULL DEFAULT '',
  `language` varchar(5) NOT NULL DEFAULT '' COMMENT 'Language code (ex. fr, zh, zh-hans)',
  `name` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_sites_name` (`site_id`),
  CONSTRAINT `fk_sites_name` FOREIGN KEY (`site_id`) REFERENCES `informea_sites` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `informea_sites_name`
--

LOCK TABLES `informea_sites_name` WRITE;
/*!40000 ALTER TABLE `informea_sites_name` DISABLE KEYS */;
INSERT INTO `informea_sites_name` VALUES ('1','4cbc51ee-1b32-49eb-bbf0-6c7b15d33f0f','en','Prehistoric Pile dwellings around the Alps'),('2','4cbc51ee-1b32-49eb-bbf0-6c7b15d33f0f','es','Kluane / Wrangell-St Elias / Glacier Bay / Tatshenshini-Alsek'),('3','4cbc51ee-1b32-49eb-bbf0-6c7b15d33f0f','fr','Jesuit Missions of the Guaranis Missoes (Brazil)');
/*!40000 ALTER TABLE `informea_sites_name` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

--
-- informea_documents
--
DROP VIEW IF EXISTS `informea_documents`;
DROP TABLE IF EXISTS informea_documents;
CREATE TABLE informea_documents (
  `id` VARCHAR(36) PRIMARY KEY,
  schemaversion INT,
  published DATETIME,
  `updated` DATETIME,
  treaty VARCHAR(255),
  thumbnailUrl VARCHAR(255),
  displayOrder INT,
  country VARCHAR(2)
);

DELETE FROM informea_documents;
INSERT INTO informea_documents VALUES (
  '00000000-0000-0000-0000-000000000000',
  1,
  '2008-10-02 12:34:56',
  '2014-06-16 13:05:13',
  'cms',
  'http://www.cms.int/sites/default/filespublication/gorilla_0_3_0_0.jpg',
  '2',
  'RO'
);

--
-- informea_documents_title
--
DROP VIEW IF EXISTS `informea_documents_title`;
DROP TABLE IF EXISTS informea_documents_title;
CREATE TABLE informea_documents_title (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  value VARCHAR(255)
);
DELETE FROM informea_documents_title;
INSERT INTO informea_documents_title VALUES (
  '00000000-0000-0000-0000-000000000000-en',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'Title english'
);

INSERT INTO informea_documents_title VALUES (
  '00000000-0000-0000-0000-000000000000-fr',
  '00000000-0000-0000-0000-000000000000',
  'fr',
  'Title french'
);

--
-- informea_documents_authors
--
DROP VIEW IF EXISTS `informea_documents_authors`;
DROP TABLE IF EXISTS informea_documents_authors;
CREATE TABLE informea_documents_authors (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  type VARCHAR(32),
  name VARCHAR(255)
);
DELETE FROM informea_documents_authors;
INSERT INTO informea_documents_authors VALUES (
  '00000000-0000-0000-0000-000000000000-1',
  '00000000-0000-0000-0000-000000000000',
  'Person',
  'Cristian Romanescu'
);
INSERT INTO informea_documents_authors VALUES (
  '00000000-0000-0000-0000-000000000000-2',
  '00000000-0000-0000-0000-000000000000',
  'Company',
  'John Doe'
);

--
-- informea_documents_description
--
DROP VIEW IF EXISTS `informea_documents_description`;
DROP TABLE IF EXISTS informea_documents_description;
CREATE TABLE informea_documents_description (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  value TEXT
);
DELETE FROM informea_documents_description;
INSERT INTO informea_documents_description VALUES (
  '00000000-0000-0000-0000-000000000000-en',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'Description english'
);
INSERT INTO informea_documents_description VALUES (
  '00000000-0000-0000-0000-000000000000-fr',
  '00000000-0000-0000-0000-000000000000',
  'fr',
  'Description french'
);

--
-- informea_documents_identifiers
--
DROP VIEW IF EXISTS `informea_documents_identifiers`;
DROP TABLE IF EXISTS informea_documents_identifiers;
CREATE TABLE informea_documents_identifiers (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  name VARCHAR(255),
  value VARCHAR(255)
);
DELETE FROM informea_documents_identifiers;
INSERT INTO informea_documents_identifiers VALUES (
  '00000000-0000-0000-0000-000000000000-1',
  '00000000-0000-0000-0000-000000000000',
  'Identifier 1',
  'Value 1'
);
INSERT INTO informea_documents_identifiers VALUES (
  '00000000-0000-0000-0000-000000000000-2',
  '00000000-0000-0000-0000-000000000000',
  'Identifier 2',
  'Value 2'
);

--
-- informea_documents_files
--
DROP VIEW IF EXISTS `informea_documents_files`;
DROP TABLE IF EXISTS informea_documents_files;
CREATE TABLE informea_documents_files (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  url VARCHAR(255),
  content TEXT,
  mimeType VARCHAR(64),
  language VARCHAR(2),
  filename VARCHAR(255)
);
DELETE FROM informea_documents_files;
INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-en-pdf',
  '00000000-0000-0000-0000-000000000000',
  'Url 1',
  'Content 1',
  'Mime 1',
  'en',
  'filename1.pdf'
);
INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-en-doc',
  '00000000-0000-0000-0000-000000000000',
  'Url 2',
  'Content 2',
  'Mime 2',
  'en',
  'filename2.doc'
);

INSERT INTO informea_documents_files VALUES (
  '00000000-0000-0000-0000-000000000000-fr-pdf',
  '00000000-0000-0000-0000-000000000000',
  'Url 3',
  'Content 3',
  'Mime 3',
  'fr',
  'filename3.pdf'
);

--
-- informea_documents_keywords
--
DROP VIEW IF EXISTS `informea_documents_keywords`;
DROP TABLE IF EXISTS informea_documents_keywords;
CREATE TABLE informea_documents_keywords (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  termURI VARCHAR(255),
  scope VARCHAR(255),
  literalForm VARCHAR(64),
  sourceURL VARCHAR(255)
);
DELETE FROM informea_documents_keywords;
INSERT INTO informea_documents_keywords VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'http://www.informea.org/term/acceptance',
  'InforMEA',
  'Acceptance',
  'http://www.informea.org/taxonomy/term/1135'
);

INSERT INTO informea_documents_keywords VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'Uri 2',
  'Scope 2',
  'Term 2',
  'Source URL 2'
);

--
-- informea_documents_references
--
DROP VIEW IF EXISTS `informea_documents_references`;
DROP TABLE IF EXISTS informea_documents_references;
CREATE TABLE informea_documents_references (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  type VARCHAR(255),
  refId VARCHAR(255)
);
DELETE FROM informea_documents_references;
INSERT INTO informea_documents_references VALUES (
  '00000000-0000-0000-0000-000000000000-r1',
  '00000000-0000-0000-0000-000000000000',
  'meeting',
  '00000000-0000-0000-0000-000000000001'
);

INSERT INTO informea_documents_references VALUES (
  '00000000-0000-0000-0000-000000000000-r2',
  '00000000-0000-0000-0000-000000000000',
  'decision',
  '00000000-0000-0000-0000-000000000002'
);


--
-- informea_documents_types
--
DROP VIEW IF EXISTS `informea_documents_types`;
DROP TABLE IF EXISTS informea_documents_types;
CREATE TABLE informea_documents_types (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  value VARCHAR(255)
);
DELETE FROM informea_documents_types;
INSERT INTO informea_documents_types VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'Technical Series'
);

INSERT INTO informea_documents_types VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'Publication'
);

--
-- informea_documents_tags
--
DROP VIEW IF EXISTS `informea_documents_tags`;
DROP TABLE IF EXISTS informea_documents_tags;
CREATE TABLE informea_documents_tags (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  language VARCHAR(2),
  scope VARCHAR(255),
  value VARCHAR(255),
  comment VARCHAR(255)
);
DELETE FROM informea_documents_tags;
INSERT INTO informea_documents_tags VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'BRS',
  'Chemical',
  'Custom term'
);

INSERT INTO informea_documents_tags VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'en',
  'BRS',
  'DDT',
  'Test term'
);

--
-- informea_documents_treaties
--
DROP VIEW IF EXISTS `informea_documents_treaties`;
DROP TABLE IF EXISTS informea_documents_treaties;
CREATE TABLE informea_documents_treaties (
  `id` VARCHAR(255) PRIMARY KEY,
  document_id VARCHAR(36),
  treaty VARCHAR(255)
);
DELETE FROM informea_documents_treaties;
INSERT INTO informea_documents_treaties VALUES (
  '00000000-0000-0000-0000-000000000000-t1',
  '00000000-0000-0000-0000-000000000000',
  'cms'
);

INSERT INTO informea_documents_treaties VALUES (
  '00000000-0000-0000-0000-000000000000-t2',
  '00000000-0000-0000-0000-000000000000',
  'aewa'
);
