## 1.  Get number of monthly active customers.
-- 1
with customer_activity as (
  select customer_id, convert(rental_date, date) as Activity_date,
  date_format(rental_date, '%M') as Activity_Month,
  date_format(rental_date, '%Y') as Activity_year
  from sakila.rental
)
select count(distinct customer_id) as Active_users, Activity_year, Activity_Month
from customer_activity
group by Activity_year, Activity_Month
order by Activity_year, Activity_Month;

## 2.  
with customer_activity as (
  select customer_id, convert(rental_date, date) as Activity_date,
  date_format(rental_date, '%M') as Activity_Month,
  date_format(rental_date, '%Y') as Activity_year
  from sakila.rental
),
monthly_active_users as (
  select count(distinct customer_id) as Active_users, Activity_year, Activity_Month
  from customer_activity
  group by Activity_year, Activity_Month
  order by Activity_year, Activity_Month
),
cte_activity as (
  select Active_users, lag(Active_users,1) over (partition by Activity_year) as last_month, Activity_year, Activity_month
  from monthly_active_users
)
select * from cte_activity
where last_month is not null;

## 3.  Percentage change in the number of active customers.

with customer_activity as (
  select customer_id, convert(rental_date, date) as Activity_date,
  date_format(rental_date, '%M') as Activity_Month,
  date_format(rental_date, '%Y') as Activity_year
  from sakila.rental
),
monthly_active_users as (
  select count(distinct customer_id) as Active_users, Activity_year, Activity_Month
  from customer_activity
  group by Activity_year, Activity_Month
  order by Activity_year, Activity_Month
),
cte_activity as (
  select Active_users, lag(Active_users,1) over (partition by Activity_year) as last_month, Activity_year, Activity_month
  from monthly_active_users
)
select (Active_users-last_month)/Active_users*100 as percentage_change, activity_year, activity_month
from cte_activity
where last_month is not null;