-- ============================================================================
-- EJEMPLOS DE FUNCIONES DE VENTANA EN SQL
-- ============================================================================
-- 
-- Las funciones de ventana permiten realizar cálculos sobre un conjunto de
-- filas relacionadas sin necesidad de GROUP BY tradicional.
--
-- Sintaxis general:
-- FUNCTION_NAME(column) OVER (
--     [PARTITION BY column]
--     [ORDER BY column [ASC|DESC]]
--     [ROWS BETWEEN ... AND ...]
-- )
--
-- ============================================================================

-- 1. ROW_NUMBER: Asigna un número único a cada fila
-- ============================================================================

-- Ejemplo 1.1: Numerar empleados por departamento (ordenados por salario DESC)
SELECT
    employee_id,
    name,
    department,
    salary,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS salary_rank
FROM employees
ORDER BY department, salary_rank;

-- Ejemplo 1.2: Obtener el empleado con mayor salario por departamento
SELECT *
FROM (
    SELECT
        employee_id,
        name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn = 1;


-- 2. RANK y DENSE_RANK: Ranking con empates
-- ============================================================================

-- RANK: Si hay empates, deja huecos en la numeración (1, 1, 3, 4...)
-- DENSE_RANK: Si hay empates, NO deja huecos (1, 1, 2, 3...)

-- Ejemplo 2.1: Ranking de salarios por departamento (con empates)
SELECT
    employee_id,
    name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank
FROM employees
ORDER BY department, salary DESC;


-- 3. LAG y LEAD: Acceder a filas anteriores/posteriores
-- ============================================================================

-- LAG: Accede a la fila ANTERIOR
-- LEAD: Accede a la fila POSTERIOR

-- Ejemplo 3.1: Comparar salario actual vs salario anterior (dentro del departamento)
SELECT
    employee_id,
    name,
    department,
    salary,
    LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) AS previous_salary,
    salary - LAG(salary) OVER (PARTITION BY department ORDER BY hire_date) AS difference
FROM employees
ORDER BY department, hire_date;

-- Ejemplo 3.2: Tendencia de ventas mes a mes
SELECT
    year,
    month,
    amount,
    LAG(amount) OVER (ORDER BY year, month) AS previous_month,
    amount - LAG(amount) OVER (ORDER BY year, month) AS change
FROM (
    SELECT year, month, SUM(amount) AS amount
    FROM sales
    GROUP BY year, month
    ORDER BY year, month
) monthly_sales;


-- 4. FIRST_VALUE y LAST_VALUE: Primer y último valor en la ventana
-- ============================================================================

-- Ejemplo 4.1: Mostrar primer y último salario en cada departamento
SELECT
    employee_id,
    name,
    department,
    salary,
    FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary) AS min_salary,
    LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS max_salary
FROM employees
ORDER BY department, salary;


-- 5. SUM/AVG/COUNT OVER: Agregaciones con ventana
-- ============================================================================

-- Ejemplo 5.1: Salario vs promedio de departamento
SELECT
    employee_id,
    name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary,
    salary - AVG(salary) OVER (PARTITION BY department) AS difference_from_avg
FROM employees
ORDER BY department, salary DESC;

-- Ejemplo 5.2: Total acumulado de ventas (running total)
SELECT
    sale_id,
    employee_id,
    sale_date,
    amount,
    SUM(amount) OVER (ORDER BY sale_date) AS cumulative_total
FROM sales
ORDER BY sale_date;

