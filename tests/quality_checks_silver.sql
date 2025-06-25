--============================================
-- Table (crm_cust_info)
--============================================

-- Check for Nulls or Duplicates in Primary Key
-- Expectation : No results
SELECT cst_id ,COUNT(*) FROM silver.crm_cust_info
GROUP BY cst_id 
HAVING COUNT(*) > 1 or cst_id  is null

-- Check for unwanted spaces
-- Expectation : No results
SELECT cst_firstname FROM  silver.crm_cust_info
WHERE cst_firstname  != TRIM(cst_firstname );

SELECT cst_lastname FROM  silver.crm_cust_info
WHERE cst_lastname  != TRIM(cst_lastname );

-- Data Standardization & Cosistency
SELECT DISTINCT cst_marital_status 
FROM silver.crm_cust_info

SELECT DISTINCT cst_gndr 
FROM silver.crm_cust_info


--============================================
-- Table (crm_prd_info)
--============================================

-- Check for Nulls or Duplicates in Primary Key
-- Expectation : No results
SELECT prd_id ,COUNT(*) FROM silver.crm_prd_info
GROUP BY prd_id 
HAVING COUNT(*) > 1 or prd_id   is null

-- Check for Nulls or Negative Values 
-- Expectation : No results
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 or prd_cost is null

-- Check for unwanted spaces
-- Expectation : No results
SELECT prd_nm FROM  silver.crm_prd_info
WHERE prd_nm  != TRIM(prd_nm);

-- Data Standardization & Cosistency
SELECT DISTINCT prd_line 
FROM silver.crm_prd_info

-- Check for Invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt


--============================================
-- Table (crm_sales_details)
--============================================

-- Check for unwanted spaces
-- Expectation : No results
SELECT sls_ord_num FROM  silver.crm_sales_details
WHERE sls_ord_num  != TRIM(sls_ord_num);

-- Referential Integrity Check
-- Expectation : No results
SELECT *
FROM silver.crm_sales_details 
WHERE sls_prd_key  not in (select prd_key from silver.crm_prd_info)

SELECT *
FROM silver.crm_sales_details 
WHERE sls_cust_id  NOT IN (SELECT cst_id  FROM silver.crm_cust_info)

-- Check for Nulls , Negative Values or Invalid Values
-- Expectation : No results

-------------------------------------
-- Date Columns
-------------------------------------
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt <= 0
OR
LEN(sls_order_dt) != 8 

SELECT *
FROM silver.crm_sales_details
WHERE sls_ship_dt<= 0
OR
LEN(sls_ship_dt) != 8 

SELECT *
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0
OR
LEN(sls_due_dt) != 8 

-------------------------------------
-- Sales ,Quantity and Price Columns
-------------------------------------

SELECT *
FROM silver.crm_sales_details
WHERE sls_sales <=0 OR sls_sales IS NULL

SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity <=0 OR sls_quantity IS NULL

SELECT *
FROM silver.crm_sales_details
WHERE sls_price <=0 OR sls_price IS NULL


-- Check for Invalid Dates-- Check for Invalid Date Orders (Order Date > Shipping/Due Dates)
-- Expectation: No ResultsSELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt  OR sls_order_dt > sls_due_dt 

-- Check Data Consistency: Sales = Quantity * Price
-- Expectation: No Results
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price


--============================================
-- Table (erp_cust_az12)
--============================================

-- Identify Out-of-Range Dates
-- Expectation: Birthdates between 1924-01-01 and Today
SELECT DISTINCT bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Data Standardization & Cosistency
SELECT DISTINCT gen 
FROM silver.erp_cust_az12


--============================================
-- Table (erp_loc_a101)
--============================================

-- Data Standardization & Cosistency
SELECT DISTINCT cntry 
from silver.erp_loc_a101


--============================================
-- Table (erp_px_cat_g1v2)
--============================================

-- Check for unwanted spaces
-- Expectation : No results
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance)

-- Data Standardization & Cosistency
SELECT DISTINCT cat
from silver.erp_px_cat_g1v2

SELECT DISTINCT subcat
from silver.erp_px_cat_g1v2

SELECT DISTINCT maintenance
from silver.erp_px_cat_g1v2

