-- Lab SQL Queries - Lesson 2.5
select * from actor
having first_name= 'Scarlett';

-- 2
select count(*) from sakila.film;
select count(*) from sakila.rental;

-- 3
select min(length) from film;
select max(length) from film;

-- 4
select floor(avg(length/60)) as hours, round(avg(length)%60) as minutes from film;

-- 5
select count(distinct(last_name)) from actor;

-- 6
select datediff(max(rental_date), min(rental_date) as active_days from rental;

-- 7
select *, date_format()

-- 8

select *
case
when date_format(rental_date, '%W) in  ("SAturday", "Sunday") then "Weekend" )
else "workday"
end as "Status_Description" # column
from bank.loan;


select date(max(rental_date))
from rentals;)))


-- 1
select * from sakila.actor
where first_name = ‘SCARLETT’;
-- 2
select count(*) from sakila.film;
select count(*) from sakila.rental;
-- 3
select max(rental_duration) as max_duration, min(rental_duration) as min_duration
from sakila.film;
-- 4
select floor(avg(length) / 60) as hours, round(avg(length) % 60) as minutes
from sakila.film;
-- 5
select count(distinct last_name)
from actor;
-- 6
select datediff(max(rental_date), min(rental_date)) as active_days
from rental;
-- 7
select *, date_format(rental_date, ‘%M’) as month , date_format(rental_date, ‘%W’) as weekday
from rental
limit 20;
-- 8
select *, case when date_format(rental_date, ‘%W’) in (‘Saturday’, ‘Sunday’)
          then ‘weekend’
          else ‘workday’ end as day_type
from rental;
-- 9
select date(max(rental_date))
from rental;
select *, date_format(`rental_date`, “%M”) as Month_,
date_format(`rental_date`, “%Y”) as Year_
from rental
having Month_ = ‘October’ and Year_ = 2020;