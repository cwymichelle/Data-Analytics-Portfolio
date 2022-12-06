-- Table: public.factor

-- DROP TABLE IF EXISTS public.factor;

CREATE TABLE IF NOT EXISTS public.factor
(
    "RANK" integer NOT NULL,
    "Country" text COLLATE pg_catalog."default" NOT NULL,
    "Happiness score" real,
    "Whisker-high" real,
    "Whisker-low" real,
    "Dystopia (1.83) + residual" real,
    "Explained by: GDP per capita" real,
    "Explained by: Social support" real,
    "Explained by: Healthy life expectancy" real,
    "Explained by: Freedom to make life choices" real,
    "Explained by: Generosity" real,
    "Explained by: Perceptions of corruption" real,
    CONSTRAINT factor_pkey PRIMARY KEY ("Country")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.factor
    OWNER to postgres;
	
-- Table: public.vaccine

-- DROP TABLE IF EXISTS public.vaccine;

CREATE TABLE IF NOT EXISTS public.vaccine
(
    "Country" text COLLATE pg_catalog."default" NOT NULL,
    "Doses administered per 100 people" real,
    "Total doses administered" real,
    "% of population vaccinated" real,
    "% of population fully vaccinated" real,
    CONSTRAINT vaccine_pkey PRIMARY KEY ("Country")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vaccine
    OWNER to postgres;
	
-- Preview tables
SELECT * FROM factor;

SELECT * FROM vaccine;

-- Check and clean up for null values
SELECT SUM(CASE WHEN "Happiness score" IS NULL THEN 1 ELSE 0 END) AS Null_Happiness, 
SUM(CASE WHEN "Whisker-high" IS NULL THEN 1 ELSE 0 END) AS Null_WhiskerHigh, 
SUM(CASE WHEN "Whisker-low" IS NULL THEN 1 ELSE 0 END) AS Null_WhiskerLow,
SUM(CASE WHEN "Dystopia (1.83) + residual" IS NULL THEN 1 ELSE 0 END) AS Null_DystopiaResidual,
SUM(CASE WHEN "Explained by: GDP per capita" IS NULL THEN 1 ELSE 0 END) AS Null_GDPperCapita,
SUM(CASE WHEN "Explained by: Social support" IS NULL THEN 1 ELSE 0 END) AS Null_SocialSupport,
SUM(CASE WHEN "Explained by: Healthy life expectancy" IS NULL THEN 1 ELSE 0 END) AS Null_HealthyLifeExpectancy,
SUM(CASE WHEN "Explained by: Freedom to make life choices" IS NULL THEN 1 ELSE 0 END) AS Null_Freedom,
SUM(CASE WHEN "Explained by: Generosity" IS NULL THEN 1 ELSE 0 END) AS Null_Generosity,
SUM(CASE WHEN "Explained by: Perceptions of corruption" IS NULL THEN 1 ELSE 0 END) AS Null_Corruption 
FROM factor;

SELECT SUM(CASE WHEN "Doses administered per 100 people" IS NULL THEN 1 ELSE 0 END) AS Null_Dosesper100ppl, 
SUM(CASE WHEN "Total doses administered" IS NULL THEN 1 ELSE 0 END) AS Null_TotalDoses, 
SUM(CASE WHEN "% of population vaccinated" IS NULL THEN 1 ELSE 0 END) AS Null_Vaccinated,
SUM(CASE WHEN "% of population fully vaccinated" IS NULL THEN 1 ELSE 0 END) AS Null_FullVaccinated
FROM vaccine;

-- Check for any leading and trailing whitespaces in column "Country"
SELECT COUNT("Country")
FROM factor
WHERE "Country" LIKE ' %' AND "Country" LIKE '% ';

SELECT COUNT("Country")
FROM vaccine
WHERE "Country" LIKE ' %' AND "Country" LIKE '% ';

-- Identify the trailing asterisk in column "Country" from table "factor"
SELECT "Country"
FROM factor
WHERE "Country" LIKE '%*';

-- Remove the trailing asterisk in column "Country" from table "factor"
UPDATE factor SET "Country" = 'Luxembourg' WHERE "Country" = 'Luxembourg*';
UPDATE factor SET "Country" = 'Guatemala' WHERE "Country" = 'Guatemala*';
UPDATE factor SET "Country" = 'Kuwait' WHERE "Country" = 'Kuwait*';
UPDATE factor SET "Country" = 'Belarus' WHERE "Country" = 'Belarus*';
UPDATE factor SET "Country" = 'Turkmenistan' WHERE "Country" = 'Turkmenistan*';
UPDATE factor SET "Country" = 'North Cyprus' WHERE "Country" = 'North Cyprus*';
UPDATE factor SET "Country" = 'Libya' WHERE "Country" = 'Libya*';
UPDATE factor SET "Country" = 'Azerbaijan' WHERE "Country" = 'Azerbaijan*';
UPDATE factor SET "Country" = 'Gambia' WHERE "Country" = 'Gambia*';
UPDATE factor SET "Country" = 'Liberia' WHERE "Country" = 'Liberia*';
UPDATE factor SET "Country" = 'Niger' WHERE "Country" = 'Niger*';
UPDATE factor SET "Country" = 'Comoros' WHERE "Country" = 'Comoros*';
UPDATE factor SET "Country" = 'Palestinian Territories' WHERE "Country" = 'Palestinian Territories*';
UPDATE factor SET "Country" = 'Eswatini, Kingdom of' WHERE "Country" = 'Eswatini, Kingdom of*';
UPDATE factor SET "Country" = 'Madagascar' WHERE "Country" = 'Madagascar*';
UPDATE factor SET "Country" = 'Chad' WHERE "Country" = 'Chad*';
UPDATE factor SET "Country" = 'Yemen' WHERE "Country" = 'Yemen*';
UPDATE factor SET "Country" = 'Mauritania' WHERE "Country" = 'Mauritania*';
UPDATE factor SET "Country" = 'Lesotho' WHERE "Country" = 'Lesotho*';
UPDATE factor SET "Country" = 'Botswana' WHERE "Country" = 'Botswana*';
UPDATE factor SET "Country" = 'Rwanda' WHERE "Country" = 'Rwanda*';

-- Check if inconsistent name expressed in column "Country" between 2 tables
SELECT DISTINCT factor."Country"
FROM factor
WHERE factor."Country" NOT IN (SELECT vaccine."Country" FROM vaccine);

SELECT DISTINCT vaccine."Country"
FROM vaccine
WHERE vaccine."Country" NOT IN (SELECT factor."Country" FROM factor);

-- Specify the difference expression of these 10 countries between 2 tables
-- 9 matches are found as below while no match found for "North Cyprus"
-- Rename the expression in factor table to make it consistent with vaccine table
UPDATE factor SET "Country" = 'Eswatini' WHERE "Country" = 'Eswatini, Kingdon of';
UPDATE factor SET "Country" = 'U.K.' WHERE "Country" = 'United Kingdom';
UPDATE factor SET "Country" = 'Dominican Rep.' WHERE "Country" = 'Dominican Republic';
UPDATE factor SET "Country" = 'Taiwan' WHERE "Country" = 'Taiwan Province of China';
UPDATE factor SET "Country" = 'West Bank & Gaza' WHERE "Country" = 'Palestinian Territories';
UPDATE factor SET "Country" = 'Mainland China' WHERE "Country" = 'China';
UPDATE factor SET "Country" = 'U.A.E.' WHERE "Country" = 'United Arab Emirates';
UPDATE factor SET "Country" = 'Hong Kong' WHERE "Country" = 'Hong Kong S.A.R. of China';
UPDATE factor SET "Country" = 'Czech Republic' WHERE "Country" = 'Czechia';

-- Combine rows from 2 tables
SELECT factor."RANK",
factor."Country",
factor."Happiness score" AS "Happiness",
factor."Dystopia (1.83) + residual" AS "DystopiaResidual",
factor."Explained by: GDP per capita" AS "GDPperCapita",
factor."Explained by: Social support" AS "SocialSupport",
factor."Explained by: Healthy life expectancy" AS "HealthyLifeExpectancy",
factor."Explained by: Freedom to make life choices" AS "Freedom",
factor."Explained by: Generosity" AS "Generosity",
factor."Explained by: Perceptions of corruption" AS "Corruption",
vaccine."% of population vaccinated" AS "Vaccinated",
vaccine."% of population fully vaccinated" AS "FullVaccinated"
FROM factor
JOIN vaccine ON factor."Country"=vaccine."Country";