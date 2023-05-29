/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : roleplay

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2023-05-29 15:36:56
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `accounts`
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `password` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `admin` int(11) NOT NULL DEFAULT '0',
  `serial` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `limit` int(11) NOT NULL DEFAULT '3',
  `lastlogin` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of accounts
-- ----------------------------
INSERT INTO `accounts` VALUES ('1', 'test', 'test', '8', '9005638F97DC1640DD35331F4076AA12', '3', '2023-05-29 14:28:48');

-- ----------------------------
-- Table structure for `characters`
-- ----------------------------
DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL DEFAULT '0',
  `name` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  `pos` varchar(255) NOT NULL DEFAULT '0,0,5,0,0',
  `age` int(11) NOT NULL DEFAULT '18',
  `height` int(11) NOT NULL DEFAULT '175',
  `weight` int(11) NOT NULL DEFAULT '65',
  `gender` int(1) NOT NULL DEFAULT '1',
  `model` int(11) NOT NULL DEFAULT '170',
  `money` bigint(11) NOT NULL DEFAULT '1000',
  `hunger` int(11) NOT NULL DEFAULT '100',
  `thirst` int(11) NOT NULL DEFAULT '100',
  `dead` int(1) NOT NULL DEFAULT '0',
  `health` int(11) NOT NULL DEFAULT '100',
  `armor` int(11) NOT NULL DEFAULT '0',
  `walk` int(11) NOT NULL DEFAULT '128',
  `job` int(11) NOT NULL DEFAULT '0',
  `active` int(1) NOT NULL DEFAULT '1',
  `injured` int(1) NOT NULL DEFAULT '0',
  `faction` int(11) NOT NULL DEFAULT '0',
  `faction_rank` int(11) NOT NULL DEFAULT '0',
  `faction_lead` int(11) NOT NULL DEFAULT '0',
  `lastlogin` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of characters
