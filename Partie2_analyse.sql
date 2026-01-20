-- 8. Insertion dans deux tables liées
INSERT INTO [dbo].[Master] (id, name)
VALUES (1, 'Master Example');

INSERT INTO [dbo].[student] (student_id, student_name, city, subject_id, Master_id)
VALUES (2016, 'Test Student', 'Paris', 11, 1);

-- 9. Cours avec ≥ 3 étudiants
SELECT s.subject_name, COUNT(st.student_id) AS nb_etudiants
FROM subject s
JOIN student st ON s.subject_id = st.subject_id
GROUP BY s.subject_name
HAVING COUNT(st.student_id) >= 3;

-- 10. Orders où total > 400
SELECT order_id, customer_id, total
FROM orders
WHERE total > 400;

-- Total dépensé par client
SELECT customer_id, SUM(total) AS total_depense
FROM orders
GROUP BY customer_id
ORDER BY total_depense DESC;

-- 11. Total de quantités par produit
SELECT product_id, SUM(quantity) AS total_vendu
FROM order_items
GROUP BY product_id;

-- 12. Insertion des données de customer_orders
INSERT INTO Customers (name, address, city, country)
SELECT DISTINCT name, address, city, country
FROM customer_orders;

INSERT INTO Orders (customer_id, order_date, total)
SELECT c.id, co.order_date, co.total
FROM customer_orders co
JOIN Customers c ON co.name = c.name;

INSERT INTO OrderDetails (order_id, product, quantity, price)
SELECT o.id, co.product, co.quantity, co.price
FROM customer_orders co
JOIN Customers c ON co.name = c.name
JOIN Orders o ON o.customer_id = c.id AND o.order_date = co.order_date;