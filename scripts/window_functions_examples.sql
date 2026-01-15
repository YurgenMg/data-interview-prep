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
