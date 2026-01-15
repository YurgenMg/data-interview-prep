# Notebook de Ejemplo: Análisis Exploratorio de Datos

Este es un template para comenzar un análisis exploratorio.

## Instalación de Dependencias en Jupyter

```python
# Si necesitas instalar paquetes dentro del notebook
import sys
!{sys.executable} -m pip install package-name
```

## Conexión a PostgreSQL

```python
import pandas as pd
from sqlalchemy import create_engine

# Configuración de conexión
DB_URI = 'postgresql://admin_user:secure_password_123@localhost:5432/analytics_playground'

# Crear conexión
engine = create_engine(DB_URI)

# Cargar datos
df = pd.read_sql_table('sales_data', engine)
df.head()
```

## Exploración Básica

```python
# Información general
print(df.info())
print(df.describe())
print(df.shape)

# Datos faltantes
print(df.isnull().sum())

# Valores únicos
print(df.nunique())
```

## Visualización

```python
import matplotlib.pyplot as plt
import seaborn as sns

# Configurar estilo
sns.set_style("whitegrid")
plt.figure(figsize=(12, 6))

# Ejemplo: Distribución de montos
sns.histplot(data=df, x='amount', kde=True)
plt.title('Distribución de Montos de Transacción')
plt.show()

# Ejemplo: Ventas por categoría
sns.barplot(data=df, x='category', y='amount', ci=None)
plt.title('Monto Promedio por Categoría')
plt.xticks(rotation=45)
plt.show()
```

## Análisis Estadístico

```python
# Agrupación
categoria_stats = df.groupby('category')['amount'].agg(['mean', 'sum', 'count'])
print(categoria_stats)

# Correlaciones
numeric_df = df.select_dtypes(include=['number'])
print(numeric_df.corr())

# Distribución por estado
print(df['status'].value_counts())
```

## Machine Learning (Ejemplo)

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report

# Preparar datos
X = df[['amount', 'category']].copy()
y = df['status'].copy()

# Codificar categorías
le = LabelEncoder()
X['category'] = le.fit_transform(X['category'])

# Split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Modelo
model = RandomForestClassifier(random_state=42)
model.fit(X_train, y_train)

# Predicción
y_pred = model.predict(X_test)

# Reporte
print(classification_report(y_test, y_pred))
```

## Guardar Resultados

```python
# Guardar como CSV
df.to_csv('data/processed/analysis_results.csv', index=False)

# Guardar gráfico
plt.savefig('data/processed/distribution_plot.png', dpi=300, bbox_inches='tight')
```

---

**¡Usa este template como base para tus análisis!**
