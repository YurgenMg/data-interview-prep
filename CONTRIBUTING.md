# Guía de Contribución

¡Gracias por tu interés en contribuir a Data Interview Prep! 🎉

Este documento te guía sobre cómo contribuir al proyecto de manera profesional y ordenada.

## 📋 Tabla de Contenidos

1. [Código de Conducta](#código-de-conducta)
2. [¿Cómo Contribuir?](#cómo-contribuir)
3. [Reportar Bugs](#reportar-bugs)
4. [Sugerir Mejoras](#sugerir-mejoras)
5. [Pull Requests](#pull-requests)
6. [Estándares de Código](#estándares-de-código)

---

## 💬 Código de Conducta

Todos los contribuyentes deben ser respetuosos, profesionales y constructivos. No toleramos:
- Lenguaje ofensivo
- Acoso de ningún tipo
- Discriminación

Si ves un comportamiento inapropiado, reporta a los mantenedores directamente.

---

## 🤝 ¿Cómo Contribuir?

### Opción 1: Reportar un Bug 🐛

1. Antes de crear un issue, busca si ya existe uno similar
2. Haz click en "Issues" → "New Issue"
3. Selecciona "Bug report"
4. Completa el formulario:
   - **Descripción clara** del problema
   - **Pasos para reproducir**
   - **Resultado esperado vs actual**
   - **Tu entorno** (SO, Python version, versión del proyecto)
   - **Logs o mensajes de error**

### Opción 2: Sugerir una Mejora 💡

1. Haz click en "Issues" → "New Issue"
2. Selecciona "Feature request"
3. Describe:
   - **Problema que resuelve**
   - **Solución propuesta**
   - **Alternativas consideradas**
   - **Contexto adicional**

### Opción 3: Crear tu Primer Pull Request 🚀

#### Paso 1: Fork el Repositorio

Haz click en el botón "Fork" en la esquina superior derecha de GitHub.

#### Paso 2: Clona tu Fork

```bash
git clone https://github.com/TU_USUARIO/data-interview-prep.git
cd data-interview-prep
git remote add upstream https://github.com/usuario_original/data-interview-prep.git
```

#### Paso 3: Crea una Rama

```bash
git checkout -b feature/tu-nueva-feature
```

Usa nombres descriptivos:
- `feature/agregar-análisis-avanzado`
- `fix/corregir-conexión-bd`
- `docs/mejorar-readme`

#### Paso 4: Haz tus Cambios

Trabaja en tu rama local.

#### Paso 5: Commit con Mensajes Claros

```bash
git add .
git commit -m "feat: agregar análisis de clusters con K-means"
```

**Formato de mensajes:**
```
type: descripción corta

Descripción más detallada si es necesario.
- Punto 1
- Punto 2

Cierra #123
```

**Tipos válidos:**
- `feat:` - Nueva funcionalidad
- `fix:` - Corrección de bug
- `docs:` - Cambios en documentación
- `style:` - Formato, sin cambios lógicos
- `refactor:` - Reorganización de código
- `test:` - Agregar o mejorar tests
- `chore:` - Cambios en herramientas/dependencias

#### Paso 6: Sincroniza con el Repositorio Original

```bash
git fetch upstream
git rebase upstream/main
```

#### Paso 7: Push a tu Fork

```bash
git push origin feature/tu-nueva-feature
```

#### Paso 8: Abre un Pull Request

1. Ve a tu fork en GitHub
2. Haz click en "Compare & pull request"
3. Completa el título y descripción:
   - Qué problema resuelve
   - Cómo lo resuelve
   - Testing realizado
   - Cambios en documentación

---

## 🐛 Reportar Bugs

### Información Requerida

```
**Versión del Proyecto:** v1.0.0
**Python Version:** 3.10
**Sistema Operativo:** Linux / Mac / Windows
**Docker:** Sí / No

**Descripción del Bug:**
[Describe el problema aquí]

**Pasos para Reproducir:**
1. Paso 1
2. Paso 2
3. Paso 3

**Resultado Esperado:**
[Qué debería pasar]

**Resultado Actual:**
[Qué pasó realmente]

**Logs/Errores:**
[Pega el mensaje de error completo]
```

### Ejemplo

```
**Versión del Proyecto:** v1.0.0
**Python Version:** 3.10
**Sistema Operativo:** Ubuntu 22.04
**Docker:** Sí

**Descripción del Bug:**
El script ingest_data.py falla al conectar a PostgreSQL

**Pasos para Reproducir:**
1. Ejecuto docker-compose up -d
2. Activo el entorno virtual
3. Ejecuto python scripts/ingest_data.py

**Resultado Esperado:**
Debería cargar 5000 filas en la tabla sales_data

**Resultado Actual:**
Error: connection refused on port 5432

**Logs/Errores:**
```
Error crítico: (psycopg2.OperationalError) could not connect to server: 
Connection refused. Is the server running on host "localhost"...
```
```

---

## 💡 Sugerir Mejoras

```
**¿Es este un problema relacionado con confusión?**
[Describe si está relacionado con documentación]

**Describe la Solución Deseada:**
[Descripción clara de qué quieres]

**Describe Alternativas que Consideraste:**
[Otras opciones posibles]

**Contexto Adicional:**
[Otros detalles útiles]
```

---

## 📝 Pull Requests

### Checklist antes de Enviar

- [ ] He actualizado la documentación
- [ ] He agregado tests si aplica
- [ ] Mi código sigue los estándares (ver abajo)
- [ ] No hay conflictos con `main`
- [ ] He probado localmente
- [ ] Commita mensajes son claros

### Proceso de Review

1. **Automated checks:** El CI/CD verificará tests y linting
2. **Code review:** Un mantenedor revisará tu código
3. **Changes requested:** Si hay cambios, edita y haz push
4. **Merge:** Una vez aprobado, ¡tu PR será mergeado!

---

## 📐 Estándares de Código

### Python

Usamos **PEP 8** como estándar. Recomendamos:

```python
# Instala las herramientas
pip install black flake8 pylint

# Formatea tu código
black scripts/ notebooks/

# Verifica
flake8 scripts/
```

### Ejemplo de Buen Código

```python
"""
Módulo para ingesta de datos de ventas.

Este módulo proporciona funciones para generar y cargar
datos sintéticos a PostgreSQL.
"""

import pandas as pd
from sqlalchemy import create_engine


def generate_sales_data(num_rows: int = 5000) -> pd.DataFrame:
    """
    Genera datos sintéticos de ventas.
    
    Args:
        num_rows: Número de filas a generar (default: 5000)
        
    Returns:
        DataFrame con columnas: transaction_id, date, category, amount, customer_id, status
        
    Example:
        >>> df = generate_sales_data(1000)
        >>> df.shape
        (1000, 6)
    """
    # Implementación aquí
    pass
```

### Estándares

✅ **Hacer:**
- Nombres descriptivos (`sales_data` no `sd`)
- Docstrings en funciones importantes
- Comments explicando la lógica compleja
- Type hints en funciones

❌ **Evitar:**
- Variables de una letra (excepto loops)
- Código mágico sin explicación
- Funciones muy largas (>50 líneas)
- Importaciones circulares

---

## 🧪 Tests

Si agregas nueva funcionalidad, agrega tests:

```bash
# Estructura de carpetas
tests/
├── test_scripts.py
├── test_analysis.py
└── test_utils.py

# Ejecutar tests
pytest tests/

# Con cobertura
pytest --cov=scripts tests/
```

---

## 📚 Recursos Útiles

- [GitHub Docs - Collaborating](https://docs.github.com/en/pull-requests)
- [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce56f0b9e82ea01dc6d)
- [PEP 8 Style Guide](https://www.python.org/dev/peps/pep-0008/)

---

## ❓ ¿Preguntas?

1. Revisa la documentación en [README.md](README.md)
2. Abre una Issue etiquetada como `question`
3. Contacta a los mantenedores

---

**¡Gracias por contribuir! Tu ayuda es valiosa.** 🙌
