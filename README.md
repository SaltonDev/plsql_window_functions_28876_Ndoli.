---

# Property Portfolio Analytics: SQL JOINS & Window Functions Project

**Course:** Database Development with PL/SQL (INSY 8311) **Instructor:** Eric Maniraguha 
**Student Name:** Ndoli Salton
**Student ID:** 28876

---

## 1. Problem Definition (Step 1)

* **Business Context:** Real Estate SaaS platform managing urban residential properties.


* **Data Challenge:** The platform needs to identify underperforming properties and track monthly revenue growth through multi-table relational analysis.


* **Expected Outcome:** Data-driven insights to optimize property management and improve tenant retention.



## 2. Success Criteria (Step 2)

The project implements exactly five measurable goals:

1. **Top 5 Properties** per region using `RANK()`.


2. **Running monthly revenue** totals using `SUM() OVER()`.


3. **Month-over-month growth** using `LAG()`.


4. **Tenant segmentation** into quartiles using `NTILE(4)`.


5. **Three-month moving averages** using `AVG() OVER()`.

---

## 3. Database Schema & ER Diagram (Step 3)

The system uses three related tables: `properties`, `tenants`, and `payments`.

**


[ER Diagram](images/ERD.png)

---

## 4. Part A: SQL JOINS Implementation (Step 4)

*All queries include results and professional business interpretation.* 

### 1. INNER JOIN (Active Revenue)

```sql
SELECT t.tenant_name, p.amount, p.payment_date
FROM tenants t
INNER JOIN payments p ON t.tenant_id = p.tenant_id;

```

**[ER Diagram](images/INNER-JOIN.png)**


**Interpretation:** This result identifies all tenants with successful payment records, ensuring revenue tracking only includes active accounts.

### 2. LEFT JOIN (Payment Gaps)

```sql
SELECT t.tenant_name, p.amount
FROM tenants t
LEFT JOIN payments p ON t.tenant_id = p.tenant_id
WHERE p.payment_id IS NULL;

```

**[ER Diagram](images/LEFT-JOIN.png)**


**Interpretation:** This highlights tenants who have never made a payment, signaling potential vacancies or high-risk accounts.

### 3. RIGHT JOIN (Vacant Properties)

```sql
SELECT pr.property_name, t.tenant_name
FROM tenants t
RIGHT JOIN properties pr ON t.property_id = pr.property_id
WHERE t.tenant_id IS NULL;

```

**[ER Diagram](images/RIGHT-JOIN.png)**


**Interpretation:** Detects properties currently without assigned tenants, helping managers focus on filling vacancies.

### 4. FULL OUTER JOIN (Comprehensive Audit)

```sql
SELECT t.tenant_name, pr.property_name
FROM tenants t
FULL OUTER JOIN properties pr ON t.property_id = pr.property_id;

```

**[ER Diagram](images/FULL-OUTER-JOIN.png)**


**Interpretation:** A full audit comparing all system records to ensure data integrity between the tenant list and the property registry.

### 5. SELF JOIN (Regional Benchmark)

```sql
SELECT a.property_name AS Unit_A, b.property_name AS Unit_B, a.city
FROM properties a
JOIN properties b ON a.city = b.city AND a.property_id <> b.property_id;

```

**[ER Diagram](images/SELF-JOIN.png)**


**Interpretation:** Compares different properties within the same city to allow for regional performance benchmarking.

---

## 5. Part B: Window Functions Implementation (Step 5)

*Demonstrating ranking, aggregate, navigation, and distribution categories.* 

### 1. Ranking Function: `RANK()`

```sql
SELECT property_name, city, amount,
       RANK() OVER(PARTITION BY city ORDER BY amount DESC) as revenue_rank
FROM properties pr
JOIN tenants t ON pr.property_id = t.property_id
JOIN payments pa ON t.tenant_id = pa.tenant_id;

```

**[ER Diagram](images/RANKING.png)**


**Interpretation:** Ranks units within each city to identify top-performing properties by revenue for bonus allocation.

### 2. Aggregate Window Function: `SUM() OVER()`

```sql
SELECT payment_date, amount,
       SUM(amount) OVER(ORDER BY payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as running_total
FROM payments;

```

**![ER Diagram](images/AGGREGATE.png)**


**Interpretation:** Provides a cumulative view of total income collected over time to monitor real-time business growth.

### 3. Navigation Function: `LAG()`

```sql
SELECT tenant_id, payment_date, amount,
       LAG(amount) OVER(PARTITION BY tenant_id ORDER BY payment_date) as last_payment
FROM payments;

```

**[ER Diagram](images/NAVIGATION.png)**


**Interpretation:** Used for period-to-period comparisons to track revenue growth and payment consistency per tenant.

### 4. Distribution Function: `NTILE(4)`

```sql
SELECT tenant_id, amount,
       NTILE(4) OVER(ORDER BY amount DESC) as tenant_tier
FROM payments;

```

**[ER Diagram](images/DISTRIBUTION.png)**


**Interpretation:** Segments tenants into four quartiles based on their total spend to identify the most valuable customers.

---

## 6. Results Analysis (Step 7)

* **Descriptive (What happened?):** Total revenue grew consistently across the Kigali region, though Rubavu showed higher vacancy rates.


* **Diagnostic (Why?):** Revenue increased for specific tenants due to scheduled annual rent adjustments, while some properties lacked sales activity.


* **Prescriptive (What next?):** Implement aggressive marketing for vacant units and offer loyalty discounts for tenants in the top 25% (Tier 1).



## 7. Academic Integrity & References (Step 8)

**Academic Integrity Statement:** "All sources were properly cited. Implementations and analysis represent original work. No AI-generated content was copied without attribution or adaptation." 

**References:** 

* PostgreSQL Official Documentation: Window Functions.


* Supabase SQL Editor Tutorials.



---


