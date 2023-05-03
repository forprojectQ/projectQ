/*
Navicat MySQL Data Transfer

Source Server         : Database
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : roleplay

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2023-05-03 14:29:19
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of accounts
-- ----------------------------

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of characters
-- ----------------------------

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
  `tax` int(11) NOT NULL DEFAULT '0',
  `job` int(11) DEFAULT NULL,
  `pos` varchar(255) NOT NULL DEFAULT '0,0,5,0,0,0,0,90',
  `plate` text,
  `color` varchar(255) NOT NULL DEFAULT '0,0,0',
  `upgrades` text,
  `lock` int(11) NOT NULL DEFAULT '1',
  `interest` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) DEFAULT NULL,
  `engine` int(11) NOT NULL DEFAULT '0',
  `enabled` int(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vehicles
-- ----------------------------

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vehicles_library
-- ----------------------------
INSERT INTO `vehicles_library` VALUES ('1', '560', 'test', 'car', '2022', '25000', '12', '1', '');
