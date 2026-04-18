# TravelMex 🏖️

Aplicación móvil completa de turismo para México construida con Flutter y Supabase.

## ✨ Características

- 🏠 **Home Screen**: SliverAppBar con gradiente, destinos destacados y filtros por categoría
- 🔍 **Búsqueda**: Búsqueda en tiempo real y vista de mapa interactivo
- 📋 **Detalles**: Galerías de imágenes, reseñas, calificaciones y sistema de reservas
- 🎨 **Diseño Premium**: Glassmorphism, gradientes y animaciones suaves
- 📱 **UI/UX Moderna**: Componentes personalizados y navegación intuitiva
- 🔄 **Estado Reactivo**: Provider para manejo eficiente del estado
- ☁️ **Backend**: Supabase con PostgreSQL y Row Level Security
- ⚡ **Performance**: const constructors, lazy loading y optimizaciones

## 🚀 Setup Completo

### 1. Configuración de Supabase

#### Paso 1: Crear proyecto en Supabase
1. Ve a [Supabase Dashboard](https://supabase.com/dashboard)
2. Crea un nuevo proyecto
3. Espera a que se complete la configuración inicial

#### Paso 2: Configurar Base de Datos
1. Ve a la sección **SQL Editor** en tu dashboard de Supabase
2. Ejecuta el archivo `sql/schema.sql` para crear las tablas
3. Ejecuta el archivo `sql/seed.sql` para poblar con datos de prueba

**Si obtienes error de "duplicate key value":**
- Los datos ya están insertados, puedes ignorar el error
- O ejecuta `sql/reset.sql` primero para limpiar la base de datos
- Luego vuelve a ejecutar `sql/seed.sql`

#### Paso 3: Configurar la App
1. Copia tu **Project URL** y **anon public key** del dashboard de Supabase
2. Actualiza `lib/main.dart` con tus credenciales:

```dart
await Supabase.initialize(
  url: 'TU_SUPABASE_URL',
  anonKey: 'TU_SUPABASE_ANON_KEY',
);
```

### 2. Flutter Setup

```bash
# Instalar dependencias
flutter pub get

# Verificar configuración
flutter doctor

# Ejecutar la app
flutter run
```

### 3. Probar Conexión con Supabase

```bash
# Ejecutar app de prueba de Supabase
flutter run lib/supabase_test.dart
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada con configuración de Supabase
├── travelmex.dart           # Archivo barrel para exports
├── theme/
│   └── app_theme.dart       # Tema completo con colores y componentes
├── models/
│   ├── category.dart        # Modelo de categorías
│   ├── destination.dart     # Modelo de destinos turísticos
│   └── review.dart          # Modelo de reseñas
├── services/
│   └── supabase_service.dart # Servicio singleton para operaciones CRUD
├── providers/
│   └── providers.dart       # State management con Provider
├── screens/
│   ├── app_shell.dart       # Shell principal con navegación
│   ├── home/
│   │   └── home_screen.dart # Pantalla principal
│   ├── search/
│   │   └── search_screen.dart # Pantalla de búsqueda
│   ├── details/
│   │   └── details_screen.dart # Detalles de destino
│   ├── profile_screen.dart  # Perfil de usuario
│   └── add_review_screen.dart # Agregar reseñas
├── widgets/
│   ├── shared_widgets.dart  # Componentes compartidos
│   ├── travel_card.dart     # Tarjeta de destino
│   ├── category_chip.dart   # Chip de categoría
│   ├── map_bottom_sheet.dart # Bottom sheet del mapa
│   └── glass_widgets.dart   # Widgets con glassmorphism
└── supabase_test.dart       # Script de prueba de conexión

sql/
├── schema.sql               # Schema de base de datos (tablas + índices)
├── seed.sql                 # Datos de prueba + políticas RLS (idempotente)
└── reset.sql                # Reset completo de la base de datos
```

## 🗄️ Base de Datos

### Tablas Principales

- **categories**: Categorías de destinos (Playa, Montaña, Ciudad, etc.)
- **destinations**: Destinos turísticos con ubicación GPS
- **reviews**: Sistema de reseñas y calificaciones

### Políticas de Seguridad

- ✅ Lectura pública para todas las tablas
- 🔐 Escritura solo para usuarios autenticados en reseñas
- 👤 Usuarios pueden editar solo sus propias reseñas

## 🎨 Diseño

### Tema Personalizado
- **Colores**: Palette inspirada en México (azules, dorados, terracota)
- **Tipografía**: Google Fonts (Poppins)
- **Componentes**: Glassmorphism con blur y transparencias
- **Animaciones**: Hero transitions y animaciones suaves

### Glassmorphism Effects
- BackdropFilter con blur para efectos de vidrio
- Gradientes lineales y radiales
- Sombras personalizadas con opacidades variables

## 🔧 Solución de Problemas

### Error: "duplicate key value violates unique constraint"
**Síntomas:** Al ejecutar `seed.sql` obtienes error sobre claves duplicadas
**Solución:**
1. Los datos ya están insertados (puedes ignorar)
2. Para resetear: ejecuta `sql/reset.sql` primero
3. Luego vuelve a ejecutar `sql/seed.sql`

### Error: "relation does not exist"
**Síntomas:** Error al ejecutar consultas SQL
**Solución:** Asegúrate de ejecutar `schema.sql` antes que `seed.sql`

### Error: "Supabase connection failed"
**Síntomas:** La app no puede conectarse a Supabase
**Solución:**
1. Verifica que las credenciales en `main.dart` sean correctas
2. Confirma que el proyecto de Supabase esté activo
3. Revisa que las tablas y políticas estén creadas

### Flutter Analyze muestra warnings
**Síntomas:** `flutter analyze` muestra warnings de código
**Solución:** Los warnings son menores y no afectan la funcionalidad. El código está optimizado para performance.

## 📱 Screenshots

*(Próximamente - agregar screenshots de la app)*

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- [Flutter](https://flutter.dev/) - Framework UI
- [Supabase](https://supabase.com/) - Backend as a Service
- [Unsplash](https://unsplash.com/) - Imágenes de alta calidad
- [Google Fonts](https://fonts.google.com/) - Tipografía
2. Crea un nuevo proyecto
3. Ve a **SQL Editor** y ejecuta el contenido de `sql/schema.sql`
4. Ve a **Settings → API** y copia tu URL y anon key

### 2. Flutter Setup

```bash
# Instalar dependencias
flutter pub get

# Configurar Supabase (opcional - ya está configurado)
# Edita lib/main.dart con tus credenciales de Supabase

# Ejecutar la app
flutter run
```

### 3. Configuración de Plataformas

#### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

#### iOS (`ios/Runner/Info.plist`):
```xml
<dict>
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
</dict>
```

## 🏗️ Arquitectura

```
lib/
├── main.dart                    # Punto de entrada + configuración
├── travelmex.dart               # Exports de barrel
├── theme/
│   └── app_theme.dart           # Sistema de colores y tipografía
├── models/
│   ├── category.dart            # Modelo de categorías
│   ├── destination.dart         # Modelo de destinos
│   └── review.dart              # Modelo de reseñas
├── services/
│   └── supabase_service.dart    # Servicio de base de datos
├── providers/
│   └── providers.dart           # Providers de estado
├── widgets/
│   ├── travel_card.dart         # Tarjetas de destinos
│   ├── category_chip.dart       # Chips de categorías
│   ├── map_bottom_sheet.dart    # Bottom sheet del mapa
│   └── shared_widgets.dart      # Widgets compartidos
└── screens/
    ├── app_shell.dart           # Shell principal con navegación
    ├── home/
    │   └── home_screen.dart     # Pantalla principal
    ├── details/
    │   └── details_screen.dart  # Detalles de destino
    └── search/
        └── search_screen.dart   # Búsqueda y mapa
```

## 🎨 Sistema de Diseño

### Colores
- **Primary**: `#C62300` (Rich Red)
- **Secondary**: `#500073` (Deep Purple)
- **Accent**: `#FAD017` (Gold)
- **Background**: `#EEF5E8` (Light Sage)

### Tipografía
- **Headings**: Sora (ExtraBold/Bold)
- **Body**: Plus Jakarta Sans

### Componentes
- **Border Radius**: 24px (cards), 28px (featured), 999px (pills)
- **Shadows**: Soft black12 para elevación
- **Glass Effect**: BackdropFilter con blur para elementos flotantes

## 📊 Base de Datos

### Tablas
- `categories`: Categorías de destinos
- `destinations`: Destinos turísticos con coordenadas GPS
- `reviews`: Sistema de reseñas con calificaciones

### Características
- UUID para IDs seguros
- Índices optimizados para búsquedas
- Row Level Security activado
- Triggers automáticos para actualizar promedios de rating
- Datos de muestra incluidos

## 🔧 Desarrollo

### Comandos Útiles

```bash
# Verificar código
flutter analyze

# Ejecutar tests
flutter test

# Build para producción
flutter build apk
flutter build ios
```

### Convenciones de Código

- ✅ **const constructors** everywhere para performance
- ✅ **Immutable models** con factory constructors
- ✅ **Provider pattern** para state management
- ✅ **Clean architecture** con separación de responsabilidades
- ✅ **Error handling** con try/catch en servicios
- ✅ **Loading states** en todas las operaciones async

## 📱 Screenshots

*(Agrega screenshots de tu app aquí)*

## 🤝 Contribuir

1. Fork el proyecto
2. Crea tu feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push al branch (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

- [Flutter](https://flutter.dev/) - Framework UI
- [Supabase](https://supabase.com/) - Backend as a Service
- [Unsplash](https://unsplash.com/) - Imágenes de ejemplo
- [Google Fonts](https://fonts.google.com/) - Tipografías

---

**Desarrollado con ❤️ para los amantes del turismo en México**
