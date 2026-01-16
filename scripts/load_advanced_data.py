"""
Script para cargar datos complejos - Perfecto para practicar funciones de ventana.

Crea tablas realistas con:
- Empleados y salarios
- Departamentos
- Proyectos
- Asignaciones de empleados a proyectos
- Datos de ventas mensuales

Uso:
    python scripts/load_advanced_data.py
"""

import pandas as pd
import numpy as np
from sqlalchemy import create_engine, text
from datetime import datetime, timedelta

# Configuración
DB_URI = 'postgresql://admin_user:secure_password_123@localhost:5432/analytics_playground'

def create_employees_data(n_employees=50):
    """Generar datos de empleados."""
    print("📊 Generando datos de empleados...")
    
    departments = ['Ventas', 'TI', 'RRHH', 'Finanzas', 'Marketing', 'Operaciones']
    locations = ['Madrid', 'Barcelona', 'Valencia', 'Bilbao', 'Sevilla', 'Málaga']
    
    np.random.seed(42)
    
    data = {
        'employee_id': range(1001, 1001 + n_employees),
        'name': [f'Empleado_{i}' for i in range(1, n_employees + 1)],
        'department': np.random.choice(departments, n_employees),
        'salary': np.random.randint(20000, 80000, n_employees),
        'hire_date': [datetime(2015, 1, 1) + timedelta(days=int(x)) 
                     for x in np.random.rand(n_employees) * 3650],
        'location': np.random.choice(locations, n_employees),
    }
    
    return pd.DataFrame(data)

def create_sales_data(n_records=500):
    """Generar datos de ventas con fechas mensuales."""
    print("📈 Generando datos de ventas...")
    
    np.random.seed(42)
    
    # Empleados de ventas
    sales_employees = list(range(1001, 1021))  # 20 empleados de ventas
    
    # Fecha base
    base_date = datetime(2023, 1, 1)
    
    data = {
        'sale_id': range(5001, 5001 + n_records),
        'employee_id': np.random.choice(sales_employees, n_records),
        'sale_date': [base_date + timedelta(days=int(x)) 
                     for x in np.random.rand(n_records) * 730],
        'amount': np.random.randint(100, 50000, n_records),
        'product': np.random.choice(['Producto A', 'Producto B', 'Producto C', 'Producto D'], n_records),
        'region': np.random.choice(['Norte', 'Sur', 'Este', 'Oeste'], n_records),
    }
    
    df = pd.DataFrame(data)
    df['year'] = df['sale_date'].dt.year
    df['month'] = df['sale_date'].dt.month
    
    return df

def create_projects_data():
    """Generar datos de proyectos."""
    print("🎯 Generando datos de proyectos...")
    
    data = {
        'project_id': range(3001, 3011),
        'project_name': ['Proyecto Alpha', 'Proyecto Beta', 'Proyecto Gamma', 
                        'Proyecto Delta', 'Proyecto Epsilon', 'Proyecto Zeta',
                        'Proyecto Eta', 'Proyecto Theta', 'Proyecto Iota', 'Proyecto Kappa'],
        'budget': [50000, 75000, 100000, 60000, 80000, 120000, 90000, 70000, 110000, 65000],
        'start_date': pd.date_range(start='2023-01-01', periods=10, freq='M'),
        'status': np.random.choice(['En Progreso', 'Completado', 'En Pausa'], 10),
    }
    
    return pd.DataFrame(data)

def create_project_assignments():
    """Generar asignaciones de empleados a proyectos."""
    print("👥 Generando asignaciones de empleados a proyectos...")
    
    np.random.seed(42)
    
    assignments = []
    for emp_id in range(1001, 1031):  # 30 empleados
        n_projects = np.random.randint(1, 4)
        projects = np.random.choice(range(3001, 3011), n_projects, replace=False)
        
        for proj_id in projects:
            assignments.append({
                'assignment_id': len(assignments) + 1,
                'employee_id': emp_id,
                'project_id': proj_id,
                'role': np.random.choice(['Desarrollador', 'Líder', 'Asistente', 'Analista']),
                'hours_allocated': np.random.randint(10, 40),
            })
    
    return pd.DataFrame(assignments)

