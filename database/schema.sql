-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: ecms
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agreement_progress`
--

DROP TABLE IF EXISTS `agreement_progress`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `agreement_progress` (
  `progress_id` int NOT NULL AUTO_INCREMENT,
  `award_id` int NOT NULL,
  `total_contract_value` decimal(14,2) DEFAULT NULL,
  `amount_billed` decimal(14,2) DEFAULT '0.00',
  `amount_paid` decimal(14,2) DEFAULT '0.00',
  `pct_complete` decimal(5,2) GENERATED ALWAYS AS (round(((`amount_billed` / nullif(`total_contract_value`,0)) * 100),2)) STORED,
  `last_invoice_date` date DEFAULT NULL,
  `estimated_completion` date DEFAULT NULL,
  `actual_completion` date DEFAULT NULL,
  `status` enum('Active','Complete','On Hold','Terminated') DEFAULT 'Active',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`progress_id`),
  UNIQUE KEY `award_id` (`award_id`),
  CONSTRAINT `agreement_progress_ibfk_1` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agreement_progress`
--

LOCK TABLES `agreement_progress` WRITE;
/*!40000 ALTER TABLE `agreement_progress` DISABLE KEYS */;
INSERT INTO `agreement_progress` (`progress_id`, `award_id`, `total_contract_value`, `amount_billed`, `amount_paid`, `last_invoice_date`, `estimated_completion`, `actual_completion`, `status`, `updated_at`) VALUES (1,1,800000.00,760000.00,750000.00,'2024-08-01','2024-10-01',NULL,'Complete','2026-05-23 07:41:38'),(2,2,750000.00,700000.00,690000.00,'2023-10-15','2023-12-01',NULL,'Complete','2026-05-23 07:41:38'),(3,3,900000.00,850000.00,840000.00,'2023-11-01','2024-01-01',NULL,'Complete','2026-05-23 07:41:38'),(4,9,900000.00,900000.00,900000.00,'2023-06-15','2023-06-30',NULL,'Complete','2026-05-23 07:41:38'),(5,10,750000.00,680000.00,670000.00,'2023-10-01','2024-01-01',NULL,'Complete','2026-05-23 07:41:38'),(6,15,780000.00,390000.00,380000.00,'2025-04-15','2025-09-01',NULL,'Active','2026-05-23 07:41:38'),(7,18,30000.00,28000.00,28000.00,'2025-03-10','2025-04-01',NULL,'Complete','2026-05-23 07:41:38'),(8,19,400000.00,200000.00,195000.00,'2025-04-01','2025-08-01',NULL,'Active','2026-05-23 07:41:38'),(9,24,273371.00,273371.00,273371.00,'2023-10-01','2023-10-01',NULL,'Complete','2026-05-23 07:41:38'),(10,25,288740.00,288740.00,285000.00,'2024-01-15','2024-01-15',NULL,'Complete','2026-05-23 07:41:38'),(11,26,260000.00,130000.00,125000.00,'2024-06-01','2024-10-01',NULL,'Active','2026-05-23 07:41:38'),(12,29,450000.00,225000.00,220000.00,'2025-01-15','2025-06-01',NULL,'Active','2026-05-23 07:41:38'),(13,31,600000.00,150000.00,145000.00,'2025-02-01','2025-09-01',NULL,'Active','2026-05-23 07:41:38'),(14,35,500000.00,500000.00,495000.00,'2024-01-01','2024-01-01',NULL,'Complete','2026-05-23 07:41:38'),(15,36,480000.00,480000.00,478000.00,'2024-08-01','2024-08-01',NULL,'Complete','2026-05-23 07:41:38');
/*!40000 ALTER TABLE `agreement_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `awards`
--

DROP TABLE IF EXISTS `awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `awards` (
  `award_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int NOT NULL,
  `firm_id` int NOT NULL,
  `site_id` int DEFAULT NULL,
  `division_id` int NOT NULL,
  `agreement_number` varchar(50) DEFAULT NULL,
  `po_number` varchar(50) DEFAULT NULL,
  `assignment` varchar(200) DEFAULT NULL,
  `solicitation_type_id` int NOT NULL,
  `award_type` enum('On-site','Scope') NOT NULL,
  `award_date` date NOT NULL,
  `award_amount` decimal(14,2) NOT NULL DEFAULT '0.00',
  `fiscal_year` int GENERATED ALWAYS AS ((case when (month(`award_date`) >= 7) then year(`award_date`) else (year(`award_date`) - 1) end)) STORED,
  `fiscal_quarter` tinyint GENERATED ALWAYS AS ((case when (month(`award_date`) in (7,8,9)) then 1 when (month(`award_date`) in (10,11,12)) then 2 when (month(`award_date`) in (1,2,3)) then 3 else 4 end)) STORED,
  `avg_listed_firms` int DEFAULT NULL,
  `num_assignments` int DEFAULT '1',
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`award_id`),
  KEY `program_id` (`program_id`),
  KEY `firm_id` (`firm_id`),
  KEY `site_id` (`site_id`),
  KEY `division_id` (`division_id`),
  KEY `solicitation_type_id` (`solicitation_type_id`),
  CONSTRAINT `awards_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`),
  CONSTRAINT `awards_ibfk_2` FOREIGN KEY (`firm_id`) REFERENCES `firms` (`firm_id`),
  CONSTRAINT `awards_ibfk_3` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`),
  CONSTRAINT `awards_ibfk_4` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`division_id`),
  CONSTRAINT `awards_ibfk_5` FOREIGN KEY (`solicitation_type_id`) REFERENCES `solicitation_types` (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `awards`
--

LOCK TABLES `awards` WRITE;
/*!40000 ALTER TABLE `awards` DISABLE KEYS */;
INSERT INTO `awards` (`award_id`, `program_id`, `firm_id`, `site_id`, `division_id`, `agreement_number`, `po_number`, `assignment`, `solicitation_type_id`, `award_type`, `award_date`, `award_amount`, `avg_listed_firms`, `num_assignments`, `notes`, `created_at`) VALUES (1,11,1,1,4,'407-22-011-A01','3000041001','Kim Travers',1,'Scope','2022-08-15',800000.00,11,1,NULL,'2026-05-22 18:50:50'),(2,11,1,2,4,'407-22-011-A02','3000041002','Kim Travers',1,'On-site','2022-11-20',750000.00,11,1,NULL,'2026-05-22 18:50:50'),(3,11,1,1,4,'407-22-011-A03','3000041003','Mark Torres',1,'Scope','2023-02-10',900000.00,11,1,NULL,'2026-05-22 18:50:50'),(4,11,1,3,4,'407-22-011-A04','3000041004','Mark Torres',1,'On-site','2023-06-01',650000.00,11,1,NULL,'2026-05-22 18:50:50'),(5,11,1,1,4,'407-22-011-A05','3000041005','Kim Travers',1,'Scope','2023-09-15',725000.00,11,1,NULL,'2026-05-22 18:50:50'),(6,11,1,2,4,'407-22-011-A06','3000041006','Sarah Klein',1,'On-site','2024-01-20',850000.00,11,1,NULL,'2026-05-22 18:50:50'),(7,11,1,1,4,'407-22-011-A07','3000041007','Sarah Klein',1,'Scope','2024-04-10',700000.00,11,1,NULL,'2026-05-22 18:50:50'),(8,11,1,3,4,'407-22-011-A08','3000041008','Mark Torres',1,'On-site','2024-09-01',625000.00,11,1,NULL,'2026-05-22 18:50:50'),(9,3,3,6,7,'415-22-003-A01','3000042001','Samantha Scott',4,'On-site','2023-03-10',900000.00,6,1,NULL,'2026-05-22 18:50:50'),(10,3,3,6,7,'415-22-003-A02','3000042002','Samantha Scott',4,'Scope','2023-07-01',750000.00,6,1,NULL,'2026-05-22 18:50:50'),(11,4,3,6,7,'415-23-004-A01','3000042003','Plank Sinatra',5,'On-site','2023-12-01',850000.00,5,1,NULL,'2026-05-22 18:50:50'),(12,11,3,1,4,'407-22-011-B01','3000042004','Mark Torres',1,'On-site','2024-02-20',700000.00,11,1,NULL,'2026-05-22 18:50:50'),(13,11,3,2,4,'407-22-011-B02','3000042005','Sarah Klein',1,'Scope','2024-08-15',934301.00,11,1,NULL,'2026-05-22 18:50:50'),(14,2,1,1,3,'405-22-002-A01','3000043001','John Doe',1,'Scope','2025-03-15',780000.00,12,1,NULL,'2026-05-22 18:50:50'),(15,2,19,1,3,'405-22-002-B01','3000043002','John Doe',1,'On-site','2025-04-01',820000.00,12,1,NULL,'2026-05-22 18:50:50'),(16,2,20,2,3,'405-22-002-C01','3000043003','Eric Marsh',1,'Scope','2025-04-20',750000.00,12,1,NULL,'2026-05-22 18:50:50'),(17,9,17,1,5,'426-21-045-B01','3000032047','Paul Catherall',1,'Scope','2025-03-04',30000.00,9,1,NULL,'2026-05-22 18:50:50'),(18,9,17,2,5,'426-21-045-B02','3000032057','Paul Catherall',1,'On-site','2025-03-05',400000.00,9,1,NULL,'2026-05-22 18:50:50'),(19,9,17,1,5,'426-21-045-B03','3000032092','Paul Catherall',1,'Scope','2025-03-14',60000.00,9,1,NULL,'2026-05-22 18:50:50'),(20,9,17,3,5,'426-21-045-B04','3000032101','Paul Catherall',1,'On-site','2025-04-01',120000.00,9,1,NULL,'2026-05-22 18:50:50'),(21,9,13,1,5,'426-21-045-C01','3000032110','Paul Catherall',1,'Scope','2024-06-10',110000.00,9,1,NULL,'2026-05-22 18:50:50'),(22,9,15,2,5,'426-21-045-D01','3000032115','Dave Whitman',1,'On-site','2024-09-20',102000.00,9,1,NULL,'2026-05-22 18:50:50'),(23,10,18,8,4,'407-20-028-C01','3000031398','Lindsay Degueldre',1,'On-site','2023-07-10',273371.00,14,1,NULL,'2026-05-22 18:50:50'),(24,10,18,8,4,'407-20-028-C02','3000031526','Lindsay Degueldre',1,'On-site','2023-11-13',288740.00,14,1,NULL,'2026-05-22 18:50:50'),(25,10,18,8,4,'407-20-028-C03','3000031601','Lindsay Degueldre',1,'Scope','2024-02-20',260000.00,14,1,NULL,'2026-05-22 18:50:50'),(26,10,18,8,4,'407-20-028-C04','3000031734','Lindsay Degueldre',1,'On-site','2024-06-05',208289.00,14,1,NULL,'2026-05-22 18:50:50'),(27,5,5,8,7,'415-24-005-A01','3000044001','Level Larry',3,'Scope','2024-10-05',450000.00,10,1,NULL,'2026-05-22 18:50:50'),(28,5,5,8,7,'415-24-005-A02','3000044002','Level Larry',3,'On-site','2024-11-20',380000.00,10,1,NULL,'2026-05-22 18:50:50'),(29,5,7,1,7,'415-24-005-B01','3000044003','Level Larry',3,'Scope','2024-10-01',600000.00,10,1,NULL,'2026-05-22 18:50:50'),(30,5,7,2,7,'415-24-005-B02','3000044004','Level Larry',3,'On-site','2025-01-10',550000.00,10,1,NULL,'2026-05-22 18:50:50'),(31,5,10,8,7,'415-24-005-C01','3000044005','Mark Holloway',3,'Scope','2024-11-01',350000.00,10,1,NULL,'2026-05-22 18:50:50'),(32,5,10,1,7,'415-24-005-C02','3000044006','Mark Holloway',3,'On-site','2025-01-15',330000.00,10,1,NULL,'2026-05-22 18:50:50'),(33,1,6,8,2,'402-21-001-A01','3000045001','Bob Smith',2,'On-site','2023-08-15',500000.00,8,1,NULL,'2026-05-22 18:50:50'),(34,1,6,8,2,'402-21-001-A02','3000045002','Bob Smith',2,'Scope','2024-01-10',480000.00,8,1,NULL,'2026-05-22 18:50:50'),(35,1,14,8,2,'402-21-001-B01','3000045003','Bob Smith',2,'On-site','2023-06-01',450000.00,8,1,NULL,'2026-05-22 18:50:50'),(36,1,14,8,2,'402-21-001-B02','3000045004','Dave Whitman',2,'Scope','2024-03-20',390000.00,8,1,NULL,'2026-05-22 18:50:50'),(37,1,16,8,2,'402-21-001-C01','3000045005','Bob Smith',2,'On-site','2023-05-10',480000.00,8,1,NULL,'2026-05-22 18:50:50'),(38,1,16,8,2,'402-21-001-C02','3000045006','Dave Whitman',2,'Scope','2024-06-01',526760.00,8,1,NULL,'2026-05-22 18:50:50'),(39,12,6,1,2,'402-22-012-A01','3000046001','Tom Willis',2,'On-site','2023-01-15',780000.00,10,1,NULL,'2026-05-22 18:50:50'),(40,12,6,2,2,'402-22-012-A02','3000046002','Tom Willis',2,'Scope','2023-05-20',820000.00,10,1,NULL,'2026-05-22 18:50:50'),(41,12,6,3,2,'402-22-012-A03','3000046003','Anne Fisher',2,'On-site','2023-10-01',750000.00,10,1,NULL,'2026-05-22 18:50:50'),(42,12,6,1,2,'402-22-012-A04','3000046004','Anne Fisher',2,'Scope','2024-02-10',700000.00,10,1,NULL,'2026-05-22 18:50:50'),(43,12,9,1,2,'402-22-012-B01','3000046005','Tom Willis',2,'On-site','2023-08-01',550000.00,10,1,NULL,'2026-05-22 18:50:50'),(44,12,9,2,2,'402-22-012-B02','3000046006','Tom Willis',2,'Scope','2024-01-15',500000.00,10,1,NULL,'2026-05-22 18:50:50'),(45,12,15,8,2,'402-22-012-C01','3000046007','Anne Fisher',2,'On-site','2023-04-01',450000.00,10,1,NULL,'2026-05-22 18:50:50'),(46,12,15,1,2,'402-22-012-C02','3000046008','Tom Willis',2,'Scope','2023-11-01',495754.00,10,1,NULL,'2026-05-22 18:50:50'),(47,12,16,8,2,'402-22-012-D01','3000046009','Tom Willis',2,'On-site','2023-02-01',500000.00,10,1,NULL,'2026-05-22 18:50:50'),(48,12,16,1,2,'402-22-012-D02','3000046010','Anne Fisher',2,'Scope','2023-09-20',490000.00,10,1,NULL,'2026-05-22 18:50:50'),(49,7,8,6,1,'120-23-007-A01','3000047001','Bob Builder',1,'On-site','2024-02-01',130000.00,7,1,NULL,'2026-05-22 18:50:50'),(50,7,8,5,1,'120-23-007-A02','3000047002','Frank Russo',1,'Scope','2024-09-10',115000.00,7,1,NULL,'2026-05-22 18:50:50'),(51,7,11,6,1,'120-23-007-B01','3000047003','Bob Builder',1,'On-site','2024-05-20',300000.00,7,1,NULL,'2026-05-22 18:50:50'),(52,7,11,5,1,'120-23-007-B02','3000047004','Frank Russo',1,'Scope','2024-10-01',410158.00,7,1,NULL,'2026-05-22 18:50:50'),(53,11,3,1,4,'407-22-011-C01','3000048001','Mark Torres',1,'Scope','2025-01-10',500000.00,11,1,NULL,'2026-05-22 18:50:50'),(54,11,3,2,4,'407-22-011-C02','3000048002','Sarah Klein',1,'On-site','2025-03-01',600000.00,11,1,NULL,'2026-05-22 18:50:50');
/*!40000 ALTER TABLE `awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_code` varchar(20) DEFAULT NULL,
  `category_name` varchar(200) NOT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `category_name` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'BRG','Bridges'),(2,'BLD','Buildings'),(3,'GEO','Geotechnical Investigation'),(4,'STR','Structural Steel Inspection & NDT'),(5,'APP','Application Support'),(6,'RPT','Reporting, Scheduling & Document Management'),(7,'PLN','Planning and Design'),(8,'ENV','Environmental'),(9,'ELEC','Electrical Systems'),(10,'MECH','Mechanical Systems'),(11,'TRF','Traffic Engineering'),(12,'CIV','Civil Engineering'),(13,'ARCH','Architecture'),(14,'PM','Program Management'),(15,'CM','Construction Management'),(16,'FAC','Facilities Condition Survey'),(17,'INS','Inspection Services'),(18,'DOC','Document and Records Management'),(19,'PSU','Project Support Unit'),(20,'EFS','Engineering & Financial Services');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communications`
--

DROP TABLE IF EXISTS `communications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communications` (
  `comm_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `award_id` int DEFAULT NULL,
  `firm_id` int NOT NULL,
  `comm_type` enum('Solicitation Sent','Response Received','No Response','Clarification Request','Award Notification','Non-Award Notification','Performance Notice','General Correspondence') NOT NULL,
  `comm_date` date NOT NULL,
  `sent_by` varchar(150) DEFAULT NULL,
  `subject` varchar(400) DEFAULT NULL,
  `body_summary` text,
  `has_attachment` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`comm_id`),
  KEY `program_id` (`program_id`),
  KEY `award_id` (`award_id`),
  KEY `firm_id` (`firm_id`),
  CONSTRAINT `communications_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`),
  CONSTRAINT `communications_ibfk_2` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`),
  CONSTRAINT `communications_ibfk_3` FOREIGN KEY (`firm_id`) REFERENCES `firms` (`firm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communications`
--

LOCK TABLES `communications` WRITE;
/*!40000 ALTER TABLE `communications` DISABLE KEYS */;
INSERT INTO `communications` VALUES (1,2,NULL,1,'Solicitation Sent','2024-11-15','PSU Team','RFP 6000000002 - Facility Condition Surveys','Solicitation package sent to Craig Geotechnical for Bridge & Building Surveys program.',0,'2026-05-22 18:50:50'),(2,2,NULL,3,'Solicitation Sent','2024-11-15','PSU Team','RFP 6000000002 - Facility Condition Surveys','Solicitation package sent to Infrastructure LLC.',0,'2026-05-22 18:50:50'),(3,2,NULL,10,'Solicitation Sent','2024-11-15','PSU Team','RFP 6000000002 - Facility Condition Surveys','Solicitation package sent to PACO Group.',0,'2026-05-22 18:50:50'),(4,2,NULL,13,'Solicitation Sent','2024-11-15','PSU Team','RFP 6000000002 - Facility Condition Surveys','Solicitation package sent to KTA-Tator.',0,'2026-05-22 18:50:50'),(5,2,NULL,10,'No Response','2024-12-05','PSU Team','No Response - RFP 6000000002','PACO Group did not respond to the solicitation by the deadline of December 1, 2024. No submission received.',0,'2026-05-22 18:50:50'),(6,2,NULL,10,'Clarification Request','2024-12-10','PSU Team','Follow-up: RFP 6000000002','Follow-up email sent to PACO Group requesting confirmation of receipt. No reply received as of Dec 15.',0,'2026-05-22 18:50:50'),(7,2,NULL,1,'Response Received','2024-11-28','PSU Team','Submission Received - RFP 6000000002','Craig Geotechnical submitted a complete proposal on time.',0,'2026-05-22 18:50:50'),(8,2,NULL,3,'Response Received','2024-11-30','PSU Team','Submission Received - RFP 6000000002','Infrastructure LLC submitted a complete proposal on time.',0,'2026-05-22 18:50:50'),(9,2,15,1,'Award Notification','2025-03-15','PSU Team','Award Notice - 405-22-002-A01','Craig Geotechnical awarded task order 405-22-002-A01 for $780,000.',0,'2026-05-22 18:50:50'),(10,2,NULL,10,'Non-Award Notification','2025-03-18','PSU Team','Non-Award Notice - RFP 6000000002','PACO Group notified they were not selected due to non-response to solicitation.',0,'2026-05-22 18:50:50');
/*!40000 ALTER TABLE `communications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `divisions`
--

DROP TABLE IF EXISTS `divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `divisions` (
  `division_id` int NOT NULL AUTO_INCREMENT,
  `division_code` varchar(10) NOT NULL,
  `division_number` varchar(10) DEFAULT NULL,
  `division_name` varchar(150) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`division_id`),
  UNIQUE KEY `division_code` (`division_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `divisions`
--

LOCK TABLES `divisions` WRITE;
/*!40000 ALTER TABLE `divisions` DISABLE KEYS */;
INSERT INTO `divisions` VALUES (1,'EAM','120','Enterprise Asset Management',1),(2,'EOD','402','Engineering Operations Division',1),(3,'QAD','405','Quality Assurance Division',1),(4,'EPD','407','Engineering Programs Division',1),(5,'CMD','410','Construction Management Division',1),(6,'MEU','426','Mechanical & Electrical Unit',1),(7,'EAD','415','Engineering & Architecture Division',1),(8,'EADD','415-D','Engineering & Architecture Design Division',1);
/*!40000 ALTER TABLE `divisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `firms`
--

DROP TABLE IF EXISTS `firms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `firms` (
  `firm_id` int NOT NULL AUTO_INCREMENT,
  `firm_name` varchar(250) NOT NULL,
  `alternate_name` varchar(250) DEFAULT NULL,
  `global_vendor_id` varchar(50) DEFAULT NULL,
  `sap_vendor_number` varchar(50) DEFAULT NULL,
  `is_sbe` tinyint(1) DEFAULT '0',
  `is_wbe` tinyint(1) DEFAULT '0',
  `is_dbe` tinyint(1) DEFAULT '0',
  `is_mbe` tinyint(1) DEFAULT '0',
  `is_mwbe` tinyint(1) DEFAULT '0',
  `is_sdvob` tinyint(1) DEFAULT '0',
  `is_ai` tinyint(1) DEFAULT '0',
  `is_lbe` tinyint(1) DEFAULT '0',
  `is_certified` tinyint(1) DEFAULT '0',
  `salutation` varchar(10) DEFAULT NULL,
  `primary_contact_name` varchar(150) DEFAULT NULL,
  `primary_contact_title` varchar(150) DEFAULT NULL,
  `primary_contact_email` varchar(200) DEFAULT NULL,
  `primary_contact_phone` varchar(30) DEFAULT NULL,
  `secondary_contact_name` varchar(150) DEFAULT NULL,
  `secondary_contact_email` varchar(200) DEFAULT NULL,
  `third_contact_name` varchar(150) DEFAULT NULL,
  `third_contact_email` varchar(200) DEFAULT NULL,
  `address1` varchar(200) DEFAULT NULL,
  `address2` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip` varchar(10) DEFAULT NULL,
  `dedup_cluster_id` int DEFAULT NULL,
  `dedup_canonical` tinyint(1) DEFAULT '1',
  `dedup_reviewed` tinyint(1) DEFAULT '0',
  `dedup_notes` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`firm_id`),
  UNIQUE KEY `global_vendor_id` (`global_vendor_id`),
  UNIQUE KEY `sap_vendor_number` (`sap_vendor_number`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `firms`
--

LOCK TABLES `firms` WRITE;
/*!40000 ALTER TABLE `firms` DISABLE KEYS */;
INSERT INTO `firms` VALUES (1,'Craig Geotechnical Drilling, LLC',NULL,'GVD-0001','SAP-1001',0,0,0,0,0,0,0,0,0,NULL,'Michael Craig','Principal','mCraig@cgd.com','212-555-0101','Lisa Hane','lHane@cgd.com',NULL,NULL,'123 Rock Ave',NULL,'Flushing','NY','11354',1,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(2,'Craig Geotechnical Drilling LLC','Craig Geo','GVD-0001B',NULL,0,0,0,0,0,0,0,0,0,NULL,'Michael Craig','Principal','michael.craig@cgd.com','212-555-0101',NULL,NULL,NULL,NULL,'123 Rock Avenue',NULL,'Flushing','NY','11354',1,0,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(3,'OVE ARUP & Partners, P.C.',NULL,'GVD-0002','SAP-1002',0,0,0,0,0,0,0,0,0,NULL,'Sarah Lowe','VP Engineering','sLowe@arup.com','212-555-0202','Tom Reid','tReid@arup.com',NULL,NULL,'77 Water St',NULL,'New York','NY','10005',2,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(4,'Arup & Partners PC','OVE ARUP',NULL,NULL,0,0,0,0,0,0,0,0,0,NULL,'Sarah Lowe','VP','s.lowe@arup.com',NULL,NULL,NULL,NULL,NULL,'77 Water Street',NULL,'New York','NY','10005',2,0,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(5,'Infrastructure LLC',NULL,'GVD-0003','SAP-1003',0,0,0,1,1,0,0,0,1,NULL,'Diana Park','Director','dPark@infra.com','212-555-0303','Kevin Walsh','kWalsh@infra.com',NULL,NULL,'55 Broadway',NULL,'New York','NY','10006',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(6,'EnTech Engineering, PC',NULL,'GVD-0004','SAP-1004',1,0,0,0,0,0,0,0,1,NULL,'Raymond Torres','President','rTorres@entech.com','212-555-0404','Aisha Brown','aBrown@entech.com',NULL,NULL,'200 Park Ave S',NULL,'New York','NY','10003',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(7,'WSP USA SOLUTIONS INC.',NULL,'GVD-0005','SAP-1005',0,0,0,0,0,0,0,0,0,NULL,'James Whitfield','Project Director','jWhitfield@wsp.com','212-555-0505','Priya Nair','pNair@wsp.com',NULL,NULL,'One Penn Plaza',NULL,'New York','NY','10119',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(8,'Drive Engineering, P.C.',NULL,'GVD-0006','SAP-1006',0,1,0,0,1,0,0,1,1,NULL,'Angela Russo','CEO','aRusso@driveeng.com','212-555-0606','Mark Chen','mChen@driveeng.com',NULL,NULL,'330 W 42nd St',NULL,'New York','NY','10036',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(9,'Pennoni Associates, Inc.',NULL,'GVD-0007','SAP-1007',0,0,0,0,0,0,0,0,0,NULL,'Frank Pennoni','Senior Associate','fPennoni@pennoni.com','215-555-0707','Cynthia Ho','cHo@pennoni.com',NULL,NULL,'1900 Market St',NULL,'Philadelphia','PA','19103',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(10,'PACO Group',NULL,'GVD-0008','SAP-1008',0,0,1,0,0,0,0,0,1,NULL,'Roberto Paco','President','rPaco@pacogroup.com','212-555-0808','Sandra Lee','sLee@pacogroup.com',NULL,NULL,'20 Exchange Place',NULL,'New York','NY','10005',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(11,'SJH Engineering P.C.',NULL,'GVD-0009','SAP-1009',1,0,0,0,0,0,0,0,1,NULL,'Samuel Huang','Principal','sHuang@sjheng.com','212-555-0909','Olivia Grant','oGrant@sjheng.com',NULL,NULL,'80 Broad St',NULL,'New York','NY','10004',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(12,'Urban Engineers of NY',NULL,'GVD-0010','SAP-1010',0,1,1,0,1,0,0,0,1,NULL,'Tanya Williams','VP Operations','tWilliams@urbanengny.com','212-555-1010','Craig Stevens','cStevens@urbanengny.com',NULL,NULL,'375 Hudson St',NULL,'New York','NY','10014',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(13,'Bureau Veritas',NULL,'GVD-0011','SAP-1011',0,0,0,0,0,0,0,0,0,NULL,'Pierre Leblanc','Regional Director','pLeblanc@bureauveritas.com','212-555-1111','Alice Wong','aWong@bureauveritas.com',NULL,NULL,'299 Park Ave',NULL,'New York','NY','10171',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(14,'Gedeon Engineering',NULL,'GVD-0012','SAP-1012',1,0,0,1,1,0,0,0,1,NULL,'Gedeon Toto','President','gToto@gedeoneng.com','212-555-1212','Marie Blanc','mBlanc@gedeoneng.com',NULL,NULL,'247 W 35th St',NULL,'New York','NY','10001',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(15,'KTA-Tator, Inc.','KTA','GVD-0013','SAP-1013',0,0,0,0,0,0,0,0,0,NULL,'David Tator','CEO','dTator@kta-tator.com','412-555-1313','Jennifer Cole','jCole@kta-tator.com',NULL,NULL,'115 Technology Dr',NULL,'Pittsburgh','PA','15275',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(16,'Stellar Engineering & Design',NULL,'GVD-0014','SAP-1014',0,0,0,0,0,1,0,0,1,NULL,'Nina Stellar','Director','nStellar@stellareng.com','212-555-1414','Carlos Rivera','cRivera@stellareng.com',NULL,NULL,'60 Broad St',NULL,'New York','NY','10004',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(17,'CSA Group','CSA','GVD-0015','SAP-1015',0,0,0,0,0,0,0,0,0,NULL,'Martin Cooper','Technical Lead','mCooper@csagroup.com','212-555-1515','Wendy Park','wPark@csagroup.com',NULL,NULL,'178 Columbus Ave',NULL,'New York','NY','10023',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(18,'20/20 Inspections',NULL,'GVD-0016','SAP-1016',0,0,0,0,0,0,0,1,0,NULL,'Paul Catherall','Owner','pCatherall@2020insp.com','718-555-1616','Brian Holt','bHolt@2020insp.com',NULL,NULL,'412 Union Ave',NULL,'Brooklyn','NY','11211',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(19,'A.G. Consulting Engineering, P.C.',NULL,'GVD-0017','SAP-1017',0,1,0,0,1,0,0,0,1,NULL,'Lindsay Degueldre','President','lDegueldre@agconsult.com','212-555-1717','Thomas Gray','tGray@agconsult.com',NULL,NULL,'55 W 46th St',NULL,'New York','NY','10036',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(20,'Hardesty & Hanover, LLC',NULL,'GVD-0018','SAP-1018',0,0,0,0,0,0,0,0,0,NULL,'Bruce Hanover','Senior Partner','bHanover@hardesty-hanover.com','212-555-1818','Rachel Kim','rKim@hardesty-hanover.com',NULL,NULL,'1501 Broadway',NULL,'New York','NY','10036',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(21,'Metro Concrete Specialists',NULL,'GVD-0020','SAP-1020',1,0,0,1,1,0,0,1,1,NULL,'Jose Rivera','President','jRivera@metroconcrete.com','718-555-2020',NULL,NULL,NULL,NULL,'88 Jamaica Ave',NULL,'Jamaica','NY','11435',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(22,'Atlantic Inspection Group',NULL,'GVD-0021','SAP-1021',0,0,0,0,0,1,0,0,1,NULL,'Robert Doyle','Director','rDoyle@atlanticinsp.com','212-555-2121',NULL,NULL,NULL,NULL,'200 Rector St',NULL,'New York','NY','10006',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50'),(23,'GeoTech Solutions NY',NULL,'GVD-0022','SAP-1022',1,1,0,0,1,0,0,0,1,NULL,'Priya Sharma','CEO','pSharma@geotechny.com','212-555-2222',NULL,NULL,NULL,NULL,'45 Wall St',NULL,'New York','NY','10005',NULL,1,0,NULL,1,'2026-05-22 18:50:50','2026-05-22 18:50:50');
/*!40000 ALTER TABLE `firms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mbe_tracking`
--

DROP TABLE IF EXISTS `mbe_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mbe_tracking` (
  `mbe_id` int NOT NULL AUTO_INCREMENT,
  `award_id` int NOT NULL,
  `firm_id` int NOT NULL,
  `prime_firm_id` int NOT NULL,
  `mbe_category` enum('MBE','WBE','DBE','MWBE','SBE','SDVOB') NOT NULL,
  `committed_amount` decimal(14,2) DEFAULT '0.00',
  `paid_amount` decimal(14,2) DEFAULT '0.00',
  `actual_amount` decimal(14,2) DEFAULT '0.00',
  `committed_pct` decimal(5,2) DEFAULT NULL,
  `paid_pct` decimal(5,2) GENERATED ALWAYS AS (round(((`paid_amount` / nullif(`committed_amount`,0)) * 100),2)) STORED,
  `reporting_period` date DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mbe_id`),
  KEY `award_id` (`award_id`),
  KEY `firm_id` (`firm_id`),
  KEY `prime_firm_id` (`prime_firm_id`),
  CONSTRAINT `mbe_tracking_ibfk_1` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`),
  CONSTRAINT `mbe_tracking_ibfk_2` FOREIGN KEY (`firm_id`) REFERENCES `firms` (`firm_id`),
  CONSTRAINT `mbe_tracking_ibfk_3` FOREIGN KEY (`prime_firm_id`) REFERENCES `firms` (`firm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mbe_tracking`
--

LOCK TABLES `mbe_tracking` WRITE;
/*!40000 ALTER TABLE `mbe_tracking` DISABLE KEYS */;
INSERT INTO `mbe_tracking` (`mbe_id`, `award_id`, `firm_id`, `prime_firm_id`, `mbe_category`, `committed_amount`, `paid_amount`, `actual_amount`, `committed_pct`, `reporting_period`, `notes`, `created_at`) VALUES (1,1,21,1,'MBE',160000.00,145000.00,140000.00,20.00,'2023-06-30',NULL,'2026-05-22 18:50:50'),(2,9,23,3,'WBE',90000.00,85000.00,85000.00,10.00,'2023-09-30',NULL,'2026-05-22 18:50:50'),(3,29,21,5,'MBE',90000.00,75000.00,70000.00,20.00,'2024-12-31',NULL,'2026-05-22 18:50:50'),(4,35,21,6,'MBE',100000.00,95000.00,95000.00,20.00,'2023-12-31',NULL,'2026-05-22 18:50:50'),(5,35,22,6,'WBE',80000.00,70000.00,68000.00,16.00,'2023-12-31',NULL,'2026-05-22 18:50:50'),(6,1,21,1,'MBE',160000.00,145000.00,140000.00,20.00,'2023-06-30',NULL,'2026-05-23 07:41:38'),(7,9,23,3,'WBE',90000.00,85000.00,85000.00,10.00,'2023-09-30',NULL,'2026-05-23 07:41:38'),(8,29,21,5,'MBE',90000.00,75000.00,70000.00,20.00,'2024-12-31',NULL,'2026-05-23 07:41:38'),(9,35,21,6,'MBE',100000.00,95000.00,95000.00,20.00,'2023-12-31',NULL,'2026-05-23 07:41:38'),(10,35,22,6,'WBE',80000.00,70000.00,68000.00,16.00,'2023-12-31',NULL,'2026-05-23 07:41:38');
/*!40000 ALTER TABLE `mbe_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `performance_letters`
--

DROP TABLE IF EXISTS `performance_letters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `performance_letters` (
  `letter_id` int NOT NULL AUTO_INCREMENT,
  `firm_id` int NOT NULL,
  `award_id` int DEFAULT NULL,
  `program_id` int DEFAULT NULL,
  `letter_type` enum('Commendation','Warning','Cure Notice','Poor Performance','Default','Other') NOT NULL,
  `letter_date` date NOT NULL,
  `issued_by` varchar(150) DEFAULT NULL,
  `description` text,
  `resolution` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`letter_id`),
  KEY `firm_id` (`firm_id`),
  KEY `award_id` (`award_id`),
  KEY `program_id` (`program_id`),
  CONSTRAINT `performance_letters_ibfk_1` FOREIGN KEY (`firm_id`) REFERENCES `firms` (`firm_id`),
  CONSTRAINT `performance_letters_ibfk_2` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`),
  CONSTRAINT `performance_letters_ibfk_3` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `performance_letters`
--

LOCK TABLES `performance_letters` WRITE;
/*!40000 ALTER TABLE `performance_letters` DISABLE KEYS */;
INSERT INTO `performance_letters` VALUES (1,9,NULL,1,'Poor Performance','2023-11-15','Dave Whitman','PACO Group failed to meet deliverable deadlines on Program 402-21-001. Two milestones were missed by more than 30 days without notification.','Firm placed on performance watch. Reviewed at next selection committee.',1,'2026-05-22 18:50:50'),(2,15,38,12,'Cure Notice','2023-06-20','Tom Willis','Quality of deliverables on TO 402-22-012-C01 did not meet specifications. Corrective action requested within 14 days.','Firm submitted corrective action plan. Accepted by PM. Letter closed Aug 2023.',1,'2026-05-22 18:50:50'),(3,17,18,9,'Commendation','2025-04-15','Paul Catherall','Exceptional performance on JFK structural steel inspection assignments. Delivered all reports ahead of schedule with zero deficiencies noted.',NULL,1,'2026-05-22 18:50:50');
/*!40000 ALTER TABLE `performance_letters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_categories`
--

DROP TABLE IF EXISTS `program_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_categories` (
  `program_id` int NOT NULL,
  `category_id` int NOT NULL,
  `sort_order` tinyint DEFAULT '1',
  PRIMARY KEY (`program_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `program_categories_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`),
  CONSTRAINT `program_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_categories`
--

LOCK TABLES `program_categories` WRITE;
/*!40000 ALTER TABLE `program_categories` DISABLE KEYS */;
INSERT INTO `program_categories` VALUES (1,14,3),(1,19,1),(1,20,2),(2,1,1),(2,2,2),(2,15,3),(3,1,1),(3,4,2),(4,3,1),(5,7,1),(5,12,2),(6,11,2),(6,14,1),(7,13,1),(8,7,1),(9,4,1),(9,17,2),(10,14,1),(11,3,1),(12,5,1),(12,17,2);
/*!40000 ALTER TABLE `program_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `program_firms`
--

DROP TABLE IF EXISTS `program_firms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `program_firms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `program_id` int NOT NULL,
  `firm_id` int NOT NULL,
  `agmt_firm_record` tinyint(1) DEFAULT '1',
  `is_on_scp_list` tinyint(1) DEFAULT '0',
  `date_added` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_program_firm` (`program_id`,`firm_id`),
  KEY `firm_id` (`firm_id`),
  CONSTRAINT `program_firms_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`),
  CONSTRAINT `program_firms_ibfk_2` FOREIGN KEY (`firm_id`) REFERENCES `firms` (`firm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `program_firms`
--

LOCK TABLES `program_firms` WRITE;
/*!40000 ALTER TABLE `program_firms` DISABLE KEYS */;
INSERT INTO `program_firms` VALUES (1,1,5,1,1,'2023-03-01',1),(2,1,6,1,0,'2023-03-01',1),(3,1,10,1,0,'2023-03-01',1),(4,1,15,1,0,'2023-03-01',1),(5,1,17,1,0,'2023-03-01',1),(6,1,19,1,0,'2023-03-01',1),(7,1,13,1,0,'2023-03-01',1),(8,1,14,1,0,'2023-03-01',1),(9,2,1,1,0,'2024-11-01',1),(10,2,3,1,0,'2024-11-01',1),(11,2,9,1,0,'2024-11-01',1),(12,2,13,1,0,'2024-11-01',1),(13,2,14,1,0,'2024-11-01',1),(14,2,16,1,0,'2024-11-01',1),(15,2,19,1,0,'2024-11-01',1),(16,2,20,1,0,'2024-11-01',1),(17,2,21,1,0,'2024-11-01',1),(18,2,22,1,0,'2024-11-01',1),(19,2,11,1,0,'2024-11-01',1),(20,2,12,1,0,'2024-11-01',1),(21,3,3,1,0,'2023-09-01',1),(22,3,6,1,0,'2023-09-01',1),(23,3,19,1,0,'2023-09-01',1),(24,3,20,1,0,'2023-09-01',1),(25,3,16,1,0,'2023-09-01',1),(26,3,12,1,0,'2023-09-01',1),(27,4,1,1,0,'2023-08-01',1),(28,4,3,1,0,'2023-08-01',1),(29,4,12,1,0,'2023-08-01',1),(30,4,19,1,0,'2023-08-01',1),(31,4,21,1,0,'2023-08-01',1),(32,5,7,1,0,'2024-06-01',1),(33,5,11,1,0,'2024-06-01',1),(34,5,12,1,0,'2024-06-01',1),(35,5,15,1,0,'2024-06-01',1),(36,5,17,1,0,'2024-06-01',1),(37,5,10,1,0,'2024-06-01',1),(38,6,5,1,0,'2023-02-01',1),(39,6,8,1,0,'2023-02-01',1),(40,6,9,1,0,'2023-02-01',1),(41,6,10,1,0,'2023-02-01',1),(42,6,16,1,0,'2023-02-01',1),(43,6,17,1,0,'2023-02-01',1),(44,9,17,1,0,'2021-01-01',1),(45,9,13,1,0,'2021-01-01',1),(46,9,15,1,0,'2021-01-01',1),(47,9,14,1,0,'2021-01-01',1),(48,9,5,1,0,'2021-01-01',1),(49,9,9,1,0,'2021-01-01',1),(50,9,11,1,0,'2021-01-01',1),(51,9,12,1,0,'2021-01-01',1),(52,9,22,1,0,'2021-01-01',1),(53,10,18,1,0,'2020-04-01',1),(54,10,3,1,0,'2020-04-01',1),(55,10,6,1,0,'2020-04-01',1),(56,10,12,1,0,'2020-04-01',1),(57,10,20,1,0,'2020-04-01',1),(58,10,21,1,0,'2020-04-01',1),(59,11,1,1,0,'2022-03-01',1),(60,11,3,1,0,'2022-03-01',1),(61,11,19,1,0,'2022-03-01',1),(62,11,20,1,0,'2022-03-01',1),(63,11,6,1,0,'2022-03-01',1),(64,11,22,1,0,'2022-03-01',1),(65,12,5,1,0,'2022-06-01',1),(66,12,9,1,0,'2022-06-01',1),(67,12,10,1,0,'2022-06-01',1),(68,12,15,1,0,'2022-06-01',1),(69,12,16,1,0,'2022-06-01',1),(70,12,17,1,0,'2022-06-01',1);
/*!40000 ALTER TABLE `program_firms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `programs`
--

DROP TABLE IF EXISTS `programs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `programs` (
  `program_id` int NOT NULL AUTO_INCREMENT,
  `rfp_number` varchar(50) NOT NULL,
  `rfp_shorthand` varchar(300) DEFAULT NULL,
  `program_title` varchar(400) NOT NULL,
  `agreement_number` varchar(50) DEFAULT NULL,
  `solicitation_type_id` int NOT NULL,
  `division_id` int NOT NULL,
  `unit_id` int DEFAULT NULL,
  `authorized_amount` decimal(16,2) DEFAULT '0.00',
  `awarded_amount` decimal(16,2) DEFAULT '0.00',
  `spent_amount` decimal(16,2) DEFAULT '0.00',
  `solicitation_date` date DEFAULT NULL,
  `valid_from` date DEFAULT NULL,
  `valid_to` date DEFAULT NULL,
  `date_sent_to_procurement` date DEFAULT NULL,
  `award_date` date DEFAULT NULL,
  `ice_estimate` decimal(16,2) DEFAULT NULL,
  `num_firms_on_list` int DEFAULT '0',
  `num_submissions` int DEFAULT '0',
  `pm_name` varchar(150) DEFAULT NULL,
  `agree_pm` varchar(150) DEFAULT NULL,
  `dar_name` varchar(150) DEFAULT NULL,
  `pa_contact` varchar(150) DEFAULT NULL,
  `status` enum('Active','Closed','Pending','Cancelled') DEFAULT 'Active',
  `security_level` enum('Public','Confidential','Restricted') DEFAULT 'Public',
  `program_type` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`program_id`),
  UNIQUE KEY `rfp_number` (`rfp_number`),
  KEY `solicitation_type_id` (`solicitation_type_id`),
  KEY `division_id` (`division_id`),
  KEY `unit_id` (`unit_id`),
  CONSTRAINT `programs_ibfk_1` FOREIGN KEY (`solicitation_type_id`) REFERENCES `solicitation_types` (`type_id`),
  CONSTRAINT `programs_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`division_id`),
  CONSTRAINT `programs_ibfk_3` FOREIGN KEY (`unit_id`) REFERENCES `units` (`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `programs`
--

LOCK TABLES `programs` WRITE;
/*!40000 ALTER TABLE `programs` DISABLE KEYS */;
INSERT INTO `programs` VALUES (1,'6000000001','Eng Services Op Support & Project Support','ENGINEERING SERVICES FOR OPERATIONS SUPPORT AND PROJECT SUPPORT','402-21-001',2,2,11,8000000.00,0.00,0.00,'2023-03-15','2023-05-01','2027-05-01','2023-02-01','2023-05-01',5000000.00,8,8,'Bob Smith','Dave Whitman','Jennifer Reed','APM Lee','Active','Public','Small Contracts - Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(2,'6000000002','Facility Condition Surveys Bridges & Buildings','FACILITY CONDITION SURVEYS FOR BRIDGES AND BUILDINGS','405-22-002',1,3,12,15000000.00,0.00,0.00,'2024-12-01','2025-03-01','2029-03-01','2024-11-01','2025-03-01',12000000.00,12,10,'John Doe','Brian ONeil','Eric Marsh','DAR Jones','Active','Public','Task Order Program - Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(3,'6000000003','Design Services Manhattan Bridge Structural Rehab','DESIGN SERVICES FOR THE MANHATTAN BRIDGE STRUCTURAL REHABILITATION','415-22-003',4,7,9,25000000.00,0.00,0.00,'2023-10-01','2023-12-01','2027-12-01','2023-09-01','2023-12-01',18000000.00,6,4,'Samantha Scott','Paul Donnelly','Josh Hart','APM Singh','Active','Public','Large Program','2026-05-22 18:50:50','2026-05-22 18:50:50'),(4,'6000000004','Design Services Brooklyn Bridge','DESIGN SERVICES FOR THE BROOKLYN BRIDGE','415-23-004',5,7,6,12000000.00,0.00,0.00,'2023-09-01','2023-11-01','2027-11-01','2023-08-01','2023-11-01',9500000.00,5,3,'Plank Sinatra','Steve Parker','Jennifer Reed','DAR Chang','Active','Confidential','Scope Specific','2026-05-22 18:50:50','2026-05-22 18:50:50'),(5,'6000000005','Clean Construction Services SBE','CLEAN CONSTRUCTION SERVICES - SBE SET-ASIDE','415-24-005',3,7,9,10000000.00,0.00,0.00,'2024-07-01','2024-09-01','2028-08-01','2024-06-01','2024-09-01',7500000.00,10,9,'Level Larry','Mark Holloway','Samantha Cruz','APM Lee','Active','Public','Small Business Enterprise - Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(6,'6000000006','Eng Services Op Support No Categories','ENGINEERING SERVICES FOR OPERATIONS SUPPORT (NO CATEGORIES)','402-23-006',2,2,11,5000000.00,0.00,0.00,'2023-03-15','2023-05-01','2027-05-01','2023-02-10','2023-05-01',3500000.00,6,5,'Jane Doe','Carlos Mendoza','Samantha Cruz','DAR Jones','Active','Public','Small Contracts - No Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(7,'6000000007','Architectural Exterior Wall Services Task Order','ARCHITECTURAL EXTERIOR WALL SERVICES ON A TASK ORDER BASIS','120-23-007',1,1,NULL,6000000.00,0.00,0.00,'2023-10-01','2023-12-01','2027-12-01','2023-09-15','2023-12-01',4000000.00,7,6,'Bob Builder','Frank Russo','Josh Hart','APM Park','Active','Public','Task Order Program - No Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(8,'6000000008','Build Construction Services SBE No Categories','BUILD CONSTRUCTION SERVICES - SBE SET-ASIDE (NO CATEGORIES)','426-24-008',3,6,NULL,4000000.00,0.00,0.00,'2023-10-01','2023-12-01','2027-12-01','2023-09-20','2023-12-01',2500000.00,5,4,'Grout Scott','Jason Alvarez','Eric Marsh','DAR Singh','Active','Public','Small Business Enterprise - No Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(9,'6000000009','Structural Steel Inspection NDT CMD','STRUCTURAL STEEL INSPECTION AND NON-DESTRUCTIVE TESTING SERVICES','426-21-045',1,5,4,12000000.00,0.00,0.00,'2021-01-15','2021-03-01','2025-03-01','2021-01-01','2021-03-01',8000000.00,9,8,'Paul Catherall','Dave Whitman','Jennifer Reed','APM Torres','Active','Public','Task Order Program - Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(10,'6000000010','Engineering Portfolio Manager EPD','EXPERT PROFESSIONAL AND TECHNICAL PROJECT MANAGEMENT SERVICES','407-20-028',1,4,13,20000000.00,0.00,0.00,'2020-05-01','2020-07-01','2024-07-01','2020-04-01','2020-07-01',15000000.00,14,12,'Lindsay Degueldre','Steve Parker','Josh Hart','APM Chen','Closed','Public','Task Order Program - Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(11,'6000000011','Geotechnical Investigation Program EPD','GEOTECHNICAL INVESTIGATION SERVICES - EPD','407-22-011',1,4,6,30000000.00,0.00,0.00,'2022-04-01','2022-06-01','2026-06-01','2022-03-01','2022-06-01',20000000.00,11,10,'Mark Torres','Sarah Klein','David Park','APM Liu','Active','Public','Task Order Program - Categories','2026-05-22 18:50:50','2026-05-22 18:50:50'),(12,'6000000012','Small Contracts General Engineering EOD','GENERAL ENGINEERING SERVICES - SMALL CONTRACTS','402-22-012',2,2,NULL,8000000.00,0.00,0.00,'2022-07-01','2022-09-01','2026-09-01','2022-06-15','2022-09-01',6000000.00,10,9,'Tom Willis','Anne Fisher','Greg Brown','DAR Patel','Active','Public','Small Contracts - No Categories','2026-05-22 18:50:50','2026-05-22 18:50:50');
/*!40000 ALTER TABLE `programs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sites` (
  `site_id` int NOT NULL AUTO_INCREMENT,
  `site_code` varchar(20) NOT NULL,
  `site_name` varchar(150) NOT NULL,
  `borough` varchar(50) DEFAULT NULL,
  `state` char(2) DEFAULT 'NY',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`site_id`),
  UNIQUE KEY `site_code` (`site_code`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (1,'JFK','John F. Kennedy International Airport','Queens','NY',1),(2,'LGA','LaGuardia Airport','Queens','NY',1),(3,'EWR','Newark Liberty International Airport',NULL,'NJ',1),(4,'STI','Staten Island','Staten Island','NY',1),(5,'BKN','Brooklyn Facilities','Brooklyn','NY',1),(6,'MHT','Manhattan Facilities','Manhattan','NY',1),(7,'BRX','Bronx Facilities','Bronx','NY',1),(8,'HQ','Headquarters - 2 Broadway','Manhattan','NY',1);
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitation_types`
--

DROP TABLE IF EXISTS `solicitation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitation_types` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_code` varchar(40) NOT NULL,
  `type_label` varchar(100) NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `type_code` (`type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitation_types`
--

LOCK TABLES `solicitation_types` WRITE;
/*!40000 ALTER TABLE `solicitation_types` DISABLE KEYS */;
INSERT INTO `solicitation_types` VALUES (1,'task_order','Task Order'),(2,'small_contracts','Small Contracts'),(3,'sbe_set_aside','SBE Set-Aside'),(4,'large_program','Large Program'),(5,'scope_specific','Scope Specific');
/*!40000 ALTER TABLE `solicitation_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spend_tracking`
--

DROP TABLE IF EXISTS `spend_tracking`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spend_tracking` (
  `spend_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int NOT NULL,
  `award_id` int DEFAULT NULL,
  `spend_type` enum('Purchase Order','Task Order','Change Order','Invoice') NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `spend_date` date NOT NULL,
  `amount` decimal(14,2) NOT NULL,
  `vendor_firm_id` int DEFAULT NULL,
  `site_id` int DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL,
  `approved_by` varchar(150) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`spend_id`),
  KEY `program_id` (`program_id`),
  KEY `award_id` (`award_id`),
  KEY `vendor_firm_id` (`vendor_firm_id`),
  KEY `site_id` (`site_id`),
  CONSTRAINT `spend_tracking_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`),
  CONSTRAINT `spend_tracking_ibfk_2` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`),
  CONSTRAINT `spend_tracking_ibfk_3` FOREIGN KEY (`vendor_firm_id`) REFERENCES `firms` (`firm_id`),
  CONSTRAINT `spend_tracking_ibfk_4` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spend_tracking`
--

LOCK TABLES `spend_tracking` WRITE;
/*!40000 ALTER TABLE `spend_tracking` DISABLE KEYS */;
INSERT INTO `spend_tracking` VALUES (1,11,1,'Purchase Order','PO-3000041001-A','2022-09-01',400000.00,1,1,'Initial mobilization and drilling - JFK','Kim Travers','2026-05-23 07:41:38'),(2,11,1,'Purchase Order','PO-3000041001-B','2022-11-01',350000.00,1,1,'Continued drilling - JFK Phase 2','Kim Travers','2026-05-23 07:41:38'),(3,11,1,'Invoice','INV-2022-CGD-01','2022-10-15',390000.00,1,1,'Invoice for September drilling work','Kim Travers','2026-05-23 07:41:38'),(4,11,3,'Purchase Order','PO-3000041003-A','2023-03-01',450000.00,1,1,'Manhattan Bridge geotechnical study','Mark Torres','2026-05-23 07:41:38'),(5,11,3,'Invoice','INV-2023-CGD-02','2023-04-01',440000.00,1,1,'Invoice for Manhattan geo work','Mark Torres','2026-05-23 07:41:38'),(6,3,9,'Task Order','TO-415-22-003-01','2023-04-01',450000.00,3,6,'Manhattan Bridge structural assessment phase 1','Samantha Scott','2026-05-23 07:41:38'),(7,3,9,'Invoice','INV-2023-ARUP-01','2023-05-01',430000.00,3,6,'Phase 1 invoice','Samantha Scott','2026-05-23 07:41:38'),(8,3,10,'Task Order','TO-415-22-003-02','2023-08-01',375000.00,3,6,'Phase 2 structural drawings','Paul Donnelly','2026-05-23 07:41:38'),(9,9,18,'Task Order','TO-426-21-045-01','2025-03-10',28000.00,17,1,'JFK structural steel scope inspection','Paul Catherall','2026-05-23 07:41:38'),(10,9,19,'Task Order','TO-426-21-045-02','2025-03-15',200000.00,17,2,'LGA steel NDT inspection','Paul Catherall','2026-05-23 07:41:38');
/*!40000 ALTER TABLE `spend_tracking` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sub_awards`
--

DROP TABLE IF EXISTS `sub_awards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sub_awards` (
  `sub_award_id` int NOT NULL AUTO_INCREMENT,
  `award_id` int NOT NULL,
  `sub_firm_id` int NOT NULL,
  `committed_amount` decimal(14,2) DEFAULT '0.00',
  `paid_amount` decimal(14,2) DEFAULT '0.00',
  `pct_of_prime` decimal(5,2) GENERATED ALWAYS AS (round(((`paid_amount` / nullif(`committed_amount`,0)) * 100),2)) STORED,
  `description` varchar(500) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`sub_award_id`),
  KEY `award_id` (`award_id`),
  KEY `sub_firm_id` (`sub_firm_id`),
  CONSTRAINT `sub_awards_ibfk_1` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`),
  CONSTRAINT `sub_awards_ibfk_2` FOREIGN KEY (`sub_firm_id`) REFERENCES `firms` (`firm_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sub_awards`
--

LOCK TABLES `sub_awards` WRITE;
/*!40000 ALTER TABLE `sub_awards` DISABLE KEYS */;
INSERT INTO `sub_awards` (`sub_award_id`, `award_id`, `sub_firm_id`, `committed_amount`, `paid_amount`, `description`, `created_at`) VALUES (1,1,21,160000.00,145000.00,'Concrete core sampling and lab testing','2026-05-22 18:50:50'),(2,1,23,80000.00,72000.00,'Site survey and geotechnical reporting','2026-05-22 18:50:50'),(3,9,22,180000.00,162000.00,'Structural analysis sub-contract','2026-05-22 18:50:50'),(4,9,23,90000.00,85000.00,'Environmental assessment','2026-05-22 18:50:50'),(5,20,22,30000.00,28000.00,'NDT laboratory analysis','2026-05-22 18:50:50'),(6,29,21,90000.00,75000.00,'Materials testing support','2026-05-22 18:50:50'),(7,31,23,120000.00,110000.00,'Geotechnical review services','2026-05-22 18:50:50'),(8,35,21,100000.00,95000.00,'Concrete inspection services','2026-05-22 18:50:50'),(9,35,22,80000.00,70000.00,'Technical writing and documentation','2026-05-22 18:50:50'),(10,1,21,160000.00,145000.00,'Concrete core sampling and lab testing','2026-05-23 07:41:38'),(11,1,23,80000.00,72000.00,'Site survey and geotechnical reporting','2026-05-23 07:41:38'),(12,9,22,180000.00,162000.00,'Structural analysis sub-contract','2026-05-23 07:41:38'),(13,9,23,90000.00,85000.00,'Environmental assessment','2026-05-23 07:41:38'),(14,18,22,30000.00,28000.00,'NDT laboratory analysis','2026-05-23 07:41:38'),(15,29,21,90000.00,75000.00,'Materials testing support','2026-05-23 07:41:38'),(16,31,23,120000.00,110000.00,'Geotechnical review services','2026-05-23 07:41:38'),(17,35,21,100000.00,95000.00,'Concrete inspection services','2026-05-23 07:41:38'),(18,35,22,80000.00,70000.00,'Technical writing and documentation','2026-05-23 07:41:38');
/*!40000 ALTER TABLE `sub_awards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `units`
--

DROP TABLE IF EXISTS `units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `units` (
  `unit_id` int NOT NULL AUTO_INCREMENT,
  `division_id` int NOT NULL,
  `unit_code` varchar(30) DEFAULT NULL,
  `unit_name` varchar(150) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`unit_id`),
  KEY `division_id` (`division_id`),
  CONSTRAINT `units_ibfk_1` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`division_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `units`
--

LOCK TABLES `units` WRITE;
/*!40000 ALTER TABLE `units` DISABLE KEYS */;
INSERT INTO `units` VALUES (1,7,'EAD-ARCH','EAD - Architecture',1),(2,7,'EAD-CIV','EAD - Civil',1),(3,7,'EAD-CON','EAD - Contracts',1),(4,7,'EAD-ENV','EAD - Environmental',1),(5,7,'EAD-ELEC','EAD - Electrical',1),(6,7,'EAD-GEO','EAD - Geotechnical',1),(7,7,'EAD-MECH','EAD - Mechanical',1),(8,7,'EAD-RSD','EAD - RSD',1),(9,7,'EAD-STR','EAD - Structural',1),(10,7,'EAD-TRF','EAD - Traffic',1),(11,2,'EOD-DT','Digital Transformation',1),(12,3,'QAD-SIU','Structural Integrity Unit',1),(13,4,'EPD-INF','Infrastructure Projects',1),(14,5,'CMD-BRG','Bridge Programs',1),(15,5,'CMD-BLD','Building Programs',1),(16,6,'MEU-MECH','Mechanical Systems',1);
/*!40000 ALTER TABLE `units` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_awards_detail`
--

DROP TABLE IF EXISTS `v_awards_detail`;
/*!50001 DROP VIEW IF EXISTS `v_awards_detail`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_awards_detail` AS SELECT 
 1 AS `award_id`,
 1 AS `award_date`,
 1 AS `fiscal_year`,
 1 AS `fiscal_quarter`,
 1 AS `fiscal_period`,
 1 AS `award_amount`,
 1 AS `award_type`,
 1 AS `agreement_number`,
 1 AS `po_number`,
 1 AS `assignment`,
 1 AS `awarded_firm`,
 1 AS `is_sbe`,
 1 AS `is_wbe`,
 1 AS `is_dbe`,
 1 AS `is_mbe`,
 1 AS `is_mwbe`,
 1 AS `is_sdvob`,
 1 AS `solicitation_type`,
 1 AS `division_code`,
 1 AS `division_name`,
 1 AS `site_code`,
 1 AS `site_name`,
 1 AS `program_title`,
 1 AS `solicitation_number`,
 1 AS `solicitation_date`,
 1 AS `program_authorized_amt`,
 1 AS `ice_estimate`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_by_division`
--

DROP TABLE IF EXISTS `v_by_division`;
/*!50001 DROP VIEW IF EXISTS `v_by_division`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_by_division` AS SELECT 
 1 AS `division_code`,
 1 AS `division_name`,
 1 AS `awards_amt`,
 1 AS `num_awards`,
 1 AS `pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_by_site`
--

DROP TABLE IF EXISTS `v_by_site`;
/*!50001 DROP VIEW IF EXISTS `v_by_site`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_by_site` AS SELECT 
 1 AS `site_code`,
 1 AS `site_name`,
 1 AS `awards_amt`,
 1 AS `num_awards`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_by_solicitation_type`
--

DROP TABLE IF EXISTS `v_by_solicitation_type`;
/*!50001 DROP VIEW IF EXISTS `v_by_solicitation_type`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_by_solicitation_type` AS SELECT 
 1 AS `solicitation_type`,
 1 AS `awards_amt`,
 1 AS `num_awards`,
 1 AS `pct`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_duplicate_firms`
--

DROP TABLE IF EXISTS `v_duplicate_firms`;
/*!50001 DROP VIEW IF EXISTS `v_duplicate_firms`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_duplicate_firms` AS SELECT 
 1 AS `dedup_cluster_id`,
 1 AS `firm_id`,
 1 AS `firm_name`,
 1 AS `alternate_name`,
 1 AS `global_vendor_id`,
 1 AS `sap_vendor_number`,
 1 AS `primary_contact_name`,
 1 AS `primary_contact_email`,
 1 AS `address1`,
 1 AS `city`,
 1 AS `state`,
 1 AS `zip`,
 1 AS `dedup_canonical`,
 1 AS `dedup_reviewed`,
 1 AS `dedup_notes`,
 1 AS `num_awards`,
 1 AS `total_awarded`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_firm_profile`
--

DROP TABLE IF EXISTS `v_firm_profile`;
/*!50001 DROP VIEW IF EXISTS `v_firm_profile`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_firm_profile` AS SELECT 
 1 AS `firm_id`,
 1 AS `firm_name`,
 1 AS `global_vendor_id`,
 1 AS `sap_vendor_number`,
 1 AS `is_sbe`,
 1 AS `is_wbe`,
 1 AS `is_dbe`,
 1 AS `is_mbe`,
 1 AS `is_mwbe`,
 1 AS `is_sdvob`,
 1 AS `primary_contact_name`,
 1 AS `primary_contact_email`,
 1 AS `address1`,
 1 AS `city`,
 1 AS `state`,
 1 AS `zip`,
 1 AS `dedup_cluster_id`,
 1 AS `dedup_canonical`,
 1 AS `total_awards`,
 1 AS `programs_on`,
 1 AS `total_awarded`,
 1 AS `total_spent`,
 1 AS `last_award_date`,
 1 AS `performance_letters`,
 1 AS `times_as_sub`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_kpi_totals`
--

DROP TABLE IF EXISTS `v_kpi_totals`;
/*!50001 DROP VIEW IF EXISTS `v_kpi_totals`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_kpi_totals` AS SELECT 
 1 AS `total_awards`,
 1 AS `total_award_amt`,
 1 AS `task_order_amt`,
 1 AS `task_order_count`,
 1 AS `small_contracts_amt`,
 1 AS `small_contracts_count`,
 1 AS `sbe_amt`,
 1 AS `sbe_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_mbe_summary`
--

DROP TABLE IF EXISTS `v_mbe_summary`;
/*!50001 DROP VIEW IF EXISTS `v_mbe_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_mbe_summary` AS SELECT 
 1 AS `prime_firm`,
 1 AS `mbe_firm`,
 1 AS `mbe_category`,
 1 AS `rfp_number`,
 1 AS `program_title`,
 1 AS `committed_amount`,
 1 AS `paid_amount`,
 1 AS `actual_amount`,
 1 AS `committed_pct`,
 1 AS `paid_pct`,
 1 AS `reporting_period`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_program_financials`
--

DROP TABLE IF EXISTS `v_program_financials`;
/*!50001 DROP VIEW IF EXISTS `v_program_financials`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_program_financials` AS SELECT 
 1 AS `rfp_number`,
 1 AS `program_title`,
 1 AS `division_code`,
 1 AS `authorized_amount`,
 1 AS `total_awarded`,
 1 AS `total_spent`,
 1 AS `remaining_authorized`,
 1 AS `pct_awarded`,
 1 AS `pct_spent`,
 1 AS `num_awards`,
 1 AS `valid_from`,
 1 AS `valid_to`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_quarterly_trend`
--

DROP TABLE IF EXISTS `v_quarterly_trend`;
/*!50001 DROP VIEW IF EXISTS `v_quarterly_trend`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_quarterly_trend` AS SELECT 
 1 AS `fiscal_year`,
 1 AS `fiscal_quarter`,
 1 AS `fiscal_period`,
 1 AS `total_amt`,
 1 AS `num_awards`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_stuck_workflows`
--

DROP TABLE IF EXISTS `v_stuck_workflows`;
/*!50001 DROP VIEW IF EXISTS `v_stuck_workflows`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_stuck_workflows` AS SELECT 
 1 AS `workflow_id`,
 1 AS `workflow_type`,
 1 AS `workflow_ref`,
 1 AS `current_stage`,
 1 AS `rfp_number`,
 1 AS `program_title`,
 1 AS `assigned_to`,
 1 AS `created_date`,
 1 AS `due_date`,
 1 AS `days_overdue`,
 1 AS `stuck_reason`,
 1 AS `sent_to_procurement`,
 1 AS `procurement_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_sub_award_summary`
--

DROP TABLE IF EXISTS `v_sub_award_summary`;
/*!50001 DROP VIEW IF EXISTS `v_sub_award_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_sub_award_summary` AS SELECT 
 1 AS `award_id`,
 1 AS `po_number`,
 1 AS `prime_firm`,
 1 AS `sub_firm`,
 1 AS `is_mbe`,
 1 AS `is_wbe`,
 1 AS `is_sbe`,
 1 AS `committed_amount`,
 1 AS `paid_amount`,
 1 AS `pct_of_prime_award`,
 1 AS `description`,
 1 AS `rfp_number`,
 1 AS `program_title`,
 1 AS `division_code`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_top_firms`
--

DROP TABLE IF EXISTS `v_top_firms`;
/*!50001 DROP VIEW IF EXISTS `v_top_firms`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_top_firms` AS SELECT 
 1 AS `awarded_firm`,
 1 AS `awards_amt`,
 1 AS `num_awards`,
 1 AS `solicitation_types`,
 1 AS `divisions`,
 1 AS `awards_amt_pct`,
 1 AS `awards_count_pct`,
 1 AS `first_award_date`,
 1 AS `last_award_date`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `workflow_history`
--

DROP TABLE IF EXISTS `workflow_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflow_history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `workflow_id` int NOT NULL,
  `from_state_id` int DEFAULT NULL,
  `to_state_id` int NOT NULL,
  `changed_by` varchar(150) DEFAULT NULL,
  `changed_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `comment` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`history_id`),
  KEY `workflow_id` (`workflow_id`),
  KEY `from_state_id` (`from_state_id`),
  KEY `to_state_id` (`to_state_id`),
  CONSTRAINT `workflow_history_ibfk_1` FOREIGN KEY (`workflow_id`) REFERENCES `workflows` (`workflow_id`),
  CONSTRAINT `workflow_history_ibfk_2` FOREIGN KEY (`from_state_id`) REFERENCES `workflow_states` (`state_id`),
  CONSTRAINT `workflow_history_ibfk_3` FOREIGN KEY (`to_state_id`) REFERENCES `workflow_states` (`state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_history`
--

LOCK TABLES `workflow_history` WRITE;
/*!40000 ALTER TABLE `workflow_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `workflow_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflow_states`
--

DROP TABLE IF EXISTS `workflow_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflow_states` (
  `state_id` int NOT NULL AUTO_INCREMENT,
  `state_code` varchar(40) NOT NULL,
  `state_label` varchar(100) NOT NULL,
  `state_order` int DEFAULT NULL,
  `is_terminal` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`state_id`),
  UNIQUE KEY `state_code` (`state_code`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflow_states`
--

LOCK TABLES `workflow_states` WRITE;
/*!40000 ALTER TABLE `workflow_states` DISABLE KEYS */;
INSERT INTO `workflow_states` VALUES (1,'draft','Draft',1,0),(2,'under_review','Under Internal Review',2,0),(3,'legal_review','Legal Review',3,0),(4,'pending_approval','Pending Approval',4,0),(5,'sent_procurement','Sent to Procurement',5,0),(6,'in_procurement','In Procurement',6,0),(7,'board_auth','Board Authorization',7,0),(8,'approved','Approved',8,1),(9,'rejected','Rejected',9,1),(10,'on_hold','On Hold',0,0);
/*!40000 ALTER TABLE `workflow_states` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workflows`
--

DROP TABLE IF EXISTS `workflows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workflows` (
  `workflow_id` int NOT NULL AUTO_INCREMENT,
  `program_id` int DEFAULT NULL,
  `award_id` int DEFAULT NULL,
  `workflow_type` enum('RFP','Task Order','Change Order','Board Authorization','Procurement') NOT NULL,
  `workflow_ref` varchar(100) DEFAULT NULL,
  `current_state_id` int NOT NULL,
  `assigned_to` varchar(150) DEFAULT NULL,
  `created_by` varchar(150) DEFAULT NULL,
  `created_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `completed_date` date DEFAULT NULL,
  `is_stuck` tinyint(1) DEFAULT '0',
  `stuck_reason` varchar(400) DEFAULT NULL,
  `sent_to_procurement` tinyint(1) DEFAULT '0',
  `procurement_date` date DEFAULT NULL,
  `notes` text,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`workflow_id`),
  KEY `program_id` (`program_id`),
  KEY `award_id` (`award_id`),
  KEY `current_state_id` (`current_state_id`),
  CONSTRAINT `workflows_ibfk_1` FOREIGN KEY (`program_id`) REFERENCES `programs` (`program_id`),
  CONSTRAINT `workflows_ibfk_2` FOREIGN KEY (`award_id`) REFERENCES `awards` (`award_id`),
  CONSTRAINT `workflows_ibfk_3` FOREIGN KEY (`current_state_id`) REFERENCES `workflow_states` (`state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workflows`
--

LOCK TABLES `workflows` WRITE;
/*!40000 ALTER TABLE `workflows` DISABLE KEYS */;
INSERT INTO `workflows` VALUES (7,2,NULL,'RFP','WF-RFP-2025-001',8,'John Doe','Eric Marsh','2024-10-01','2024-12-01',NULL,0,NULL,1,'2024-11-20',NULL,'2026-05-23 07:41:12'),(8,5,NULL,'RFP','WF-RFP-2024-005',8,'Level Larry','Samantha Cruz','2024-05-01','2024-08-01',NULL,0,NULL,1,'2024-06-15',NULL,'2026-05-23 07:41:12'),(9,3,NULL,'RFP','WF-RFP-2023-003',8,'Samantha Scott','Josh Hart','2023-08-01','2023-11-01',NULL,0,NULL,1,'2023-09-15',NULL,'2026-05-23 07:41:12'),(10,11,NULL,'RFP','WF-RFP-2022-011',8,'Mark Torres','David Park','2022-02-01','2022-05-01',NULL,0,NULL,1,'2022-03-01',NULL,'2026-05-23 07:41:12'),(11,9,18,'Task Order','WF-TO-2025-018',4,'Paul Catherall','Dave Whitman','2025-03-01','2025-03-20',NULL,1,'Pending signature from Division Head. No response for 12 business days.',0,NULL,NULL,'2026-05-23 07:41:12'),(12,11,50,'Task Order','WF-TO-2025-050',3,'Sarah Klein','Mark Torres','2025-02-15','2025-03-15',NULL,1,'Legal review stalled â€” contract language dispute on liability clause.',0,NULL,NULL,'2026-05-23 07:41:12'),(13,12,43,'Task Order','WF-TO-2023-043',8,'Tom Willis','Anne Fisher','2023-01-01','2023-02-01',NULL,0,NULL,1,'2023-01-28',NULL,'2026-05-23 07:41:12'),(14,5,29,'Task Order','WF-TO-2024-029',5,'Level Larry','Samantha Cruz','2024-09-15','2024-10-15',NULL,0,NULL,1,'2024-10-01',NULL,'2026-05-23 07:41:12'),(15,3,NULL,'Board Authorization','WF-BA-2023-003',7,'Samantha Scott','Josh Hart','2023-11-01','2023-12-15',NULL,0,NULL,0,NULL,NULL,'2026-05-23 07:41:12'),(16,11,NULL,'Board Authorization','WF-BA-2022-011',8,'Mark Torres','David Park','2022-05-01','2022-06-01',NULL,0,NULL,1,'2022-05-20',NULL,'2026-05-23 07:41:12'),(17,9,20,'Change Order','WF-CO-2025-020',2,'Paul Catherall','Paul Catherall','2025-04-01','2025-04-30',NULL,0,NULL,0,NULL,NULL,'2026-05-23 07:41:12');
/*!40000 ALTER TABLE `workflows` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_awards_detail`
--

/*!50001 DROP VIEW IF EXISTS `v_awards_detail`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_awards_detail` AS select `a`.`award_id` AS `award_id`,`a`.`award_date` AS `award_date`,`a`.`fiscal_year` AS `fiscal_year`,`a`.`fiscal_quarter` AS `fiscal_quarter`,concat('Q',`a`.`fiscal_quarter`,' FY',`a`.`fiscal_year`) AS `fiscal_period`,`a`.`award_amount` AS `award_amount`,`a`.`award_type` AS `award_type`,`a`.`agreement_number` AS `agreement_number`,`a`.`po_number` AS `po_number`,`a`.`assignment` AS `assignment`,`f`.`firm_name` AS `awarded_firm`,`f`.`is_sbe` AS `is_sbe`,`f`.`is_wbe` AS `is_wbe`,`f`.`is_dbe` AS `is_dbe`,`f`.`is_mbe` AS `is_mbe`,`f`.`is_mwbe` AS `is_mwbe`,`f`.`is_sdvob` AS `is_sdvob`,`st`.`type_label` AS `solicitation_type`,`d`.`division_code` AS `division_code`,`d`.`division_name` AS `division_name`,`s`.`site_code` AS `site_code`,`s`.`site_name` AS `site_name`,`p`.`program_title` AS `program_title`,`p`.`rfp_number` AS `solicitation_number`,`p`.`solicitation_date` AS `solicitation_date`,`p`.`authorized_amount` AS `program_authorized_amt`,`p`.`ice_estimate` AS `ice_estimate` from (((((`awards` `a` join `firms` `f` on((`f`.`firm_id` = `a`.`firm_id`))) join `solicitation_types` `st` on((`st`.`type_id` = `a`.`solicitation_type_id`))) join `divisions` `d` on((`d`.`division_id` = `a`.`division_id`))) join `programs` `p` on((`p`.`program_id` = `a`.`program_id`))) left join `sites` `s` on((`s`.`site_id` = `a`.`site_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_by_division`
--

/*!50001 DROP VIEW IF EXISTS `v_by_division`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_by_division` AS select `v_awards_detail`.`division_code` AS `division_code`,`v_awards_detail`.`division_name` AS `division_name`,sum(`v_awards_detail`.`award_amount`) AS `awards_amt`,count(0) AS `num_awards`,round(((sum(`v_awards_detail`.`award_amount`) / (select sum(`v_awards_detail`.`award_amount`) from `v_awards_detail`)) * 100),2) AS `pct` from `v_awards_detail` group by `v_awards_detail`.`division_code`,`v_awards_detail`.`division_name` order by `awards_amt` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_by_site`
--

/*!50001 DROP VIEW IF EXISTS `v_by_site`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_by_site` AS select `v_awards_detail`.`site_code` AS `site_code`,`v_awards_detail`.`site_name` AS `site_name`,sum(`v_awards_detail`.`award_amount`) AS `awards_amt`,count(0) AS `num_awards` from `v_awards_detail` where (`v_awards_detail`.`site_code` is not null) group by `v_awards_detail`.`site_code`,`v_awards_detail`.`site_name` order by `awards_amt` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_by_solicitation_type`
--

/*!50001 DROP VIEW IF EXISTS `v_by_solicitation_type`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_by_solicitation_type` AS select `v_awards_detail`.`solicitation_type` AS `solicitation_type`,sum(`v_awards_detail`.`award_amount`) AS `awards_amt`,count(0) AS `num_awards`,round(((sum(`v_awards_detail`.`award_amount`) / (select sum(`v_awards_detail`.`award_amount`) from `v_awards_detail`)) * 100),2) AS `pct` from `v_awards_detail` group by `v_awards_detail`.`solicitation_type` order by `awards_amt` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_duplicate_firms`
--

/*!50001 DROP VIEW IF EXISTS `v_duplicate_firms`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_duplicate_firms` AS select `f`.`dedup_cluster_id` AS `dedup_cluster_id`,`f`.`firm_id` AS `firm_id`,`f`.`firm_name` AS `firm_name`,`f`.`alternate_name` AS `alternate_name`,`f`.`global_vendor_id` AS `global_vendor_id`,`f`.`sap_vendor_number` AS `sap_vendor_number`,`f`.`primary_contact_name` AS `primary_contact_name`,`f`.`primary_contact_email` AS `primary_contact_email`,`f`.`address1` AS `address1`,`f`.`city` AS `city`,`f`.`state` AS `state`,`f`.`zip` AS `zip`,`f`.`dedup_canonical` AS `dedup_canonical`,`f`.`dedup_reviewed` AS `dedup_reviewed`,`f`.`dedup_notes` AS `dedup_notes`,count(`a`.`award_id`) AS `num_awards`,sum(`a`.`award_amount`) AS `total_awarded` from (`firms` `f` left join `awards` `a` on((`a`.`firm_id` = `f`.`firm_id`))) where (`f`.`dedup_cluster_id` is not null) group by `f`.`firm_id` order by `f`.`dedup_cluster_id`,`f`.`dedup_canonical` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_firm_profile`
--

/*!50001 DROP VIEW IF EXISTS `v_firm_profile`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_firm_profile` AS select `f`.`firm_id` AS `firm_id`,`f`.`firm_name` AS `firm_name`,`f`.`global_vendor_id` AS `global_vendor_id`,`f`.`sap_vendor_number` AS `sap_vendor_number`,`f`.`is_sbe` AS `is_sbe`,`f`.`is_wbe` AS `is_wbe`,`f`.`is_dbe` AS `is_dbe`,`f`.`is_mbe` AS `is_mbe`,`f`.`is_mwbe` AS `is_mwbe`,`f`.`is_sdvob` AS `is_sdvob`,`f`.`primary_contact_name` AS `primary_contact_name`,`f`.`primary_contact_email` AS `primary_contact_email`,`f`.`address1` AS `address1`,`f`.`city` AS `city`,`f`.`state` AS `state`,`f`.`zip` AS `zip`,`f`.`dedup_cluster_id` AS `dedup_cluster_id`,`f`.`dedup_canonical` AS `dedup_canonical`,coalesce(`aw`.`total_awards`,0) AS `total_awards`,coalesce(`aw`.`programs_on`,0) AS `programs_on`,coalesce(`aw`.`total_awarded`,0) AS `total_awarded`,coalesce(`sp`.`total_spent`,0) AS `total_spent`,`aw`.`last_award_date` AS `last_award_date`,coalesce(`pl`.`letter_count`,0) AS `performance_letters`,coalesce(`sa`.`sub_count`,0) AS `times_as_sub` from ((((`firms` `f` left join (select `awards`.`firm_id` AS `firm_id`,count(`awards`.`award_id`) AS `total_awards`,count(distinct `awards`.`program_id`) AS `programs_on`,sum(`awards`.`award_amount`) AS `total_awarded`,max(`awards`.`award_date`) AS `last_award_date` from `awards` group by `awards`.`firm_id`) `aw` on((`aw`.`firm_id` = `f`.`firm_id`))) left join (select `spend_tracking`.`vendor_firm_id` AS `vendor_firm_id`,sum(`spend_tracking`.`amount`) AS `total_spent` from `spend_tracking` group by `spend_tracking`.`vendor_firm_id`) `sp` on((`sp`.`vendor_firm_id` = `f`.`firm_id`))) left join (select `performance_letters`.`firm_id` AS `firm_id`,count(0) AS `letter_count` from `performance_letters` where (`performance_letters`.`is_active` = 1) group by `performance_letters`.`firm_id`) `pl` on((`pl`.`firm_id` = `f`.`firm_id`))) left join (select `sub_awards`.`sub_firm_id` AS `sub_firm_id`,count(0) AS `sub_count` from `sub_awards` group by `sub_awards`.`sub_firm_id`) `sa` on((`sa`.`sub_firm_id` = `f`.`firm_id`))) where (`f`.`dedup_canonical` = 1) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_kpi_totals`
--

/*!50001 DROP VIEW IF EXISTS `v_kpi_totals`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_kpi_totals` AS select count(0) AS `total_awards`,sum(`v_awards_detail`.`award_amount`) AS `total_award_amt`,sum((case when (`v_awards_detail`.`solicitation_type` = 'Task Order') then `v_awards_detail`.`award_amount` end)) AS `task_order_amt`,sum((case when (`v_awards_detail`.`solicitation_type` = 'Task Order') then 1 end)) AS `task_order_count`,sum((case when (`v_awards_detail`.`solicitation_type` = 'Small Contracts') then `v_awards_detail`.`award_amount` end)) AS `small_contracts_amt`,sum((case when (`v_awards_detail`.`solicitation_type` = 'Small Contracts') then 1 end)) AS `small_contracts_count`,sum((case when (`v_awards_detail`.`solicitation_type` = 'SBE Set-Aside') then `v_awards_detail`.`award_amount` end)) AS `sbe_amt`,sum((case when (`v_awards_detail`.`solicitation_type` = 'SBE Set-Aside') then 1 end)) AS `sbe_count` from `v_awards_detail` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_mbe_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_mbe_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_mbe_summary` AS select `fp`.`firm_name` AS `prime_firm`,`fs`.`firm_name` AS `mbe_firm`,`mt`.`mbe_category` AS `mbe_category`,`p`.`rfp_number` AS `rfp_number`,`p`.`program_title` AS `program_title`,`mt`.`committed_amount` AS `committed_amount`,`mt`.`paid_amount` AS `paid_amount`,`mt`.`actual_amount` AS `actual_amount`,`mt`.`committed_pct` AS `committed_pct`,`mt`.`paid_pct` AS `paid_pct`,`mt`.`reporting_period` AS `reporting_period` from ((((`mbe_tracking` `mt` join `firms` `fp` on((`fp`.`firm_id` = `mt`.`prime_firm_id`))) join `firms` `fs` on((`fs`.`firm_id` = `mt`.`firm_id`))) join `awards` `a` on((`a`.`award_id` = `mt`.`award_id`))) join `programs` `p` on((`p`.`program_id` = `a`.`program_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_program_financials`
--

/*!50001 DROP VIEW IF EXISTS `v_program_financials`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_program_financials` AS select `p`.`rfp_number` AS `rfp_number`,`p`.`program_title` AS `program_title`,`d`.`division_code` AS `division_code`,`p`.`authorized_amount` AS `authorized_amount`,coalesce(`aw`.`total_awarded`,0) AS `total_awarded`,coalesce(`sp`.`total_spent`,0) AS `total_spent`,(`p`.`authorized_amount` - coalesce(`aw`.`total_awarded`,0)) AS `remaining_authorized`,round(((coalesce(`aw`.`total_awarded`,0) / nullif(`p`.`authorized_amount`,0)) * 100),2) AS `pct_awarded`,round(((coalesce(`sp`.`total_spent`,0) / nullif(`p`.`authorized_amount`,0)) * 100),2) AS `pct_spent`,coalesce(`aw`.`num_awards`,0) AS `num_awards`,`p`.`valid_from` AS `valid_from`,`p`.`valid_to` AS `valid_to`,`p`.`status` AS `status` from (((`programs` `p` join `divisions` `d` on((`d`.`division_id` = `p`.`division_id`))) left join (select `awards`.`program_id` AS `program_id`,sum(`awards`.`award_amount`) AS `total_awarded`,count(0) AS `num_awards` from `awards` group by `awards`.`program_id`) `aw` on((`aw`.`program_id` = `p`.`program_id`))) left join (select `spend_tracking`.`program_id` AS `program_id`,sum(`spend_tracking`.`amount`) AS `total_spent` from `spend_tracking` group by `spend_tracking`.`program_id`) `sp` on((`sp`.`program_id` = `p`.`program_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_quarterly_trend`
--

/*!50001 DROP VIEW IF EXISTS `v_quarterly_trend`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_quarterly_trend` AS select `v_awards_detail`.`fiscal_year` AS `fiscal_year`,`v_awards_detail`.`fiscal_quarter` AS `fiscal_quarter`,`v_awards_detail`.`fiscal_period` AS `fiscal_period`,sum(`v_awards_detail`.`award_amount`) AS `total_amt`,count(0) AS `num_awards` from `v_awards_detail` group by `v_awards_detail`.`fiscal_year`,`v_awards_detail`.`fiscal_quarter`,`v_awards_detail`.`fiscal_period` order by `v_awards_detail`.`fiscal_year`,`v_awards_detail`.`fiscal_quarter` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_stuck_workflows`
--

/*!50001 DROP VIEW IF EXISTS `v_stuck_workflows`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_stuck_workflows` AS select `w`.`workflow_id` AS `workflow_id`,`w`.`workflow_type` AS `workflow_type`,`w`.`workflow_ref` AS `workflow_ref`,`ws`.`state_label` AS `current_stage`,`p`.`rfp_number` AS `rfp_number`,`p`.`program_title` AS `program_title`,`w`.`assigned_to` AS `assigned_to`,`w`.`created_date` AS `created_date`,`w`.`due_date` AS `due_date`,(to_days(curdate()) - to_days(`w`.`due_date`)) AS `days_overdue`,`w`.`stuck_reason` AS `stuck_reason`,`w`.`sent_to_procurement` AS `sent_to_procurement`,`w`.`procurement_date` AS `procurement_date` from ((`workflows` `w` join `workflow_states` `ws` on((`ws`.`state_id` = `w`.`current_state_id`))) left join `programs` `p` on((`p`.`program_id` = `w`.`program_id`))) where ((`w`.`is_stuck` = 1) or ((`w`.`due_date` < curdate()) and (`ws`.`is_terminal` = 0))) order by (to_days(curdate()) - to_days(`w`.`due_date`)) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_sub_award_summary`
--

/*!50001 DROP VIEW IF EXISTS `v_sub_award_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_sub_award_summary` AS select `a`.`award_id` AS `award_id`,`a`.`po_number` AS `po_number`,`fp`.`firm_name` AS `prime_firm`,`fs`.`firm_name` AS `sub_firm`,`fs`.`is_mbe` AS `is_mbe`,`fs`.`is_wbe` AS `is_wbe`,`fs`.`is_sbe` AS `is_sbe`,`sa`.`committed_amount` AS `committed_amount`,`sa`.`paid_amount` AS `paid_amount`,round(((`sa`.`paid_amount` / nullif(`a`.`award_amount`,0)) * 100),2) AS `pct_of_prime_award`,`sa`.`description` AS `description`,`p`.`rfp_number` AS `rfp_number`,`p`.`program_title` AS `program_title`,`d`.`division_code` AS `division_code` from (((((`sub_awards` `sa` join `awards` `a` on((`a`.`award_id` = `sa`.`award_id`))) join `firms` `fp` on((`fp`.`firm_id` = `a`.`firm_id`))) join `firms` `fs` on((`fs`.`firm_id` = `sa`.`sub_firm_id`))) join `programs` `p` on((`p`.`program_id` = `a`.`program_id`))) join `divisions` `d` on((`d`.`division_id` = `a`.`division_id`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_top_firms`
--

/*!50001 DROP VIEW IF EXISTS `v_top_firms`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = latin1 */;
/*!50001 SET character_set_results     = latin1 */;
/*!50001 SET collation_connection      = latin1_swedish_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_firms` AS select `v_awards_detail`.`awarded_firm` AS `awarded_firm`,sum(`v_awards_detail`.`award_amount`) AS `awards_amt`,count(0) AS `num_awards`,group_concat(distinct `v_awards_detail`.`solicitation_type` order by `v_awards_detail`.`solicitation_type` ASC separator ', ') AS `solicitation_types`,group_concat(distinct `v_awards_detail`.`division_code` order by `v_awards_detail`.`division_code` ASC separator ', ') AS `divisions`,round(((sum(`v_awards_detail`.`award_amount`) / (select sum(`v_awards_detail`.`award_amount`) from `v_awards_detail`)) * 100),2) AS `awards_amt_pct`,round(((count(0) / (select count(0) from `v_awards_detail`)) * 100),2) AS `awards_count_pct`,min(`v_awards_detail`.`award_date`) AS `first_award_date`,max(`v_awards_detail`.`award_date`) AS `last_award_date` from `v_awards_detail` group by `v_awards_detail`.`awarded_firm` order by `awards_amt` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-23  7:43:43
