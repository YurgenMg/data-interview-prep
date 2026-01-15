# .github/config.yml - Configuración del Repositorio

# Este archivo documenta la configuración recomendada para GitHub

## Recomendaciones de Configuración

### 1. Protecciones de Rama (Branch Protection Rules)

En Settings → Branches → Add rule:

- **Branch name pattern:** `main`
- **Require a pull request before merging:** ✅
- **Require approvals:** ✅ (1 reviewer)
- **Require status checks to pass:** ✅
- **Status checks:**
  - Tests
  - Linting
  - Coverage
- **Require branches to be up to date before merging:** ✅
- **Restrict who can push to matching branches:** ✅ (solo admins)

### 2. Reglas de Merge

- **Allow squash merging:** ✅ (Recomendado para mantener historia limpia)
- **Allow rebase merging:** ✅
- **Default to PR title for squash merge:** ✅
- **Auto-delete head branches:** ✅

### 3. Colaboradores

- Agregar como Collaborators a miembros del equipo
- Roles:
  - **Maintainers:** Pull access + Merge
  - **Contributors:** Pull access

### 4. Acciones (Actions)

- Habilitar GitHub Actions: ✅
- Ejecutar workflows de: Pull requests, Push

### 5. Seguridad

- **Secret scanning:** ✅ (Enterprise feature)
- **Dependabot:** ✅ (Actualizaciones automáticas)
  - Alerts: ✅
  - Updates: ✅ (Daily)

### 6. Insights

Regularmente revisar:
- Dependency graph
- Network graph
- Commits
- Issues trends

## Archivos Importantes

Este proyecto incluye:

```
.github/
├── workflows/
│   └── tests.yml           # CI/CD Pipeline
├── ISSUE_TEMPLATE/
│   ├── bug_report.md       # Plantilla para bugs
│   ├── feature_request.md  # Plantilla para features
│   └── question.md         # Plantilla para preguntas
└── PULL_REQUEST_TEMPLATE.md # Template para PRs
```

## Badges (Opcional)

Para el README.md, puedes agregar badges:

```markdown
[![Python 3.10+](https://img.shields.io/badge/python-3.10%2B-blue.svg)](https://www.python.org/downloads/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Tests Passing](https://github.com/usuario/data-interview-prep/workflows/Tests/badge.svg)](https://github.com/usuario/data-interview-prep/actions)
```

## Topics (Etiquetas del Repositorio)

Agrega en Settings → Options → Topics:
- data-science
- sql
- machine-learning
- python
- postgresql
- docker
- interview-prep
- education

---

**Nota:** Estas son recomendaciones. Ajusta según las necesidades del proyecto.
