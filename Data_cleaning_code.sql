-- Creating a Duplicate Table to Work With

CREATE TABLE `layoffs_staging` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting Data into the Duplicate Table
INSERT INTO layoffs_staging
SELECT * FROM layoffs;

-- Identifying and Viewing Duplicates Using CTE
WITH duplictecte AS (
    SELECT *, ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
    ) AS row_num
    FROM layoffs_staging
)
SELECT * FROM duplictecte
WHERE row_num > 1;

-- Creating Another Table to Work with Duplicates

CREATE TABLE `layoffs_staging2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Inserting Data with Row Numbers into New Table
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() OVER(
    PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions
) AS row_num
FROM layoffs_staging;

-- Deleting Duplicate Rows Based on Row Number
DELETE FROM layoffs_staging2
WHERE row_num > 1;

-- Verifying that Duplicates are Removed
SELECT * FROM layoffs_staging2
WHERE row_num > 1;

-- Viewing the Cleaned Table
SELECT * FROM layoffs_staging2;

-- Standardizing Data

-- Trimming Whitespace from Company Names
SELECT company, TRIM(company) FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Checking Distinct Industry Values
SELECT DISTINCT industry FROM layoffs_staging2
ORDER BY industry;

-- Finding and Updating 'Crypto' Industry Entries
SELECT * FROM layoffs_staging2
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- Checking Distinct Country Values
SELECT DISTINCT country FROM layoffs_staging2
ORDER BY 1;

-- Finding and Updating 'United States' Entries
SELECT * FROM layoffs_staging2
WHERE country LIKE 'United States%';

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- Changing Data Type for Date from String to Date

-- Converting Date String to Date Format
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Altering the Table to Change Date Column Type
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- Viewing the Table After Date Conversion
SELECT * FROM layoffs_staging2;

-- Working with Null and Blank Values

-- Checking for Rows with Null Total and Percentage Laid Off
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Checking for Rows with Null or Empty Industry
SELECT * FROM layoffs_staging2
WHERE industry IS NULL OR industry = '';

-- Checking Specific Company Data (e.g., Airbnb)
SELECT * FROM layoffs_staging2
WHERE company = 'Airbnb';

-- Finding Non-null Industry Values for Matching Records
SELECT t1.industry, t2.industry FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- Updating Industry to Null if Blank
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Propagating Non-null Industry Values to Null Entries
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Removing Unwanted Rows and Blanks

-- Finding Rows with Null Total and Percentage Laid Off
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL AND
percentage_laid_off IS NULL;

-- Deleting Rows with Null Total and Percentage Laid Off
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL AND
percentage_laid_off IS NULL;

-- Final View of the Cleaned Table
SELECT * FROM layoffs_staging2;
