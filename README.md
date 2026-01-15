# 📊 Data Interview Prep - Guía Completa de Configuración

Un proyecto educativo para prepararse en entrevistas de datos, con un entorno PostgreSQL containerizado y scripts de ingesta de datos sintéticos.

---

## 📋 Tabla de Contenidos

1. [Descripción General](#descripción-general)
2. [Requisitos Previos](#requisitos-previos)
3. [Fase 1: Preparación del Entorno](#fase-1-preparación-del-entorno)
4. [Fase 2: Instalación de Dependencias](#fase-2-instalación-de-dependencias)
5. [Fase 3: Configuración de la Base de Datos](#fase-3-configuración-de-la-base-de-datos)
6. [Fase 4: Carga de Datos](#fase-4-carga-de-datos)
7. [Fase 5: Análisis de Datos](#fase-5-análisis-de-datos)
8. [Estructura del Proyecto](#estructura-del-proyecto)
9. [Solución de Problemas](#solución-de-problemas)

---

## 🎯 Descripción General

Este proyecto te proporciona un entorno completo para:
- ✅ Practicar consultas SQL avanzadas
- ✅ Trabajar con análisis de datos en Python
- ✅ Usar machine learning y visualización
- ✅ Simular un entorno profesional de base de datos

**Lo especial:** Todo corre en contenedores Docker, así que es fácil de compartir y reproducir en cualquier máquina.

---

## 🔧 Requisitos Previos

Antes de empezar, asegúrate de tener instalado:

1. **Git** - Para clonar/versionear el proyecto
   - Descárgalo desde: https://git-scm.com/

2. **Docker Desktop** - Para ejecutar PostgreSQL en un contenedor
   - Descárgalo desde: https://www.docker.com/products/docker-desktop
   - Instálalo según tu sistema operativo (Windows/Mac/Linux)

3. **Visual Studio Code** (opcional pero recomendado)
   - Descárgalo desde: https://code.visualstudio.com/
   - Instala la extensión: "Python" (de Microsoft)

4. **Python 3.10+** - Ya viene con Windows/Mac/Linux
   - Verifica con: `python --version`

**Verificar instalación:**
```bash
docker --version
python --version
git --version
```

Si ves los números de versión, ¡estás listo!

---

## 📦 Fase 1: Preparación del Entorno

### Paso 1.1: Clonar o Descargar el Proyecto

**Opción A - Clonar con Git:**
```bash
git clone https://github.com/YurgenMg/data-interview-prep.git
cd data-interview-prep
```

**Opción B - Descargar como ZIP:**
- Descarga el proyecto como ZIP desde GitHub
- Descomprime la carpeta
- Abre una terminal en esa carpeta

### Paso 1.2: Abrir el Proyecto en VS Code

```bash
code .
```

O abre VS Code manualmente y selecciona "Open Folder" → elige la carpeta del proyecto.

---

## 🐍 Fase 2: Instalación de Dependencias

### Paso 2.1: Crear el Entorno Virtual

El entorno virtual es como una "burbuja" aislada donde instalaremos las librerías sin afectar tu sistema.

**En Windows (PowerShell):**
```bash
python -m venv .venv
.venv\Scripts\activate
```

**En Mac/Linux:**
```bash
python3 -m venv .venv
source .venv/bin/activate
```

Verás que aparece `(.venv)` al inicio de la terminal. ¡Es normal!

### Paso 2.2: Instalar las Dependencias

Con el entorno virtual activado, instala todas las librerías necesarias:

```bash
pip install -r requirements.txt
```

Esto descargará e instalará:
- **pandas** - Manipulación de datos
- **numpy** - Cálculos numéricos
- **matplotlib & seaborn** - Gráficos
- **streamlit** - Apps web interactivas
- **sqlalchemy** - Conexión a bases de datos
- **scikit-learn** - Machine learning
- **xgboost, lightgbm** - Algoritmos avanzados
- **Y más...**

**¿Tardó mucho?** Es normal la primera vez. El sistema está descargando ~500MB de código.

### Paso 2.3: Verificar la Instalación

```bash
python -c "import pandas; import numpy; import sqlalchemy; print('✅ Todo instalado correctamente')"
```

Si ves el ✅, ¡vamos bien!

---

## 🗄️ Fase 3: Configuración de la Base de Datos

### Paso 3.1: Iniciar PostgreSQL con Docker

Desde la carpeta raíz del proyecto, ejecuta:

```bash
docker-compose up -d
```

**¿Qué significa?**
- `docker-compose` - Herramienta para manejar contenedores
- `up` - Inicia los contenedores
- `-d` - Los ejecuta en background (no bloquea tu terminal)

**Espera 10-15 segundos** mientras Docker inicia PostgreSQL.

### Paso 3.2: Verificar que PostgreSQL está Corriendo

```bash
docker-compose ps
```

Deberías ver algo como:
```
NAME                STATUS
data-interview-prep-postgres-1   Up 2 minutes
```

Si ves "Up", ¡la base de datos está lista!

### Paso 3.3: Revisar los Credenciales de Conexión

Abre el archivo `scripts/ingest_data.py` y verifica:

```python
DB_URI = 'postgresql://admin_user:secure_password_123@localhost:5432/analytics_playground'
```

Estos datos coinciden con el archivo `docker-compose.yaml`. **No los cambies** a menos que hayas modificado docker-compose.

---

## 📥 Fase 4: Carga de Datos

### Paso 4.1: Ejecutar el Script de Ingesta

Asegúrate de que:
1. El entorno virtual está activado (`(.venv)` en la terminal)
2. PostgreSQL está corriendo (`docker-compose ps`)

Luego ejecuta:

```bash
python scripts/ingest_data.py
```

**Resultado esperado:**
```
Generando 5000 filas de datos simulados...
Conectando a la base de datos...
Insertando datos...
✅ ¡Éxito! 5000 filas cargadas en la tabla 'sales_data'.
```

¡Felicidades! Ya tienes datos en tu base de datos. 🎉

### Paso 4.2: Verificar los Datos (Opcional)

Si tienes `psql` instalado localmente, puedes consultar:

```bash
psql -h localhost -U admin_user -d analytics_playground -c "SELECT COUNT(*) FROM sales_data;"
```

Te pedirá la contraseña: `secure_password_123`

---

## 📊 Fase 5: Análisis de Datos

### Opción 1: Análisis en Notebooks Jupyter

```bash
jupyter notebook
```

Se abrirá un navegador. Accede a la carpeta `notebooks/` y crea un nuevo notebook para:
- Explorar los datos con pandas
- Crear visualizaciones
- Análisis estadísticos

### Opción 2: Consultas SQL Avanzadas

Abre `analisis_senior.sql` o `analisis_avanzado.sql` en VS Code y ejecuta contra tu base de datos.

**Herramientas para ejecutar SQL:**
- **DBeaver** (gratuito) - Descárgalo: https://dbeaver.io/
- **pgAdmin** - https://www.pgadmin.org/
- **Postico** (Mac, pago) - https://eggerapps.at/postico2/

Conexión:
```
Host: localhost
Puerto: 5432
Usuario: admin_user
Contraseña: secure_password_123
Base de datos: analytics_playground
```

### Opción 3: Machine Learning

En un notebook o script Python:

```python
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier

# Cargar datos desde PostgreSQL
from sqlalchemy import create_engine
engine = create_engine('postgresql://admin_user:secure_password_123@localhost:5432/analytics_playground')
df = pd.read_sql_table('sales_data', engine)

# Tu análisis aquí...
```

---

## 📁 Estructura del Proyecto

```
data-interview-prep/
├── README.md                    # Este archivo
├── docker-compose.yaml          # Configuración de PostgreSQL en Docker
├── requirements.txt             # Lista de librerías Python
├── .venv/                       # Entorno virtual (ignorar)
├── .gitignore                   # Archivos a ignorar en Git
│
├── scripts/
│   └── ingest_data.py          # Script para generar e insertar datos
│
├── config/
│   └── (archivos de configuración futuros)
│
├── data/
│   └── (datos locales, CSVs, etc.)
│
├── notebooks/
│   └── (Jupyter notebooks para análisis)
│
└── analisis_*.sql              # Scripts SQL avanzados
```

---

## 🆘 Solución de Problemas

### Problema: "No se ha podido resolver la importación 'pandas'"

**Solución:**
1. Verifica que el entorno virtual está activado (debe mostrar `(.venv)`)
2. Reinstala las dependencias:
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```
3. Recarga VS Code: `Ctrl+Shift+P` → "Developer: Reload Window"

### Problema: "Connection refused" al conectarse a PostgreSQL

**Solución:**
1. Verifica que Docker está corriendo: `docker-compose ps`
2. Si no está corriendo, inicia con: `docker-compose up -d`
3. Espera 15 segundos y vuelve a intentar

### Problema: "Error: la tabla 'sales_data' no existe"

**Solución:**
1. Ejecuta el script de ingesta: `python scripts/ingest_data.py`
2. Verifica que PostgreSQL está corriendo

### Problema: "Port 5432 already in use"

**Solución:**
1. Detén el contenedor actual: `docker-compose down`
2. Espera 10 segundos
3. Vuelve a iniciar: `docker-compose up -d`

### Problema: Python no encontrado en la terminal

**Solución:**
- En Windows, usa `py` en lugar de `python`
- En Mac/Linux, usa `python3` en lugar de `python`

---

## 🚀 Próximos Pasos

Una vez que todo esté funcionando:

1. **Practica SQL:** Modifica `analisis_senior.sql` y prueba nuevas queries
2. **Explora los datos:** Crea notebooks con pandas y matplotlib
3. **Entrena modelos:** Usa scikit-learn y xgboost
4. **Visualiza:** Crea dashboards con Streamlit

---

## 📝 Notas Importantes

- **Seguridad:** Las credenciales en este proyecto son solo para desarrollo. NUNCA uses esto en producción.
- **Datos:** Cada vez que ejecutas `ingest_data.py`, borra los datos antiguos y genera nuevos.
- **Entorno Virtual:** Siempre actívalo antes de trabajar: `.venv\Scripts\activate` (Windows) o `source .venv/bin/activate` (Mac/Linux)
- **Docker:** Asegúrate de tener Docker Desktop abierto antes de ejecutar `docker-compose`

---

## 💡 Tips Profesionales

✅ **Commit a Git regularmente:**
```bash
git add .
git commit -m "Descripción de los cambios"
git push origin main
```

✅ **Mantén el requirements.txt actualizado:**
```bash
pip freeze > requirements.txt
```

✅ **Crea ramas para nuevas features:**
```bash
git checkout -b nueva-feature
```

✅ **Documenta tu código:**
```python
def mi_funcion(x):
    """Breve descripción de qué hace."""
    return x + 1
```

---

## 📧 Soporte

Si encuentras problemas:
1. Revisa la sección "Solución de Problemas"
2. Verifica que todas las fases están completas
3. Comparte el error en GitHub Issues

---

**¡Buena suerte con tu preparación! 🍀**

**Última actualización:** Enero 2026
