WITH cte_gdp AS (
	SELECT
		year,
		country,
		GDP,
		LAG(GDP) OVER (ORDER BY year ASC) AS gdp_previous_year,
		ROUND((((GDP - LAG(GDP) OVER (ORDER BY year))/ LAG(GDP) OVER (ORDER BY year ASC)) * 100)::NUMERIC, 2) AS gdp_rise
	FROM t_petra_slaharova_project_sql_secondary_final
	WHERE country = 'Czech Republic'
),
price_default AS (
	SELECT DISTINCT 
		year,
		product_name,
		avg_price
	FROM t_petra_slaharova_project_sql_primary_final
	ORDER BY product_name, year
),
price_rise AS (
	SELECT
		*,
		LAG(avg_price, 1) OVER (PARTITION BY product_name ORDER BY year ASC) AS previous_price_value,
		ROUND(((avg_price - LAG(avg_price, 1) OVER (PARTITION BY product_name ORDER BY year ASC))/ 	LAG(avg_price, 1) OVER (PARTITION BY product_name ORDER BY year ASC)) * 100, 2) AS perc_narust_price
	FROM price_default
),
avg_price_rise AS (
	SELECT
		year,
		ROUND(AVG(perc_narust_price), 2) AS avg_price_rise
	FROM price_rise
	GROUP BY year
),
pay_default AS(
	SELECT DISTINCT
		year,
		industry_branch_name ,
		avg_payroll
	FROM t_petra_slaharova_project_sql_primary_final
	ORDER BY year
),
pay_rise AS (
	SELECT
		*, 
		LAG(avg_payroll, 1) OVER (PARTITION BY industry_branch_name ORDER BY year ASC) AS previous_pay_value,
		ROUND(((avg_payroll - LAG(avg_payroll, 1) OVER (PARTITION BY industry_branch_name ORDER BY year ASC))/ LAG(avg_payroll, 1) OVER (PARTITION BY industry_branch_name ORDER BY year ASC)) * 100, 2) AS perc_narust_pay
	FROM pay_default
),
avg_pay_rise AS (
	SELECT
		year,
		ROUND(AVG(perc_narust_pay), 2) AS avg_pay_rise
	FROM pay_rise
	GROUP BY year
)
SELECT
	gdp.year,
	gdp.gdp_rise,
	apy.avg_pay_rise,
	api.avg_price_rise
FROM cte_gdp gdp
JOIN avg_pay_rise apy ON apy.year = gdp.year
JOIN avg_price_rise api ON api.year = gdp.YEAR
ORDER BY YEAR;


-- Postup analýzy vztahu HDP, růstu mezd a růstu cen potravin

-- Z dat o HDP ČR jsme spočítali meziroční procentní změnu HDP pomocí funkce LAG().
-- Z dat o cenách potravin jsme vypočítali meziroční procentní změnu průměrných cen pro jednotlivé produkty a následně spočítali průměrný růst cen potravin za každý rok.
-- Z dat o mzdách jsme podobně spočítali meziroční procentní změnu průměrné mzdy v jednotlivých odvětvích a poté průměrný růst mezd za každý rok.
-- Nakonec jsme sloučili všechny tři ukazatele (růst HDP, růst mezd, růst cen) podle roku pro přehledné porovnání.