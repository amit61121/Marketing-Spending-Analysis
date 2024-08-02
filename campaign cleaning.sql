-- import all the data from csv with table data import wizard
select *
from campaigns;

-- Making a copy for work
create table marketing
SELECT * 
FROM campaigns;

select *
from marketing;

-- ---------------------------------------------
-- -------------- Clean data -------------------

-- 1. Remove Duplicates
-- 2. Standardize the Data - issues like spelling
-- 3. Null Values or blank values
-- 4. Remove Any Columns or rows


-- 1. Remove Duplicates
-- Check for duplicate campaigns within a single day
SELECT 	c_date, campaign_id,
		COUNT(*) AS count
FROM marketing
GROUP BY c_date, campaign_id
HAVING COUNT(*) > 1;

SELECT 	c_date, campaign_name,
		COUNT(*) AS count
FROM marketing
GROUP BY c_date, campaign_name
HAVING COUNT(*) > 1;

-- No duplicates were found


-- 2. Standardize the Data

-- Converted campaign names to lowercase for consistency
update marketing
set campaign_name = lower(campaign_name);


SELECT *, DATE_FORMAT(c_date, '%W') AS day_of_week
FROM marketing;

-- Checked for misspellings in categories
select distinct category
from marketing;

-- Mismatched orders and revenue
select *
from marketing
where (orders > 0 and revenue = 0) or (orders = 0 and revenue > 0);


-- 3. Null Values or blank values
SELECT *
FROM marketing
WHERE
    id IS NULL OR TRIM(id) = '' OR
    c_date IS NULL OR TRIM(c_date) = '' OR
    campaign_name IS NULL OR TRIM(campaign_name) = '' OR
    category IS NULL OR TRIM(category) = '' OR
    campaign_id IS NULL OR TRIM(campaign_id) = '' OR
    impressions IS NULL OR TRIM(impressions) = '' OR
    mark_spent IS NULL OR TRIM(mark_spent) = '' OR
    clicks IS NULL OR TRIM(clicks) = '' OR
    leads IS NULL OR TRIM(leads) = '' OR
    orders IS NULL OR TRIM(orders) = '' OR
    revenue IS NULL OR TRIM(revenue) = '';


-- 4. Remove Any Columns or rows
-- No columns or rows needed to be removed.