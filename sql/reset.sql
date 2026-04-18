-- TravelMex Database Reset
-- Use this script if you want to completely reset the database
-- WARNING: This will delete all existing data!

-- Delete all data (in correct order due to foreign keys)
DELETE FROM reviews;
DELETE FROM destinations;
DELETE FROM profiles;
DELETE FROM categories;

-- Reset sequences if needed
-- ALTER SEQUENCE categories_id_seq RESTART WITH 1;

-- Now run seed.sql to populate with fresh data