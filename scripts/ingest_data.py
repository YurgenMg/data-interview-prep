import pandas as pd
from sqlalchemy import create_engine, text
import numpy as np
from datetime import datetime, timedelta

# --- CONFIGURACIÓN ---
# Cadena de conexión: postgresql://usuario:password@host:puerto/nombre_db
# Nota: Usamos 'localhost' porque este script corre en tu entorno local (WSL),
# y gracias a los puertos expuestos (5432:5432) en Docker, podemos acceder así.
DB_URI = 'postgresql://admin_user:secure_password_123@localhost:5432/analytics_playground'

def generate_data(num_rows=5000):
    """Genera un DataFrame con datos sintéticos de ventas."""
    print(f"Generando {num_rows} filas de datos simulados...")
    
    # Semilla para reproducibilidad (siempre saldrán los mismos números aleatorios)
    np.random.seed(42)
    
    # Generar fechas aleatorias en los últimos 60 días
    base_date = datetime.today()
    date_list = [base_date - timedelta(days=x) for x in range(60)]
    
    data = {
        'transaction_id': range(1, num_rows + 1),
        'date': np.random.choice(date_list, num_rows),
        'category': np.random.choice(['Electronics', 'Books', 'Home', 'Fashion', 'Sports'], num_rows),
        'amount': np.random.uniform(10.0, 500.0, num_rows).round(2),
        'customer_id': np.random.randint(100, 150, num_rows), # Simulamos 50 clientes recurrentes
        'status': np.random.choice(['Completed', 'Refunded', 'Pending'], num_rows, p=[0.9, 0.05, 0.05])
    }
    
    return pd.DataFrame(data)

def load_to_postgres(df):
    """Carga el DataFrame a PostgreSQL usando SQLAlchemy."""
    try:
        print("Conectando a la base de datos...")
        # Crear el motor de conexión
        engine = create_engine(DB_URI)
        
        # Ingesta: to_sql crea la tabla automáticamente si no existe.
        # if_exists='replace': Borra la tabla y la crea de nuevo (útil para practicar).
        # index=False: No guardamos el índice numérico de Pandas como columna.
        print("Insertando datos...")
        df.to_sql('sales_data', engine, if_exists='replace', index=False)
        
        print(f"✅ ¡Éxito! {len(df)} filas cargadas en la tabla 'sales_data'.")
        
    except Exception as e:
        print(f"❌ Error crítico: {e}")

if __name__ == "__main__":
    df_ventas = generate_data()
    load_to_postgres(df_ventas)