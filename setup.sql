-- =====================================================
-- WealthNest PostgreSQL Setup Script
-- Matches SQLAlchemy models in db/models.py
-- =====================================================

-- Drop existing tables (for clean setup)
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS holdings CASCADE;
DROP TABLE IF EXISTS instruments CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- =====================================================
-- USERS TABLE
-- =====================================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- INSTRUMENTS TABLE
-- =====================================================
CREATE TABLE instruments (
    id SERIAL PRIMARY KEY,
    symbol VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100),
    category VARCHAR(50), -- e.g. Stock, Mutual Fund
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TRANSACTIONS TABLE
-- =====================================================
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    instrument_id INTEGER NOT NULL REFERENCES instruments(id) ON DELETE CASCADE,
    type VARCHAR(10) NOT NULL CHECK (type IN ('BUY', 'SELL')),
    units NUMERIC(12, 4) NOT NULL,
    price NUMERIC(12, 2) NOT NULL,
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- HOLDINGS TABLE
-- =====================================================
CREATE TABLE holdings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    instrument_id INTEGER NOT NULL REFERENCES instruments(id) ON DELETE CASCADE,
    total_units NUMERIC(12, 4) DEFAULT 0,
    average_cost NUMERIC(12, 2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_instrument UNIQUE (user_id, instrument_id)
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- USERS
INSERT INTO users (name, email, hashed_password)
VALUES
('Ayush', 'ayush@example.com', 'hashed_pw_ayush'),
('Test User', 'test@example.com', 'hashed_pw_test');

-- INSTRUMENTS
INSERT INTO instruments (symbol, name, category)
VALUES
('TCS', 'Tata Consultancy Services', 'Stock'),
('INFY', 'Infosys Ltd', 'Stock'),
('HDFCBANK', 'HDFC Bank Ltd', 'Stock'),
('RELIANCE', 'Reliance Industries Ltd', 'Stock'),
('ITC', 'ITC Ltd', 'Stock'),
('SBIN', 'State Bank of India', 'Stock');

-- TRANSACTIONS (BUY + SELL)
INSERT INTO transactions (user_id, instrument_id, type, units, price, transaction_date)
VALUES
(1, 1, 'BUY', 5.0, 3200.00, '2025-10-10'),
(1, 2, 'BUY', 10.0, 1450.00, '2025-10-11'),
(1, 4, 'BUY', 8.0, 2300.00, '2025-10-12'),
(2, 3, 'BUY', 12.0, 1650.00, '2025-10-15'),
(2, 5, 'BUY', 15.0, 420.00, '2025-10-16'),
(2, 6, 'BUY', 20.0, 630.00, '2025-10-17');

-- HOLDINGS (reflecting total position)
INSERT INTO holdings (user_id, instrument_id, total_units, average_cost)
VALUES
(1, 1, 5.0, 3200.00),   -- Ayush - TCS
(1, 2, 10.0, 1450.00),  -- Ayush - INFY
(1, 4, 8.0, 2300.00),   -- Ayush - RELIANCE
(2, 3, 12.0, 1650.00),  -- TestUser - HDFCBANK
(2, 5, 15.0, 420.00),   -- TestUser - ITC
(2, 6, 20.0, 630.00);   -- TestUser - SBIN

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- SELECT * FROM users;
-- SELECT * FROM instruments;
-- SELECT * FROM transactions;
-- SELECT * FROM holdings;

-- =====================================================
-- END OF SCRIPT
-- =====================================================
