/*
Navicat MySQL Data Transfer

Source Server         : localsw
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : roleplay

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2023-05-12 02:50:04
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `accounts`
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `password` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `admin` int(11) NOT NULL DEFAULT 0,
  `serial` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `limit` int(11) NOT NULL DEFAULT 3,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of accounts
-- ----------------------------
INSERT INTO `accounts` VALUES ('1', 'test', 'test', '8', '9005638F97DC1640DD35331F4076AA12', '3');

-- ----------------------------
-- Table structure for `characters`
-- ----------------------------
DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL DEFAULT 0,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `pos` varchar(255) NOT NULL DEFAULT '0,0,5,0,0',
  `age` int(11) NOT NULL DEFAULT 18,
  `height` int(11) NOT NULL DEFAULT 175,
  `weight` int(11) NOT NULL DEFAULT 65,
  `gender` int(1) NOT NULL DEFAULT 1,
  `model` int(11) NOT NULL DEFAULT 170,
  `money` bigint(11) NOT NULL DEFAULT 1000,
  `hunger` int(11) NOT NULL DEFAULT 100,
  `thirst` int(11) NOT NULL DEFAULT 100,
  `dead` int(1) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 100,
  `armor` int(11) NOT NULL DEFAULT 0,
  `walk` int(11) NOT NULL DEFAULT 128,
  `job` int(11) NOT NULL DEFAULT 0,
  `active` int(1) NOT NULL DEFAULT 1,
  `injured` int(1) NOT NULL DEFAULT 0,
  `faction` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of characters
-- ----------------------------
INSERT INTO `characters` VALUES ('1', '1', 'test', '0,0,5,0,0', '21', '175', '70', '1', '59', '1000', '27', '25', '0', '100', '0', '128', '0', '1', '0', '1');

-- ----------------------------
-- Table structure for `factions`
-- ----------------------------
DROP TABLE IF EXISTS `factions`;
CREATE TABLE `factions` (
  `id` int(11) NOT NULL,
  `name` text DEFAULT NULL,
  `type` int(3) NOT NULL DEFAULT 2,
  `balance` bigint(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of factions
-- ----------------------------
INSERT INTO `factions` VALUES ('1', 'testfact', '2', '0');
INSERT INTO `factions` VALUES ('2', 'testfact2', '1', '0');

-- ----------------------------
-- Table structure for `factions_rank`
-- ----------------------------
DROP TABLE IF EXISTS `factions_rank`;
CREATE TABLE `factions_rank` (
  `id` int(11) NOT NULL,
  `faction_id` int(11) DEFAULT NULL,
  `name` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of factions_rank
-- ----------------------------
INSERT INTO `factions_rank` VALUES ('1', '1', 'testrank');
INSERT INTO `factions_rank` VALUES ('2', '1', 'testrank2');
INSERT INTO `factions_rank` VALUES ('3', '1', 'testrank3');
INSERT INTO `factions_rank` VALUES ('4', '1', 'testrank4');

-- ----------------------------
-- Table structure for `items`
-- ----------------------------
DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
  `id` bigint(11) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `owner` bigint(11) DEFAULT NULL,
  `item` int(11) DEFAULT NULL,
  `value` text DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of items
-- ----------------------------
INSERT INTO `items` VALUES ('1', '1', '1', '2', '1', '1');

-- ----------------------------
-- Table structure for `vehicles`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `library_id` int(11) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `odometer` int(11) DEFAULT NULL,
  `tax` int(11) NOT NULL DEFAULT 0,
  `job` int(11) DEFAULT NULL,
  `pos` varchar(255) NOT NULL DEFAULT '0,0,5,0,0,0,0,90',
  `plate` text DEFAULT NULL,
  `color` varchar(255) NOT NULL DEFAULT '0,0,0',
  `upgrades` text DEFAULT NULL,
  `lock` int(11) NOT NULL DEFAULT 1,
  `interest` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) DEFAULT NULL,
  `engine` int(11) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of vehicles
-- ----------------------------

-- ----------------------------
-- Table structure for `vehicles_custom`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_custom`;
CREATE TABLE `vehicles_custom` (
  `id` int(11) NOT NULL,
  `brand` text DEFAULT NULL,
  `model` text DEFAULT NULL,
  `year` int(11) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `handling` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `doortype` int(11) DEFAULT NULL,
  `fueltype` int(11) DEFAULT NULL,
  `tanksize` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of vehicles_custom
-- ----------------------------

-- ----------------------------
-- Table structure for `vehicles_library`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_library`;
CREATE TABLE `vehicles_library` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gta` int(11) DEFAULT NULL,
  `brand` text DEFAULT NULL,
  `model` text DEFAULT NULL,
  `year` text DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `enabled` int(11) DEFAULT NULL,
  `handling` varchar(1000) DEFAULT '',
  `stock` int(11) DEFAULT NULL,
  `tanksize` int(11) DEFAULT NULL,
  `donateprice` int(11) DEFAULT NULL,
  `doortype` int(11) DEFAULT NULL,
  `fueltype` int(11) DEFAULT NULL,
  `isdonate` int(11) DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedate` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- ----------------------------
-- Records of vehicles_library
-- ----------------------------
INSERT INTO `vehicles_library` VALUES ('1', '560', 'test', 'car', '2022', '25000', '12', '1', '', '100', '100', '0', '-1', '-1', '0', '1', '2023-05-10 00:52:38');
INSERT INTO `vehicles_library` VALUES ('2', '555', 'test2', 'test car', '2001', '10000', '31', '1', '', null, null, null, null, null, null, null, null);
INSERT INTO `vehicles_library` VALUES ('3', '554', 'araÃ§ markasÄ±', 'araÃ§ modeli', '2000', '155', '1111', '0', '', null, null, null, null, null, null, null, '2023-05-10 00:55:29');
INSERT INTO `vehicles_library` VALUES ('4', '553', 'test marka', 'test model', '2012', '15000000', '555', '0', '', '55', '80', '50', '0', '1', '1', '1', '2023-05-10 00:55:27');
INSERT INTO `vehicles_library` VALUES ('5', '552', 'test marka2', 'test model2', '2001', '654897', '1500', '1', '', '85', '100', '0', '-1', '0', '0', '1', '2023-05-10 00:51:43');
