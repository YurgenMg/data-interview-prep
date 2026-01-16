

--🟡 Fase 2: Profundización (Nivel Intermedio)
--Objetivo: Dominar JOINS, GROUP BY complejos, manejo de fechas y lógica condicional CASE.
--Ingresos por Tienda: Calcula cuánto dinero total ha recaudado cada tienda (store), uniendo las tablas de staff (quien cobra) y payment.
--Salida Esperada: store_id y total_revenue (suma de montos).
SELECT sf.staff_id, CONCAT(sf.first_name, ' ', sf.last_name) AS Store_name, SUM(p.amount) AS total_revenue
FROM staff sf
JOIN payment p ON sf.staff_id = p.staff_id
GROUP BY sf.staff_id, Store_name
ORDER BY SUM(p.amount) DESC;
--Clientes sin Rentas: Encuentra si existen clientes en la base de datos que nunca hayan realizado una renta. (Pista: LEFT JOIN y buscar nulos).
--Salida Esperada: customer_id, first_name. (Si la base está limpia, podría venir vacía, pero la lógica es lo que importa).
SELECT c.customer_id, CONCAT(c.first_name,' ', c.last_name) AS customer_name
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_id IS NULL;
--Películas por Categoría: Muestra el nombre de cada categoría (category.name) y la cantidad de películas que pertenecen a ella.
--Salida Esperada: category_name (Action, Comedy...) y film_count.
SELECT c.name AS category_name, COUNT(fc.film_id) AS film_count
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
GROUP BY c.name
order BY COUNT(fc.film_id) DESC;
--El Actor más Popular: ¿Qué actor (actor) aparece en la mayor cantidad de películas? Necesitas unir actor, film_actor y agrupar.
--Salida Esperada: first_name, last_name, film_count (ordenado descendente, limit 1);
SELECT CONCAT(a.first_name, ' ', a.last_name) AS actor_name, COUNT(fa.actor_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY actor_name
ORDER BY COUNT(fa.actor_id) DESC
LIMIT 1;
--Etiquetado de Duración (CASE): Crea una consulta que liste los títulos de películas y una nueva columna llamada duracion_tipo que diga:
--'Corta' si dura < 60 min.
--'Media' si dura entre 60 y 100 min.
--'Larga' si dura > 100 min.
--Salida Esperada: title, length, duracion_tipo.;
SELECT 
    title, 
    length,
    CASE
        WHEN length < 60 THEN 'Corta'
        WHEN length BETWEEN 60 AND 100 THEN 'Media'
        WHEN length > 100 THEN 'Larga'
        ELSE 'Desconocida'
    END AS duracion_tipo
FROM film
ORDER BY title ASC;

--Ventas Mensuales (2005): Muestra el total de ventas (amount) agrupado por mes, pero solo para el año 2005.
--Salida Esperada: mes (número o nombre) y total_sales.

-- ✅ VERSIÓN OPTIMIZADA (más limpia y eficiente):
SELECT 
    EXTRACT(YEAR FROM payment_date) AS Year,
    EXTRACT(MONTH FROM payment_date) AS Month,
    TO_CHAR(payment_date, 'Month') AS Month_Name,
    SUM(amount) AS total_sales
FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = 2005
GROUP BY
    EXTRACT(YEAR FROM payment_date),
    EXTRACT(MONTH FROM payment_date),
    TO_CHAR(payment_date, 'Month')
ORDER BY 
    EXTRACT(MONTH FROM payment_date) ASC;

--Clientes de Alto Valor: Lista los clientes que han gastado más de $100 dólares en total en rentas.
--Salida Esperada: first_name, last_name, total_spent (filas solo con valores > 100).
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY customer_name
HAVING SUM(p.amount) > 100
ORDER BY SUM(p.amount) DESC;
--Inventario Agotado: Muestra qué películas (título) están registradas en el sistema (film) pero no tienen copias físicas en el inventario (inventory).
--Salida Esperada: title de las películas que faltan en stock.
SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL
ORDER BY F.title;
--Duración Promedio por Categoría: ¿Cuál es la duración promedio de las películas de cada categoría?
--Salida Esperada: category_name, avg_length.
SELECT c.name AS category_name, AVG(length) AS avg_length
FROM category c
JOIN film_category fc ON c.category_id = fc.category_id
JOIN film f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY AVG(length) DESC;

--Direcciones de Tiendas: Obtén la dirección completa (address, city, country) de cada una de las tiendas. Requiere múltiples JOINS.
--Salida Esperada: store_id, address, city, country.
SELECT
    CONCAT(sf.first_name, ' ', sf.last_name) AS store,
    CONCAT(a.address, ' ', a.address2) AS address,
    ci.city,
    co.country
FROM store s
JOIN staff sf ON s.store_id = sf.store_id
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
ORDER BY s.store_id;