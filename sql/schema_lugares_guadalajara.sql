-- TravelMex Database Schema (Limpio y Funcional)
-- Con lugares REALES e ICÓNICOS de Guadalajara
-- Ejecuta esto en el SQL Editor de Supabase

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. CATEGORIES TABLE
DROP TABLE IF EXISTS categories CASCADE;
CREATE TABLE categories (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    icon_name TEXT NOT NULL
);

INSERT INTO categories (id, name, icon_name) VALUES
(1, 'Playas', 'beach'),
(2, 'Montañas', 'mountain'),
(3, 'Ruinas', 'ruins'),
(4, 'Cenotes', 'cenote'),
(5, 'Comida', 'food'),
(6, 'Ciudades', 'city')
ON CONFLICT (id) DO NOTHING;

-- 2. DESTINATIONS TABLE
DROP TABLE IF EXISTS destinations CASCADE;
CREATE TABLE destinations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    location TEXT NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL,
    rating_avg DECIMAL(3,2) DEFAULT 0.0,
    image_url TEXT NOT NULL,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
    latitude DECIMAL(10,8) NOT NULL,
    longitude DECIMAL(11,8) NOT NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. PROFILES TABLE
DROP TABLE IF EXISTS profiles CASCADE;
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    name TEXT,
    avatar_url TEXT,
    bio TEXT,
    phone TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. REVIEWS TABLE
DROP TABLE IF EXISTS reviews CASCADE;
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    comment TEXT NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(destination_id, user_id)
);

-- 5. INDEXES
CREATE INDEX idx_destinations_category ON destinations(category_id);
CREATE INDEX idx_destinations_rating ON destinations(rating_avg DESC);
CREATE INDEX idx_destinations_featured ON destinations(is_featured);
CREATE INDEX idx_reviews_destination ON reviews(destination_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);

-- 6. ROW LEVEL SECURITY
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE destinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Public read access for all
DROP POLICY IF EXISTS "Public read categories" ON categories;
CREATE POLICY "Public read categories" ON categories FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read destinations" ON destinations;
CREATE POLICY "Public read destinations" ON destinations FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read profiles" ON profiles;
CREATE POLICY "Public read profiles" ON profiles FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read reviews" ON reviews;
CREATE POLICY "Public read reviews" ON reviews FOR SELECT USING (true);

-- Profile policies
DROP POLICY IF EXISTS "Users can insert own profile" ON profiles;
CREATE POLICY "Users can insert own profile" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON profiles;
CREATE POLICY "Users can update own profile" ON profiles
    FOR UPDATE USING (auth.uid() = id);

-- Reviews policies
DROP POLICY IF EXISTS "Users can create reviews" ON reviews;
CREATE POLICY "Users can create reviews" ON reviews
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own reviews" ON reviews;
CREATE POLICY "Users can update own reviews" ON reviews
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own reviews" ON reviews;
CREATE POLICY "Users can delete own reviews" ON reviews
    FOR DELETE USING (auth.uid() = user_id);

-- 7. RATING AVERAGE FUNCTION
DROP FUNCTION IF EXISTS refresh_rating_avg() CASCADE;
CREATE OR REPLACE FUNCTION refresh_rating_avg()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE destinations
    SET rating_avg = (
        SELECT COALESCE(AVG(rating)::DECIMAL(3,2), 0.0)
        FROM reviews
        WHERE destination_id = COALESCE(NEW.destination_id, OLD.destination_id)
    )
    WHERE id = COALESCE(NEW.destination_id, OLD.destination_id);
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- 8. TRIGGERS
DROP TRIGGER IF EXISTS trigger_refresh_rating_insert ON reviews;
CREATE TRIGGER trigger_refresh_rating_insert
    AFTER INSERT ON reviews FOR EACH ROW
    EXECUTE FUNCTION refresh_rating_avg();

DROP TRIGGER IF EXISTS trigger_refresh_rating_update ON reviews;
CREATE TRIGGER trigger_refresh_rating_update
    AFTER UPDATE ON reviews FOR EACH ROW
    EXECUTE FUNCTION refresh_rating_avg();

