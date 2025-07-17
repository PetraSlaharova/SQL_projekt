# Analýza dostupnosti základních potravin v ČR

## Úvod

Cílem projektu bylo analyzovat vývoj mezd, cen potravin a HDP v České republice na základě veřejně dostupných dat z let 2006 až 2018. Pomocí SQL dotazů byly zodpovězeny následující otázky:

---

## Otázka 1:  
**Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?**

Mzdy v Česku vykazují obecně rostoucí trend napříč všemi odvětvími, přesto se v některých letech objevují mírné meziroční poklesy. Největší pokles byl zaznamenán během roku 2013. Celkově ale dochází k růstu mezd ve většině let a odvětví.

**Ukázka výstupu (zkráceno):**
| Odvětví                                   | Rok  | Průměrná mzda (Kč) | Meziroční změna (Kč) |
|-------------------------------------------|------|---------------------|-----------------------|
| Administrativní a podpůrné činnosti       | 2006 | 14 444              | -                     |
| Administrativní a podpůrné činnosti       | 2007 | 15 236              | 792                   |
| Administrativní a podpůrné činnosti       | 2008 | 15 527              | 291                   |
| Činnosti v oblasti nemovitostí             | 2006 | 19 242              | -                     |
| Činnosti v oblasti nemovitostí             | 2007 | 20 708              | 1 466                 |
| Činnosti v oblasti nemovitostí             | 2008 | 20 790              | 82                    |
| Doprava a skladování                       | 2006 | 19 257              | -                     |
| Doprava a skladování                       | 2007 | 20 654              | 1 397                 |
| Doprava a skladování                       | 2008 | 22 374              | 1 720                 |

---

## Otázka 2:  
**Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?**

| Produkt                       | Průměrná mzda (Kč) | Cena (Kč) | Množství [kg/l] | Rok  |
|------------------------------|---------------------|-----------|------------------|------|
| Chléb konzumní kmínový       | 21 165.32           | 16.12     | 1 312.98         | 2006 |
| Chléb konzumní kmínový       | 33 091.63           | 24.24     | 1 365.17         | 2018 |
| Mléko polotučné pasterované  | 21 165.32           | 14.44     | 1 465.74         | 2006 |
| Mléko polotučné pasterované  | 33 091.63           | 19.82     | 1 669.61         | 2018 |

Ve srovnání let 2006 a 2018 si bylo možné za průměrnou mzdu koupit více litrů mléka i kilogramů chleba. U chleba se množství mírně zvýšilo (zhruba o 52 kg), u mléka byl nárůst výraznější (přes 200 litrů).

---

## Otázka 3:  
**Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?**

Nejpomaleji rostly ceny u těchto potravin:

| Potravina                          | Průměrný roční nárůst (%) |
|-----------------------------------|----------------------------|
| Cukr krystalový                   | -1.92                      |
| Rajská jablka červená kulatá     | -0.74                      |
| Banány žluté                     | 0.81                       |
| Vepřová pečeně s kostí           | 0.99                       |
| Přírodní minerální voda uhličitá | 1.02                       |

---

## Otázka 4:  
**Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?**

Ne, ve sledovaném období neexistuje žádný rok, ve kterém by rozdíl mezi meziročním růstem cen potravin a mezd přesáhl 10 %. Největší rozdíl byl zaznamenán v roce 2009, kdy činil 9,43 procentního bodu.

**Ukázka výstupu:**

| Rok  | Růst cen potravin (%) | Růst mezd (%) | Rozdíl (p.b.) |
|------|------------------------|----------------|----------------|
| 2009 | 2.84                   | -6.59          | 9.43           |
| 2013 | -0.78                  | 6.01           | 6.79           |
| 2018 | 7.88                   | 2.41           | 5.47           |

---

## Otázka 5:  
**Má výška HDP vliv na změny ve mzdách a cenách potravin?**

Na základě dostupných dat nelze potvrdit přímou souvislost mezi růstem HDP a růstem mezd nebo cen potravin. V některých letech s výrazným růstem HDP (např. 2015 a 2017) sice následoval růst cen i mezd, ale v jiných obdobích (např. 2007 nebo 2012) se vývoj těchto ukazatelů lišil. Vliv HDP na ceny a mzdy je tedy spíše nepravidelný a není možné z něj vyvodit jednoznačnou závislost.

**Ukázka výstupu:**

| Rok  | Růst HDP (%) | Růst mezd (%) | Růst cen potravin (%) |
|------|--------------|----------------|------------------------|
| 2007 | 5.57         | 6.91           | 9.26                   |
| 2009 | -4.66        | 2.84           | -6.59                  |
| 2015 | 5.39         | 2.90           | -0.69                  |
| 2017 | 5.17         | 6.40           | 7.06                   |

---

> 📌 Všechny výpočty byly provedeny pomocí SQL dotazů nad upravenými primárními a sekundárními tabulkami z projektu Engeto Data Academy.

