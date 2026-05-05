# 📝 Sistema de Reseñas - TravelMex

## 📊 Estructura de Reseñas en BD

### Tabla: `reviews`

```sql
id              UUID PRIMARY KEY
destination_id  UUID (FK → destinations)
user_id         UUID (FK → profiles)
comment         TEXT (máximo 500 caracteres)
rating          INTEGER (1-5 estrellas)
created_at      TIMESTAMP (fecha automática)
```

### Constrains

- **UNIQUE(destination_id, user_id)**: Un usuario solo puede reseñar una vez por destino
- **rating CHECK**: Solo valores 1, 2, 3, 4, 5

---

## 🎯 Flujo de Reseñas

```
1. Usuario en pantalla de detalles
   ↓
2. Toca "Agregar reseña"
   ↓
3. Va a PantallaAgregarResena
   ↓
4. Selecciona calificación (1-5 estrellas)
   ↓
5. Escribe comentario
   ↓
6. Toca "Publicar reseña"
   ↓
7. Se guarda en BD con:
   - destination_id: ID del destino
   - user_id: ID del usuario autenticado
   - comment: Texto escrito
   - rating: Número de estrellas
   ↓
8. TRIGGER: Recalcula rating_avg en tabla destinos
   ↓
9. Se vuelve a pantalla anterior
   ↓
10. Reseña aparece en la lista automáticamente
```

---

## 🔐 Seguridad (RLS Policies)

### Crear Reseña
```
- Solo usuarios autenticados
- user_id debe ser el del usuario que crea
```

### Actualizar Reseña
```
- Solo el dueño de la reseña
- Valida user_id = auth.uid()
```

### Eliminar Reseña
```
- Solo el dueño de la reseña
- Valida user_id = auth.uid()
```

### Leer Reseña
```
- Público (todos pueden leer)
```

---

## 📱 Pantalla de Agregar Reseña

**Archivo**: `lib/pantallas/resenas/pantalla_agregar_resena.dart`

### Componentes:
- ⭐ Selector de 5 estrellas interactivo
- 📝 Campo de comentario multi-línea
- ✅ Botón "Publicar reseña"
- ❌ Botón "Cancelar"

### Validaciones:
- ✓ Usuario debe estar autenticado
- ✓ Comentario no puede estar vacío
- ✓ Calificación entre 1-5
- ✓ Máximo 500 caracteres en comentario

---

## 💾 Métodos en SupabaseService

### Crear Reseña
```dart
Future<ModeloResena> crearResena({
  required String idDestino,
  required String idUsuario,
  required String comentario,
  required int calificacion,
})
```

### Obtener Reseñas de Destino
```dart
Future<List<ModeloResena>> obtenerResenasPorDestino(String idDestino)
```

### Obtener Reseñas de Usuario
```dart
Future<List<ModeloResena>> obtenerResenasPorUsuario(String idUsuario)
```

### Actualizar Reseña
```dart
Future<ModeloResena> actualizarResena({
  required String idResena,
  required String comentario,
  required int calificacion,
})
```

### Eliminar Reseña
```dart
Future<void> eliminarResena(String idResena)
```

---

## 📊 Cálculo de Rating Automático

### Trigger: `refresh_rating_avg()`

Se ejecuta automáticamente cuando:
- ✅ Se INSERTA una nueva reseña
- ✅ Se ACTUALIZA una reseña
- ✅ Se ELIMINA una reseña

### Cálculo:
```sql
AVG(rating) = SUM(rating) / COUNT(reseñas)
Resultado: DECIMAL(3,2) → Ejemplo: 4.50
```

---

## 🎨 Pantalla de Detalles con Reseñas

**Archivo**: `lib/pantallas/detalles/pantalla_detalles.dart`

### Componentes:
1. **Encabezado del Destino**
   - Imagen
   - Nombre
   - Ubicación
   - Rating promedio
   - Precio

2. **Botón Agregar Reseña**
   - Requiere autenticación
   - Abre PantallaAgregarResena

3. **Listado de Reseñas**
   - Avatar del usuario
   - Nombre del usuario
   - Calificación (estrellas)
   - Comentario
   - Fecha relativa (hace X horas)

---

## 🔄 Flujo de Actualización de Rating

```
Usuario publica reseña
        ↓
INSERT en tabla reviews
        ↓
TRIGGER: refresh_rating_avg()
        ↓
UPDATE en tabla destinations:
  rating_avg = AVG(rating)
        ↓
Se actualiza el destino
        ↓
Pantalla de detalles
  muestra nuevo rating
```

---

## 🗂️ Archivos Relacionados

```
lib/
├── pantallas/
│   ├── resenas/
│   │   └── pantalla_agregar_resena.dart ← Crear reseña
│   └── detalles/
│       └── pantalla_detalles.dart ← Ver reseñas
├── modelos/
│   └── modelo_resena.dart ← Estructura de datos
└── servicios/
    └── servicio_supabase.dart ← CRUD de reseñas

sql/
├── schema_limpio.sql ← Tablas y triggers
└── schema_lugares_guadalajara.sql ← Lugares reales
```

---

## 📋 Checklist de Funcionalidad

- [x] Tabla reviews creada
- [x] RLS policies configuradas
- [x] Trigger refresh_rating_avg() funcionando
- [x] Modelo ModeloResena completo
- [x] Métodos CRUD en SupabaseService
- [x] Pantalla PantallaAgregarResena
- [x] Integración en PantallaDetalles
- [x] Validaciones en el formulario
- [x] Guardado en BD automático
- [x] Actualización de ratings automática

---

## 🧪 Cómo Probar Reseñas

1. Inicia sesión con un usuario
2. Ve a la pantalla de inicio
3. Toca en un destino (ej: Teatro Degollado)
4. Se abre PantallaDetalles
5. Desplázate hacia abajo
6. Toca "Agregar reseña"
7. Selecciona 5 estrellas
8. Escribe: "¡Hermoso lugar!"
9. Toca "Publicar reseña"
10. ✅ Aparece en la lista de reseñas
11. El rating promedio se actualiza

---

## ⚠️ Casos Edge

### Usuario intenta reseñar 2 veces
```
Error: UNIQUE constraint violated
Mensaje: "Ya has reseñado este destino"
```

### Usuario sin autenticación
```
Error: No session
Acción: Redirige a login
```

### Comentario vacío
```
Validación: No permite publicar
Mensaje: "Escribe un comentario"
```

### Rating fuera de rango
```
Validación: Valida 1-5
Acción: Desactiva botón si no es válido
```

---

**Sistema de reseñas completamente integrado y funcional** ✅
