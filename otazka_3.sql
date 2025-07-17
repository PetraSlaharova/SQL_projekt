WITH price_diffs AS (
    SELECT 
        product_name,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY product_name ORDER BY year) AS prev_price
    FROM t_petra_slaharova_project_sql_primary_final AS t 
    GROUP BY product_name, year, avg_price
),
percent_changes AS (
    SELECT 
        product_name,
        ROUND(((avg_price - prev_price) / prev_price) * 100.0, 2) AS percent_change
    FROM price_diffs
    WHERE prev_price IS NOT NULL
),
average_percent_change AS (
    SELECT 
        product_name,
        ROUND(AVG(percent_change)::NUMERIC, 2) AS avg_percent_increase
    FROM percent_changes
    GROUP BY product_name
)
SELECT *
FROM average_percent_change
ORDER BY avg_percent_increase ASC
LIMIT 5;


-- Postup analýzy průměrného meziročního růstu cen produktů

-- Pomocí funkce LAG() jsme získali cenu produktu z předchozího roku pro každý produkt.
-- Vypočítali jsme procentní změnu ceny meziročním srovnáním aktuální a předchozí ceny.
-- Spočítali jsme průměrnou procentní změnu ceny za celé období pro každý produkt.
-- Vybrali jsme 5 produktů s nejmenším průměrným růstem cen.