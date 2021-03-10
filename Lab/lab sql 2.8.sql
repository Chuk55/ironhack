USE sakila;
select * from film;

select *, row_number() over (order by A4 desc) as 'Position'
from bank.district;
select * , rank() over (partition by A3 order by A4 desc) as "Position"
from bank.district;
select *, dense_rank() over(order by balance desc) as 'RANK'
from bank.trans
limit 20;
-- 1
select district.A2 as district_name, count(*) as num_customers
from bank.client
inner join bank.district on client.district_id = district.A1
group by district.A2
order by num_customers desc;
-- 2
select district.A3 as region_name, count(*) as num_customers
from bank.client inner join bank.district on client.district_id = district.A1
group by district.A3
order by num_customers desc;
-- 3
select d.A2 , sum(l.amount), avg(l.amount)
from account a 
inner join district d on a.`district_id` = d.A1
inner join loan l on l.account_id = a.account_id
group by d.A2;
-- 4
select d.A2 as district_name, date_format(convert(date, date),'%Y') as year, count(*) num_accounts
from bank.account a 
inner join bank.district d on a.district_id = d.A1
group by district_name, year
order by district_name, year;
-- 1
select title, length, RANK() over (ORDER BY length) ranks
from sakila.film
where length is not null and length > 0;
-- 2
select title, length, rating, rank() over (partition by rating order by length desc) as ranks
from sakila.film
where length is not null and length > 0;
-- 3
select name as category_name, count(*) as num_films
from sakila.category as cats 
inner join sakila.film_category film_cats
on cats.category_id = film_cats.category_id
group by category_name
order by num_films desc;
-- 4
select actor.actor_id, actor.first_name, actor.last_name,
count(actor_id) as film_count
from sakila.actor join sakila.film_actor using (actor_id)
group by actor.actor_id
order by film_count desc
limit 1;
-- 5
select customer.*,
count(rental_id) as rental_count
from sakila.customer join sakila.rental using (customer_id)
group by customer_id
order by rental_count desc
limit 1;
BONUS
select film.title, count(rental_id) as rental_count
from sakila.film inner join sakila.inventory using (film_id)
inner join sakila.rental using (inventory_id)
group by film_id
order by rental_count desc
limit 1;