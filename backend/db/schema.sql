-- PostgreSQL Schema DDL for All India Administrative Location Directory

-- Enable trigram extension for scalable text searching
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- States and Union Territories Table
CREATE TABLE IF NOT EXISTS states (
    id SERIAL PRIMARY KEY,
    official_code VARCHAR(50) UNIQUE NOT NULL,
    name_en VARCHAR(100) NOT NULL,
    name_hi VARCHAR(100),
    location_type VARCHAR(50) DEFAULT 'STATE', -- 'STATE' or 'UT'
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Districts Table
CREATE TABLE IF NOT EXISTS districts (
    id SERIAL PRIMARY KEY,
    official_code VARCHAR(50) UNIQUE NOT NULL,
    state_id INTEGER NOT NULL REFERENCES states(id) ON DELETE CASCADE,
    name_en VARCHAR(100) NOT NULL,
    name_hi VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Sub-Districts / Tehsils Table
CREATE TABLE IF NOT EXISTS sub_districts (
    id SERIAL PRIMARY KEY,
    official_code VARCHAR(50) UNIQUE NOT NULL,
    district_id INTEGER NOT NULL REFERENCES districts(id) ON DELETE CASCADE,
    name_en VARCHAR(100) NOT NULL,
    name_hi VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Villages Table
CREATE TABLE IF NOT EXISTS villages (
    id SERIAL PRIMARY KEY,
    official_code VARCHAR(50) UNIQUE NOT NULL,
    sub_district_id INTEGER NOT NULL REFERENCES sub_districts(id) ON DELETE CASCADE,
    name_en VARCHAR(100) NOT NULL,
    name_hi VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance & cascading search optimization
CREATE INDEX IF NOT EXISTS idx_districts_state_id ON districts(state_id);
CREATE INDEX IF NOT EXISTS idx_sub_districts_district_id ON sub_districts(district_id);
CREATE INDEX IF NOT EXISTS idx_villages_sub_district_id ON villages(sub_district_id);

-- Trigram indexes for fast prefix/infix searching in English and Hindi village names
CREATE INDEX IF NOT EXISTS idx_villages_name_en_trgm ON villages USING gin (name_en gin_trgm_ops);
CREATE INDEX IF NOT EXISTS idx_villages_name_hi_trgm ON villages USING gin (name_hi gin_trgm_ops);
