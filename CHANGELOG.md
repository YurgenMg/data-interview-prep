# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato se basa en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto se adhiere al [Versionado Semántico](https://semver.org/lang/es/).

## [Versiones Futuras]

### Planeado
- [ ] Dashboard interactivo con Streamlit
- [ ] Más datasets de práctica
- [ ] Notebooks con soluciones completadas
- [ ] GitHub Actions CI/CD
- [ ] Tests automatizados

---

## [1.0.0] - 2026-01-15

### Agregado
- ✨ Proyecto inicial con estructura profesional
- 🐳 Docker Compose para PostgreSQL
- 🐍 Script de ingesta de datos sintéticos
- 📊 Ejemplos de análisis SQL avanzado
- 📚 Documentación completa en README.md
- 🔒 Licencia MIT
- 📋 Guía de contribución (CONTRIBUTING.md)
- 🎯 Estructura base de notebooks
- 📦 requirements.txt con dependencias de:
  - Pandas, NumPy, Matplotlib, Seaborn
  - SQLAlchemy para conexión a BD
  - Scikit-learn, XGBoost, LightGBM
  - Streamlit para visualizaciones
  - Jupyter para análisis interactivo

### Cambios
- N/A (Versión inicial)

### Arreglado
- N/A (Versión inicial)

### Eliminado
- N/A (Versión inicial)

---

## Formato de Versiones Futuras

Para versiones futuras, usa este formato:

### [X.Y.Z] - YYYY-MM-DD

#### Agregado
- Descripción de nuevas features

#### Cambios
- Cambios en funcionalidad existente

#### Arreglado
- Bugs que fueron corregidos

#### Eliminado
- Features que fueron removidas

#### Seguridad
- Actualizaciones de seguridad

---

## Notas para Contribuyentes

Cuando agregues cambios al proyecto:

1. **Antes de cada release**, actualiza el CHANGELOG
2. **Agrupa cambios** por categoría (Agregado, Cambios, Arreglado, Eliminado)
3. **Usa formato Markdown** para links y código
4. **Incluye números de PR o Issue** si aplica
5. **Mantén un registro detallado** para futuros usuarios

### Ejemplo de Entry

```markdown
### Agregado
- Soporte para análisis de cohortes (#42)
- Nueva función `calculate_retention()` en analytics.py
- Tests para validar cálculos de retención

### Cambios
- Mejorado rendimiento de ingesta de datos (2x más rápido)

### Arreglado
- Bug en cálculo de promedio con valores nulos (#38)

### Seguridad
- Actualizada dependencia psycopg2 a 2.9.11
```

---

**Última actualización:** 2026-01-15
