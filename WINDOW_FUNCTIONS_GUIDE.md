# 📚 Guía Práctica: Funciones de Ventana en SQL

## 🎯 ¿Qué son las funciones de ventana?

Las **funciones de ventana** te permiten hacer cálculos sobre un conjunto de filas SIN usar `GROUP BY`, manteniendo todas las filas en el resultado.

**Diferencia clave:**
- `GROUP BY`: Reduce filas, agrupa resultados
- Window Functions: Mantiene todas las filas originales

---

## 📊 Datos Disponibles para Practicar

Ya has cargado 5 tablas en tu BD:

### 1. **employees** (50 empleados)
```sql
SELECT * FROM employees LIMIT 5;
```
Campos: `employee_id`, `name`, `department`, `salary`, `hire_date`, `location`

### 2. **sales** (500 transacciones)
```sql
SELECT * FROM sales LIMIT 5;
```
Campos: `sale_id`, `employee_id`, `sale_date`, `amount`, `product`, `region`, `year`, `month`

### 3. **projects** (10 proyectos)
### 4. **project_assignments** (58 asignaciones)
### 5. **performance_reviews** (100 evaluaciones)

---

## 🚀 Funciones de Ventana - Resumen Rápido

| Función | Propósito | Ejemplo |
|---------|----------|---------|
| `ROW_NUMBER()` | Número único por fila | Ranking sin empates |
| `RANK()` | Ranking con empates | Posición (con huecos) |
| `DENSE_RANK()` | Ranking sin huecos | Posición (sin huecos) |
| `LAG()` | Fila anterior | Comparar con mes anterior |
| `LEAD()` | Fila siguiente | Predecir siguiente valor |
| `FIRST_VALUE()` | Primer valor | Mínimo en ventana |
| `LAST_VALUE()` | Último valor | Máximo en ventana |
| `SUM/AVG/COUNT()` | Agregaciones | Totales acumulados |

---

## 💡 Ejemplos Simples para Empezar

### Ejemplo 1: Numerar empleados por salario
```sql
SELECT
    name,
    department,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS rank
FROM employees
LIMIT 10;
```
**Resultado:** Cada empleado tiene un número único (1, 2, 3...)

---

### Ejemplo 2: Comparar salario vs promedio del departamento
```sql
SELECT
    name,
    department,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg,
    salary - AVG(salary) OVER (PARTITION BY department) AS diff
FROM employees
ORDER BY department, salary DESC;
```
**Resultado:** Ves cuánto gana cada uno vs el promedio de su departamento

---

### Ejemplo 3: Total acumulado de ventas
```sql
SELECT
    sale_date,
    amount,
    SUM(amount) OVER (ORDER BY sale_date) AS running_total
FROM sales
ORDER BY sale_date
LIMIT 20;
```
**Resultado:** Cada venta muestra el total acumulado hasta ese momento

---

### Ejemplo 4: Comparar con venta anterior
```sql
SELECT
    sale_date,
    amount,
    LAG(amount) OVER (ORDER BY sale_date) AS previous_sale,
    amount - LAG(amount) OVER (ORDER BY sale_date) AS change
FROM sales
ORDER BY sale_date
LIMIT 20;
```
**Resultado:** Ves si cada venta fue mayor o menor que la anterior

---

## 🔍 Cómo Ejecutar las Consultas

### Opción 1: Desde pgAdmin (GUI)
1. Ve a http://localhost:5050
2. Login: `admin@pgadmin.org` / `admin`
3. Navega a: Servers → PostgreSQL → analytics_playground → Query Tool
4. Pega la consulta SQL
5. Haz click en "Execute"

### Opción 2: Desde terminal
```bash
psql -h localhost -U admin_user -d analytics_playground
```
Luego pega la consulta

### Opción 3: Desde Python
```python
import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('postgresql://admin_user:secure_password_123@localhost:5432/analytics_playground')

query = """
SELECT
    name,
    salary,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg
FROM employees
"""

df = pd.read_sql(query, engine)
print(df)
```

---

## 📝 Ejercicios Prácticos

### EJERCICIO 1: Empleado mejor pagado por departamento
**Objetivo:** Obtén el nombre y salario del empleado mejor pagado en cada departamento

**Pista:** Usa `ROW_NUMBER()` + `PARTITION BY department` + `ORDER BY salary DESC`

**Solución:**
```sql
SELECT *
FROM (
    SELECT
        name,
        department,
        salary,
        ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS rn
    FROM employees
) ranked
WHERE rn = 1;
```

---

