-- ==========================================
-- 1. DATABASE SCHEMA DESIGN 
-- ==========================================

-- Table for Properties (The 'Parent' table)
CREATE TABLE properties (
    property_id INT PRIMARY KEY,
    property_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    manager_id INT NOT NULL
);

-- Table for Tenants (Links to Properties)
CREATE TABLE tenants (
    tenant_id INT PRIMARY KEY,
    tenant_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    property_id INT,
    CONSTRAINT fk_property 
        FOREIGN KEY (property_id) 
        REFERENCES properties(property_id)
);

-- Table for Lease Payments (Links to Tenants)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    tenant_id INT,
    CONSTRAINT fk_tenant 
        FOREIGN KEY (tenant_id) 
        REFERENCES tenants(tenant_id)
);

-- ==========================================
-- 2. SAMPLE DATA INSERTION
-- ==========================================

-- Insert Properties
INSERT INTO properties (property_id, property_name, city, manager_id) VALUES
(101, 'Kigali Heights', 'Kigali', 1),
(102, 'Palm Court', 'Kigali', 2),
(103, 'Mountain View', 'Musanze', 1),
(104, 'Lakeside Villas', 'Rubavu', 3);

-- Insert Tenants
INSERT INTO tenants (tenant_id, tenant_name, email, property_id) VALUES
(1, 'Alice Umutoni', 'alice@email.rw', 101),
(2, 'Bob Keza', 'bob@email.rw', 101),
(3, 'Charlie Mugisha', 'charlie@email.rw', 102),
(4, 'Diana Ingabire', 'diana@email.rw', 103),
(5, 'Edward Kwizera', 'edward@email.rw', NULL); -- Tenant with no property for LEFT JOIN tests

-- Insert Payments (Historical data for Window Functions)
INSERT INTO payments (payment_id, amount, payment_date, tenant_id) VALUES
(1001, 500.00, '2025-11-01', 1),
(1002, 500.00, '2025-12-01', 1),
(1003, 550.00, '2026-01-01', 1), -- Rent increase for Alice
(1004, 300.00, '2025-12-15', 2),
(1005, 300.00, '2026-01-15', 2),
(1006, 700.00, '2025-12-01', 3),
(1007, 700.00, '2026-01-01', 3),
(1008, 450.00, '2026-01-20', 4);
