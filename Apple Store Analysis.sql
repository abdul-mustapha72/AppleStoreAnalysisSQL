CREATE TABLE 
	appleStore_description_combined AS

SELECT 
	* 
FROM 
	appleStore_description1

UNION ALL

SELECT 
	* 
FROM 
	appleStore_description2

UNION ALL

SELECT 
	* 
FROM 
	appleStore_description3

UNION ALL

SELECT 
	* 
FROM 
	appleStore_description4

--EXPLORATORY DATA ANALYSIS

--CHECKING THE NNUMBER OF UNIQUE ID'S IN BOTH TABLES 

SELECT COUNT(DISTINCT id) as 
	UniqueAppIDs
From 
	appleStore_description_combined

SELECT COUNT(DISTINCT id) as 
	UniqueAppIDs
From 
	AppleStore

--check for missing values in key fields for both tables 

SELECT COUNT(*) as 
	missingValues
from 
	AppleStore
where 
	track_name is NULL or 
    user_rating is NULL or 
    prime_genre is NULL 

SELECT COUNT(*) as 
	missingValues
from 
	appleStore_description_combined
where 
	app_desc is NULL
    
-- Find out number of apps per genre 

SELECT 
	prime_genre,
    COUNT(*) as numApps
FROM
	AppleStore
GROUP by
	prime_genre
order BY
	numApps DESC
    
--Overview of App ratings 

SELECT 
	min(user_rating) as minUserRating,
    max(user_rating) as maxUserRating,
    avg(user_rating) as avgUserRating
FROM
	AppleStore
    
**DATA ANALYSIS**

--DETERMINE WHETHER PAID APPS HAVE HIGHER RATING THAN FREE APPS

SELECT
	CASE
    	WHEN price > 0 THEN 'paid'
        ELSE 'free'
        END
        	as appType,
        	avg(user_rating) as AvgUserRating
FROM
	AppleStore
GROUP BY
	appType
    
-- CHECK IF APPS THAT SUPOORT MORE LANGUAGES HAVE HIGHER RATINGS 

SELECT 
	CASE 
	WHEN lang_num < 10 THEN '<10 Languages'
    WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'
    ELSE '>30 Languages'
    END 
    	AS Language_bracket, 
        avg(user_rating) as avgUserRating
FROM
	AppleStore
GROUP BY
	Language_bracket
order by 
	avgUserRating DEsc 

-- Check Genres with the lowest ratings

SELECT 
	prime_genre,
    avg(user_rating) as avgUserRating
FROM
	AppleStore
group by 
	prime_genre
order BY
	avgUserRating
LIMIT 10

-- check whether there is a correlation between app description and user rating

SELECT
	CASE
    when length(b.app_desc) < 300
    	THEN 'short'
	when length(b.app_desc) BETWEEN 300 AND 1000
    	THEN 'medium'
	else 'long'
    end 
    	as Lenght_Description, 
        avg(a.user_rating) as Average_Rating
from 
	AppleStore as a
JOIN
	appleStore_description_combined as b 
on 
	a.id = b.id 
GROUP by 
	Lenght_Description
ORDER by 
	Average_Rating
    
-- Check the top rated apps for each genreAppleStore

SELECT
	prime_genre,
    track_name,
    user_rating
from (
    SELECT
  		prime_genre,
    	track_name,
    	user_rating,
		RANK() OVER(PARTITION BY 
                    	prime_genre 
                    ORDER by 
                    	user_rating DESC,
                    	rating_count_tot DESC) as rank
  FROM
  	AppleStore
	) as a
WHERE
	a.rank = 1
    

    
