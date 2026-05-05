# 🗺️ Configuración Google Maps - TravelMex

## 📋 Pasos para Habilitar Google Maps API

### PASO 1: Crear Proyecto en Google Cloud Console

1. Ve a https://console.cloud.google.com
2. Haz clic en "Seleccionar un proyecto"
3. Haz clic en "NUEVO PROYECTO"
4. Nombre: `TravelMex`
5. Haz clic en "CREAR"
6. Espera a que se cree el proyecto (2-3 minutos)

### PASO 2: Habilitar las APIs Necesarias

1. En la búsqueda superior, escribe: `Maps SDK for Android`
2. Selecciona el resultado
3. Haz clic en "HABILITAR"
4. Regresa y busca: `Maps SDK for iOS`
5. Haz clic en "HABILITAR"
6. También busca y habilita: `Maps SDK for Web` (opcional)

### PASO 3: Crear Clave de API

1. Ve a "Credenciales" (izquierda)
2. Haz clic en "CREAR CREDENCIALES" → "Clave de API"
3. Copia la clave que aparece (la necesitarás)
4. Haz clic en "RESTRICCIONES"
5. En "Restricción de aplicaciones":
   - Selecciona "Aplicaciones Android"
   - Haz clic "Agregar un elemento"
   - Necesitarás tu SHA-1 (ver más abajo)

### PASO 4: Obtener SHA-1 del Proyecto Flutter

```bash
cd c:\Users\polpo\travelmex

# En Windows PowerShell:
keytool -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

Busca la línea que dice `SHA1: xxxxxxxxxxxxxxx...` y cópiala.

### PASO 5: Configurar Android

**Archivo**: `android/app/src/main/AndroidManifest.xml`

Agrega esto DENTRO del tag `<application>` (después de `<activity>`):

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="TU_CLAVE_DE_API_AQUI" />
```

**Archivo**: `android/app/build.gradle.kts`

Busca la sección `dependencies` y asegúrate que esté:

```gradle
dependencies {
    implementation 'com.google.android.gms:play-services-maps:18.2.0'
}
```

### PASO 6: Configurar iOS (Opcional)

**Archivo**: `ios/Runner/Info.plist`

Agrega esto:

```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
<key>GoogleMapsApiKey</key>
<string>TU_CLAVE_DE_API_AQUI</string>
```

### PASO 7: Actualizar Clave en TravelMex

**Archivo**: `lib/utilidades/configuracion_google_maps.dart`

```dart
const String GOOGLE_MAPS_API_KEY = 'TU_CLAVE_AQUI';
```

Reemplaza `TU_CLAVE_AQUI` con tu clave real de Google Cloud.

### PASO 8: Verificar pubspec.yaml

El archivo `pubspec.yaml` debe tener:

```yaml
dependencies:
  google_maps_flutter: ^2.4.0
  location: ^4.4.0
```

Si no están, agrega estas líneas:

```bash
flutter pub add google_maps_flutter
flutter pub add location
```

---

## 📱 Ubicaciones en Guadalajara (Coordenadas GPS)

| Lugar | Latitud | Longitud | Descripción |
|-------|---------|----------|------------|
| Teatro Degollado | 20.6736 | -103.3476 | Centro histórico |
| Catedral | 20.6749 | -103.3491 | Corazón de la ciudad |
| Mercado San Juan | 20.6733 | -103.3496 | Gastronomía |
| Parque Metropolitano | 20.6520 | -103.2850 | Recreación |
| Hospicio Cabañas | 20.6655 | -103.3410 | Patrimonio UNESCO |
| Parque Agua Azul | 20.6790 | -103.3750 | Familia |
| Zapopan | 20.7145 | -103.4031 | Basílica |
| Barrio San Felipe | 20.6570 | -103.2750 | Bohemio |
| Avenida Chapultepec | 20.6620 | -103.2680 | Gastronómico |
| Lago de Chapala | 20.4060 | -103.1220 | Pueblo Mágico |

---

## 🗺️ Centro de Guadalajara

```
Latitud:  20.6634
Longitud: -103.2822
Zoom:     13.0 (Defecto)
```

---

## ✅ Checklist de Configuración

- [ ] Crea proyecto en Google Cloud Console
- [ ] Habilita Maps SDK for Android
- [ ] Habilita Maps SDK for iOS
- [ ] Crea clave de API
- [ ] Obtén SHA-1 del proyecto
- [ ] Restringe clave a Android (agregar SHA-1)
- [ ] Actualiza `android/app/src/main/AndroidManifest.xml`
- [ ] Actualiza `android/app/build.gradle.kts`
- [ ] Actualiza `lib/utilidades/configuracion_google_maps.dart`
- [ ] Ejecuta `flutter pub get`
- [ ] Ejecuta `flutter run`
- [ ] Verifica que el mapa aparezca en la app

---

## 🐛 Solución de Problemas

### "Google Maps API key not found"
**Solución**: Verifica que la clave esté correcta en AndroidManifest.xml

### "Tiles cannot be loaded"
**Solución**: Espera unos minutos después de habilitar la API

### "Se ve gris el mapa"
**Solución**: 
1. Reinicia `flutter run`
2. Verifica conexión a internet
3. Comprueba que la clave de API esté activa

### "Error: PERMISSION_DENIED"
**Solución**: 
1. Restringe la clave a Android/iOS
2. Agrega SHA-1 correcto
3. Espera 5 minutos a que se propague

---

## 📲 Prueba de Funcionamiento

```bash
cd c:\Users\polpo\travelmex

# Limpiar build anterior
flutter clean

# Descargar dependencias
flutter pub get

# Ejecutar con verbose para ver errores
flutter run -v
```

En la app:
1. Inicia sesión
2. Toca el icono de mapa
3. ✅ Deberías ver Google Maps con marcadores

---

## 🎯 Características del Mapa en TravelMex

✅ **Vista de 10 destinos de Guadalajara**
✅ **Marcadores clickeables**
✅ **Información emergente (BottomSheet)**
✅ **Botón "Mi ubicación"**
✅ **Botón volver a Guadalajara**
✅ **Zoom automático**
✅ **Navegación a detalles del destino**

---

## 💡 Notas

- La clave de API es diferente para desarrollo y producción
- En producción usa una clave restrictiva
- Google Maps puede cobrar después de cierto uso
- La restricción de SHA-1 es importante para seguridad

---

**¡Listo para usar Google Maps en TravelMex!** 🚀
