# Changelog - módulo_inventario

## 2026-06-02

- Ejecutado `flutter analyze` y `flutter test` en el proyecto principal.
- Arreglos realizados:
  - Corregido uso de `DropdownButtonFormField.value` a `initialValue` en formularios relevantes.
  - Eliminados errores de importación al ejecutar análisis en el directorio correcto.
- Estado final: no hay errores de compilación; quedan avisos deprecados (`withOpacity`) y variables no usadas en algunos archivos no relacionados con el módulo de inventario.

Próximos pasos sugeridos:
- Si deseas, aplico conversiones deprecadas (`withOpacity` → `.withValues()`) en archivos seleccionados.
- Integrar soporte push (WebSocket/SSE) para actualizar stock en tiempo real si el backend lo soporta.
