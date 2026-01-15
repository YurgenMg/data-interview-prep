/* OBJETIVO: Análisis de Tendencias y Acumulados (Year-to-Date)
    NIVEL: Senior / Staff
*/

-- 1. CTE para limpiar y agregar datos diarios (evita repetir código)
WITH VentasDiarias AS (
    SELECT 
        category,
        date::DATE as venta_fecha, -- Casteamos a DATE para quitar la hora
        SUM(amount) as total_dia
    FROM sales_data
    WHERE status = 'Completed' -- Filtramos solo ventas reales
    GROUP BY category, date::DATE
)

-- 2. Consulta Principal usando Window Functions
SELECT 
    category,
    venta_fecha,
    total_dia,
    
    -- a) Promedio Móvil de 7 días (Moving Average)
    -- Nos dice la tendencia suavizada, eliminando picos diarios.
    AVG(total_dia) OVER (
        PARTITION BY category 
        ORDER BY venta_fecha 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as tendencia_semanal,

    -- b) Total Acumulado (Running Total)
    -- Nos dice cuánto llevamos vendido hasta la fecha en esa categoría.
    SUM(total_dia) OVER (
        PARTITION BY category 
        ORDER BY venta_fecha
    ) as acumulado_historico

FROM VentasDiarias
ORDER BY category, venta_fecha DESC;