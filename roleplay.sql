/*
Navicat MySQL Data Transfer

Source Server         : database
Source Server Version : 80017
Source Host           : localhost:3306
Source Database       : roleplay

Target Server Type    : MYSQL
Target Server Version : 80017
File Encoding         : 65001

Date: 2023-03-05 08:56:41
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
  `pos` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '0,0,5,0,0',
  `age` int(11) NOT NULL DEFAULT '18',
  `height` int(11) NOT NULL DEFAULT '175',
  `weight` int(11) NOT NULL DEFAULT '65',
  `gender` int(1) NOT NULL DEFAULT '1',
  `model` int(11) NOT NULL DEFAULT '170',
  `money` bigint(11) NOT NULL DEFAULT '1000',
  `hunger` int(11) NOT NULL DEFAULT '100',
  `thirst` int(11) NOT NULL DEFAULT '100',
  `dead` int(1) NOT NULL DEFAULT '0',
  `walk` int(11) NOT NULL DEFAULT '128',
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
-- Table structure for `vehicles_library`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles_library`;
CREATE TABLE `vehicles_library` (
  `id` bigint(11) DEFAULT NULL,
  `gta` int(11) DEFAULT NULL,
  `brand` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `model` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `year` text CHARACTER SET utf8 COLLATE utf8_general_ci,
  `price` int(11) DEFAULT NULL,
  `tax` int(11) DEFAULT NULL,
  `handling` varchar(1000) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vehicles_library
-- ----------------------------
