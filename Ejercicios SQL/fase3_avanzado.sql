🔴 Fase 3: Maestría (Nivel Experto / Staff)
Objetivo: Window Functions, CTEs, Recursividad, Análisis de Cohortes y Optimización.

Acumulado de Ventas (Running Total): Calcula el total de dinero recaudado día a día, mostrando el ingreso del día y el acumulado histórico hasta esa fecha.

Salida Esperada: payment_date (solo día), daily_amount, running_total.

Top 3 Clientes por Tienda (Ranking): Para cada tienda, identifica a los 3 clientes que más han gastado. Debes usar RANK() o DENSE_RANK().

Salida Esperada: store_id, customer_name, total_spent, ranking (1, 2, 3).

Diferencia de Tiempo (Lag): Para un cliente específico (ej: ID 1), muestra cada una de sus rentas, la fecha de la renta, y una columna extra que muestre cuántos días pasaron desde su renta anterior.

Salida Esperada: rental_id, rental_date, days_since_last_rental.

Clientes "Acción y Comedia" (Intersección): Encuentra los clientes que han rentado películas de la categoría 'Action' Y TAMBIÉN de la categoría 'Comedy'.

Salida Esperada: customer_id, customer_name.

Tasa de Retención (Churn Risk): Identifica a los clientes que no han realizado ninguna renta en los últimos 3 meses (basado en la fecha máxima de la base de datos).

Salida Esperada: customer_id, last_rental_date, status (='Inactivo').

Películas por Actor (String Aggregation): Genera una lista donde cada fila sea un actor, y la segunda columna sea una lista separada por comas de todas sus películas.

Salida Esperada: actor_name, film_list (ej: "ADAPTATION HOLES, ATLANTIS CAUSE, ...").

Análisis ABC (Pareto): Clasifica las películas en A, B o C según sus ingresos generados. 'A' son el top 20% que más generan, 'B' el siguiente 30%, y 'C' el 50% restante. (Usa NTILE).

Salida Esperada: title, total_revenue, segmento_abc.

Crecimiento Mensual (MoM Growth): Calcula el porcentaje de crecimiento (o decrecimiento) de los ingresos comparado con el mes anterior.

Salida Esperada: mes, current_revenue, prev_month_revenue, growth_percentage.

Promedio Móvil de 7 días: Calcula el promedio de pagos recibidos en una ventana móvil de 7 días para suavizar la curva de ingresos.

Salida Esperada: payment_date, daily_revenue, moving_avg_7d.

Clientes Exclusivos: Encuentra clientes que SOLO han rentado películas con clasificación 'R' y ninguna otra clasificación.

Salida Esperada: customer_name.

Duración de Renta vs Límite: Compara el tiempo real que un cliente tuvo la película vs el rental_duration permitido. Muestra aquellos que se pasaron del tiempo y por cuántos días (Overdue).

Salida Esperada: customer_name, film_title, days_overdue.

Pivot Table (Cross Tab): Crea una consulta que muestre los ingresos totales por categoría, pero donde cada tienda sea una columna distinta.

Salida Esperada: category_name, store_1_revenue, store_2_revenue.

Pares de Actores (Self Join): Encuentra pares de actores que tengan el mismo apellido. Evita duplicados (A-B y B-A) y auto-emparejamientos.

Salida Esperada: actor_1_name, actor_2_name (ambos con el mismo apellido).

Jerarquía de Fechas (Drill Down): Agrupa las rentas por Año, Trimestre (QUARTER), Mes y Semana en una sola vista jerárquica (o usando ROLLUP).

Salida Esperada: year, quarter, month, total_rentals.

El "Santo Grial" (Consulta Maestra): Escribe una consulta que obtenga el cliente con el mayor "Lifetime Value" (LTV), su película favorita (la categoría que más renta) y su tienda preferida.

Salida Esperada: customer_name, total_lifetime_spent, favorite_category, preferred_store.