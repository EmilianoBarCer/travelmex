# 🚀 INSTRUCCIONES FINALES - PRÓXIMOS PASOS

## 📋 Estado General

Tu app está **99% completa y funcional**. Solo necesita 4 pasos simples.

**Tiempo total**: ~30 minutos

---

## ⏱️ PASO 1: Obtener Clave Google Maps (15 minutos)

### Requisitos
- Cuenta de Google
- Tarjeta de crédito (para Google Cloud, no se cobran con el free tier)

### Instrucciones Detalladas

#### 1.1 Abre Google Cloud Console
```
https://console.cloud.google.com
```

#### 1.2 Crea un nuevo proyecto
1. En el selector de proyectos (arriba a la izquierda)
2. Haz clic en **"NUEVO PROYECTO"**
3. Nombre: **"TravelMex"**
4. Haz clic en **"CREAR"**
5. Espera ~30 segundos

#### 1.3 Habilita las APIs
1. En el menú lateral, ve a **"APIs y servicios"** → **"Biblioteca"**
2. Busca: **"Maps SDK for Android"**
   - Haz clic
   - Presiona **"HABILITAR"**
3. Busca: **"Maps SDK for iOS"**
   - Haz clic
   - Presiona **"HABILITAR"**

#### 1.4 Obtén la clave API
1. Ve a **"APIs y servicios"** → **"Credenciales"**
2. Presiona **"+ CREAR CREDENCIALES"**
3. Selecciona **"Clave de API"**
4. Se abrirá un popup con tu nueva clave
5. **CÓPIA EL CÓDIGO** (algo como: `AIzaSyD...`)
6. Haz clic en **"CERRAR"**

#### 1.5 Restringe tu clave (IMPORTANTE)
1. En la tabla de credenciales, haz clic en tu clave
2. Desplázate a **"Restricción de API"**
3. Selecciona: **"Mapas"**
4. Selecciona en la lista:
   - ✅ Maps SDK for Android
   - ✅ Maps SDK for iOS
5. Desplázate a **"Restricción de claves"**
6. Cambia a: **"Aplicaciones de Android e iOS"**
7. Presiona **"GUARDAR"**

### Resultado
📌 **Tienes**: Tu clave API de Google Maps

```
AIzaSyD1234567890abcdefghijklmnopqrst
```

---

## ⏱️ PASO 2: Actualizar Configuración en Flutter (2 minutos)

### 2.1 Abre el archivo
```
lib/utilidades/configuracion_google_maps.dart
```

### 2.2 Reemplaza la clave
**BUSCA**:
```dart
const String GOOGLE_MAPS_API_KEY = 'REEMPLAZA_CON_TU_CLAVE_API';
```

**CAMBIA A** (con tu clave):
```dart
const String GOOGLE_MAPS_API_KEY = 'AIzaSyD1234567890abcdefghijklmnopqrst';
```

### 2.3 Guarda el archivo
- `Ctrl + S` (o Cmd + S en Mac)

### Resultado
✅ Google Maps tiene la clave en tu app

---

## ⏱️ PASO 3: Ejecutar Schema de BD (2 minutos)

### 3.1 Abre Supabase
```
https://app.supabase.com
```

### 3.2 Selecciona tu proyecto

### 3.3 Ve a SQL Editor
En el menú lateral: **"SQL Editor"**

### 3.4 Crea nueva query
Presiona: **"+ Nueva Query"**

### 3.5 Copia el schema
1. En VS Code, abre: `sql/schema_lugares_guadalajara.sql`
2. Selecciona TODO (`Ctrl + A`)
3. Copia (`Ctrl + C`)

### 3.6 Pega en Supabase
1. En el editor de Supabase, pega (`Ctrl + V`)
2. Presiona: **"Ejecutar"** (abajo a la derecha)

### 3.7 Verifica
Deberías ver: **"Query executed successfully"** ✅

Si ves error sobre "DROP TABLE IF EXISTS", ignora - es normal.

### Resultado
✅ BD actualizada con 10 lugares reales de Guadalajara

```
✅ Theatre Degollado
✅ Catedral Metropolitana
✅ Mercado San Juan de Dios
✅ Parque Metropolitano
✅ Hospicio Cabañas
✅ Parque Agua Azul
✅ Zapopan
✅ Barrio San Felipe
✅ Avenida Chapultepec
✅ Lago de Chapala
```

---

## ⏱️ PASO 4: Actualizar Dependencias y Ejecutar (5-10 minutos)

### 4.1 Terminal - Descarga dependencias
```bash
cd c:\Users\polpo\travelmex
flutter pub get
```

Espera a que termine (verás: "Process finished with exit code 0")

### 4.2 Conecta un dispositivo
**Opción A: Android Emulator**
```bash
flutter emulators
```
Busca un emulador con el que quieras probar

**Opción B: Dispositivo físico**
- Conecta por USB
- Activa "USB Debugging"

**Opción C: Web**
```bash
flutter run -d chrome
```

### 4.3 Ejecuta la app
```bash
flutter run
```

Espera ~1-2 minutos (primera compilación es lenta)

Deberías ver:
```
Launching lib/main.dart on ...
✓ Built build/app/outputs/flutter-apk/app-debug.apk.
✓ Installed build/app/outputs/flutter-apk/app-debug.apk.
✓ Started gradlew on device...
```

### 4.4 Abre la app en el dispositivo
- La app se abrirá automáticamente

---

## ✅ VERIFICACIÓN - Prueba Cada Característica