DROP TRIGGER IF EXISTS trigger_refresh_rating_delete ON reviews;
CREATE TRIGGER trigger_refresh_rating_delete
    AFTER DELETE ON reviews FOR EACH ROW
    EXECUTE FUNCTION refresh_rating_avg();

-- 9. SAMPLE DESTINATIONS (LUGARES REALES E ICÓNICOS DE GUADALAJARA)
INSERT INTO destinations (id, name, description, location, price_per_night, image_url, category_id, latitude, longitude, is_featured)
VALUES
-- 1. Teatro Degollado (Monumento Icónico)
('d1111111-1111-1111-1111-111111111111', 'Teatro Degollado', 'Icónico teatro neoclásico del Centro Histórico, símbolo cultural de Guadalajara con arquitectura magistral. Sede de la Orquesta Filarmónica.', 'Centro, Av. Degollado, Guadalajara', 85.00, 'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?w=800', 3, 20.6736, -103.3476, true),

-- 2. La Catedral Metropolitana
('d2222222-2222-2222-2222-222222222222', 'Catedral Metropolitana', 'Majestuosa catedral construida en el siglo XVI, corazón espiritual de Guadalajara. Rodeada de plazas y edificios coloniales.', 'Centro, Plaza Guadalajara, Guadalajara', 75.00, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 3, 20.6749, -103.3491, true),

-- 3. Mercado San Juan de Dios
('d3333333-3333-3333-3333-333333333333', 'Mercado San Juan de Dios', 'Tradicional mercado tapatío con gastronomía regional auténtica, artesanías y vida cultural. Experiencia gastronómica única.', 'Centro, Calle Javier Mina, Guadalajara', 45.00, 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800', 5, 20.6733, -103.3496, false),

-- 4. Parque Metropolitano (Bosque Urbano)
('d4444444-4444-4444-4444-444444444444', 'Parque Metropolitano', 'Extenso parque urbano con lagos, senderos, ciclovía y espacios de recreación. Ideal para actividades al aire libre.', 'Av. México, Guadalajara', 60.00, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 2, 20.6520, -103.2850, true),

-- 5. Hospicio Cabañas (Patrimonio UNESCO)
('d5555555-5555-5555-5555-555555555555', 'Hospicio Cabañas', 'Patrimonio de la Humanidad UNESCO con arquitectura neoclásica y murales de Orozco. Joya cultural y artística.', 'Calle López Cotilla, Guadalajara', 80.00, 'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?w=800', 3, 20.6655, -103.3410, true),

-- 6. Parque Agua Azul
('d6666666-6666-6666-6666-666666666666', 'Parque Agua Azul', 'Parque urbano con lagos, jardines botánicos, zoológico y museo. Lugar perfecto para pasar en familia.', 'Av. México 3050, Guadalajara', 70.00, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 2, 20.6790, -103.3750, true),

-- 7. Zapopan y Basílica
('d7777777-7777-7777-7777-777777777777', 'Zapopan y Basílica', 'Tradicional pueblo mágico con la famosa Basílica Catedral. Centro religioso y cultural importante.', 'Zapopan, Guadalajara', 90.00, 'https://images.unsplash.com/photo-1510414842594-a61c69b5ae57?w=800', 6, 20.7145, -103.4031, true),

-- 8. Barrio San Felipe
('d8888888-8888-8888-8888-888888888888', 'Barrio San Felipe', 'Pintoresco barrio artístico y bohemio con galerias, tiendas de artesanía y vida nocturna vibrante.', 'Barrio San Felipe, Guadalajara', 95.00, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 5, 20.6570, -103.2750, false),

-- 9. Avenida Chapultepec
('d9999999-9999-9999-9999-999999999999', 'Avenida Chapultepec', 'Vibrante avenida con restaurantes, bares, tiendas, galerías de arte y ambiente cosmopolita. Corazón gastronómico.', 'Avenida Chapultepec, Guadalajara', 100.00, 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800', 5, 20.6620, -103.2680, true),

-- 10. Lago de Chapala (cercano a Guadalajara)
('daaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Lago de Chapala', 'El lago más grande de México, a 50 km de Guadalajara. Pueblo Mágico con vistas panorámicas y comida regional.', 'Chapala, Jalisco', 120.00, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 1, 20.4060, -103.1220, true)
ON CONFLICT (id) DO NOTHING;
