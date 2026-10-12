/*
SQLyog Community v13.3.0 (64 bit)
MySQL - 10.4.32-MariaDB : Database - poslasticarnica
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`poslasticarnica` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `poslasticarnica`;

/*Table structure for table `kategorije` */

DROP TABLE IF EXISTS `kategorije`;

CREATE TABLE `kategorije` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `naziv` varchar(255) DEFAULT NULL,
  `opis` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `kategorije` */

insert  into `kategorije`(`id`,`naziv`,`opis`) values 
(1,'Torte','Svečane torte za sve prilike'),
(2,'Kolači','Tradicionalni i moderni kolači'),
(3,'Sladoled','Domaći sladoled u raznim ukusima');

/*Table structure for table `korisnici` */

DROP TABLE IF EXISTS `korisnici`;

CREATE TABLE `korisnici` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `ime` varchar(255) DEFAULT NULL,
  `lozinka` varchar(255) DEFAULT NULL,
  `prezime` varchar(255) DEFAULT NULL,
  `uloga` varchar(255) DEFAULT NULL,
  `username` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_fnhlgpdv9nwggcetnb4hadcdi` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `korisnici` */

insert  into `korisnici`(`id`,`email`,`ime`,`lozinka`,`prezime`,`uloga`,`username`) values 
(1,'admin@example.com','Admin','$2a$10$vy/zH5q74PtHanKt1.LPwe9/Ptr3/oXvbntUq9qq38qU9lgtUHw/y','Demo','ADMIN','admin'),
(2,'user@example.com','Demo','$2a$10$xZceS1Qz49WAN32nW.Y.yOS2cZjB0n0i59K3d1.QVh61yzuc79fK2','User','KORISNIK','user');

/*Table structure for table `porudzbine` */

DROP TABLE IF EXISTS `porudzbine`;

CREATE TABLE `porudzbine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `adresa_dostave` varchar(255) DEFAULT NULL,
  `datum_porudzbine` date DEFAULT NULL,
  `napomena` varchar(255) DEFAULT NULL,
  `status_porudzbine` enum('NA_CEKANJU','PRIHVACENA','U_PRIPREMI','ZAVRSENA','OTKAZANA') DEFAULT NULL,
  `ukupan_iznos` double DEFAULT NULL,
  `korisnik_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKqlg9tjd3ilfperaao9ewuujf1` (`korisnik_id`),
  CONSTRAINT `FKqlg9tjd3ilfperaao9ewuujf1` FOREIGN KEY (`korisnik_id`) REFERENCES `korisnici` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `porudzbine` */

insert  into `porudzbine`(`id`,`adresa_dostave`,`datum_porudzbine`,`napomena`,`status_porudzbine`,`ukupan_iznos`,`korisnik_id`) values 
(1,'Kraljice Katarine','2026-10-06','','PRIHVACENA',2400,2),
(2,'Labudova 13a','2026-10-11','','U_PRIPREMI',120,2);

/*Table structure for table `poslastice` */

DROP TABLE IF EXISTS `poslastice`;

CREATE TABLE `poslastice` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cena` double DEFAULT NULL,
  `dostupnost` bit(1) DEFAULT NULL,
  `jedinica_mere` enum('KOMAD','GRAM','KILOGRAM') DEFAULT NULL,
  `kalorijska_vrednost` double DEFAULT NULL,
  `naziv` varchar(255) DEFAULT NULL,
  `opis` varchar(255) DEFAULT NULL,
  `slika` varchar(255) DEFAULT NULL,
  `kategorija_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcpvr1jqc6um0p7tblo3nktti` (`kategorija_id`),
  CONSTRAINT `FKcpvr1jqc6um0p7tblo3nktti` FOREIGN KEY (`kategorija_id`) REFERENCES `kategorije` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `poslastice` */

insert  into `poslastice`(`id`,`cena`,`dostupnost`,`jedinica_mere`,`kalorijska_vrednost`,`naziv`,`opis`,`slika`,`kategorija_id`) values 
(1,2400,'','KOMAD',420,'Čokoladna torta','Bogata čokoladna torta sa kremom','https://www.gurmanija.rs/images/1000009412.png',1),
(2,2200,'','KOMAD',350,'Voćna torta','Lagana torta sa sezonskim voćem','https://www.mysticcakes.com/wp-content/uploads/2025/11/89.-Moskva-torta-1-546x682.jpg',1),
(3,2600,'','KOMAD',450,'Rafaelo torta','Kokosova torta sa belom čokoladom','https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHbU7zEhdn1xrboRLVZWbfUX5AmQVg1orqeqKtE7bF_zQhAlrD2rNrDJc&s=10',1),
(4,1800,'','KILOGRAM',380,'Baklava','Domaća baklava sa orasima','https://cookwithfaiza.net/wp-content/uploads/2024/03/baklava-recipe-crispy-nutty-dessert.png',2),
(6,220,'','KOMAD',300,'Krempita','Klasična krempita','https://piovariations.cdn.podravka.net/public/optimized/original/04a12dde-63bc-11eb-b189-0242ac120081.webp',2),
(7,120,'','KOMAD',200,'Vanila sladoled','Sladoled od prave vanile','https://bonapeti.rs/files/lib/400x296/vanilla-ice-cream1.webp',3),
(8,120,'','KOMAD',220,'Čokoladni sladoled','Sladoled od tamne čokolade','https://www.kandit.hr/media/1053/shutterstock_265724525.jpg',3);

/*Table structure for table `stavke_porudzbine` */

DROP TABLE IF EXISTS `stavke_porudzbine`;

CREATE TABLE `stavke_porudzbine` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cena_po_jedinici` double DEFAULT NULL,
  `kolicina` int(11) DEFAULT NULL,
  `popust` double DEFAULT NULL,
  `rb` int(11) DEFAULT NULL,
  `porudzbina_id` bigint(20) DEFAULT NULL,
  `poslastica_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK1wt6l6ntox4u6ix9pgyxrslsk` (`porudzbina_id`),
  KEY `FKgao2l8tdi023x9qqynrjb28d` (`poslastica_id`),
  CONSTRAINT `FK1wt6l6ntox4u6ix9pgyxrslsk` FOREIGN KEY (`porudzbina_id`) REFERENCES `porudzbine` (`id`),
  CONSTRAINT `FKgao2l8tdi023x9qqynrjb28d` FOREIGN KEY (`poslastica_id`) REFERENCES `poslastice` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `stavke_porudzbine` */

insert  into `stavke_porudzbine`(`id`,`cena_po_jedinici`,`kolicina`,`popust`,`rb`,`porudzbina_id`,`poslastica_id`) values 
(1,2400,1,0,1,1,1),
(2,120,1,0,1,2,7);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
