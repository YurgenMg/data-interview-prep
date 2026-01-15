# Data Interview Prep - Guía de Inicio Rápido

¿Quieres empezar rápido? 🚀 Sigue estos pasos simples.

## ⚡ 30 Segundos de Setup

```bash
# 1. Clona el repo
git clone https://github.com/usuario/data-interview-prep.git
cd data-interview-prep

# 2. Crea el entorno (elige tu SO)
# Windows:
python -m venv .venv && .venv\Scripts\activate

# Mac/Linux:
python3 -m venv .venv && source .venv/bin/activate

# 3. Instala dependencias
pip install -r requirements.txt

# 4. Inicia la BD
docker-compose up -d

# 5. Carga datos
python scripts/ingest_data.py

# ✅ ¡Listo! Ahora explora:
jupyter notebook
```

## 📖 Documentación Completa

- **[README.md](README.md)** - Guía completa paso a paso
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Cómo contribuir
- **[CHANGELOG.md](CHANGELOG.md)** - Historial de cambios

## 🆘 Problemas Comunes

| Problema | Solución |
|----------|----------|
| `ImportError: No module named pandas` | Asegúrate que el `.venv` está activado |
| `Connection refused` en BD | Verifica: `docker-compose ps` |
| `Port 5432 in use` | Ejecuta: `docker-compose down` |
| Python no encontrado | Usa `python3` en Mac/Linux |

## 💡 Próximas Acciones

1. ✅ Lee el [README.md](README.md) completo
2. ✅ Explora los notebooks en `notebooks/`
3. ✅ Prueba las queries en `analisis_*.sql`
4. ✅ Crea tu primer análisis
5. ✅ ¡Contribuye! Mira [CONTRIBUTING.md](CONTRIBUTING.md)

## 🤝 ¿Necesitas Ayuda?

- 🐛 [Reporta un bug](https://github.com/usuario/data-interview-prep/issues/new?template=bug_report.md)
- 💡 [Sugiere una mejora](https://github.com/usuario/data-interview-prep/issues/new?template=feature_request.md)
- ❓ [Haz una pregunta](https://github.com/usuario/data-interview-prep/issues/new?template=question.md)

---

**¡Happy learning! 🎓**