-- Ejemplo 5.3: Total acumulado POR EMPLEADO
SELECT
    sale_id,
    employee_id,
    sale_date,
    amount,
    SUM(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS employee_cumulative
FROM sales
ORDER BY employee_id, sale_date;

-- Ejemplo 5.4: Promedio móvil (3 últimas ventas)
SELECT
    sale_id,
    employee_id,
    sale_date,
    amount,
    AVG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM sales
ORDER BY employee_id, sale_date;


-- 6. NTILE: Dividir en N partes iguales
-- ============================================================================

-- Ejemplo 6.1: Dividir empleados en 4 cuartiles por salario
SELECT
    employee_id,
    name,
    salary,
    NTILE(4) OVER (ORDER BY salary) AS salary_quartile
FROM employees
ORDER BY salary DESC;

-- Ejemplo 6.2: Dividir vendedores en mejores/peores (2 grupos)
SELECT
    employee_id,
    SUM(amount) AS total_sales,
    NTILE(2) OVER (ORDER BY SUM(amount)) AS performance_group
FROM sales
GROUP BY employee_id
ORDER BY total_sales DESC;


-- 7. PERCENT_RANK y CUME_DIST: Percentiles
-- ============================================================================

-- PERCENT_RANK: Posición en porcentaje (0-1)
-- CUME_DIST: Distribución acumulada

-- Ejemplo 7.1: ¿En qué percentil está cada empleado?
SELECT
    employee_id,
    name,
    salary,
    PERCENT_RANK() OVER (ORDER BY salary) AS salary_percentile,
    CUME_DIST() OVER (ORDER BY salary) AS cumulative_dist
FROM employees
ORDER BY salary DESC;


-- 8. CASOS DE USO COMPLEJOS
-- ============================================================================

-- Ejemplo 8.1: Comparar desempeño actual vs año anterior
SELECT
    e.employee_id,
    e.name,
    s.year,
    SUM(s.amount) AS yearly_sales,
    LAG(SUM(s.amount)) OVER (PARTITION BY e.employee_id ORDER BY s.year) AS previous_year_sales,
    SUM(s.amount) - LAG(SUM(s.amount)) OVER (PARTITION BY e.employee_id ORDER BY s.year) AS yoy_change
FROM employees e
LEFT JOIN sales s ON e.employee_id = s.employee_id
GROUP BY e.employee_id, e.name, s.year
ORDER BY e.employee_id, s.year;

-- Ejemplo 8.2: Rangos de desempeño en evaluaciones
SELECT
    e.name,
    e.department,
    r.review_date,
    r.rating,
    RANK() OVER (PARTITION BY r.review_date ORDER BY r.rating DESC) AS rank_on_date,
    DENSE_RANK() OVER (PARTITION BY e.department ORDER BY r.rating DESC) AS dept_rank
FROM employees e
LEFT JOIN performance_reviews r ON e.employee_id = r.employee_id
ORDER BY r.review_date, rank_on_date;

-- Ejemplo 8.3: Detectar cambios significativos en ventas
SELECT
    employee_id,
    sale_date,
    amount,
    LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS prev_amount,
    CASE
        WHEN LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) IS NULL THEN 'Primera venta'
        WHEN amount > LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) * 1.5 THEN 'Incremento notable'
        WHEN amount < LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) * 0.5 THEN 'Decremento notable'
        ELSE 'Normal'
    END AS change_type
FROM sales
ORDER BY employee_id, sale_date;

-- Ejemplo 8.4: Análisis de proyectos (quién más horas trabaja)
SELECT
    p.project_name,
    a.employee_id,
    e.name,
    a.role,
    a.hours_allocated,
    SUM(a.hours_allocated) OVER (PARTITION BY p.project_id) AS total_project_hours,
    ROUND(100.0 * a.hours_allocated / SUM(a.hours_allocated) OVER (PARTITION BY p.project_id), 2) AS percent_of_project
FROM projects p
JOIN project_assignments a ON p.project_id = a.project_id
JOIN employees e ON a.employee_id = e.employee_id
ORDER BY p.project_name, a.hours_allocated DESC;


-- 9. EJERCICIOS PARA PRACTICAR
-- ============================================================================

-- EJERCICIO 1: ¿Cuál es la diferencia de salario entre el empleado mejor
-- y peor pagado en cada departamento?
-- (Pista: FIRST_VALUE + LAST_VALUE)

-- EJERCICIO 2: Obtén el TOP 3 de vendedores por región en 2024
-- (Pista: ROW_NUMBER + PARTITION BY + WHERE)

-- EJERCICIO 3: Calcula el promedio móvil de 6 meses de ventas
-- (Pista: AVG + ROWS BETWEEN)

-- EJERCICIO 4: Identifica empleados cuyas ventas caen más del 20% respecto
-- al mes anterior
-- (Pista: LAG + Case When)

-- EJERCICIO 5: Crea un ranking de departamentos por salario promedio
-- (Pista: RANK OVER + GROUP BY)

