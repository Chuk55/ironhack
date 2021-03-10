-- Get all pairs of actors that worked together.

select * from (
select fa1.film_id , fa1.actor_id as actor1, fa2.actor_id as actor2
from film_actor fa1
join film_actor fa2
on fa1.`actor_id` <> fa2.actor_id and fa1.film_id = fa2.film_id 
where fa1.film_id =1)sub
where actor1 > actor2
order by actor1, actor2;

#1 Pairs of Actors (based on Ids)
select fa1.actor_id, fa2.actor_id, fa1.film_id from film_actor fa1
join film_actor fa2
on fa1.film_id = fa2.film_id
where fa1.actor_id <> fa2.actor_id;

# Pairs of Actors (based on Names)
create temporary table temp_pair_actor
select fa1.actor_id as Actor1, fa2.actor_id as Actor2, fa1.film_id from film_actor fa1
join film_actor fa2
on fa1.film_id = fa2.film_id
where fa1.actor_id <> fa2.actor_id;
select a1.first_name, a1.last_name, a2.first_name, a2.last_name, tp.film_id as Film_id from temp_pair_actor tp
join actor a1
on tp.actor1 = a1.actor_id
join actor a2
on tp.actor2 = a2.actor_id;

-- Get all pairs of customers that have rented the same film more than 3 times.
select *
from
(select  in2.film_id, a1.customer_id as First_pair, a2.customer_id as Second_pair , count(*) as number_films, rank() over(partition by a1.customer_id order by a2.customer_id) as Ranks
from sakila.customer a1
inner join rental re1 on re1.customer_id = a1.customer_id
inner join inventory in1 on (re1.inventory_id = in1.inventory_id)
inner join film fa1 on in1.film_id=fa1.film_id
inner join inventory in2 on (fa1.film_id = in2.film_id)
inner join rental re2 on re2.inventory_id=in2.inventory_id
inner join customer a2 on re2.customer_id=a2.customer_id
where a1.customer_id <> a2.customer_id
group by a1.customer_id, a2.customer_id
having count(*)>3
order by number_films desc)tab
where Ranks=1;


-- Get all possible pairs of actors and films.

select concat(a.first_name, ' ', a.last_name) as actor_name, f.title from sakila.actor a;