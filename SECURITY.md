# Security Policy

## 🔒 Reporte de Vulnerabilidades de Seguridad

Si descubres una vulnerabilidad de seguridad, **no la reportes públicamente en los Issues**.

### Cómo Reportar

Por favor, envía un email a través de una forma segura (si está disponible en el perfil del proyecto).

En el email incluye:

1. **Descripción** de la vulnerabilidad
2. **Pasos para reproducir** (si es posible)
3. **Impacto potencial**
4. **Sugerencias de parche** (si tienes)

### Timeline

- **Recepción:** Confirmaremos recepción en 48 horas
- **Investigación:** Investigaremos dentro de 7 días
- **Parche:** Liberaremos un parche en la siguiente versión
- **Divulgación:** Publicaremos el aviso de seguridad

## ✅ Prácticas de Seguridad

Este proyecto sigue estas prácticas:

- ✅ Mantiene dependencias actualizadas
- ✅ Ejecuta análisis de seguridad automático
- ✅ Valida todas las entradas de usuarios
- ✅ No almacena credenciales en código
- ✅ Usa HTTPS para comunicaciones

## ⚠️ Información Sensible

**NUNCA incluyas:**
- Contraseñas o tokens en el código
- Claves de API
- Datos personales o confidenciales

Use archivos `.env` para configuración sensible (sin commitearlos).

## 📦 Dependencias

Regularmente se revisan y actualizan las dependencias para parches de seguridad.

```bash
# Verificar vulnerabilidades en dependencias
pip install safety
safety check
```

## 🙏 Gracias

Agradecemos a los investigadores de seguridad que responsablemente reportan vulnerabilidades.

---

**Última actualización:** 2026-01-15