-- ============================================================================

-- 10. CTEs (Common Table Expressions) - WITH
-- ============================================================================
-- 
-- Un CTE es una "tabla temporal" que defines antes de tu consulta principal.
-- Te permite hacer queries más legibles y reutilizables.
--
-- Sintaxis:
-- WITH nombre_cte AS (
--     SELECT ... FROM ...
-- )
-- SELECT * FROM nombre_cte;
--

-- Ejemplo 10.1: CTE simple - Empleados de alto salario
WITH high_earners AS (
    SELECT 
        employee_id,
        name,
        department,
        salary
    FROM employees
    WHERE salary > 50000
)
SELECT 
    department,
    COUNT(*) AS high_earners_count,
    AVG(salary) AS avg_salary
FROM high_earners
GROUP BY department
ORDER BY avg_salary DESC;


-- Ejemplo 10.2: CTE con funciones de ventana - Ranking de vendedores
WITH sales_summary AS (
    SELECT
        e.employee_id,
        e.name,
        e.department,
        SUM(s.amount) AS total_sales,
        RANK() OVER (PARTITION BY e.department ORDER BY SUM(s.amount) DESC) AS dept_rank
    FROM employees e
    LEFT JOIN sales s ON e.employee_id = s.employee_id
    GROUP BY e.employee_id, e.name, e.department
)
SELECT *
FROM sales_summary
WHERE dept_rank <= 3
ORDER BY department, dept_rank;


-- Ejemplo 10.3: MÚLTIPLES CTEs (encadenadas)
WITH sales_by_employee AS (
    -- CTE 1: Calcular total de ventas por empleado
    SELECT
        employee_id,
        SUM(amount) AS total_sales,
        COUNT(*) AS transaction_count
    FROM sales
    GROUP BY employee_id
),
employee_details AS (
    -- CTE 2: Enriquecer con info del empleado
    SELECT
        e.employee_id,
        e.name,
        e.department,
        sbe.total_sales,
        sbe.transaction_count
    FROM employees e
    LEFT JOIN sales_by_employee sbe ON e.employee_id = sbe.employee_id
)
SELECT
    department,
    COUNT(*) AS emp_count,
    SUM(total_sales) AS dept_total,
    AVG(total_sales) AS avg_sales_per_emp,
    MAX(total_sales) AS top_seller
FROM employee_details
GROUP BY department
ORDER BY dept_total DESC;


-- Ejemplo 10.4: CTE con análisis de tendencias
WITH monthly_sales AS (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        SUM(amount) AS monthly_total
    FROM sales
    GROUP BY year, month
),
sales_with_trend AS (
    SELECT
        year,
        month,
        monthly_total,
        LAG(monthly_total) OVER (ORDER BY year, month) AS prev_month_total,
        monthly_total - LAG(monthly_total) OVER (ORDER BY year, month) AS month_over_month_change,
        ROUND(100.0 * (monthly_total - LAG(monthly_total) OVER (ORDER BY year, month)) / 
              LAG(monthly_total) OVER (ORDER BY year, month), 2) AS percent_change
    FROM monthly_sales
)
SELECT *
FROM sales_with_trend
WHERE percent_change IS NOT NULL
ORDER BY year, month;


-- Ejemplo 10.5: CTE con CASE para categorización
WITH categorized_employees AS (
    SELECT
        employee_id,
        name,
        salary,
        CASE
            WHEN salary < 30000 THEN 'Junior'
            WHEN salary BETWEEN 30000 AND 50000 THEN 'Mid-Level'
            WHEN salary > 50000 THEN 'Senior'
        END AS seniority_level
    FROM employees
)
SELECT
    seniority_level,
    COUNT(*) AS emp_count,
    AVG(salary) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary
FROM categorized_employees
GROUP BY seniority_level
ORDER BY avg_salary DESC;


