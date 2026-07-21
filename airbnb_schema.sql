-- ==========================================
-- AIRBNB CLONE - DATABASE SCHEMA (DDL)
-- ==========================================

-- 1. USERS TABLE
CREATE TABLE users (
  email text UNIQUE NOT NULL,
  hashed_password text NOT NULL,
  username text UNIQUE NOT NULL,
  phone_number text UNIQUE NOT NULL,
  created_at timestamp DEFAULT now(),
  id uuid PRIMARY KEY DEFAULT gen_random_uuid()
);

-- 2. HOSTS TABLE (1:1 Relationship with users)
CREATE TABLE hosts (
  iban text UNIQUE NOT NULL,
  partita_iva text UNIQUE NOT NULL,
  user_id uuid UNIQUE NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  id uuid PRIMARY KEY DEFAULT gen_random_uuid()
);

-- 3. PROPERTIES TABLE (1:N Relationship from hosts)
CREATE TABLE properties (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  host_id uuid NOT NULL REFERENCES hosts(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text NOT NULL,
  location text NOT NULL
);

-- 4. BOOKINGS TABLE (Transactional Table - N:1 to users and N:1 to properties)
CREATE TABLE bookings (
  id_booked uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  property_id uuid NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  price integer NOT NULL, -- Price stored in cents to prevent floating point inaccuracies
  check_in_date date NOT NULL,
  check_out_date date NOT NULL,
  created_at timestamp NOT NULL DEFAULT now()
);
