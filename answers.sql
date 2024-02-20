    -- 1) Find the product with the highest average revenue per sale?
    
SELECT  Product_name,AVG_Revenue FROM
(
SELECT P.Product_name
	,round(AVG(S.revenue),0) as AVG_Revenue
	,DENSE_RANK() OVER ( order by round(AVG(S.revenue),0) desc) as Rev_rank 
from products P join 
sales S using (product_id )
group by P.Product_name 
) X
where  Rev_rank = 1 ;
    
    -- 2) Find the product with the highest total revenue?
SELECT Product_name, T_Revenue FROM
(
SELECT P.product_name
	,round(sum(S.revenue),0) as T_Revenue
    ,DENSE_RANK() OVER( order by round(sum(S.revenue),0) desc) as Rev_rank 
FROM products P join 
sales S using (product_id )
group by P.product_name
) X
where Rev_rank = 1;
    
    -- 3) Revenue Country wise along with total sales  
    
SELECT 
C.country_name,
SUM(S.revenue) AS T_Rev,
SUM(S.quantity_sold) AS Qty
FROM
    sales S
        JOIN
    countries C USING (country_id)
GROUP BY C.country_name
ORDER BY T_Rev DESC;
    
    -- 4) Rank the Brands based on total Number of products sold 
    
    Select P.brand,sum(S.quantity_sold) as Qty,
    dense_rank() over( order by sum(S.quantity_sold) desc ) as D_rank
    from Products P join sales S
    using(product_id)
    group by brand;
    
    -- 5) Country wise most sold chocolates and their brand name
    
SELECT 
    C.Country_name,
    P.Product_name,
    P.Brand,
    SUM(S.quantity_sold) AS Qty
FROM
    Sales S
        JOIN
    products P ON P.product_id = S.product_id
        JOIN
    countries C ON S.country_id = C.country_id
GROUP BY C.country_name , P.product_name , P.brand;
    
-- 6) Update date format " 2024-02-14 " into " 14-FEB-2024 "

-- Create new column
ALTER TABLE Sales
ADD COLUMN new_date_column VARCHAR(12);

-- Update the new column with the formatted date
UPDATE Sales 
SET new_date_column = DATE_FORMAT(sale_date, '%d-%b-%Y');

-- Drop the old column to overwrite it (optional)
ALTER TABLE Sales
DROP COLUMN sale_date;