-- Ejemplo 10.6: CTE recursiva (para jerarquías - avanzado)
-- Nota: Este es un ejemplo más complejo
WITH ranked_sales AS (
    SELECT
        employee_id,
        name,
        department,
        SUM(amount) AS total_sales,
        ROW_NUMBER() OVER (ORDER BY SUM(amount) DESC) AS global_rank,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY SUM(amount) DESC) AS dept_rank
    FROM employees e
    LEFT JOIN sales s ON e.employee_id = s.employee_id
    GROUP BY e.employee_id, e.name, e.department
)
SELECT
    global_rank,
    name,
    department,
    total_sales,
    dept_rank,
    CASE
        WHEN dept_rank = 1 THEN '🥇 Top Seller'
        WHEN dept_rank = 2 THEN '🥈 2nd Place'
        WHEN dept_rank = 3 THEN '🥉 3rd Place'
        ELSE 'Regular'
    END AS badge
FROM ranked_sales
WHERE global_rank <= 10
ORDER BY global_rank;


-- Ejemplo 10.7: CTE para detectar anomalías
WITH sale_statistics AS (
    SELECT
        employee_id,
        AVG(amount) AS avg_sale,
        STDDEV(amount) AS std_dev,
        MAX(amount) AS max_sale,
        MIN(amount) AS min_sale
    FROM sales
    GROUP BY employee_id
),
anomaly_detection AS (
    SELECT
        s.sale_id,
        s.employee_id,
        e.name,
        s.amount,
        ss.avg_sale,
        ss.std_dev,
        CASE
            WHEN s.amount > (ss.avg_sale + 2 * ss.std_dev) THEN 'Anomalía Alta'
            WHEN s.amount < (ss.avg_sale - 2 * ss.std_dev) THEN 'Anomalía Baja'
            ELSE 'Normal'
        END AS anomaly_type
    FROM sales s
    JOIN employees e ON s.employee_id = e.employee_id
    JOIN sale_statistics ss ON s.employee_id = ss.employee_id
)
SELECT *
FROM anomaly_detection
WHERE anomaly_type != 'Normal'
ORDER BY employee_id, sale_date DESC;


-- ============================================================================

-- 11. CTEs EJERCICIOS PARA PRACTICAR
-- ============================================================================

-- EJERCICIO CTE 1: Crear un CTE con el promedio de ventas por empleado,
-- luego mostrar solo los que están ARRIBA del promedio general
-- (Pista: Dos CTEs: una para promedio general, otra para empleados)

-- EJERCICIO CTE 2: Usar un CTE para rankear proyectos por presupuesto,
-- luego obtener los 5 proyectos más caros

-- EJERCICIO CTE 3: Crear un CTE que calcule:
-- - Total de ventas por departamento
-- - Promedio por departamento
-- - % respecto al total
-- (Pista: Dos CTEs encadenadas)

-- EJERCICIO CTE 4: Combina funciones de ventana + CTE:
-- CTE1: Calcular ranking de empleados por salario
-- CTE2: Filtrar top 10
-- Query principal: Mostrar info completa con comparativa al promedio

-- ============================================================================

-- 12. FUNCIONES DE MANEJO DE TIEMPO (DATE/TIME FUNCTIONS)
-- ============================================================================
--
-- PostgreSQL ofrece funciones poderosas para trabajar con fechas y horas.
-- Son esenciales para análisis temporal, reportes de período, y comparativas.
--
-- Funciones principales:
-- - EXTRACT(): Extrae partes específicas de una fecha (año, mes, día, hora, etc.)
-- - DATE_TRUNC(): Trunca una fecha a un intervalo específico (mes, trimestre, año, etc.)
-- - DATE_PART(): Similar a EXTRACT, sintaxis alternativa
-- - AGE(): Calcula la diferencia entre dos fechas
-- - INTERVAL: Suma/resta tiempo a una fecha
-- - CURRENT_DATE, CURRENT_TIMESTAMP: Fecha/hora actual
-- - TO_CHAR(): Formatea fecha a texto
-- - TO_DATE(): Convierte texto a fecha

-- Ejemplo 12.1: EXTRACT - Descomponer fechas en partes
SELECT
    name,
    hire_date,
    EXTRACT(YEAR FROM hire_date) AS hire_year,
    EXTRACT(MONTH FROM hire_date) AS hire_month,
    EXTRACT(DAY FROM hire_date) AS hire_day,
    EXTRACT(QUARTER FROM hire_date) AS hire_quarter,
    EXTRACT(DOW FROM hire_date) AS day_of_week  -- 0=Domingo, 6=Sábado
