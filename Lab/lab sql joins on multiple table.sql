-- 1 Write a query to display for each store its store ID, city, and country.
select s.store_id as 'Store ID', c.city as 'City', cy.country as 'Country'
from store as s
join address as a on a.address_id = s.address_id
join city as c on c.city_id = a.city_id
join country as cy on cy.country_id = c.country_id
order by s.store_id;

-- 2 Write a query to display how much business, in dollars, each store brought in.
select store as 'Store', total_sales as 'Total Sales' from sales_by_store;

select concat(c.city,', ',cy.country) as `Store`, s.store_id as 'Store ID', sum(p.amount) as `Total Sales` 
from payment as p
join rental as r on r.rental_id = p.rental_id
join inventory as i on i.inventory_id = r.inventory_id
join store as s on s.store_id = i.store_id
join address as a on a.address_id = s.address_id
join city as c on c.city_id = a.city_id
join country as cy on cy.country_id = c.country_id
group by s.store_id;

-- 3 What is the average running time of films by category?
select category.name, avg(length)
from film join film_category using (film_id) join category using (category_id)
group by category.name
order by avg(length) desc;

-- 4 Which film categories are longest?
select category.name, avg(length)
from film join film_category using (film_id) join category using (category_id)
group by category.name
having avg(length) > (select avg(length) from film)
order by avg(length) desc;

-- 5 Display the most frequently rented movies in descending order.

SELECT f.title, COUNT(f.title) as rentals from film f 
JOIN 
	(SELECT r.rental_id, i.film_id FROM rental r 
    JOIN 
    inventory i ON i.inventory_id = r.inventory_id) a
    ON a.film_id = f.film_id GROUP BY f.title ORDER BY rentals DESC;

-- 6 List the top five genres in gross revenue in descending order
select c.name as 'Film', sum(p.amount) as 'Gross Revenue'
from category as c
join film_category as fc on fc.category_id = c.category_id
join inventory as i on i.film_id = fc.film_id
join rental as r on r.inventory_id = i.inventory_id
join payment as p on p.rental_id = r.rental_id
group by c.name
order by sum(p.amount) desc
limit 5;

-- 7 Is "Academy Dinosaur" available for rent from Store 1?
select film.film_id, film.title, store.store_id, inventory.inventory_id
from inventory join store using (store_id) join film using (film_id)
where film.title = 'Academy Dinosaur' and store.store_id = 1;
