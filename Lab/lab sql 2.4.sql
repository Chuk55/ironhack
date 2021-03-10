SELECT * FROM actor; 
-- column from a table
SELECT title FROM film; 

-- language id gives all '1'
SELECT language_id as 'language' FROM film;

-- last name from staff
SELECT last_name FROM staff;

SELECT count(*) FROM staff;

SELECT count(*) as TotalStores FROM store;

SELECT first_name FROM staff;

SELECT count(distinct rental_date) from rental;

SELECT COUNT(DISTINCT(DATEDIFF(return_date,rental_date))) from rental;

select distinct(DATE(rental_date)) from rental;

