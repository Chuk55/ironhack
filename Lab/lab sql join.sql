-- 3.01
select district_id, district.A2 as district_name, count(*) as num_customers
from bank.client
inner join bank.district on client.district_id = district.A1
group by district.A2
order by district_id;

select count(count_id) from bank.client
group by district_id;

----- 
#inner join bank.district on client.district_id = district.A1
#where district_name = 'Strakonice';
-- 3.02
-- all district have client
drop table if exists strakonise;
CREATE TABLE strakonise (
  district_id int(11) UNIQUE NOT NULL,
  num_customers int(11) DEFAULT NULL,
  district_name TEXT DEFAULT NULL,
  CONSTRAINT PRIMARY KEY (district_id)  -- constraint keyword is optional but its a good practice
);
insert into strakonise
select * from strakonise;

UPDATE strakonise
SET district_id = 100,
num_customers = 43,
district_name = 'strakonise';

----------------------------
-- fourth step
select t.account_id,
 t.operation,
 a.frequency,
 sum(amount) as TotalAmount,
 sum(balance) as TotalBalance
from bank.trans t
left join bank.account a
on t.account_id = a.account_id
where t.operation = 'VKLAD' and balance > 1000
group by t.account_id, t.operation, a.frequency
having TotalAmount > 500000
order by TotalAmount desc
limit 10;
------------------- 

select d.disp_id,
d.type,
d.client_id,
c.birth_number,
ca.type
from bank.disp d
join bank.client c
on d.client_id = c.client_id
join bank.card ca
on d.disp_id = ca.disp_id
where ca.type = "gold";


create temporary table bank.loan_and_amount
select l.loan_id, l.account_id, a.district_id, l.amount, l.payments, a.frequency
from bank.loan l
join bank.account a
on l.account_id = a.account_id;

select * from bank.loan_and_amount;


create temporary table bank.disp_and_account
select d.disp_id, d.client_id, d.account_id, a.district_id, d.type
from bank.disp d
join bank.account a
on d.account_id = a.account_id;

select * from bank.disp_and_account;

select * from bank.loan_and_amount la
join bank.disp_and_account da
on la.account_id = da.account_id
and la.district_id = da.district_id;


--------------------- 26 Jan 21
select * from bank.account a1
join bank.account a2
on a1.account_id <> a2.account_id
and a1.district_id = a2.district_id
order by a1.district_id;

select * from bank.account a2;

select a1.account_id, a2.account_id, a1.district_id
from bank.account a1
join bank.account a2
on a1.account_id <> a2.account_id
and a1.district_id = a2.district_id
order by a1.district_id, a1.account_id;

-- 3.03 activity 1
select * from bank.account a1
join bank.disp d1
on a1.account_id = d1.account_id
where d1.type = 'DISPONENT';

select d1.account_id, d1.client_id, d2.disp_id, rank() over (partition by d1.account_id order by d1.client_id) as Ranks
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type
order by Ranks, d1.account_id;

select d1.account_id, d1.client_id, d2.disp_id
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type
group by d1.account_id;
-------------------------------------- temp table
create temporary table temp1
select d1.account_id, d1.client_id, d2.disp_id, rank() over(partition by d1.account_id order by d1.client_id) as Ranks
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type
order by Ranks, d1.account_id;

select account_id, client_id, disp_id
from temp1
where Ranks = 1;

--- or use sub query
select account_id, client_id, disp_id
from ( select d1.account_id, d1.client_id, d2.disp_id, rank() over(partition by d1.account_id order by d1.client_id) as Ranks
from bank.disp d1
join bank.disp d2
on d1.account_id = d2.account_id
and d1.type <> d2.type
order by Ranks, d1.account_id)sub_1
where Ranks = 1;
---------------------------------------
select * from bank.card cross join bank.loan limit 100;

select * from
( select distinct type from bank.card) sub1
cross join ( select distinct type from bank.disp) sub2;

-------------- lab SQL self and cross join
--- get all pair of actors that worked together
SELECT f.film_id , fa.actor_id, f.title
FROM film_actor fa
INNER JOIN film f 
ON fa.film_id= f.film_id
GROUP BY f.film_id, actor_id;

select * from inventory;
------ Get all pairs of customers that have rented the same film more than 3 times.
SELECT R.customer_id, COUNT(*) AS cnt 
FROM sakila.rental R LEFT JOIN sakila.inventory I ON R.inventory_id = I.inventory_id;


SELECT R.*, I.*
FROM sakila.rental R LEFT JOIN sakila.inventory I ON R.inventory_id = I.inventory_id
#Group by film_id
order by film_id;

#LEFT JOIN sakila.film F ON I.film_id = F.film_id 
#LEFT JOIN sakila.film_category FC on F.film_id = FC.film_id 
#LEFT JOIN sakila.category C ON FC.category_id = C.category_id 
#WHERE C.name = "Horror" 
#GROUP BY R.customer_id HAVING cnt > 10;

SELECT first_name, last_name, address
FROM staff s 
JOIN address a
ON s.address_id = a.address_id;

SELECT payment.staff_id, staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff INNER JOIN payment ON
staff.staff_id = payment.staff_id AND payment_date LIKE '2005-08%'; 

select * from (
select fa1.film_id , fa1.actor_id as actor1, fa2.actor_id as actor2
from film_actor fa1
join film_actor fa2
on fa1.`actor_id` <> fa2.actor_id and fa1.film_id = fa2.film_id 
where fa1.film_id =1)sub
where actor1 > actor2
order by actor1, actor2;