/*
 OBJETIVO: Análisis de ventas acumuladas y ranking por categoría.
 TÉCNICAS: CTEs (Common Table Expressions) y Window Functions.
*/

WITH CategoryStats AS (
    -- Paso 1: Pre-agregar datos para limpiar el ruido
    SELECT 
        category,
        date,
        SUM(amount) as daily_sales
    FROM sales_data
    WHERE status = 'Completed' -- Filtramos devoluciones (Best Practice)
    GROUP BY category, date
)

SELECT 
    category,
    date,
    daily_sales,
    -- Calcula el promedio móvil de 7 días (Tendencia)
    AVG(daily_sales) OVER (
        PARTITION BY category 
        ORDER BY date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as avg_weekly_trend,
    -- Calcula el total acumulado por categoría (Year-to-Date simulado)
    SUM(daily_sales) OVER (
        PARTITION BY category 
        ORDER BY date
    ) as running_total
FROM CategoryStats
ORDER BY category, date DESC;