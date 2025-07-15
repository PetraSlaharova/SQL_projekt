-- Totožné porovnatelné období bude 2006 - 2018

SELECT * FROM czechia_payroll AS cp ORDER BY cp.payroll_year DESC; 	-- 2000 - 2021
SELECT * FROM czechia_price AS c ORDER BY c.date_from DESC; 		-- 2006 - 2018


-- Vytvořím tabulku 1 pro data mezd a cen potravin za Českou republiku sjednocených na totožné porovnatelné období pomocí dvou dočasných tabulek.

-- Nejdříve ceny potravin, kde není nutné specifikovat roky, protože data už jsou v daném společném porovnatelném období. 

CREATE TEMPORARY TABLE czechia_price_temp AS 
	SELECT 
		DATE_PART('year', cp.date_from) AS "year",
		cpc.code,
		cpc.name,
		ROUND(AVG(cp.value)::NUMERIC, 2) AS avg_price,
		cpc.price_unit
	FROM 
		czechia_price AS cp
		JOIN czechia_price_category AS cpc
			ON cp.category_code = cpc.code
	GROUP BY 
		year,
		cpc.code,
		cpc.name,
		cpc.price_unit;
		
SELECT * FROM czechia_price_temp;


-- Potom mzdy

CREATE TEMPORARY TABLE czechia_payroll_temp AS 
	SELECT
		cp.payroll_year AS "year",
		cpib.code,
		cpib.name AS industry_branch_name,
		ROUND(AVG(cp.value)::NUMERIC) AS avg_payroll
	FROM 
		czechia_payroll AS cp 
		LEFT JOIN czechia_payroll_industry_branch AS cpib -- LEFT JOIN mě zbaví NULL hodnot
			ON cp.industry_branch_code = cpib.code
	WHERE cp.value_type_code = 5958 -- kód mezd
		AND cp.calculation_code = 200 -- pouze přepočítaná data
		AND cp.payroll_year BETWEEN 2006 AND 2018 -- tady už musím specifikovat roky, protože jsou zde data i z jiných časových období
		AND cp.industry_branch_code IS NOT NULL 
	GROUP BY 
		cp.payroll_year,
		cpib.code,
		cpib.name;
		
SELECT * FROM czechia_payroll_temp;


-- Nakonec spojení dočasných tabulek v jednu finální.

CREATE TABLE IF NOT EXISTS t_petra_slaharova_project_SQL_primary_final AS 
	SELECT 
		cpay.year,
		cpay.code AS branch_code,
		cpay.industry_branch_name,
		cpay.avg_payroll,
		cprice.code AS product_code,
		cprice.name AS product_name,
		cprice.avg_price,
		cprice.price_unit
	FROM
		czechia_payroll_temp AS cpay
		JOIN czechia_price_temp AS cprice
			ON cpay.YEAR = cprice.YEAR;
			
			
SELECT * FROM t_petra_slaharova_project_SQL_primary_final;





-- Vytvořím druhou tabulku pro data o ostatních evropských státech na sledované období 
-- (toto bodobí potřebuji ke zpracování poslední otázky, kde budu zkoumat vliv HDP na změny ve mzdách a cenách potravin)

CREATE TABLE IF NOT EXISTS t_petra_slaharova_project_SQL_secondary_final AS 
	SELECT 
		c.country,
		e."year",
		c.population,
		e.gdp,
		e.gini
	FROM 
		countries AS c 
		JOIN economies AS e 
			ON e.country = c.country
	WHERE e."year" BETWEEN 2006 AND 2018
		AND c.continent = 'Europe';
		
SELECT * FROM t_petra_slaharova_project_SQL_secondary_final;
	













