CREATE DATABASE  IF NOT EXISTS `mykoopmysql` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `mykoopmysql`;
-- MySQL dump 10.13  Distrib 5.6.17, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: mykoopmysql
-- ------------------------------------------------------
-- Server version	5.6.19-log

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
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bill` (
  `idbill` int(32) NOT NULL AUTO_INCREMENT,
  `createdDate` datetime NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `idUser` int(11) DEFAULT NULL,
  `closedDate` datetime DEFAULT NULL,
  PRIMARY KEY (`idbill`),
  UNIQUE KEY `idbill_UNIQUE` (`idbill`),
  KEY `bill_idUser_idx` (`idUser`),
  CONSTRAINT `bill_idUser` FOREIGN KEY (`idUser`) REFERENCES `user` (`id`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bill_discount`
--

DROP TABLE IF EXISTS `bill_discount`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bill_discount` (
  `idbill` int(11) NOT NULL,
  `type` enum('percentage','fixed') NOT NULL,
  `amount` decimal(12,2) NOT NULL,
  `isAfterTax` bit(1) NOT NULL,
  KEY `billDiscount_idBill_idx` (`idbill`),
  CONSTRAINT `billDiscount_idBill` FOREIGN KEY (`idbill`) REFERENCES `bill` (`idbill`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bill_item`
--

