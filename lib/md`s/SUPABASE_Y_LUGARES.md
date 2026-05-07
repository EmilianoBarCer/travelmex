# 📌 Supabase y Lugares de Guadalajara

## 1. Por qué aparece el error al iniciar sesión

El error que ves:

> ClientException: Failed to fetch, uri=https://your-supabase-url.supabase.co/auth/v1/signup?

significa que tu aplicación aún está usando
valores de ejemplo en:

- `lib/constantes/claves_supabase.dart`

Ese archivo tiene actualmente:

```dart
const String urlSupabase = 'https://your-supabase-url.supabase.co';
const String clavAnonSupabase = 'your-anon-key';
```

Debes reemplazar esos valores por los datos reales de tu proyecto Supabase.

---

## 2. Cómo obtener los datos reales de Supabase

1. Abre tu proyecto en Supabase.
2. Ve a **Settings** → **API**.
3. Copia el valor de **Project URL**.
4. Copia la **anon key** (public anonymous key).

Luego pega esos valores en:

`lib/constantes/claves_supabase.dart`

Ejemplo:

```dart
const String urlSupabase = 'https://xxxxxx.supabase.co';
const String clavAnonSupabase = 'eyJhbGciOiJI...';
```

---

## 3. Por qué el archivo está en `.gitignore`

He actualizado `.gitignore` para que:

- `lib/utilidades/configuracion_google_maps.dart`
- `lib/constantes/claves_supabase.dart`

no se suban al repositorio. Esto protege tu clave de Google Maps y tu URL/anon key de Supabase.

---

## 4. Documentación de los lugares de Guadalajara

Los lugares reales están en:

- `sql/schema_lugares_guadalajara.sql`

Ese archivo crea los destinos en la base de datos con:

- nombre
- descripción
- ubicación GPS
- categoría
- precio por noche
- imagen
- rating promedio

### 10 destinos incluidos

1. Teatro Degollado
2. Catedral Metropolitana
3. Mercado San Juan de Dios
4. Parque Metropolitano
5. Hospicio Cabañas
6. Parque Agua Azul
7. Basílica de Zapopan
8. Barrio San Felipe
9. Avenida Chapultepec
10. Lago de Chapala

---

## 5. Cómo cargar los destinos en tu base de datos

1. Abre Supabase.
2. Ve a **SQL Editor**.
3. Crea una nueva query.
4. Copia todo el contenido de `sql/schema_lugares_guadalajara.sql`.
5. Presiona **Run**.

Si el schema ya existe, solo debes ejecutar la parte de `INSERT` para los destinos.

---

## 6. Qué archivos usan Supabase en la app

- `lib/main.dart` → Inicializa Supabase.
- `lib/constantes/claves_supabase.dart` → Contiene URL y anon key.
- `lib/proveedores/proveedor_autenticacion.dart` → Maneja login/registro.
- `lib/servicios/servicio_supabase.dart` → Consulta destinos, reseñas y perfiles.

---

## 7. Qué hacer ahora

### Paso 1
Reemplaza `urlSupabase` y `clavAnonSupabase` en `lib/constantes/claves_supabase.dart`.

### Paso 2
Ejecuta la app otra vez.

### Paso 3
Si quieres, puedo ayudarte a revisar tus datos de Supabase y a completar la documentación del proyecto.
