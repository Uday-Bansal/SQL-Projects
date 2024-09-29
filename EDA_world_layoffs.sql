-- Exploratory Data Analysis
Select * from layoffs_staging2;

SELECT MAX(total_laid_off)
FROM layoffs_staging2;

-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funds_raised_millions we can see how big some of these companies were
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE  percentage_laid_off = 1
ORDER BY funds_raised DESC;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch

-- top 5 companies with biggest single layoffs --
SELECT company, total_laid_off
FROM world_layoffs.layoffs_staging2
ORDER BY 2 DESC
LIMIT 5;
-- now that's just on a single day

-- Top 10 Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off) agg_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 locations with most layoffs
SELECT location, SUM(total_laid_off) agg_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- total layoffs by countries in the past 4 years

SELECT country, SUM(total_laid_off) agg_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY 2 desc;

-- Total Layoffs by year
SELECT YEAR(date) `YEAR`, SUM(total_laid_off) as agg_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

-- Total Layoffs by industry
SELECT industry, SUM(total_laid_off) as agg_laid_off
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total Layoffs by Stage at which the company is 
SELECT stage, SUM(total_laid_off) agg_laid_off
FROM world_layoffs.layoffs_staging2
where stage <> ''
GROUP BY stage
ORDER BY 2 DESC;

-- Looking at companies with most layoffs Each year
WITH Company_Year AS 
(
  SELECT company, YEAR(date) AS years, SUM(total_laid_off) AS agg_laid_off
  FROM layoffs_staging2
  GROUP BY company, YEAR(date)
)
, Company_Year_Rank AS (
  SELECT company, years, agg_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY agg_laid_off DESC) AS ranking
  FROM Company_Year
)
SELECT company, years, agg_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, agg_laid_off DESC;

-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS agg_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC;

-- using rolling total of layoffs per month as cte and querying off it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS agg_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(agg_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;

 