DROP TABLE IF EXISTS `bill_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bill_item` (
  `idBillItem` int(11) NOT NULL AUTO_INCREMENT,
  `idBill` int(11) NOT NULL,
  `idItem` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(12,2) NOT NULL,
  PRIMARY KEY (`idBillItem`),
  KEY `billItem_idBill_idx` (`idBill`),
  KEY `billItem_idItem_idx` (`idItem`),
  CONSTRAINT `billItem_idbill` FOREIGN KEY (`idBill`) REFERENCES `bill` (`idbill`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `billItem_idItem` FOREIGN KEY (`idItem`) REFERENCES `item` (`idItem`) ON DELETE SET NULL ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bill_transaction`
--

DROP TABLE IF EXISTS `bill_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bill_transaction` (
  `idbill` int(11) NOT NULL,
  `idTransaction` int(11) NOT NULL,
  UNIQUE KEY `idTransaction_UNIQUE` (`idTransaction`),
  KEY `billTransaction_idBill_idx` (`idbill`),
  KEY `billTransaction_idTransaction_idx` (`idTransaction`),
  CONSTRAINT `billTransaction_idBill` FOREIGN KEY (`idbill`) REFERENCES `bill` (`idbill`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `billTransaction_idTransaction` FOREIGN KEY (`idTransaction`) REFERENCES `transaction` (`idTransaction`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event` (
  `idEvent` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('cashier','workshop') NOT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime DEFAULT NULL,
  `startAmount` decimal(10,2) DEFAULT NULL,
  `endAmount` decimal(10,2) DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`idEvent`),
  UNIQUE KEY `idEvent_UNIQUE` (`idEvent`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_transaction`
--

DROP TABLE IF EXISTS `event_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_transaction` (
  `idEvent` int(11) NOT NULL,
  `idTransaction` int(11) NOT NULL,
  PRIMARY KEY (`idEvent`,`idTransaction`),
  KEY `idTransaction_idx` (`idTransaction`),
  CONSTRAINT `eventTransaction_idEvent` FOREIGN KEY (`idEvent`) REFERENCES `event` (`idEvent`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `eventTransaction_idTransaction` FOREIGN KEY (`idTransaction`) REFERENCES `transaction` (`idTransaction`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_user`
--

DROP TABLE IF EXISTS `event_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_user` (
  `idEvent` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  `registered` tinyint(1) NOT NULL,
  PRIMARY KEY (`idEvent`,`idUser`),
  KEY `idUser_idx` (`idUser`),
  CONSTRAINT `eventUser_idEvent` FOREIGN KEY (`idEvent`) REFERENCES `event` (`idEvent`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `eventUser_idUser` FOREIGN KEY (`idUser`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `item` (
  `idItem` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(45) DEFAULT NULL,
  `name` varchar(45) DEFAULT NULL,
  `price` decimal(12,2) DEFAULT 0,
  `quantity` int(11) DEFAULT 0,
  `threshold` int(11) DEFAULT 0,
  PRIMARY KEY (`idItem`),
  UNIQUE KEY `idItem_UNIQUE` (`idItem`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary table structure for view `item_list`
--

DROP TABLE IF EXISTS `item_list`;
/*!50001 DROP VIEW IF EXISTS `item_list`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `item_list` (
  `id` tinyint NOT NULL,
  `name` tinyint NOT NULL,
  `price` tinyint NOT NULL,
  `threshold` tinyint NOT NULL,
  `quantityStock` tinyint NOT NULL,
  `quantityReserved` tinyint NOT NULL,
  `quantityAvailable` tinyint NOT NULL,
  `code` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `mailinglist`
--

DROP TABLE IF EXISTS `mailinglist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailinglist` (
  `idMailingList` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `description` tinytext,
  PRIMARY KEY (`idMailingList`),
  UNIQUE KEY `idMailingLists_UNIQUE` (`idMailingList`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mailinglist_users`
--

DROP TABLE IF EXISTS `mailinglist_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mailinglist_users` (
  `idMailingList` int(11) NOT NULL,
  `idUser` int(11) NOT NULL,
  PRIMARY KEY (`idMailingList`,`idUser`),
  KEY `User_idx` (`idUser`),
  CONSTRAINT `mailingListUser_idMailingList` FOREIGN KEY (`idMailingList`) REFERENCES `mailinglist` (`idMailingList`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `mailingListUser_idUser` FOREIGN KEY (`idUser`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `member` (
  `id` int(11) NOT NULL,
  `subscriptionExpirationDate` date DEFAULT NULL,
  `feeTransactionId` int(11) DEFAULT NULL,
  `subscriptionTransactionId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `member_feeTransactionId_idx` (`feeTransactionId`),
  KEY `member_subscriptionTransactionId_idx` (`subscriptionTransactionId`),
  CONSTRAINT `member_feeTransactionId` FOREIGN KEY (`feeTransactionId`) REFERENCES `bill` (`idbill`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `member_subscriptionTransactionId` FOREIGN KEY (`subscriptionTransactionId`) REFERENCES `bill` (`idbill`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `member_userID` FOREIGN KEY (`id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `option`
--

DROP TABLE IF EXISTS `option`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `option` (
  `idOption` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `value` varchar(45) NOT NULL,
  `type` varchar(45) NOT NULL,
  PRIMARY KEY (`idOption`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `privilege`
--

DROP TABLE IF EXISTS `privilege`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `privilege` (
  `idPrivilege` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  PRIMARY KEY (`idPrivilege`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `session_id` varchar(255) COLLATE utf8_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text COLLATE utf8_bin,
  PRIMARY KEY (`session_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taxes`
--

DROP TABLE IF EXISTS `taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taxes` (
  `idTaxes` int(11) NOT NULL AUTO_INCREMENT,
  `rate` decimal(10,5) DEFAULT NULL,
  `localizeKey` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`idTaxes`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction` (
  `idTransaction` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(14,4) NOT NULL,
  `date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idTransaction`),
  UNIQUE KEY `idTransaction_UNIQUE` (`idTransaction`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(64) NOT NULL,
  `firstname` varchar(64) DEFAULT NULL,
  `lastname` varchar(64) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `phone` varchar(32) DEFAULT NULL,
  `salt` varchar(172) NOT NULL,
  `pwdhash` varchar(172) NOT NULL,
  `origin` varchar(64) DEFAULT NULL,
  `notes` varchar(512) DEFAULT NULL,
  `signupDate` date NOT NULL,
  `referral` varchar(64) DEFAULT NULL,
  `usageFrequency` varchar(64) DEFAULT NULL,
  `usageNote` varchar(128) DEFAULT NULL,
  `referralSpecify` varchar(128) DEFAULT NULL,
  `perms` text COMMENT 'User permissions.',
  PRIMARY KEY (`id`,`email`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_availability`
--

DROP TABLE IF EXISTS `user_availability`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_availability` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idUser` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `User_idx` (`idUser`),
  CONSTRAINT `userAvailability_UserId` FOREIGN KEY (`idUser`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_privileges`
--

DROP TABLE IF EXISTS `user_privileges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_privileges` (
  `idUsers` int(11) NOT NULL,
  `idPrivilege` int(11) NOT NULL,
  PRIMARY KEY (`idUsers`,`idPrivilege`),
  KEY `idUsers_idx` (`idUsers`),
  KEY `idPrivilege_idx` (`idPrivilege`),
  CONSTRAINT `userPrivileges_idPrivilege` FOREIGN KEY (`idPrivilege`) REFERENCES `privilege` (`idPrivilege`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `userPrivileges_idUser` FOREIGN KEY (`idUsers`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_transaction`
--

DROP TABLE IF EXISTS `user_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_transaction` (
  `idUser` int(11) NOT NULL,
  `idTransaction` int(11) NOT NULL,
  PRIMARY KEY (`idUser`,`idTransaction`),
  KEY `idTransaction_idx` (`idTransaction`),
  CONSTRAINT `userTransaction_idTransaction` FOREIGN KEY (`idTransaction`) REFERENCES `transaction` (`idTransaction`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `userTransaction_idUser` FOREIGN KEY (`idUser`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Final view structure for view `item_list`
--

/*!50001 DROP TABLE IF EXISTS `item_list`*/;
/*!50001 DROP VIEW IF EXISTS `item_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`b3f0e26d50e103`@`%` SQL SECURITY DEFINER */
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

-- Dump completed on 2014-11-22 15:44:49
