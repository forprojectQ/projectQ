/*
Navicat MySQL Data Transfer

Source Server         : localsw
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : roleplay

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2023-04-28 16:32:57
*/

SET FOREIGN_KEY_CHECKS=0;
-- ----------------------------
-- Table structure for `accounts`
-- ----------------------------
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` text CHARACTER SET latin1 DEFAULT NULL,
  `password` text CHARACTER SET latin1 DEFAULT NULL,
  `admin` int(11) NOT NULL DEFAULT 0,
  `serial` text CHARACTER SET latin1 DEFAULT NULL,
  `limit` int(11) NOT NULL DEFAULT 3,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of accounts
-- ----------------------------
INSERT INTO `accounts` VALUES ('1', 'test', 'test', '10', 'B5D767EFFB542805FE49564D79C68A54', '3');

-- ----------------------------
-- Table structure for `characters`
-- ----------------------------
DROP TABLE IF EXISTS `characters`;
CREATE TABLE `characters` (
  `id` int(11) NOT NULL,
  `account` int(11) NOT NULL DEFAULT 0,
  `name` text CHARACTER SET latin1 DEFAULT NULL,
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
  `walk` int(11) NOT NULL DEFAULT 128,
  `job` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of characters
-- ----------------------------
INSERT INTO `characters` VALUES ('1', '1', 'test', '0,0,5,0,0', '21', '175', '70', '2', '93', '1000', '63', '59', '0', '131', '0');

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of items
-- ----------------------------
INSERT INTO `items` VALUES ('31', '1', '1', '2', '13', '1');
INSERT INTO `items` VALUES ('32', '1', '1', '2', '14', '1');
INSERT INTO `items` VALUES ('33', '1', '1', '2', '15', '1');
INSERT INTO `items` VALUES ('34', '1', '1', '2', '16', '1');
INSERT INTO `items` VALUES ('35', '1', '1', '2', '17', '1');
INSERT INTO `items` VALUES ('36', '1', '1', '2', '18', '1');

-- ----------------------------
-- Table structure for `vehicles`
-- ----------------------------
DROP TABLE IF EXISTS `vehicles`;
CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `library_id` int(11) DEFAULT NULL,
  `fuel` int(11) NOT NULL DEFAULT 100,
  `tax` int(11) NOT NULL DEFAULT 0,
  `job` int(11) DEFAULT NULL,
  `pos` varchar(255) NOT NULL DEFAULT '0,0,5,0,0,0,0,90',
  `plate` text DEFAULT NULL,
  `color` varchar(255) NOT NULL DEFAULT '0,0,0',
  `upgrades` text DEFAULT '',
  `lock` int(11) NOT NULL DEFAULT 1,
  `interest` int(11) NOT NULL DEFAULT 0,
  `owner` int(11) DEFAULT NULL,
  `engine` int(11) NOT NULL DEFAULT 0,
  `enabled` int(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of vehicles
-- ----------------------------
INSERT INTO `vehicles` VALUES ('13', '1', '100', '0', '0', '8.5634580278042,8.7875766467764,3.1096496582031,0,0,0,0,100.23803710938', 'AOF-865', '0,0,0', null, '1', '0', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('14', '1', '100', '0', '0', '8.0699133685011,-2.7380825766116,3.1171875,0,0,0,0,206.74113464355', 'JXV-728', '0,0,0', null, '1', '0', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('15', '1', '100', '0', '0', '27.784453625541,-13.538959302451,3.1171875,0,0,0,0,255.99908447266', 'SNH-114', '0,0,0', null, '1', '0', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('16', '1', '100', '0', '0', '34.089652932674,5.7571424293423,3.1171875,0,0,0,0,18.201873779297', 'DEZ-521', '0,0,0', null, '1', '0', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('17', '1', '100', '0', '0', '21.632355946983,-6.9611503467267,3.1171875,0,0,0,0,332.96499633789', 'AJN-666', '0,0,0', null, '1', '0', '1', '0', '1');
INSERT INTO `vehicles` VALUES ('18', '1', '100', '0', '0', '49.476451372852,-31.174437523343,1.1405982971191,0,0,0,0,58.582733154297', 'ERL-416', '0,0,0', null, '1', '0', '1', '0', '1');

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
  `brand` text DEFAULT NULL,
  `model` text DEFAULT NULL,
  `year` text DEFAULT NULL,
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