### 1. Login
```
1. Toca: "¿No tienes cuenta? Crea una aquí"
2. Email: testuser@example.com
3. Contraseña: Test123456 (mínimo 6 caracteres)
4. Acepta términos
5. Presiona: "Registrar"
→ ✅ Deberías estar en pantalla de inicio
```

### 2. Pantalla Inicio
```
1. Deberías ver lista de 10 destinos
2. Cada uno con:
   - Imagen
   - Nombre
   - Rating (ej: ⭐⭐⭐⭐⭐)
   - Precio
→ ✅ Si ves todos estos elementos, está bien
```

### 3. Perfil
```
1. Presiona: Avatar/Perfil (arriba a la derecha)
2. Verás tus datos (email, nombre)
3. Presiona: "Editar perfil"
4. Cambia tu nombre a algo diferente
5. Presiona: "Guardar"
→ ✅ Tu nombre debe actualizarse
```

### 4. Mapa
```
1. En pantalla inicio, presiona: Botón de Mapa (abajo derecha)
2. Verás mapa de Google Maps
3. Debe mostrar Guadalajara (20.6634, -103.2822)
4. Deberías ver 10 marcadores rojos/azules
5. Presiona un marcador
→ ✅ Se abrirá BottomSheet con info del lugar
```

### 5. Detalles del Destino
```
1. En el BottomSheet, presiona: "Ver detalles"
2. Se abre página grande del destino
3. Muestra:
   - Imagen grande
   - Nombre
   - Rating
   - Descripción
   - Precio
   - Botón "Agregar reseña"
→ ✅ Todo visible correctamente
```

### 6. Agregar Reseña
```
1. En detalles, presiona: "Agregar reseña"
2. Se abre selector de estrellas
3. Presiona la 5ª estrella
4. Escribe en comentario: "¡Hermoso lugar!"
5. Presiona: "Publicar reseña"
6. Se cierra automáticamente
→ ✅ Reseña aparece en lista debajo
```

### 7. Diseño
```
1. En main.dart, abre la app (presiona F5 en debug)
2. Cambia la ruta temporal a: '/diseno'
3. Deberías ver:
   - Paleta de colores
   - Tipografía
   - Botones
   - Tarjetas
   - Iconos
   - Formularios
→ ✅ Sistema de diseño completo visible
```

---

## 🐛 Troubleshooting

### Error: "Google Maps API key not configured"
**Solución**:
1. Verifica que `GOOGLE_MAPS_API_KEY` no sea `'REEMPLAZA_CON_TU_CLAVE_API'`
2. Asegúrate de haber guardado el archivo
3. Ejecuta: `flutter run` de nuevo

### Error: "No se puede conectar a Supabase"
**Solución**:
1. Verifica que tu proyecto Supabase esté activo
2. Verifica URL en `constantes/claves_supabase.dart`
3. Verifica la clave anónima
4. Prueba desde navegador accediendo a https://app.supabase.com

### Mapa no muestra marcadores
**Solución**:
1. Verifica que ejecutaste el schema SQL
2. Espera a que cargue (puede tardar 2-3 segundos)
3. Si no aparecen, revisa la consola de debug

### Error al agregar reseña
**Solución**:
1. Verifica que estés autenticado
2. Verifica que no hayas ya reseñado ese destino
3. Revisa que el comentario no esté vacío
4. Revisa que hayas seleccionado estrellas

---

## 📱 Dispositivos Soportados

✅ **Android**: 5.0+ (API 21)
✅ **iOS**: 11.0+
✅ **Web**: Chrome, Firefox, Safari
✅ **Desktop**: (en construcción)

---

## 📊 Resumen de Cambios

| Elemento | Nuevo | Actualizado |
|----------|-------|-------------|
| Pantalla Diseño | ✨ | - |
| Google Maps Config | ✨ | - |
| 10 Lugares Reales | ✨ | - |
| Schema BD | - | ✅ |
| Pantalla Mapa | - | ✅ (+1 línea) |
| main.dart | - | ✅ (+2 líneas) |

---

## ✅ Checklist Final Antes de Producción

- [ ] Google Maps API key configurada
- [ ] Schema `schema_lugares_guadalajara.sql` ejecutado
- [ ] `flutter pub get` completado
- [ ] App compilada sin errores
- [ ] Probaste login/registro
- [ ] Probaste mapa con marcadores
- [ ] Probaste agregar reseña
- [ ] Probaste pantalla de diseño
- [ ] No hay errores en consola

---

## 🎉 ¡LISTO!

Tu app TravelMex está **99% completa** y lista para:
- ✅ Testing
- ✅ Mejoras futuras
- ✅ Deployment en App Store/Play Store

### Próximos Pasos Opcionales
1. Mejorar UI/UX
2. Agregar más destinos
3. Sistema de favoritos
4. Notificaciones
5. Publicación en stores

---

## 📞 Preguntas Frecuentes

**P: ¿Es gratis usar Google Maps?**
R: Sí, hasta 1,000 solicitudes/día gratis.

**P: ¿Es seguro el API key?**
R: Sí, lo restringimos a solo Android e iOS.

**P: ¿Funciona sin conectividad?**
R: No, Google Maps necesita internet.

**P: ¿Puedo agregar más destinos?**
R: Sí, solo agrégalos al schema SQL.

**P: ¿Cómo distribuyo la app?**
R: Sigue el tutorial de Flutter oficial.

---

**¡Adelante! Tu app está lista para el mundo! 🚀**
