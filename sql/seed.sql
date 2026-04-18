-- TravelMex Database Setup
-- Execute this in your Supabase SQL Editor after running schema.sql
-- This script is safe to run multiple times (idempotent)

-- Insert Categories (safe for multiple executions)
INSERT INTO categories (id, name, icon_name) VALUES
(1, 'Playa', 'beach_access'),
(2, 'Montaña', 'terrain'),
(3, 'Ciudad', 'location_city'),
(4, 'Cultural', 'museum'),
(5, 'Aventura', 'hiking'),
(6, 'Relax', 'spa')
ON CONFLICT (id) DO NOTHING;

-- Insert Sample Destinations (safe for multiple executions)
INSERT INTO destinations (id, name, description, location, price_per_night, rating_avg, image_url, category_id, latitude, longitude, is_featured) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'Lago de Chapala', 'El lago más grande de México cerca de Guadalajara. Ideal para paseos en barco y atardeceres junto al agua.', 'Chapala, Guadalajara, Jalisco', 250.00, 4.8, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 1, 20.4060, -103.1220, true),
('550e8400-e29b-41d4-a716-446655440001', 'Bosque de la Primavera', 'Área natural protegida con senderos, volcanes y vistas verdes. Perfecto para hiking y camping.', 'Zapopan, Guadalajara, Jalisco', 180.00, 4.6, 'https://images.unsplash.com/photo-1464822759844-d150f39a97d3?w=800', 2, 20.7819, -103.4500, true),
('550e8400-e29b-41d4-a716-446655440002', 'Centro Histórico Guadalajara', 'El corazón de la ciudad con arquitectura colonial, museos y una vibrante vida cultural.', 'Centro Histórico, Guadalajara, Jalisco', 200.00, 4.7, 'https://images.unsplash.com/photo-1518105779142-d975f22f1b0a?w=800', 3, 20.6736, -103.3476, true),
('550e8400-e29b-41d4-a716-446655440003', 'Teatro Degollado', 'Teatro histórico con espectáculos culturales y arquitectura impresionante en el centro de Guadalajara.', 'Centro Histórico, Guadalajara, Jalisco', 150.00, 4.9, 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 4, 20.6736, -103.3476, false),
('550e8400-e29b-41d4-a716-446655440004', 'Barranca de Huentitán', 'Imponente cañón natural con rutas de senderismo y vistas espectaculares cerca de Guadalajara.', 'Huentitán, Guadalajara, Jalisco', 220.00, 4.5, 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800', 5, 20.7488, -103.4552, true),
('550e8400-e29b-41d4-a716-446655440005', 'Mercado San Juan de Dios', 'Mercado tradicional con comida tapatía, artesanías y sabor local. Un icono de Guadalajara.', 'Centro Histórico, Guadalajara, Jalisco', 280.00, 4.4, 'https://images.unsplash.com/photo-1539635278303-d4002c07eae3?w=800', 1, 20.6733, -103.3496, false),
('550e8400-e29b-41d4-a716-446655440006', 'Bosque Los Colomos', 'Parque urbano con lago, jardín japonés y senderos naturales dentro de Guadalajara.', 'Providencia, Guadalajara, Jalisco', 160.00, 4.3, 'https://images.unsplash.com/photo-1464822759844-d150f39a97d3?w=800', 2, 20.7219, -103.3925, false),
('550e8400-e29b-41d4-a716-446655440007', 'Andares Guadalajara', 'Zona comercial y de entretenimiento con tiendas, restaurantes y vida nocturna moderna.', 'Puerta de Hierro, Guadalajara, Jalisco', 190.00, 4.6, 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800', 4, 20.7237, -103.3805, false)
ON CONFLICT (id) DO NOTHING;

-- Insert Sample Profiles (safe for multiple executions)
INSERT INTO profiles (id, email, name, avatar_url) VALUES
('11111111-1111-1111-1111-111111111111', 'usuario1@travelmex.com', 'Camila', 'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=200'),
('22222222-2222-2222-2222-222222222222', 'usuario2@travelmex.com', 'Alejandro', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'),
('33333333-3333-3333-3333-333333333333', 'usuario3@travelmex.com', 'Valeria', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200'),
('44444444-4444-4444-4444-444444444444', 'usuario4@travelmex.com', 'Diego', 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200'),
('55555555-5555-5555-5555-555555555555', 'usuario5@travelmex.com', 'Mariana', 'https://images.unsplash.com/photo-1502685104226-ee32379fefbe?w=200')
ON CONFLICT (id) DO NOTHING;

-- Insert Sample Reviews (safe for multiple executions)
INSERT INTO reviews (id, destination_id, user_id, comment, rating) VALUES
('66666666-6666-6666-6666-666666666666', '550e8400-e29b-41d4-a716-446655440000', '11111111-1111-1111-1111-111111111111', 'Increíble experiencia, las playas son paradisíacas. El servicio fue excelente.', 5),
('77777777-7777-7777-7777-777777777777', '550e8400-e29b-41d4-a716-446655440000', '22222222-2222-2222-2222-222222222222', 'Muy buena ubicación y precios accesibles. Recomiendo ampliamente.', 5),
('88888888-8888-8888-8888-888888888888', '550e8400-e29b-41d4-a716-446655440001', '33333333-3333-3333-3333-333333333333', 'Las vistas son espectaculares. Un lugar mágico para conectar con la naturaleza.', 5),
('99999999-9999-9999-9999-999999999999', '550e8400-e29b-41d4-a716-446655440002', '44444444-4444-4444-4444-444444444444', 'El centro histórico es fascinante. Hay mucho que explorar y aprender.', 4),
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '550e8400-e29b-41d4-a716-446655440003', '55555555-5555-5555-5555-555555555555', 'La casa de Frida es impresionante. Una experiencia cultural única.', 5)
ON CONFLICT (id) DO NOTHING;

-- Row Level Security Policies
-- Create policies only if they don't already exist

-- Allow public read access to all tables
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'categories' AND policyname = 'Public read access for categories') THEN
        CREATE POLICY "Public read access for categories" ON categories FOR SELECT USING (true);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'destinations' AND policyname = 'Public read access for destinations') THEN
        CREATE POLICY "Public read access for destinations" ON destinations FOR SELECT USING (true);
    END IF;
END $$;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'reviews' AND policyname = 'Public read access for reviews') THEN
        CREATE POLICY "Public read access for reviews" ON reviews FOR SELECT USING (true);
    END IF;
END $$;

-- Allow authenticated users to insert reviews
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'reviews' AND policyname = 'Authenticated users can insert reviews') THEN
        CREATE POLICY "Authenticated users can insert reviews" ON reviews FOR INSERT WITH CHECK (auth.uid() = user_id);
    END IF;
END $$;

-- Allow users to update their own reviews
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'reviews' AND policyname = 'Users can update own reviews') THEN
        CREATE POLICY "Users can update own reviews" ON reviews FOR UPDATE USING (auth.uid() = user_id);
    END IF;
END $$;

-- Allow users to delete their own reviews
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'reviews' AND policyname = 'Users can delete own reviews') THEN
        CREATE POLICY "Users can delete own reviews" ON reviews FOR DELETE USING (auth.uid() = user_id);
    END IF;
END $$;