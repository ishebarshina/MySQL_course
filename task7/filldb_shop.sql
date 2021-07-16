#
# TABLE STRUCTURE FOR: catalogs
#

DROP TABLE IF EXISTS `catalogs`;

CREATE TABLE `catalogs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название раздела',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Разделы интернет-магазина';

INSERT INTO `catalogs` (`id`, `name`) VALUES (1, 'autem');
INSERT INTO `catalogs` (`id`, `name`) VALUES (2, 'aut');
INSERT INTO `catalogs` (`id`, `name`) VALUES (3, 'neque');
INSERT INTO `catalogs` (`id`, `name`) VALUES (4, 'nihil');
INSERT INTO `catalogs` (`id`, `name`) VALUES (5, 'consequuntur');
INSERT INTO `catalogs` (`id`, `name`) VALUES (6, 'ea');
INSERT INTO `catalogs` (`id`, `name`) VALUES (7, 'voluptatibus');
INSERT INTO `catalogs` (`id`, `name`) VALUES (8, 'atque');
INSERT INTO `catalogs` (`id`, `name`) VALUES (9, 'voluptas');
INSERT INTO `catalogs` (`id`, `name`) VALUES (10, 'non');
INSERT INTO `catalogs` (`id`, `name`) VALUES (11, 'quia');
INSERT INTO `catalogs` (`id`, `name`) VALUES (12, 'officiis');
INSERT INTO `catalogs` (`id`, `name`) VALUES (13, 'et');
INSERT INTO `catalogs` (`id`, `name`) VALUES (14, 'sint');
INSERT INTO `catalogs` (`id`, `name`) VALUES (15, 'deserunt');
INSERT INTO `catalogs` (`id`, `name`) VALUES (16, 'et');
INSERT INTO `catalogs` (`id`, `name`) VALUES (17, 'qui');
INSERT INTO `catalogs` (`id`, `name`) VALUES (18, 'veritatis');
INSERT INTO `catalogs` (`id`, `name`) VALUES (19, 'sint');
INSERT INTO `catalogs` (`id`, `name`) VALUES (20, 'minus');


#
# TABLE STRUCTURE FOR: discounts
#

DROP TABLE IF EXISTS `discounts`;

CREATE TABLE `discounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `discount` float unsigned DEFAULT NULL COMMENT 'Величина скидки от 0.0 до 1.0',
  PRIMARY KEY (`id`),
  KEY `fk_d_user_id` (`user_id`),
  KEY `fk_d_product_id` (`product_id`),
  CONSTRAINT `fk_d_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
  CONSTRAINT `fk_d_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Скидки';

INSERT INTO `discounts` (`id`, `user_id`, `product_id`, `discount`) VALUES (1, 1, 1, '8');
INSERT INTO `discounts` (`id`, `user_id`, `product_id`, `discount`) VALUES (2, 2, 2, '44');
INSERT INTO `discounts` (`id`, `user_id`, `product_id`, `discount`) VALUES (3, 3, 3, '0');
INSERT INTO `discounts` (`id`, `user_id`, `product_id`, `discount`) VALUES (4, 4, 4, '27');
INSERT INTO `discounts` (`id`, `user_id`, `product_id`, `discount`) VALUES (5, 5, 5, '5');


#
# TABLE STRUCTURE FOR: orders
#

DROP TABLE IF EXISTS `orders`;

CREATE TABLE `orders` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_order_user_id` (`user_id`),
  CONSTRAINT `fk_order_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Заказы';

INSERT INTO `orders` (`id`, `user_id`) VALUES (1, 1);
INSERT INTO `orders` (`id`, `user_id`) VALUES (2, 2);
INSERT INTO `orders` (`id`, `user_id`) VALUES (3, 3);
INSERT INTO `orders` (`id`, `user_id`) VALUES (4, 4);
INSERT INTO `orders` (`id`, `user_id`) VALUES (5, 5);
INSERT INTO `orders` (`id`, `user_id`) VALUES (6, 6);
INSERT INTO `orders` (`id`, `user_id`) VALUES (7, 7);


#
# TABLE STRUCTURE FOR: orders_products
#

DROP TABLE IF EXISTS `orders_products`;

CREATE TABLE `orders_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `total` int(10) unsigned DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  PRIMARY KEY (`id`),
  KEY `fk_order_id` (`order_id`),
  KEY `fk_product_id` (`product_id`),
  CONSTRAINT `fk_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Состав заказа';

INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (1, 1, 1, 8);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (2, 2, 2, 9);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (3, 3, 3, 0);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (4, 4, 4, 3);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (5, 5, 5, 5);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (6, 6, 6, 0);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (7, 7, 7, 1);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (8, 1, 8, 3);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (9, 2, 9, 7);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (10, 3, 10, 1);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (11, 4, 11, 9);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (12, 5, 12, 2);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (13, 6, 13, 8);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (14, 7, 14, 6);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (15, 1, 15, 1);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (16, 2, 16, 8);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (17, 3, 17, 1);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (18, 4, 18, 3);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (19, 5, 19, 6);
INSERT INTO `orders_products` (`id`, `order_id`, `product_id`, `total`) VALUES (20, 6, 20, 1);


