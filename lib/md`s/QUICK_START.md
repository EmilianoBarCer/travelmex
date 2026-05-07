# ⚡ QUICK START - Comienza en 5 Minutos

## 🎯 Lo Esencial

Tu app está **99% lista**. Solo necesitas:

1. **Clave Google Maps** (15 min) → Google Cloud
2. **Actualizar Configuración** (1 min) → VS Code
3. **Ejecutar Schema SQL** (2 min) → Supabase
4. **Compilar y Probar** (5 min) → Terminal

**Total: ~30 minutos**

---

## 1️⃣ CLAVE GOOGLE MAPS (15 min)

### Rápido:
```
https://console.cloud.google.com
→ Nuevo Proyecto: "TravelMex"
→ Habilitar: Maps SDK for Android + iOS
→ Crear Credencial: API Key
→ Copiar: AIzaSyD...
```

---

## 2️⃣ ACTUALIZAR CÓDIGO (1 min)

### Archivo: `lib/utilidades/configuracion_google_maps.dart`

```dart
// CAMBIAR ESTO:
const String GOOGLE_MAPS_API_KEY = 'REEMPLAZA_CON_TU_CLAVE_API';

// A ESTO (tu clave Google):
const String GOOGLE_MAPS_API_KEY = 'AIzaSyD1234567890abcdefghijklmnopqrst';
```

### Guardar: `Ctrl+S`

---

## 3️⃣ ACTUALIZAR BD (2 min)

### Pasos:
1. Abre: `sql/schema_lugares_guadalajara.sql`
2. Selecciona todo: `Ctrl+A`
3. Copia: `Ctrl+C`
4. Ve a: https://app.supabase.com → SQL Editor
5. Nueva query: `+ Nueva Query`
6. Pega: `Ctrl+V`
7. Ejecuta: Botón azul "Ejecutar"
8. Espera: "Query executed successfully" ✅

---

## 4️⃣ COMPILAR Y CORRER (5 min)

### Terminal:
```bash
cd c:\Users\polpo\travelmex
flutter pub get
flutter run
```

### Espera ~2 minutos (primera vez es lenta)

---

## ✅ PRUEBA RÁPIDA

```
1. Register: testuser@example.com / Test123456
2. Inicio: Deberías ver 10 destinos
3. Mapa: Botón abajo derecha
4. Destino: Presiona marcador
5. Reseña: Escribe comentario + ⭐⭐⭐⭐⭐
6. Diseño: Ruta /diseno (sistema visual)
```

---

## 📄 DOCUMENTACIÓN

Si necesitas más detalle, lee en orden:

1. **INSTRUCCIONES_FINALES.md** ← ✅ RECOMENDADO
2. CONFIGURACION_GOOGLE_MAPS.md
3. SISTEMA_RESENAS.md
4. RESUMEN_ACTUALIZACION_FINAL.md
5. ARBOL_PROYECTO_COMPLETO.md

---

## 🚨 Problemas?

**Mapa no muestra**
```
→ Verifica GOOGLE_MAPS_API_KEY no esté vacía
→ Verifica que ejecutaste schema SQL
→ Recarga: flutter run
```

**Error de compilación**
```
→ Ejecuta: flutter clean
→ Luego: flutter pub get
→ Luego: flutter run
```

**No ves destinos**
```
→ Verifica en Supabase que tabla `destinations` tiene 10 filas
→ Verifica conexión a internet
```

---

## 🎉 ¡LISTO!

Ahora tu app está:
- ✅ Compilada
- ✅ Funcional
- ✅ Con 10 destinos reales
- ✅ Con Google Maps
- ✅ Con sistema de reseñas
- ✅ Con diseño completo

**¡Disfrútalo!** 🚀