FROM employees
ORDER BY hire_date DESC
LIMIT 10;


-- Ejemplo 12.2: DATE_TRUNC - Agrupar por períodos
-- Útil para agregaciones por mes, trimestre, año
SELECT
    DATE_TRUNC('month', sale_date)::DATE AS month_start,
    TO_CHAR(DATE_TRUNC('month', sale_date), 'Month YYYY') AS month_name,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_sale
FROM sales
GROUP BY DATE_TRUNC('month', sale_date)
ORDER BY month_start DESC;


-- Ejemplo 12.3: AGE - Calcular diferencia entre fechas
-- Retorna un INTERVAL (días, horas, minutos, segundos)
SELECT
    name,
    hire_date,
    AGE(CURRENT_DATE, hire_date) AS tenure,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS years_employed,
    EXTRACT(DAY FROM AGE(CURRENT_DATE, hire_date)) AS days_employed
FROM employees
ORDER BY hire_date ASC
LIMIT 5;


-- Ejemplo 12.4: INTERVAL - Suma/resta tiempo
-- Cálculos de fechas futuras o pasadas
SELECT
    name,
    hire_date,
    hire_date + INTERVAL '1 year' AS one_year_anniversary,
    hire_date + INTERVAL '6 months' AS six_month_review,
    hire_date + INTERVAL '30 days' AS first_month_check,
    CURRENT_DATE - INTERVAL '7 days' AS last_week
FROM employees
LIMIT 5;


-- Ejemplo 12.5: TO_CHAR - Formatear fechas como texto
-- Muy útil para reportes y legibilidad
SELECT
    name,
    hire_date,
    TO_CHAR(hire_date, 'DD/MM/YYYY') AS formatted_dmy,
    TO_CHAR(hire_date, 'YYYY-MM-DD') AS formatted_iso,
    TO_CHAR(hire_date, 'Day, Month DD, YYYY') AS formatted_long,
    TO_CHAR(hire_date, 'Dy Mon YYYY') AS formatted_short
FROM employees
LIMIT 5;


-- Ejemplo 12.6: Análisis de ventas por hora del día
-- Extrae hora de timestamp para análisis temporal detallado
SELECT
    EXTRACT(HOUR FROM sale_date) AS sale_hour,
    TO_CHAR(sale_date, 'HH24:00') AS hour_label,
    COUNT(*) AS transaction_count,
    SUM(amount) AS hourly_total,
    AVG(amount) AS avg_sale,
    MIN(amount) AS min_sale,
    MAX(amount) AS max_sale
FROM sales
GROUP BY EXTRACT(HOUR FROM sale_date), TO_CHAR(sale_date, 'HH24:00')
ORDER BY sale_hour ASC;


-- Ejemplo 12.7: Comparación de períodos (Año Anterior vs Actual)
-- Patrón común: comparar mismo período en años diferentes
WITH sales_with_period AS (
    SELECT
        sale_date,
        EXTRACT(YEAR FROM sale_date) AS sale_year,
        EXTRACT(MONTH FROM sale_date) AS sale_month,
        EXTRACT(DAY FROM sale_date) AS sale_day,
        amount
    FROM sales
)
SELECT
    sale_month,
    sale_day,
    SUM(CASE WHEN sale_year = 2023 THEN amount ELSE 0 END) AS sales_2023,
    SUM(CASE WHEN sale_year = 2024 THEN amount ELSE 0 END) AS sales_2024,
    SUM(CASE WHEN sale_year = 2025 THEN amount ELSE 0 END) AS sales_2025,
    SUM(CASE WHEN sale_year = 2024 THEN amount ELSE 0 END) - 
    SUM(CASE WHEN sale_year = 2023 THEN amount ELSE 0 END) AS growth_2024_vs_2023
FROM sales_with_period
GROUP BY sale_month, sale_day
ORDER BY sale_month, sale_day;


-- Ejemplo 12.8: Identificar ventas en fin de semana vs entre semana
-- Útil para análisis de patrones de consumo
SELECT
    TO_CHAR(sale_date, 'Day') AS day_name,
    EXTRACT(DOW FROM sale_date) AS day_of_week,
    CASE 
        WHEN EXTRACT(DOW FROM sale_date) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS transaction_count,
    SUM(amount) AS total_sales,
    AVG(amount) AS avg_sale