#
# TABLE STRUCTURE FOR: products
#

DROP TABLE IF EXISTS `products`;

CREATE TABLE `products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название',
  `desription` text COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Описание',
  `price` decimal(11,2) DEFAULT NULL COMMENT 'Цена',
  `catalog_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_catalog_id` (`catalog_id`),
  CONSTRAINT `fk_catalog_id` FOREIGN KEY (`catalog_id`) REFERENCES `catalogs` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Товарные позиции';

INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (1, 'et', NULL, '44715.50', 1);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (2, 'cupiditate', NULL, '1978.64', 2);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (3, 'neque', NULL, '3323720.04', 3);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (4, 'non', NULL, '407.00', 4);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (5, 'assumenda', NULL, '56.93', 5);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (6, 'qui', NULL, '4.70', 6);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (7, 'est', NULL, '75.06', 7);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (8, 'reprehenderit', NULL, '96074.18', 8);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (9, 'quaerat', NULL, '52106.46', 9);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (10, 'ut', NULL, '225912.50', 10);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (11, 'ipsa', NULL, '23952504.96', 11);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (12, 'fugiat', NULL, '674277.00', 12);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (13, 'eaque', NULL, '6717.59', 13);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (14, 'fugiat', NULL, '16.05', 14);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (15, 'eum', NULL, '68461830.00', 15);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (16, 'explicabo', NULL, '0.00', 16);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (17, 'et', NULL, '0.42', 17);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (18, 'distinctio', NULL, '3.00', 18);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (19, 'illum', NULL, '0.00', 19);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (20, 'a', NULL, '67447124.51', 20);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (21, 'asperiores', NULL, '107890.23', 1);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (22, 'molestiae', NULL, '0.00', 2);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (23, 'quidem', NULL, '9224.48', 3);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (24, 'et', NULL, '72.00', 4);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (25, 'repellendus', NULL, '17.91', 5);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (26, 'ut', NULL, '399.89', 6);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (27, 'quia', NULL, '98.10', 7);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (28, 'voluptas', NULL, '505359.76', 8);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (29, 'ut', NULL, '30.00', 9);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (30, 'voluptatum', NULL, '57.00', 10);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (31, 'doloremque', NULL, '22.02', 11);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (32, 'et', NULL, '2.00', 12);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (33, 'ut', NULL, '0.00', 13);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (34, 'deleniti', NULL, '94176.00', 14);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (35, 'vel', NULL, '36.28', 15);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (36, 'et', NULL, '104.74', 16);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (37, 'doloremque', NULL, '769.13', 17);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (38, 'porro', NULL, '23842539.28', 18);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (39, 'et', NULL, '0.90', 19);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (40, 'exercitationem', NULL, '18.00', 20);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (41, 'et', NULL, '12147.05', 1);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (42, 'nihil', NULL, '26812.91', 2);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (43, 'rem', NULL, '70.26', 3);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (44, 'ducimus', NULL, '1291563.26', 4);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (45, 'quo', NULL, '517.01', 5);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (46, 'ratione', NULL, '0.00', 6);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (47, 'labore', NULL, '5037.57', 7);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (48, 'exercitationem', NULL, '0.00', 8);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (49, 'ut', NULL, '1702793.90', 9);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (50, 'magnam', NULL, '20.51', 10);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (51, 'fugit', NULL, '0.00', 11);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (52, 'aut', NULL, '45094.27', 12);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (53, 'ut', NULL, '0.00', 13);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (54, 'labore', NULL, '1921367.89', 14);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (55, 'id', NULL, '52104.13', 15);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (56, 'quia', NULL, '36777.40', 16);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (57, 'distinctio', NULL, '13431.46', 17);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (58, 'eius', NULL, '62005.40', 18);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (59, 'possimus', NULL, '11.38', 19);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (60, 'quaerat', NULL, '1871531.66', 20);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (61, 'est', NULL, '2.20', 1);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (62, 'nostrum', NULL, '2.00', 2);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (63, 'ullam', NULL, '278130.38', 3);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (64, 'explicabo', NULL, '0.20', 4);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (65, 'sed', NULL, '215914117.77', 5);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (66, 'est', NULL, '116.53', 6);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (67, 'vitae', NULL, '49.93', 7);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (68, 'dolores', NULL, '2982726.70', 8);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (69, 'aut', NULL, '67.87', 9);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (70, 'libero', NULL, '97175.20', 10);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (71, 'corporis', NULL, '3245.61', 11);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (72, 'provident', NULL, '0.62', 12);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (73, 'doloribus', NULL, '912151.91', 13);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (74, 'non', NULL, '14.00', 14);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (75, 'porro', NULL, '5231936.30', 15);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (76, 'harum', NULL, '0.00', 16);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (77, 'voluptatem', NULL, '47392999.17', 17);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (78, 'sed', NULL, '7.98', 18);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (79, 'dignissimos', NULL, '0.00', 19);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (80, 'non', NULL, '587309.92', 20);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (81, 'veritatis', NULL, '93913992.29', 1);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (82, 'velit', NULL, '0.00', 2);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (83, 'nihil', NULL, '50.55', 3);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (84, 'possimus', NULL, '0.00', 4);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (85, 'nostrum', NULL, '2559.81', 5);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (86, 'officiis', NULL, '4741024.97', 6);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (87, 'et', NULL, '5277.53', 7);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (88, 'at', NULL, '2018.69', 8);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (89, 'sit', NULL, '4221.00', 9);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (90, 'numquam', NULL, '79.41', 10);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (91, 'ut', NULL, '1.84', 11);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (92, 'ipsa', NULL, '1.80', 12);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (93, 'itaque', NULL, '2037368.06', 13);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (94, 'est', NULL, '1394.75', 14);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (95, 'voluptatem', NULL, '152655.56', 15);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (96, 'aut', NULL, '2138511.79', 16);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (97, 'aut', NULL, '385233130.77', 17);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (98, 'et', NULL, '402171.48', 18);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (99, 'et', NULL, '121524.45', 19);
INSERT INTO `products` (`id`, `name`, `desription`, `price`, `catalog_id`) VALUES (100, 'reiciendis', NULL, '0.00', 20);


#
# TABLE STRUCTURE FOR: storehouses
#

DROP TABLE IF EXISTS `storehouses`;

CREATE TABLE `storehouses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Название',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Склады';

