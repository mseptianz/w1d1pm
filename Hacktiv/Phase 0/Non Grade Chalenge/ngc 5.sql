CREATE TABLE customers(
	id SERIAL PRIMARY KEY,
	customer_id INTEGER,
	customer_name VARCHAR(50),
	city VARCHAR(50)
);

CREATE TABLE orders(
	id SERIAL PRIMARY KEY,
	order_id INTEGER,
	customer_id INTEGER,
	order_date TIMESTAMP,
	total_amount FLOAT
);

DROP TABLE orders

INSERT INTO orders (order_id, customer_id,order_date,total_amount)
VALUES
	(1,1,'2022-01-10',100.00),
	(2,1,'2022-02-15',150.00),
	(3,2,'2022-03-20',200.00),
	(4,3,'2022-04-25',50.00);

SELECT * FROM orders
SELECT * FROM customers

INSERT INTO customers(customer_id,customer_name,city)
VALUES 
	(1,'John Doe','New York'),
	(2,'Jane Smith', 'Los Angeles'),
	(3,'David Jonshon','Chicago');

SELECT 
	c.customer_name,
	COUNT(o.order_id) AS total_order
FROM customers AS c
LEFT JOIN 
	orders AS o ON c.customer_id = o.customer_id
GROUP BY
	c.customer_name