def create_performance_reviews():
    """Generar datos de evaluaciones de desempeño."""
    print("⭐ Generando evaluaciones de desempeño...")
    
    np.random.seed(42)
    
    data = {
        'review_id': range(7001, 7101),
        'employee_id': np.random.choice(range(1001, 1051), 100),
        'review_date': pd.date_range(start='2023-01-01', periods=100, freq='W'),
        'rating': np.random.choice([1, 2, 3, 4, 5], 100),
        'reviewer_id': np.random.choice(range(1001, 1011), 100),  # Managers
        'comments': ['Excelente desempeño'] * 100,
    }
    
    return pd.DataFrame(data)

def load_to_postgres(engine, df, table_name, if_exists='replace'):
    """Cargar DataFrame a PostgreSQL."""
    print(f"  ↳ Cargando {table_name}...")
    df.to_sql(table_name, engine, if_exists=if_exists, index=False)
    print(f"  ✅ {len(df)} registros en {table_name}")

def main():
    """Función principal."""
    print("\n" + "="*60)
    print("🚀 CARGANDO DATOS PARA PRACTICAR CONSULTAS AVANZADAS")
    print("="*60 + "\n")
    
    try:
        # Conectar a BD
        print("🔗 Conectando a PostgreSQL...")
        engine = create_engine(DB_URI)
        
        # Generar datos
        df_employees = create_employees_data(50)
        df_sales = create_sales_data(500)
        df_projects = create_projects_data()
        df_assignments = create_project_assignments()
        df_reviews = create_performance_reviews()
        
        # Cargar datos
        print("\n📥 Cargando datos en PostgreSQL...\n")
        load_to_postgres(engine, df_employees, 'employees')
        load_to_postgres(engine, df_sales, 'sales')
        load_to_postgres(engine, df_projects, 'projects')
        load_to_postgres(engine, df_assignments, 'project_assignments')
        load_to_postgres(engine, df_reviews, 'performance_reviews')
        
        # Crear índices para mejor performance
        print("\n⚡ Creando índices...")
        with engine.connect() as conn:
            conn.execute(text("CREATE INDEX IF NOT EXISTS idx_sales_employee ON sales(employee_id)"))
            conn.execute(text("CREATE INDEX IF NOT EXISTS idx_sales_date ON sales(sale_date)"))
            conn.execute(text("CREATE INDEX IF NOT EXISTS idx_assignments_employee ON project_assignments(employee_id)"))
            conn.commit()
        print("  ✅ Índices creados\n")
        
        # Mostrar resumen
        print("="*60)
        print("✅ ¡DATOS CARGADOS EXITOSAMENTE!")
        print("="*60)
        print("\n📊 TABLAS DISPONIBLES PARA PRACTICAR:\n")
        print("  1. employees (50 registros)")
        print("     Campos: employee_id, name, department, salary, hire_date, location")
        print()
        print("  2. sales (500 registros)")
        print("     Campos: sale_id, employee_id, sale_date, amount, product, region, year, month")
        print()
        print("  3. projects (10 registros)")
        print("     Campos: project_id, project_name, budget, start_date, status")
        print()
        print("  4. project_assignments (varios registros)")
        print("     Campos: assignment_id, employee_id, project_id, role, hours_allocated")
        print()
        print("  5. performance_reviews (100 registros)")
        print("     Campos: review_id, employee_id, review_date, rating, reviewer_id, comments")
        print("\n" + "="*60)
        print("\n💡 EJEMPLOS DE CONSULTAS CON FUNCIONES DE VENTANA:\n")
        print("  Ver: scripts/advanced_sql_patterns.sql")
        print("\n" + "="*60 + "\n")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        raise

if __name__ == "__main__":
    main()