### EJERCICIO 2: Top 3 vendedores por total de ventas
**Objetivo:** ¿Cuáles son los 3 empleados con más ventas totales?

**Pista:** Usa `RANK()` + `SUM()` + `GROUP BY`

**Solución:**
```sql
SELECT *
FROM (
    SELECT
        e.name,
        SUM(s.amount) AS total_sales,
        RANK() OVER (ORDER BY SUM(s.amount) DESC) AS rank
    FROM employees e
    LEFT JOIN sales s ON e.employee_id = s.employee_id
    GROUP BY e.employee_id, e.name
) ranked
WHERE rank <= 3;
```

---

### EJERCICIO 3: Promedio móvil de ventas (últimos 3 registros)
**Objetivo:** Calcula el promedio de las últimas 3 ventas para cada empleado

**Pista:** Usa `AVG()` + `ROWS BETWEEN X PRECEDING AND CURRENT ROW`

**Solución:**
```sql
SELECT
    employee_id,
    sale_date,
    amount,
    AVG(amount) OVER (
        PARTITION BY employee_id
        ORDER BY sale_date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM sales
ORDER BY employee_id, sale_date;
```

---

### EJERCICIO 4: Detectar cambios significativos
**Objetivo:** Encuentra ventas que sean 50% mayor o menor que la anterior

**Pista:** Usa `LAG()` + `CASE WHEN`

**Solución:**
```sql
SELECT
    employee_id,
    sale_date,
    amount,
    LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) AS prev_amount,
    CASE
        WHEN LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) IS NULL THEN 'Primera'
        WHEN amount > LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) * 1.5 THEN 'Subió mucho'
        WHEN amount < LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) * 0.5 THEN 'Bajó mucho'
        ELSE 'Normal'
    END AS change_type
FROM sales
WHERE CASE
    WHEN LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) IS NULL THEN FALSE
    WHEN amount > LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) * 1.5 THEN TRUE
    WHEN amount < LAG(amount) OVER (PARTITION BY employee_id ORDER BY sale_date) * 0.5 THEN TRUE
    ELSE FALSE
END
ORDER BY employee_id, sale_date;
```

---

### EJERCICIO 5: Análisis de proyectos
**Objetivo:** Para cada proyecto, muestra cuántas horas trabaja cada empleado (% del total)

**Pista:** Usa `SUM()` OVER para dividir

**Solución:**
```sql
SELECT
    p.project_name,
    e.name,
    a.hours_allocated,
    SUM(a.hours_allocated) OVER (PARTITION BY p.project_id) AS project_total,
    ROUND(100.0 * a.hours_allocated / SUM(a.hours_allocated) OVER (PARTITION BY p.project_id), 2) AS percent
FROM projects p
JOIN project_assignments a ON p.project_id = a.project_id
JOIN employees e ON a.employee_id = e.employee_id
ORDER BY p.project_name, a.hours_allocated DESC;
```

---

## 🎓 Recursos Adicionales

- **Ver archivo:** `scripts/window_functions_examples.sql` (20+ ejemplos)
- **Documentación oficial:** https://www.postgresql.org/docs/current/functions-window.html
- **Tutoriales:** https://www.modo-labs.com/blog/window-functions

---

## ✅ Checklist para Practicar

- [ ] Ejecutar: Ejemplo 1 (Numerar empleados)
- [ ] Ejecutar: Ejemplo 2 (Salario vs promedio)
- [ ] Ejecutar: Ejemplo 3 (Total acumulado)
- [ ] Ejecutar: Ejemplo 4 (Comparar con anterior)
- [ ] Resolver: EJERCICIO 1
- [ ] Resolver: EJERCICIO 2
- [ ] Resolver: EJERCICIO 3
- [ ] Resolver: EJERCICIO 4
- [ ] Resolver: EJERCICIO 5
- [ ] Explorar: `window_functions_examples.sql`

---

## 💬 Preguntas Frecuentes

**P: ¿Cuál es la diferencia entre RANK y DENSE_RANK?**
R: Si hay empate en posición 1 (dos registros iguales):
- `RANK`: Siguiente es 3
- `DENSE_RANK`: Siguiente es 2

**P: ¿Cuándo usar LAG vs subconsultas?**
R: LAG es más eficiente y legible. Úsalo siempre que puedas.

**P: ¿Cómo sé qué ROWS usar?**
R: 
- `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` = últimas 3 filas
- `ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW` = desde inicio hasta ahora
- `ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING` = todas las filas

---

¡Ahora estás listo para practicar! 🚀 Empieza con los ejemplos simples y ve escalando hacia los ejercicios.
