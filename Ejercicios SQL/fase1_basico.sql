/*🟢 Fase 1: Calentamiento (Nivel Básico)
Objetivo: Validar sintaxis fundamental (SELECT, WHERE, ORDER BY, AGGREGATES).
10 Ejercicios SQL sencillos para practicar consultas básicas.
    1.Listado de Correos: Obtén una lista de todos los correos electrónicos de los clientes (customer) que están "activos" (active = 1).

Salida Esperada: Una columna email con cientos de direcciones (ej: mary.smith@sakilacustomer.org).*/

/*
SELECT email
FROM customer
WHERE active = 1;*/

-- ============================================================================
/*
    2.Clasificación de Películas: Encuentra los títulos de películas (film) que tienen una clasificación (rating) de 'PG-13' y duran más de 120 minutos.

Salida Esperada: Dos columnas: title y length. Solo películas largas y PG-13.

SELECT title, rating, length
FROM film
WHERE rating = 'PG-13' AND length > 120
ORDER BY title, length DESC;
*/

-- ============================================================================
/*
    3.Costos de Reemplazo: ¿Cuáles son los costos de reemplazo (replacement_cost) únicos/distintos que existen en la tabla de películas? Ordénalos del más barato al más caro.

Salida Esperada: Una columna replacement_cost con valores numéricos ordenados (ej: 9.99, 10.99, ...).

SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost ASC;*/

-- ============================================================================

--    4.Conteo por Rating: ¿Cuántas películas existen para cada tipo de clasificación (rating)?

--Salida Esperada: Dos columnas: rating (G, PG, R...) y total_films (número entero).

--SELECT rating, COUNT(title) AS total_films
--FROM film
--GROUP BY rating
--ORDER BY total_films ASC;

-- ============================================================================

-- Últimos Pagos: Muestra los 10 últimos pagos realizados (payment) ordenados por fecha de pago.

-- Salida Esperada: Columnas como payment_id, amount, payment_date. Las fechas deben ser las más recientes de la base de datos.

SELECT payment_id, amount, payment_date
FROM payment
ORDER BY payment_date DESC, amount DESC
LIMIT 10;