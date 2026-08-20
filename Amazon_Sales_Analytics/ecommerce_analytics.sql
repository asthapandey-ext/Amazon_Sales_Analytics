SELECT 
    product_name, 
    category, 
    NULLIF(REGEXP_REPLACE(rating, '[^0-9.]', '', 'g'), '')::numeric AS rating,
    NULLIF(REGEXP_REPLACE(rating_count, '[^0-9]', '', 'g'), '')::numeric AS total_reviews,
    discounted_price
FROM amazon_sales_data
WHERE rating IS NOT NULL 
  AND rating_count IS NOT NULL
  AND REGEXP_REPLACE(rating, '[^0-9.]', '', 'g') <> ''
  AND REGEXP_REPLACE(rating_count, '[^0-9]', '', 'g') <> ''
ORDER BY total_reviews DESC
LIMIT 10;


SELECT 
    category,
    COUNT(*) AS total_products,
    ROUND(AVG(NULLIF(REGEXP_REPLACE(rating, '[^0-9.]', '', 'g'), '')::numeric), 2) AS avg_rating
FROM amazon_sales_data
WHERE rating IS NOT NULL 
  AND REGEXP_REPLACE(rating, '[^0-9.]', '', 'g') <> ''
GROUP BY category
ORDER BY total_products DESC;

SELECT 
    product_name, 
    category, 
    discounted_price,
    actual_price
FROM amazon_sales_data
LIMIT 10;

SELECT 
    product_name,
    category,
    discounted_price,
    actual_price,
    ROUND(
        (
            (
                CAST(NULLIF(REGEXP_REPLACE(actual_price, '[^0-9.]', '', 'g'), '') AS NUMERIC) - 
                CAST(NULLIF(REGEXP_REPLACE(discounted_price, '[^0-9.]', '', 'g'), '') AS NUMERIC)
            ) / NULLIF(CAST(NULLIF(REGEXP_REPLACE(actual_price, '[^0-9.]', '', 'g'), '') AS NUMERIC), 0)
        ) * 100, 2
    ) AS discount_percentage
FROM amazon_sales_data
WHERE actual_price IS NOT NULL 
  AND discounted_price IS NOT NULL
  AND REGEXP_REPLACE(actual_price, '[^0-9.]', '', 'g') <> ''
  AND REGEXP_REPLACE(discounted_price, '[^0-9.]', '', 'g') <> ''
ORDER BY discount_percentage DESC
LIMIT 10;


SELECT 
    CASE 
        WHEN CAST(NULLIF(REGEXP_REPLACE(discounted_price, '[^0-9.]', '', 'g'), '') AS NUMERIC) < 500 THEN 'Budget (< ₹500)'
        WHEN CAST(NULLIF(REGEXP_REPLACE(discounted_price, '[^0-9.]', '', 'g'), '') AS NUMERIC) BETWEEN 500 AND 2000 THEN 'Mid-Range (₹500 - ₹2000)'
        ELSE 'Premium (> ₹2000)'
    END AS price_category,
    COUNT(*) AS total_products,
    ROUND(AVG(NULLIF(REGEXP_REPLACE(rating, '[^0-9.]', '', 'g'), '')::numeric), 2) AS avg_rating
FROM amazon_sales_data
WHERE discounted_price IS NOT NULL
  AND REGEXP_REPLACE(discounted_price, '[^0-9.]', '', 'g') <> ''
GROUP BY price_category
ORDER BY total_products DESC;

SELECT 
    category AS full_category,
    TRIM(SPLIT_PART(category, '|', 1)) AS main_category,
    COUNT(*) AS product_count
FROM amazon_sales_data
GROUP BY category
ORDER BY product_count DESC;