FROM sales
GROUP BY TO_CHAR(sale_date, 'Day'), EXTRACT(DOW FROM sale_date)
ORDER BY EXTRACT(DOW FROM sale_date) ASC;


-- Ejemplo 12.9: Cálculo de antiguedad y bandas de antigüedad
-- Clasificar empleados por años de servicio
SELECT
    name,
    department,
    hire_date,
    ROUND(EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date))::NUMERIC, 1) AS years_tenure,
    CASE
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) < 1 THEN 'Nuevo (<1 año)'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) < 3 THEN '1-3 años'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) < 5 THEN '3-5 años'
        WHEN EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) < 10 THEN '5-10 años'
        ELSE '10+ años'
    END AS tenure_band,
    RANK() OVER (ORDER BY hire_date ASC) AS seniority_rank
FROM employees
ORDER BY hire_date ASC;


-- Ejemplo 12.10: Calcular ventanas de tiempo deslizantes
-- Ventas de los últimos 30, 60 y 90 días
WITH date_ranges AS (
    SELECT
        employee_id,
        SUM(CASE WHEN sale_date >= CURRENT_DATE - INTERVAL '30 days' THEN amount ELSE 0 END) AS sales_last_30d,
        SUM(CASE WHEN sale_date >= CURRENT_DATE - INTERVAL '60 days' THEN amount ELSE 0 END) AS sales_last_60d,
        SUM(CASE WHEN sale_date >= CURRENT_DATE - INTERVAL '90 days' THEN amount ELSE 0 END) AS sales_last_90d,
        MAX(sale_date) AS last_sale_date
    FROM sales
    GROUP BY employee_id
)
SELECT
    e.name,
    e.department,
    dr.sales_last_30d,
    dr.sales_last_60d,
    dr.sales_last_90d,
    dr.last_sale_date,
    CASE 
        WHEN dr.last_sale_date IS NULL THEN 'Inactivo'
        WHEN dr.last_sale_date >= CURRENT_DATE - INTERVAL '7 days' THEN 'Activo'
        WHEN dr.last_sale_date >= CURRENT_DATE - INTERVAL '30 days' THEN 'Moderadamente activo'
        ELSE 'Poco activo'
    END AS activity_status
FROM employees e
LEFT JOIN date_ranges dr ON e.employee_id = dr.employee_id
ORDER BY dr.sales_last_30d DESC NULLS LAST;


-- ============================================================================

-- 13. FUNCIONES DE TIEMPO - EJERCICIOS PARA PRACTICAR
-- ============================================================================

-- EJERCICIO TIEMPO 1: Calcular para cada empleado:
-- - Fecha de contratación original
-- - Próximo aniversario (en 1 año desde hoy)
-- - Días que faltan para su próximo aniversario
-- - Categorizar por meses restantes (< 1 mes, 1-3 meses, 3-6 meses, 6+ meses)

-- EJERCICIO TIEMPO 2: Análisis de patrones de ventas por trimestre:
-- - Total de ventas por trimestre por departamento
-- - Comparar T1, T2, T3, T4
-- - Mostrar en formato: "Q1 2024: $50,000"

-- EJERCICIO TIEMPO 3: Crear un reporte de "Tendencia de contratación":
-- - Contar cuántos empleados fueron contratados por año
-- - Calcular el mes promedio de contratación para cada año
-- - Mostrar año, mes de contratación, cantidad, promedio de salario

-- EJERCICIO TIEMPO 4: Identificar empleados con "próximas fechas importantes":
-- - Mostrar empleados cuyo aniversario es en los próximos 30 días
-- - Incluir nombre, departamento, años trabajados, próximo aniversario
-- - Ordenar por proximidad de fecha

-- EJERCICIO TIEMPO 5: Análisis de "edad" de las ventas:
-- - Categorizar ventas por antigüedad: < 7 días, 7-30 días, 30-90 días, 90+ días
-- - Contar y sumar por categoría
-- - Mostrar distribución de ventas recientes vs antiguas

-- ============================================================================
