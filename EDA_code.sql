-- Exploratory Data Analysis

-- 1. Find the company with the maximum total layoffs
SELECT company, MAX(total_laid_off)  
FROM layoffs_staging2
GROUP BY company
ORDER BY MAX(total_laid_off) DESC;

-- 2. Find the total layoffs for each company and order by total layoffs
SELECT company, SUM(total_laid_off)  
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC;

-- 3. Find the total layoffs by industry and order by total layoffs
SELECT industry, SUM(total_laid_off)  
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- 4. Find the earliest and latest layoff dates
SELECT MIN(`date`) AS earliest_date, MAX(`date`) AS latest_date
FROM layoffs_staging2;

-- 5. Find the total layoffs by country and order by total layoffs
SELECT country, SUM(total_laid_off)  
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC;

-- 6. Find the total layoffs by year and order by total layoffs
SELECT YEAR(`date`) AS year, SUM(total_laid_off)  
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;

-- 7. Find the total layoffs by company stage and order by total layoffs
SELECT stage, SUM(total_laid_off)  
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- 8. Calculate rolling total layoffs by month
SELECT 
    SUBSTR(`date`, 1, 7) AS `month`, 
    SUM(total_laid_off) AS total_layoffs,
    SUM(SUM(total_laid_off)) OVER(ORDER BY SUBSTR(`date`, 1, 7)) AS rolling_total
FROM layoffs_staging2
GROUP BY `month`
HAVING `month` IS NOT NULL
ORDER BY `month`;

-- 9. Find the top 5 companies with the highest layoffs each year using a common table expression (CTE)
WITH company_year AS (
    SELECT 
        company, 
        YEAR(`date`) AS year, 
        SUM(total_laid_off) AS total_layoffs 
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
),
company_rank AS (
    SELECT 
        company_year.*,
        DENSE_RANK() OVER(PARTITION BY year ORDER BY total_layoffs DESC) AS ranking
    FROM company_year
    WHERE year IS NOT NULL
)
SELECT * 
FROM company_rank
WHERE ranking <= 5;
