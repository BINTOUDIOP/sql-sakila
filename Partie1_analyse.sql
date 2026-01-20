  Projet Bintou DIOP
-- 1ère partie : Base de données Sakila


-- 1. Les films dont le titre contient "ace"
SELECT title
FROM film
WHERE title LIKE '%ace%';

-- 2. Les films de plus de 120 minutes, triés par durée décroissante
SELECT title, length
FROM film
WHERE length > 120
ORDER BY length DESC;

-- 3. Titres de films en anglais mis à jour après 2006
SELECT f.title
FROM film f
JOIN language l ON f.language_id = l.language_id
WHERE l.name = 'English'
  AND f.last_update > '2006-01-31';

-- 4. Titre, catégorie et langue de chaque film
SELECT f.title, c.name AS category, l.name AS language
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id;

-- 5. Les 10 films les plus loués
SELECT f.title, COUNT(r.rental_id) AS nb_locations
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY nb_locations DESC
LIMIT 10;

-- 6. Revenu total par film
SELECT f.title, SUM(p.amount) AS revenu_total
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title;

-- 7. Films dont la durée est supérieure à la moyenne
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 8. Films "Action", "Comedy" ou "Drama" loués plus de 50 fois
SELECT f.title, c.name AS category, COUNT(r.rental_id) AS nb_locations
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Action', 'Comedy', 'Drama')
GROUP BY f.title, c.name
HAVING COUNT(r.rental_id) > 50;

-- 9. Les 5 clients les plus rentables
SELECT c.first_name, c.last_name, c.email, ci.city, SUM(p.amount) AS total_paye
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.email, ci.city
ORDER BY total_paye DESC
LIMIT 5;

-- 10. Clients ayant encore un DVD non retourné
SELECT DISTINCT c.first_name, c.last_name, a.phone, c.email, f.title
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
WHERE r.return_date IS NULL;

-- 11. Ventes mensuelles par magasin en 2005
SELECT s.store_id, DATE_FORMAT(p.payment_date, '%Y%m') AS mois, SUM(p.amount) AS total
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY s.store_id, mois
ORDER BY s.store_id, mois;

-- 12. Montant encaissé par employé en juin 2005
SELECT s.staff_id, SUM(p.amount) AS total_juin
FROM payment p
JOIN staff s ON p.staff_id = s.staff_id
WHERE DATE_FORMAT(p.payment_date, '%Y-%m') = '2005-06'
GROUP BY s.staff_id;

-- 13. Vue top_films_2005
CREATE VIEW top_films_2005 AS
SELECT f.title, SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
WHERE YEAR(p.payment_date) = 2005
GROUP BY f.title
ORDER BY total_revenue DESC
LIMIT 20;

-- 14. Vue vip_clients
CREATE VIEW vip_clients AS
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS total_paye
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(p.amount) > 200;

-- 15. Insérer et supprimer un acteur fictif
INSERT INTO actor (first_name, last_name, last_update)
VALUES ('Fictif', 'Acteur', NOW());

DELETE FROM actor
WHERE first_name = 'Fictif' AND last_name = 'Acteur';

-- 16. DVD en circulation sans retour prévu
SELECT f.title, c.first_name, c.last_name, a.phone, a.address
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
WHERE r.return_date IS NULL;

