
-- ---------------------------------------------
-- ---------------- Analyze --------------------

-- Overall ROMI
SELECT ROUND((SUM(revenue) - SUM(mark_spent)) / SUM(mark_spent) * 100, 2) AS Overall_ROMI
FROM marketing;
-- A 40% ROMI indicates a positive return on investment.
-- to improve it, analyze performance, focus on profitable channels,
-- and enhance content and calls to action.

-- Which types of campaigns work best
with campaign_romi as(
select category, sum(revenue) as total_revenue, sum(mark_spent) as total_spent
from marketing
group by category
)
select category, round((total_revenue - total_spent) / total_spent * 100,2) as romi
from campaign_romi
order by romi desc;
-- Using influencers has provided the best profit-to-loss ratio, 
-- while social shows a negative ratio, 
-- necessitating a review of its budget and strategy.


--  on which date did we spend the most money on advertising?
select c_date, date_format(c_date, "%W") as week_day ,mark_spent
from marketing
where mark_spent = (select max(mark_spent) from marketing);
-- We spent the most on advertising on Friday 02/19/21


-- when we got the biggest revenue?
select c_date, date_format(c_date, "%W") as week_day ,revenue
from marketing
where revenue = (select max(revenue) from marketing);
-- Our revenues were the highest on Friday 19.02.21


-- when conversion rates were high?
with high_ConversionRates as(
select *, (orders / clicks) * 100 as conversion_rates
from marketing
where clicks > 0
)
select *
from high_ConversionRates
where conversion_rates = (select max((orders / clicks) * 100) from high_ConversionRates); 


-- when conversion rates were low
with low_ConversionRates as(
select *, (orders / clicks) * 100 as conversion_rates
from marketing
where clicks > 0
)
select *
from low_ConversionRates
where conversion_rates = (select min((orders / clicks) * 100) from low_ConversionRates); 
-- Identifies when the conversion rates were highest and lowest, 
-- which helps in understanding the effectiveness of campaigns.

-- What were the average order values?
select c_date, round(avg(revenue / orders),2) as avg_AOV
from marketing
group by c_date;
-- The average orders value reliably spans from 4,400 to 5,300.

-- ------------ customers ---------------
-- When buyers are more active?
-- Questions to ask
-- 1. Day of the week 
-- 2. Difference between midweek and weekend
-- 3. Types of marketing


-- 1. Day of the week 
select date_format(c_date, "%W") as day_name, sum(orders) as total_orders
from marketing
group by day_name;
-- Orders consistently increase on weekends, 
-- reflecting a higher volume of purchases during this period.


-- 2. Difference between midweek and weekend
with categorized_day as (
select  *,
		case
		when date_format(c_date, "%W") in ('Friday','Saturday') then "weekends"
		else "weekdays"
end as day_type
from marketing
)
select day_type, round(avg(orders),2) as avg_orders, round(avg(revenue),2) as avg_revenue
from categorized_day
group by day_type;
-- Orders are significantly higher on weekends 
-- compared to the average throughout the rest of the week.


-- 3. Types of marketing
select category, sum(orders) as total_orders
from marketing
group by category;
-- Utilizing influencers and social has significantly boosted our order volume, 
-- driving a substantial increase in sales.