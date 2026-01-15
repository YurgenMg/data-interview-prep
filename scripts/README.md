# Scripts de Data Interview Prep

Este directorio contiene los scripts Python ejecutables del proyecto.

## 📋 Scripts Disponibles

### 1. `ingest_data.py` - Ingesta de Datos

**Propósito:** Generar datos sintéticos de ventas e insertarlos en PostgreSQL.

**Uso:**
```bash
python scripts/ingest_data.py
```

**Qué hace:**
1. Genera 5000 filas de datos sintéticos
2. Se conecta a PostgreSQL
3. Crea la tabla `sales_data`
4. Inserta los datos

**Salida esperada:**
```
Generando 5000 filas de datos simulados...
Conectando a la base de datos...
Insertando datos...
✅ ¡Éxito! 5000 filas cargadas en la tabla 'sales_data'.
```

**Parámetros personalizables:**

Edita el archivo y cambia el parámetro en `generate_data()`:

```python
df_ventas = generate_data(num_rows=10000)  # Generar 10k filas en lugar de 5k
```

---

## 🔧 Estructura de un Script

Todos los scripts siguen esta estructura recomendada:

```python
"""
Descripción breve del módulo.

Descripción más larga si es necesario.
Ejemplo:
    Cómo usar este script desde la terminal o desde otro módulo.
"""

import os
from typing import Optional

# Configuración
DB_URI = 'postgresql://...'
LOG_LEVEL = 'INFO'


def mi_funcion(param1: str, param2: int = 10) -> Optional[str]:
    """
    Descripción de qué hace la función.
    
    Args:
        param1: Descripción del parámetro 1
        param2: Descripción del parámetro 2 (default: 10)
        
    Returns:
        Qué retorna la función
        
    Example:
        >>> resultado = mi_funcion('test')
        >>> print(resultado)
    """
    # Implementación
    pass


def main():
    """Punto de entrada principal del script."""
    print("Ejecutando script...")
    # Lógica principal


if __name__ == "__main__":
    main()
```

---

## 📥 Cómo Crear un Nuevo Script

### Paso 1: Crear el archivo

```bash
touch scripts/mi_nuevo_script.py
```

### Paso 2: Agregar el template

```python
"""
Descripción de mi_nuevo_script.py
"""

def main():
    print("Mi nuevo script está ejecutándose!")
    

if __name__ == "__main__":
    main()
```

### Paso 3: Probar

```bash
python scripts/mi_nuevo_script.py
```

### Paso 4: Documentar en este README

---

## 🔄 Variables de Entorno

Los scripts pueden usar variables de entorno para configuración sensible.

**Crear un archivo `.env`** (no commitear):

```bash
cp .env.example .env
# Edita .env con tus valores
```

**Usar en scripts:**

```python
import os
from dotenv import load_dotenv

load_dotenv()

DB_USER = os.getenv('DB_USER', 'default_user')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'default_password')
```

---

## 🐛 Debugging

### Ver logs detallados

```python
import logging

# Configurar logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

# Usar en el código
logger.debug("Mensaje de debug")
logger.info("Mensaje informativo")
logger.error("Mensaje de error")
```

### Usar pdb (debugger interactivo)

```python
import pdb

def mi_funcion():
    x = 10
    pdb.set_trace()  # El programa se pausará aquí
    y = x + 5
```

---

## 📊 Flujo de Datos Típico

```
Usuario ejecuta script
    ↓
Script lee configuración (.env, args)
    ↓
Script conecta a BD / carga archivos
    ↓
Script procesa datos
    ↓
Script guarda resultados
    ↓
Script termina (exit code 0 = éxito, ≠0 = error)
```

---

## ✅ Checklist para Nuevo Script

- [ ] Tiene docstring descriptivo
- [ ] Las funciones tienen type hints
- [ ] Tiene manejo de errores (try/except)
- [ ] Usa logging en lugar de print()
- [ ] Tiene función `main()`
- [ ] Tiene bloque `if __name__ == "__main__"`
- [ ] Está documentado en este README
- [ ] Está testeado localmente

---

## 🤝 Contribuir Scripts

¿Quieres agregar un nuevo script?

1. Crea el archivo siguiendo las convenciones
2. Documenta en este README
3. Abre un Pull Request
4. Ve a [CONTRIBUTING.md](../CONTRIBUTING.md)

---

**Preguntas?** Abre un [Issue](../../issues)
