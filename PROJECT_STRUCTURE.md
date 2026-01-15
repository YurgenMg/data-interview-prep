# Estructura del Proyecto Detallada

## 📂 Árbol Completo

```
data-interview-prep/
│
├── 📄 README.md                         # Documentación principal
├── 📄 QUICKSTART.md                     # Guía rápida de 30 segundos
├── 📄 CONTRIBUTING.md                   # Cómo contribuir
├── 📄 CHANGELOG.md                      # Historial de versiones
├── 📄 SECURITY.md                       # Política de seguridad
├── 📄 LICENSE                           # Licencia MIT
│
├── 🐳 docker-compose.yaml               # Configuración de PostgreSQL
├── 📄 requirements.txt                  # Dependencias Python
├── 📄 .gitignore                        # Archivos a ignorar en Git
├── 📄 .env.example                      # Template de variables de entorno
│
├── ⚙️ .editorconfig                     # Estándares de formato
├── ⚙️ pyproject.toml                    # Config de herramientas Python
├── ⚙️ .pre-commit-config.yaml           # Pre-commit hooks
│
├── 📁 .github/
│   ├── 📄 CONFIG.md                     # Configuración recomendada de GitHub
│   ├── 📄 PULL_REQUEST_TEMPLATE.md      # Template para PRs
│   │
│   ├── 📁 workflows/
│   │   └── 📄 tests.yml                 # Pipeline de CI/CD
│   │
│   └── 📁 ISSUE_TEMPLATE/
│       ├── 📄 bug_report.md             # Template para reportar bugs
│       ├── 📄 feature_request.md        # Template para nuevas features
│       └── 📄 question.md               # Template para preguntas
│
├── 📁 scripts/
│   └── 🐍 ingest_data.py                # Script de ingesta de datos
│
├── 📁 notebooks/
│   ├── 📓 (Notebooks del usuario)
│   └── (Para análisis exploratorio)
│
├── 📁 config/
│   └── (Archivos de configuración futuros)
│
├── 📁 data/
│   ├── raw/                             # Datos sin procesar
│   └── processed/                       # Datos procesados
│
└── 📄 analisis_*.sql                    # Queries SQL de ejemplo
    ├── analisis_avanzado.sql
    └── analisis_senior.sql
```

## 📋 Descripción de Archivos Clave

### Archivos de Documentación

| Archivo | Propósito |
|---------|-----------|
| `README.md` | Guía completa del proyecto (¡empieza aquí!) |
| `QUICKSTART.md` | Setup de 30 segundos |
| `CONTRIBUTING.md` | Cómo colaborar en el proyecto |
| `CHANGELOG.md` | Historial de cambios y versiones |
| `SECURITY.md` | Política de seguridad |
| `LICENSE` | Licencia MIT (código abierto) |

### Archivos de Configuración

| Archivo | Propósito |
|---------|-----------|
| `docker-compose.yaml` | Define los servicios de Docker (PostgreSQL) |
| `requirements.txt` | Lista de dependencias Python |
| `.env.example` | Template de variables de entorno |
| `pyproject.toml` | Config de herramientas Python (Black, Pylint, etc) |
| `.editorconfig` | Estándares de formato de código |
| `.pre-commit-config.yaml` | Validaciones automáticas al hacer commit |
| `.gitignore` | Archivos a ignorar en Git |

### Archivos de GitHub

| Archivo | Propósito |
|---------|-----------|
| `.github/workflows/tests.yml` | CI/CD Pipeline automático |
| `.github/PULL_REQUEST_TEMPLATE.md` | Template para Pull Requests |
| `.github/ISSUE_TEMPLATE/` | Templates para Issues (bugs, features, etc) |
| `.github/CONFIG.md` | Guía de configuración del repositorio |

### Código del Proyecto

| Carpeta | Contenido |
|---------|----------|
| `scripts/` | Scripts ejecutables (ingesta de datos) |
| `notebooks/` | Jupyter Notebooks para análisis |
| `config/` | Archivos de configuración (reservado) |
| `data/` | Datos locales (raw y processed) |
| `*.sql` | Queries SQL de ejemplo |

## 🔄 Flujo de Trabajo Típico

```
1. Editas código en scripts/ o notebooks/
       ↓
2. .pre-commit-config.yaml valida automáticamente
       ↓
3. Haces commit y push
       ↓
4. GitHub Actions ejecuta tests (workflows/tests.yml)
       ↓
5. Si todo pasa, el PR está listo para review
       ↓
6. Un mantenedor revisa y aprueba
       ↓
7. Se mergea a main
```

## 🛠️ Cómo Extender el Proyecto

### Agregar un nuevo módulo Python

```
scripts/
├── ingest_data.py         (existente)
├── analysis.py            (nuevo)
└── __init__.py
```

### Agregar un notebook de análisis

```
notebooks/
├── 01_exploratory_data_analysis.ipynb    (nuevo)
└── 02_feature_engineering.ipynb          (nuevo)
```

### Agregar nuevas dependencias

```bash
# Instala el paquete
pip install nuevo-paquete

# Actualiza requirements.txt
pip freeze > requirements.txt

# Commit los cambios
git add requirements.txt
git commit -m "chore: agregar nuevo-paquete"
```

## 📌 Notas Importantes

- **`.venv/`**: Nunca commitear (generado localmente)
- **`.env`**: Nunca commitear (contiene credenciales)
- **`data/`**: Ignorar archivos grandes (configurar en `.gitignore`)
- **Notebooks**: Limpiar output antes de hacer commit (opcional pero recomendado)

## 🚀 Próximas Mejoras Sugeridas

- [ ] Agregar tests automatizados en `tests/`
- [ ] Crear Dockerfile para containerizar la app
- [ ] Agregar documentación de API
- [ ] Crear dashboards con Streamlit
- [ ] Agregar ejemplos de machine learning avanzado

---

**¿Preguntas sobre la estructura?** Mira [CONTRIBUTING.md](CONTRIBUTING.md)
