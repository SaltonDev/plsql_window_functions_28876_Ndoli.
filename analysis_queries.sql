-- ==========================================
-- STEP 4: PART A - SQL JOINS IMPLEMENTATION
-- ==========================================

-- 1. INNER JOIN: Retrieve tenants with valid payments
-- Use case: Identify active revenue-generating tenants[cite: 64].
SELECT t.tenant_name, p.amount, p.payment_date
FROM tenants t
INNER JOIN payments p ON t.tenant_id = p.tenant_id;

-- 2. LEFT JOIN: Identify tenants who have never made a transaction
-- Use case: Find high-risk tenants or those with pending first payments[cite: 65].
SELECT t.tenant_name, p.amount
FROM tenants t
LEFT JOIN payments p ON t.tenant_id = p.tenant_id
WHERE p.payment_id IS NULL;

-- 3. RIGHT JOIN: Detect properties with no sales activity
-- Use case: Identify vacant properties in the portfolio[cite: 66].
SELECT pr.property_name, t.tenant_name
FROM tenants t
RIGHT JOIN properties pr ON t.property_id = pr.property_id
WHERE t.tenant_id IS NULL;

-- 4. FULL OUTER JOIN: Compare customers and products including unmatched records
-- Use case: Complete audit of all system entities[cite: 67].
SELECT t.tenant_name, pr.property_name
FROM tenants t
FULL OUTER JOIN properties pr ON t.property_id = pr.property_id;

-- 5. SELF JOIN: Compare properties within the same city
-- Use case: Regional performance benchmarking[cite: 69].
SELECT a.property_name AS Unit_A, b.property_name AS Unit_B, a.city
FROM properties a
JOIN properties b ON a.city = b.city AND a.property_id <> b.property_id;


-- ==========================================
-- STEP 5: PART B - WINDOW FUNCTIONS
-- ==========================================

-- 1. RANKING FUNCTIONS: Top properties by revenue
-- Use case: Identify the most profitable units per city[cite: 78].
SELECT pr.property_name, pr.city, SUM(pa.amount) as total_revenue,
       RANK() OVER(PARTITION BY pr.city ORDER BY SUM(pa.amount) DESC) as revenue_rank
FROM properties pr
JOIN tenants t ON pr.property_id = t.property_id
JOIN payments pa ON t.tenant_id = pa.tenant_id
GROUP BY pr.property_name, pr.city;

-- 2. AGGREGATE WINDOW FUNCTIONS: Running monthly totals
-- Use case: Tracking cumulative cash flow over time using ROWS frame[cite: 79].
SELECT payment_date, amount,
       SUM(amount) OVER(ORDER BY payment_date 
                        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM payments;

-- 3. NAVIGATION FUNCTIONS: Period-to-period comparison
-- Use case: Track rent increases or payment fluctuations using LAG()[cite: 80].
SELECT tenant_id, payment_date, amount,
       LAG(amount) OVER(PARTITION BY tenant_id ORDER BY payment_date) as last_payment,
       amount - LAG(amount) OVER(PARTITION BY tenant_id ORDER BY payment_date) as revenue_change
FROM payments;

-- 4. DISTRIBUTION FUNCTIONS: Customer segmentation
-- Use case: Categorizing tenants into four quartiles based on payment size[cite: 81].
SELECT tenant_id, amount,
       NTILE(4) OVER(ORDER BY amount DESC) as tenant_tier
FROM payments;
