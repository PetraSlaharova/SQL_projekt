WITH price_default AS (
    SELECT DISTINCT 
        year,
        product_name,
        avg_price
    FROM t_petra_slaharova_project_sql_primary_final
),
price_rise AS (
    SELECT
        *,
        LAG(avg_price) OVER (PARTITION BY product_name ORDER BY year) AS previous_price,
        ROUND(
            ((avg_price - LAG(avg_price) OVER (PARTITION BY product_name ORDER BY year)) 
            / LAG(avg_price) OVER (PARTITION BY product_name ORDER BY year)) * 100, 2
        ) AS perc_price_growth
    FROM price_default
),
avg_price_rise AS (
    SELECT 
        year,
        ROUND(AVG(perc_price_growth), 2) AS avg_price_growth
    FROM price_rise
    GROUP BY year
),
pay_default AS (
    SELECT DISTINCT
        year,
        industry_branch_name,
        avg_payroll
    FROM t_petra_slaharova_project_sql_primary_final
),
pay_rise AS (
    SELECT 
        *,
        LAG(avg_payroll) OVER (PARTITION BY industry_branch_name ORDER BY year) AS previous_pay,
        ROUND(
            ((avg_payroll - LAG(avg_payroll) OVER (PARTITION BY industry_branch_name ORDER BY year)) 
            / LAG(avg_payroll) OVER (PARTITION BY industry_branch_name ORDER BY year)) * 100, 2
        ) AS perc_pay_growth
    FROM pay_default
),
avg_pay_rise AS (
    SELECT
        year,
        ROUND(AVG(perc_pay_growth), 2) AS avg_pay_growth
    FROM pay_rise
    GROUP BY year
)
SELECT
    api.year,
    apy.avg_pay_growth,
    api.avg_price_growth,
    ABS(api.avg_price_growth - apy.avg_pay_growth) AS growth_difference
FROM avg_pay_rise apy
JOIN avg_price_rise api ON api.year = apy.year
WHERE ABS(api.avg_price_growth - apy.avg_pay_growth) > 0
ORDER BY growth_difference DESC;


-- Postup analýzy meziročního růstu průměrných cen a mezd

-- Vybrali jsme unikátní hodnoty průměrných cen produktů a průměrných mezd podle odvětví a roku.
-- Pomocí funkce LAG() jsme spočítali meziroční růst cen a mezd v procentech pro každý produkt a odvětví.
-- Spočítali jsme průměrný meziroční růst cen a mezd za každý rok.
-- Porovnali jsme meziroční růst cen a mezd a vybrali roky, kdy byl rozdíl mezi nimi větší než 0.
-- Výsledky jsme seřadili podle velikosti rozdílu mezi růstem cen a mezd.
