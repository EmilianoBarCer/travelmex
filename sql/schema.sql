Failed to run sql query: ERROR:  42601: syntax error at end of input
LINE 0: 'https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=800', 6, 20.7237, -103.3805, false)
ON CONFLICT (id) DO NOTHING;

-- Insert sample reviews
INSERT INTO reviews (destination_id, user_id, comment, rating) VALUES
((SELECT id FROM destinations WHERE name = 'Lago de Chapala'), '550e8400-e29b-41d4-a716-446655440001', 'Un lugar increíble para ver el atardecer sobre el lago.', 5),
((SELECT id FROM destinations WHERE name = 'Bosque de la Primavera'), '550e8400-e29b-41d4-a716-446655440002', 'Senderos hermosos y aire fresco. Recomendado para caminar.', 4),
((SELECT id FROM destinations WHERE name = 'Teatro Degollado'), '550e8400-e29b-41d4-a716-446655440001', 'Espectacular presentación y ubicación céntrica.', 5),
((SELECT id FROM destinations WHERE name = 'Mercado San Juan de Dios'), '550e8400-e29b-41d4-a716-446655440002', 'Excelente comida local y ambiente tapatío.', 5),
((SELECT id FROM destinations WHERE name = 'Andares Guadalajara'), '550e8400-e29b-41d4-a716-446655440000', 'Buen lugar para pasear y cenar en la ciudad.', 4)
ON CONFLICT (destination_id, user_id) DO NOTHING;