INSERT INTO `storehouses` (`id`, `name`) VALUES (1, 'beatae');
INSERT INTO `storehouses` (`id`, `name`) VALUES (2, 'eum');
INSERT INTO `storehouses` (`id`, `name`) VALUES (3, 'sit');
INSERT INTO `storehouses` (`id`, `name`) VALUES (4, 'dolores');
INSERT INTO `storehouses` (`id`, `name`) VALUES (5, 'corporis');


#
# TABLE STRUCTURE FOR: storehouses_products
#

DROP TABLE IF EXISTS `storehouses_products`;

CREATE TABLE `storehouses_products` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `storehouse_id` int(10) unsigned DEFAULT NULL,
  `product_id` int(10) unsigned DEFAULT NULL,
  `value` int(10) unsigned DEFAULT NULL COMMENT 'Запас товарной позиции на складе',
  PRIMARY KEY (`id`),
  KEY `fk_sth_id` (`storehouse_id`),
  KEY `fk_sth_product_id` (`product_id`),
  CONSTRAINT `fk_sth_id` FOREIGN KEY (`storehouse_id`) REFERENCES `storehouses` (`id`),
  CONSTRAINT `fk_sth_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Запасы на складе';

INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (1, 1, 1, 7);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (2, 2, 2, 6);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (3, 3, 3, 9);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (4, 4, 4, 6);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (5, 5, 5, 8);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (6, 1, 6, 1);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (7, 2, 7, 6);
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`) VALUES (8, 3, 8, 4);


#
# TABLE STRUCTURE FOR: users
#

DROP TABLE IF EXISTS `users`;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Имя покупателя',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Покупатели';

INSERT INTO `users` (`id`, `name`) VALUES (1, 'cupiditate');
INSERT INTO `users` (`id`, `name`) VALUES (2, 'nihil');
INSERT INTO `users` (`id`, `name`) VALUES (3, 'consequuntur');
INSERT INTO `users` (`id`, `name`) VALUES (4, 'quis');
INSERT INTO `users` (`id`, `name`) VALUES (5, 'recusandae');
INSERT INTO `users` (`id`, `name`) VALUES (6, 'ut');
INSERT INTO `users` (`id`, `name`) VALUES (7, 'mollitia');
INSERT INTO `users` (`id`, `name`) VALUES (8, 'et');
INSERT INTO `users` (`id`, `name`) VALUES (9, 'facere');
INSERT INTO `users` (`id`, `name`) VALUES (10, 'modi');
INSERT INTO `users` (`id`, `name`) VALUES (11, 'id');
INSERT INTO `users` (`id`, `name`) VALUES (12, 'quae');
INSERT INTO `users` (`id`, `name`) VALUES (13, 'nam');
INSERT INTO `users` (`id`, `name`) VALUES (14, 'ea');
INSERT INTO `users` (`id`, `name`) VALUES (15, 'eum');
INSERT INTO `users` (`id`, `name`) VALUES (16, 'nemo');
INSERT INTO `users` (`id`, `name`) VALUES (17, 'quis');
INSERT INTO `users` (`id`, `name`) VALUES (18, 'culpa');
INSERT INTO `users` (`id`, `name`) VALUES (19, 'enim');
INSERT INTO `users` (`id`, `name`) VALUES (20, 'pariatur');


