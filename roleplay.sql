/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : roleplay

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2023-05-22 16:33:55
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
INSERT INTO `accounts` VALUES ('0', null, null, '0', null, '3', '2023-05-22 16:24:14');
INSERT INTO `accounts` VALUES ('1', 'test', 'test', '8', '9005638F97DC1640DD35331F4076AA12', '3', null);

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
  `lastlogin` text CHARACTER SET latin1 COLLATE latin1_swedish_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of characters
-- ----------------------------
INSERT INTO `characters` VALUES ('1', '1', 'test', '0,0,5,0,0', '21', '175', '70', '1', '59', '1000', '0', '0', '0', '100', '0', '128', '0', '1', '0', '1', '1', '2023-05-22 16:24:19');
INSERT INTO `characters` VALUES ('2', '1', 'test2', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '3', '2023-05-16 01:27:52');
INSERT INTO `characters` VALUES ('3', '1', 'test3', '0,0,5,0,0', '18', '175', '65', '1', '170', '1000', '100', '100', '0', '100', '0', '128', '0', '1', '0', '1', '2', '2023-05-16 03:35:21');

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
INSERT INTO `factions_rank` VALUES ('0', '1', 'testrank2');
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
INSERT INTO `items` VALUES ('1', '1', '1', '2', '1', '1');
INSERT INTO `items` VALUES ('2', '1', '1', '2', '1', '1');
INSERT INTO `items` VALUES ('3', '1', '1', '2', '2', '1');
INSERT INTO `items` VALUES ('4', '1', '1', '2', '3', '1');
INSERT INTO `items` VALUES ('5', '1', '1', '2', '4', '1');
INSERT INTO `items` VALUES ('6', '1', '1', '2', '5', '1');
INSERT INTO `items` VALUES ('7', '1', '1', '2', '6', '1');
INSERT INTO `items` VALUES ('8', '1', '1', '2', '7', '1');
INSERT INTO `items` VALUES ('9', '1', '1', '2', '8', '1');
INSERT INTO `items` VALUES ('10', '1', '1', '2', '9', '1');
INSERT INTO `items` VALUES ('11', '1', '1', '2', '10', '1');
INSERT INTO `items` VALUES ('12', '1', '1', '2', '11', '1');
INSERT INTO `items` VALUES ('13', '1', '1', '2', '12', '1');
INSERT INTO `items` VALUES ('14', '1', '1', '2', '13', '1');
INSERT INTO `items` VALUES ('15', '1', '1', '2', '14', '1');

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
INSERT INTO `vehicles` VALUES ('1', '1', '62', '0', '24', '0', '79.651986437866,50.956615373766,0.609375,0,0,0,0,210.67977905273', 'FVP-549', '0,0,0', 'false', '0', '0', '1', '1', '1', '1');
INSERT INTO `vehicles` VALUES ('2', '1', '100', '0', '24', '0', '-1.6499406141559,-6.5964251947967,3.1171875,0,0,0,0,238.84916687012', 'VTE-875', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('3', '1', '100', '0', '24', '0', '6.2341818108115,-3.8978860659947,3.1171875,0,0,0,0,328.85052490234', 'HAC-422', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('4', '1', '100', '0', '12', '0', '13.901718057823,-0.4312345664857,3.1096496582031,0,0,0,0,297.90707397461', 'ZLD-114', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('5', '1', '100', '0', '12', '0', '18.601913370323,2.7865388710143,3.1171875,0,0,0,0,297.90707397461', 'NOP-626', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('6', '1', '100', '0', '12', '0', '23.247421182823,5.2474763710143,3.1171875,0,0,0,0,297.90707397461', 'LJB-688', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('7', '1', '100', '0', '12', '0', '27.889022745323,7.7054841835143,3.1171875,0,0,0,0,297.90707397461', 'NHW-799', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('8', '1', '100', '0', '12', '0', '33.564803995323,10.712320121014,3.1171875,0,0,0,0,297.90707397461', 'ODM-382', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('9', '1', '100', '0', '12', '0', '38.209335245323,13.171304496014,3.1171875,0,0,0,0,297.90707397461', 'UVZ-964', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('10', '1', '100', '0', '12', '0', '42.841171182823,15.625406058514,2.8624513149261,0,0,0,0,297.90707397461', 'GHV-141', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('11', '1', '100', '0', '12', '0', '47.460311807823,18.071695121014,2.3205094337463,0,0,0,0,297.90707397461', 'RBA-933', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('12', '1', '100', '0', '12', '0', '51.564803995323,20.245523246014,1.8388575315475,0,0,0,0,297.90707397461', 'PRV-752', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('13', '1', '100', '0', '12', '0', '56.185897745323,22.693765433514,1.3281381130219,0,0,0,0,297.90707397461', 'TML-971', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('14', '1', '100', '0', '12', '0', '61.339218057823,25.423257621014,0.8902724981308,0,0,0,0,297.90707397461', 'PKT-664', '0,0,0', 'false', '1', '0', '1', '1', '0', '1');

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
