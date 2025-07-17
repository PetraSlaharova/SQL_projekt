WITH milk_bread_data AS (
	SELECT 
		year,
		product_name,
		AVG(avg_price) AS avg_price,
		AVG(avg_payroll) AS avg_payroll
	FROM 
		t_petra_slaharova_project_sql_primary_final
	WHERE 
		product_name IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
	GROUP BY 
		year, product_name
),
calc_buying_power AS (
	SELECT 
		year,
		product_name,
		ROUND(avg_payroll, 2),
		avg_price,
		ROUND(avg_payroll / avg_price, 2) AS amount_buyable
	FROM 
		milk_bread_data
)
SELECT *
FROM calc_buying_power
WHERE year IN (
	SELECT MIN(year) FROM calc_buying_power
	UNION
	SELECT MAX(year) FROM calc_buying_power
)
ORDER BY product_name, year;


-- Postup analýzy

-- Vybrali jsme data pro mléko a chléb v jednotlivých letech a spočítali průměrné ceny i průměrné mzdy.
-- Vypočítali jsme, kolik litrů mléka nebo kilogramů chleba si bylo možné koupit za průměrnou mzdu (avg_payroll / avg_price).
-- Vybrali jsme jen první a poslední rok pro porovnání a seřadili podle produktu a roku.
