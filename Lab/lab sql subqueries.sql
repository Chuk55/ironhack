-- How many copies of the film Hunchback Impossible exist in the inventory system?
select count(inventory_id) from inventory where film_id = (select film_id from film where title = 'HUNCHBACK IMPOSSIBLE');

-- List all films whose length is longer than the average of all the films.
select title, length from film where length > (select avg(length) from film) order by length; # avg 115.2720

-- Use subqueries to display all actors who appear in the film Alone Trip.
select concat(first_name,' ', last_name) as Actor_name from actor where actor_id in (
select actor_id from film_actor where film_id = (
select film_id from film where title = 'ALONE TRIP'));

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title from film where film_id in (select film_id from film_category where category_id = (
select category_id from category where name = 'Family'));

-- Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.
select concat(first_name, ' ', last_name) as NAME, email from customer where address_id in (
select address_id from address where city_id in (
select city_id from city where country_id = (
select country_id from country where country = 'Canada')));

-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.
select film_id, title from film  where film_id in (
select film_id from film_actor where actor_id = (
select actor_id from (select actor_id, count(*) as num from film_actor group by actor_id order by num desc limit 1) t));

select concat(first_name, ' ', last_name) as Actor_name from actor where actor_id = (select actor_id from (select actor_id, count(*) as num from film_actor group by actor_id order by num desc limit 1) t);

-- alternative solution
select title from film where film_id in
( select film_id from film_actor where actor_id =
	(select actor_id from film_actor 
	group by actor_id
	order by count(*) desc 
    limit 1));


-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments
select * from payment;
Select concat(first_name, ' ', last_name) as NAME from customer where customer_id = ( select customer_id, sum(amount) as total from payment group by customer_id order by total desc limit 1 );


-- Customers who spent more than the average payments. 

select customer_id, sum(amount) as Total from payment group by customer_id having Total > (select avg(amount) from payment) order by Total desc; # avg= 4.200667

------ from oliver solution ---
#1
select f.title as Filmtitle, count(i.inventory_id) as Number_of_Copies
from inventory i
join film f
on f.film_id = i.film_id
where i.film_id = (select film_id as ID from film where title = 'Hunchback Impossible');
#2
select title as Filmtitle, length as Filmlength from film
where length > (select avg(length) from film)
order by Filmlength ASC;
#3
select last_name, first_name  from actor
where actor_id in (
	select actor_id from film_actor
	where film_id = (select film_id from film where title = 'Alone Trip'))
order by last_name, first_name;
#4
select title from film
where film_id in (
	select film_id from film_category
	where category_id = (select category_id from category where name = 'Family'))
order by title;

---- solution from himancshu --- 

-- 1
select count(film_id) as counts from inventory
where film_id = (
select film_id from sakila.film
where title = 'Hunchback Impossible'
);
-- 2
select title, length 
from sakila.film
where length > 
(
select avg(length) from sakila.film
);
-- 3
select concat(first_name , ' ' , last_name) as Actor
from sakila.actor
where actor_id in (
-- Grab the actor_ids for actors in Alone Trip
select actor_id
from sakila.film_actor
where film_id = (
-- Grab the film_id for Alone Trip
select film_id
from sakila.film
where title = 'ALONE TRIP'
)
);
-- 4
select title as Title
from sakila.film
where film_id in (
select film_id
from sakila.film_category
where category_id in (
select category_id
from sakila.category
where name = 'Family'
)
);
-- 5
select concat(first_name , ' ' , last_name) as Customer_Name, email
from sakila.customer
where address_id in (
select address_id
from sakila.address
where city_id in (
select city_id
from sakila.city
where country_id in (
select country_id
from sakila.country
where country = 'Canada'
)
)
);
select concat(first_name , ' ' , last_name) as Customer_Name, email
from sakila.customer cust
join sakila.address addr on cust.address_id = addr.address_id 
join sakila.city cit on cit.city_id = addr.city_id 
join sakila.country cou on cou.country_id = cit.country_id
where country = 'Canada';
-- 6
-- get most prolific author
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1;
-- now get the films starred by the most prolific actor
select concat(first_name, ' ', last_name) as actor_name, film.title, film.release_year
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join film
using (film_id)
where actor_id = (
select actor_id
from sakila.actor
inner join sakila.film_actor
using (actor_id)
inner join sakila.film
using (film_id)
group by actor_id
order by count(film_id) desc
limit 1
)
order by release_year desc;

--- Using sub queries - Lorenz's solution --
select title from film
where film_id in
(
select film_id from film_actor
where actor_id = 
(select actor_id from 
(select a.actor_id, a.first_name, a.last_name, count(a.actor_id) as count 
from actor as a
join film_actor as fa
on a.actor_id = fa.actor_id
join film as f
on f.film_id = fa.film_id
group by a.actor_id
order by count desc
limit 1
)sub1
)
);
-- 7
-- most profitable customer
select customer_id
from sakila.customer
inner join payment using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1;
-- films rented by most profitable customer
select film_id, title, rental_date, amount
from sakila.film
inner join inventory using (film_id)
inner join rental using (inventory_id)
inner join payment using (rental_id)
where rental.customer_id = (
select customer_id
from customer
inner join payment
using (customer_id)
group by customer_id
order by sum(amount) desc
limit 1
)
order by rental_date desc;
-- 8
/* explain */
select customer_id, sum(amount) as payment
from sakila.customer
inner join payment using (customer_id)
group by customer_id
having sum(amount) > (
select avg(total_payment)
from (
select customer_id, sum(amount) total_payment
from payment
group by customer_id
) t
)
order by payment desc;

-- 3.05 activity 3
select * from 
(
select *, rank() over (partition by A2 order by counts desc) as Ranks 
from (
select c.A2 ,a.account_id, count(a.trans_id) as counts
from 
trans as a
join account as b
on a.account_id = b.account_id
join district as c
on b.district_id = c.A1
where c.A3 = 'central Bohemia'
group by c.A2 ,a.account_id
order by c.A2
)sub
)sub2
where Ranks=1;