
                                                          
DROP TABLE IF EXISTS `share_like`;
CREATE TABLE `share_like` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) DEFAULT NULL COMMENT '分类id',
  `code` varchar(8) DEFAULT NULL COMMENT '代码',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='股票收藏表';

DROP TABLE IF EXISTS `share_like_category`;
CREATE TABLE `share_like_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='股票收藏分类表';


DROP TABLE IF EXISTS `tactics`;
CREATE TABLE `tactics` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `owner` varchar(50) DEFAULT NULL COMMENT '拥有者',
  `name` varchar(50) DEFAULT NULL COMMENT '名称',
  `source` varchar(50) DEFAULT NULL COMMENT '源码路径',
  `doc` varchar(50) DEFAULT NULL COMMENT '文档路径',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='策略表';

DROP TABLE IF EXISTS `tactics_input`;
CREATE TABLE `tactics_input` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tacticsId` bigint(20) NOT NULL COMMENT '策略id',
  `name` varchar(50) DEFAULT NULL COMMENT '入参名称',
  `title` varchar(50) DEFAULT NULL COMMENT '入参key',
  `defual` varchar(50) DEFAULT NULL COMMENT '入参默认值',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='策略入参表';



                                                              
    