-- ----------------------------
INSERT INTO `characters` VALUES ('1', '1', 'test1', '0,0,5,0,0', '21', '175', '70', '2', '93', '1000', '95', '90', '0', '100', '0', '131', '0', '1', '0', '1', '1', '1', '2023-05-29 15:06:29');
INSERT INTO `characters` VALUES ('2', '1', 'test2', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '99', '97', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 15:24:24');
INSERT INTO `characters` VALUES ('3', '1', 'test3', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('4', '1', 'test4', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('5', '1', 'test5', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('6', '1', 'test6', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('7', '1', 'test7', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('8', '1', 'test8', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('9', '1', 'test9', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');
INSERT INTO `characters` VALUES ('10', '1', 'test10', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '1', '0', '2023-05-29 14:29:25');

-- ----------------------------
-- Table structure for `factions`
-- ----------------------------
DROP TABLE IF EXISTS `factions`;
CREATE TABLE `factions` (
  `id` int(11) NOT NULL,
  `name` text,
  `type` int(3) NOT NULL DEFAULT '2',
  `balance` bigint(11) NOT NULL DEFAULT '0',
  `note` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'Sayfa 1 *> Sayfa 2 *> Sayfa 3',
  `level` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of factions
-- ----------------------------
INSERT INTO `factions` VALUES ('1', 'test faction', '2', '0', 'Sayfa 1 *> Sayfa 2 *> Sayfa 3', '1');

-- ----------------------------
-- Table structure for `factions_rank`
-- ----------------------------
DROP TABLE IF EXISTS `factions_rank`;
CREATE TABLE `factions_rank` (
  `id` int(11) NOT NULL,
  `faction_id` int(11) DEFAULT NULL,
  `name` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of factions_rank
-- ----------------------------
INSERT INTO `factions_rank` VALUES ('0', '1', 'allah billah tillahaaaaaaaaaaaaaaaaaaa');
INSERT INTO `factions_rank` VALUES ('1', '1', 'testrank1');
INSERT INTO `factions_rank` VALUES ('3', '1', 'testrank3');

-- ----------------------------
-- Table structure for `items`
-- ----------------------------
DROP TABLE IF EXISTS `items`;
CREATE TABLE `items` (
  `id` bigint(11) NOT NULL,
  `type` int(11) DEFAULT NULL,
  `owner` bigint(11) DEFAULT NULL,
  `item` int(11) DEFAULT NULL,
  `value` text,
  `count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of items
-- ----------------------------

-- ----------------------------
-- Table structure for `vehicles`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `library_id` int(11) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT '100',
  `odometer` int(11) DEFAULT NULL,
  `tax` int(11) NOT NULL DEFAULT '0',
  `job` int(11) DEFAULT NULL,
  `pos` varchar(255) NOT NULL DEFAULT '0,0,5,0,0,0,0,90',
  `plate` text,
  `color` varchar(255) NOT NULL DEFAULT '0,0,0',
  `upgrades` text,
  `lock` int(11) NOT NULL DEFAULT '1',
  `interest` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) DEFAULT NULL,
  `faction` int(11) DEFAULT NULL,
  `engine` int(11) NOT NULL DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vehicles
-- ----------------------------
INSERT INTO `vehicles` VALUES ('1', '1', '100', '0', '0', '0', '4.9999999942551,0.35570843449802,3.1171875,0,0,0,0,0.00274658203125', 'PMJ-987', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('2', '1', '100', '0', '0', '0', '6.6486714232676,3.445235757417,3.1171875,0,0,0,0,337.79354858398', 'EWS-531', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('3', '1', '100', '0', '0', '0', '8.2463276732676,7.359298257417,3.1096496582031,0,0,0,0,337.79354858398', 'CJD-295', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('4', '1', '100', '0', '0', '0', '10.021718298268,11.708907632417,3.1171875,0,0,0,0,337.79354858398', 'DAA-456', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('5', '1', '100', '0', '0', '0', '11.411366735768,15.111251382417,3.1171875,0,0,0,0,337.79354858398', 'PPE-654', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('6', '1', '100', '0', '0', '0', '12.856679235768,18.652267007417,3.1171875,0,0,0,0,337.79354858398', 'BPU-853', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('7', '1', '100', '0', '0', '0', '13.531483923268,20.306563882417,3.1171875,0,0,0,0,337.79354858398', 'WSY-952', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('8', '1', '100', '0', '0', '0', '14.593007360768,22.904220132417,3.1171875,0,0,0,0,337.79354858398', 'MGW-288', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('9', '1', '100', '0', '0', '0', '15.450429235768,25.005782632417,3.1171875,0,0,0,0,337.79354858398', 'ZZP-433', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('10', '1', '100', '0', '0', '0', '16.462147985768,27.483321694917,3.1171875,0,0,0,0,337.79354858398', 'VAJ-171', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('11', '1', '100', '0', '0', '0', '17.124257360768,29.104415444917,3.1171875,0,0,0,0,337.79354858398', 'AXH-367', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('12', '1', '100', '0', '0', '0', '17.943593298268,31.112227944917,3.1171875,0,0,0,0,337.79354858398', 'VSM-275', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');

-- ----------------------------
-- Table structure for `vehicles_custom`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_custom`;
CREATE TABLE `vehicles_custom` (
  `id` int(11) NOT NULL,
  `brand` text,
  `model` text,
  `year` int(11) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `handling` text,
  `notes` text,
  `price` int(11) DEFAULT NULL,
  `doortype` int(11) DEFAULT NULL,
  `fueltype` int(11) DEFAULT NULL,
  `tanksize` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

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
  `brand` text,
  `model` text,
  `year` text,
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
  `updatedate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vehicles_library
-- ----------------------------
INSERT INTO `vehicles_library` VALUES ('1', '560', 'test', 'car', '2022', '25000', '12', '1', '', '100', '100', '0', '-1', '-1', '0', '1', '2023-05-10 00:52:38');
INSERT INTO `vehicles_library` VALUES ('2', '555', 'test2', 'test car', '2001', '10000', '31', '1', '', null, null, null, null, null, null, null, null);
INSERT INTO `vehicles_library` VALUES ('3', '554', 'araÃ§ markasÄ±', 'araÃ§ modeli', '2000', '155', '1111', '0', '', null, null, null, null, null, null, null, '2023-05-10 00:55:29');
INSERT INTO `vehicles_library` VALUES ('4', '553', 'test marka', 'test model', '2012', '15000000', '555', '0', '', '55', '80', '50', '0', '1', '1', '1', '2023-05-10 00:55:27');
INSERT INTO `vehicles_library` VALUES ('5', '552', 'test marka2', 'test model2', '2001', '654897', '1500', '1', '', '85', '100', '0', '-1', '0', '0', '1', '2023-05-10 00:51:43');
