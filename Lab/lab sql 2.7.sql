
drop table if exists films_2020;
CREATE TABLE `films_2020` (
  `film_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text,
  `release_year` year(4) DEFAULT NULL,
  `language_id` tinyint(3) unsigned NOT NULL,
  `original_language_id` tinyint(3) unsigned DEFAULT NULL,
  `rental_duration` int(6),
  `rental_rate` decimal(4,2),
  `length` smallint(5) unsigned DEFAULT NULL,
  `replacement_cost` decimal(5,2) DEFAULT NULL,
  `rating` enum('G','PG','PG-13','R','NC-17') DEFAULT NULL,
  PRIMARY KEY (`film_id`),
  CONSTRAINT FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8;

select * from films_2020;
load data local infile 'C:\Users\Admin\dataV3_Lesson_2.7_lab\files_for_part1\films_2020.csv'
into table films_2020
FIELDS TERMINATED BY ',' 
#ENCLOSED BY '"'
#LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

show variables like 'local_infile';
set global local_infile = 1;

------------- Lab part 2 ----------------------- 
-- 1
select last_name, first_name from actor
group by last_name
having count(last_name) < 2;

-- 2
select last_name, first_name from actor
group by last_name
having count(last_name) > 1;

-- 3
select count(*), staff_id from rental
group by staff_id;

-- 4
select count(*), release_year from film
group by release_year;

-- 5
select count(*), rating from film
group by rating;

-- 6
select round(avg(length),2) as mean, rating from film
group by rating;

-- 7
select round(avg(length),2) as mean, rating from film
group by rating
having mean > 120;

