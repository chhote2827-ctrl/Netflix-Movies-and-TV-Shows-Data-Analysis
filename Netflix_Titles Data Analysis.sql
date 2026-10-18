-- Step1 : CREATE TABLE NETFLIX_TITLES
CREATE TABLE netflix_titles (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(20),
    title TEXT,
    director TEXT,
    casts TEXT,             
    country TEXT,
    date_added VARCHAR(50),  
    release_year INT,        
    rating VARCHAR(10),
    duration VARCHAR(50),    
    listed_in TEXT,
    description TEXT
);


-- Step 2 : import NETFLIX_TITLES csv file in sql 
copy netflix_titles
from 'G:\kaggle dataset unzip file\netflix_titles.csv'
with (
	FORMAT csv,
	HEADER TRUE,
	DELIMITER ','
);

-- check import file
SELECT * FROM netflix_titles
LIMIT 10;

-- check the null and missing values
SELECT * FROM netflix_titles
WHERE show_id IS NULL
    OR type IS NULL
    OR title IS NULL
    OR director IS NULL
    OR casts IS NULL             
    OR country IS NULL
    OR date_added IS NULL  
    OR release_year IS NULL        
    OR rating IS NULL
    OR duration IS NULL    
    OR listed_in IS NULL
    OR description IS NULL;

-- Step 3 : replace the null values  director, casts, country in unknown
UPDATE netflix_titles
SET director = 'Unknown'
WHERE director IS NULL;

UPDATE netflix_titles
SET casts = 'Unknown'
WHERE casts IS NULL;

UPDATE netflix_titles
SET country = 'Unknown'
WHERE country IS NULL;

-- DROP MIN NULL VALUES 
DELETE FROM netflix_titles
WHERE rating IS NULL 
   OR duration IS NULL 
   OR date_added IS NULL;

-- Step 4 : duplicate values check karna
SELECT show_id, COUNT(*)
FROM netflix_titles
GROUP BY show_id
HAVING COUNT(*) > 1;

/* Features Engineering
   Step 5: Total Count Movies and Shows with percentage form
   */
SELECT 
    rating,
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER()), 2) AS percentage
FROM netflix_titles 
GROUP BY rating;

-- who country max produce in contents
SELECT 
    country, 
    COUNT(*) AS total_content
FROM netflix_titles
WHERE country IS NOT NULL  
GROUP BY country
ORDER BY total_content DESC  
LIMIT 1;     

-- year by year content compare add and release
-- part 1: Movies vs TV Shows Trend Split
WITH yearly_content AS (
    SELECT 
        EXTRACT(YEAR FROM date_added::DATE) AS added_year,
        COUNT(*) AS total_content_added
    FROM netflix_titles
    WHERE date_added IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM date_added::DATE)
)

-- part 2:
SELECT 
    added_year,
    total_content_added,
    LAG(total_content_added, 1) OVER (ORDER BY added_year) AS prev_year_content,
    ROUND(
        ((total_content_added - LAG(total_content_added, 1) OVER (ORDER BY added_year)) * 100.0 / 
        LAG(total_content_added, 1) OVER (ORDER BY added_year)), 2
    ) AS yoy_growth_percent
FROM yearly_content
ORDER BY added_year ASC;

--Content Ratings Analysis
SELECT 
    rating,
    COUNT(*) AS total_content
FROM netflix_titles
WHERE rating IS NOT NULL
GROUP BY rating
ORDER BY total_content DESC;

--Genre / Category Analysis (Top Genres kaun se hain?)
SELECT 
    listed_in AS genre,
    COUNT(*) AS total_count
FROM netflix_titles
WHERE listed_in IS NOT NULL
GROUP BY listed_in
ORDER BY total_count DESC
LIMIT 10;


--Duration Insights (Movies ki average length aur TV Shows ke seasons)
--A. Movies ki Average Duration (Minutes mein):
SELECT 
    type,
    ROUND(AVG(CAST(REPLACE(duration, ' min', '') AS INTEGER)), 2) AS avg_duration_minutes
FROM netflix_titles
WHERE type = 'Movie' AND duration IS NOT NULL
GROUP BY type;


--B. TV Shows ke Seasons ka Breakdown:
SELECT 
    duration AS seasons_count,
    COUNT(*) AS total_shows
FROM netflix_titles
WHERE type = 'TV Show'
GROUP BY duration
ORDER BY total_shows DESC;

-- final table print
SELECT * FROM netflix_titles
LIMIT 10;
