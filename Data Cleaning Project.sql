-- Data Cleaning Project

Select * 
from layoffs;

-- 1. Remove Duplicates
-- 2. standardised data
-- 3. null/blank values
-- 4. remove unnecessary rows or columns

-- creating dummy tables to work on
Create Table layoffs_staging
LIke layoffs;

Insert layoffs_staging
Select * from layoffs;

Select * from layoffs_staging;

-- checking for duplicates
Select * ,
ROW_NUMBER() Over(
Partition BY company, industry, total_laid_off, percentage_laid_off, `date`, country, funds_raised
) AS row_num
from layoffs_staging;

WITH duplicate_cte AS
(Select * ,
ROW_NUMBER() Over(
	Partition BY company, location, 
	industry, total_laid_off,
	percentage_laid_off, `date`,
	stage, country, funds_raised
) AS row_num
from layoffs_staging
)
SELECT *  
from duplicate_cte
WHere row_num > 1;

Select *
from layoffs_staging 
where company = "&Open";



Select * ,
ROW_NUMBER() Over(
	Partition BY company, location, 
	industry, total_laid_off,
	percentage_laid_off, `date`,
	stage, country, funds_raised
) AS row_num
from layoffs_staging;

-- removing duplicates
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` bigint DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
Select * ,
ROW_NUMBER() Over(
	Partition BY company, location, 
	industry, total_laid_off,
	percentage_laid_off, `date`,
	stage, country, funds_raised
) AS row_num
from layoffs_staging;

SELECT *
FROM layoffs_staging2;

Delete
FROM layoffs_staging2
Where row_num > 1;

SELECT *
FROM layoffs_staging2;

-- standardised data

Select company, Trim(company)
from layoffs_staging2;

Update layoffs_staging2
SET company = Trim(Company);

Select Distinct(industry)
from layoffs_staging2
Order by 1;

Select Distinct(location)
from layoffs_staging2
order by 1;

Select Distinct(country)
from layoffs_staging2
order by 1;

-- change date column from string to date format
Select `date`
from layoffs_staging2; 

SELECT `date`,
       STR_TO_DATE(`date`, '%Y-%m-%d') date
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- dealing with null and blank values
Select * from layoffs_staging2;

Select * from layoffs_staging2
Where industry = '' ;

Update layoffs_staging2
Set industry = "Travel"
Where company = "Appsmith";

Select * from layoffs_staging2
WHere percentage_laid_off = ''
or percentage_laid_off is NULL;

Update layoffs_staging2
Set percentage_laid_off = NULL
Where percentage_laid_off = '';

-- dropped unwanted columns
Alter Table layoffs_staging2
Drop Column row_num;

Select * from layoffs_staging2;



















