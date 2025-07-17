WITH deduplicated AS (
	SELECT DISTINCT
		industry_branch_name,
		year,
		avg_payroll
	FROM 
		t_petra_slaharova_project_sql_primary_final
)
SELECT 
	industry_branch_name,
	year,
	avg_payroll,
	LAG(avg_payroll) OVER (PARTITION BY industry_branch_name ORDER BY year) AS prev_year_payroll,
	avg_payroll - LAG(avg_payroll) OVER (PARTITION BY industry_branch_name ORDER BY year) AS payroll_diff
FROM 
	deduplicated
GROUP BY 
	year, industry_branch_name, avg_payroll 
ORDER BY 
	industry_branch_name, year;

-- Postup analýzy mezd 

-- Odstranili jsme duplicity, aby byla pro každé odvětví a rok jen jedna hodnota průměrné mzdy.  
-- Pomocí funkce `LAG()` jsme získali mzdu z předchozího roku pro každé odvětví.  
-- Spočítali jsme meziroční rozdíl mezd a seřadili výsledky podle odvětví a roku.

