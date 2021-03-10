## Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT DISTINCT
    CONCAT(first_name, ' ', last_name) AS 'Customer Name', email
FROM
    sakila.customer AS cus
        INNER JOIN
    sakila.rental AS rent USING (customer_id);

## What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT DISTINCT
    customer.customer_id,
    CONCAT(first_name, ' ', last_name) AS Name,
    email,
    ROUND(AVG(amount), 2) AS 'Avg. Payment'
FROM
    payment
        INNER JOIN
    customer USING (customer_id)
GROUP BY customer_id;


## What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
## Write the query using multiple join statements

SELECT 
    first_name, last_name, email, category_id
FROM
    rental AS rent
        INNER JOIN
    customer AS cust ON rent.customer_id = cust.customer_id
        INNER JOIN
    inventory USING (inventory_id)
        INNER JOIN
    film_category USING (film_id)
WHERE
    category_id = 1;

## Write the query using sub queries with multiple WHERE clause and IN condition

select * from rental inner join customer using (customer_id);


SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name, email
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            rental
        WHERE
            inventory_id IN (SELECT 
                    inventory_id
                FROM
                    inventory
                WHERE
                    film_id IN (SELECT 
                            film_id
                        FROM
                            film_category
                        WHERE
                            category_id IN (SELECT 
                                    category_id
                                FROM
                                    category
                                WHERE
                                    name = 'Action'))));
                                    


/* Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, 
then it should be high.*/

SELECT 
    *,
    CASE
        WHEN amount <= 2 THEN 'Low Value'
        WHEN amount > 2 AND amount < 4 THEN 'Medium Value'
        ELSE 'High Value'
    END AS Classifying
FROM
    payment;















