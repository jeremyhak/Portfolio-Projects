SELECT * FROM movies.top1000;

-- 1. top 5 movies with vote count above 15000
SELECT YEAR(STR_TO_DATE(release_date, '%d/%m/%Y')) AS "Release Year",title AS "Title" , oote_average as "Vote avg" ,popularity,round(vote_count) as "Vote Count" from movies.top1000 
WHERE vote_count > 15000 
ORDER BY oote_average desc limit 5;

-- 2. bottom 5 movies with vote count above 15000
SELECT YEAR(STR_TO_DATE(release_date, '%d/%m/%Y')) AS "Release Year",title AS "Title", oote_average AS "Vote avg" ,popularity,round(vote_count) AS "Vote Count" from movies.top1000 
WHERE vote_count > 15000 
ORDER BY oote_average asc limit 5;


-- 3. The amount of total movies made per language 
SELECT count(title) AS "Total" ,original_language AS "Languages" FROM movies.top1000
GROUP BY original_language
ORDER BY Total desc limit 10 ;

-- 4. clean the data 

SELECT title, TRIM(']' FROM TRIM('[' FROM genres)) AS cleaned_genres
FROM movies.top1000;


-- 5. what generas are the most common - creating new Table GenreCountsTable
USE movies;
CREATE TABLE GenreTable AS
SELECT
    SUM(CASE WHEN genres LIKE '%Action%' THEN 1 ELSE 0 END) AS ActionCount,
    SUM(CASE WHEN genres LIKE '%Adventure%' THEN 1 ELSE 0 END) AS AdventureCount,
    SUM(CASE WHEN genres LIKE '%Animation%' THEN 1 ELSE 0 END) AS AnimationCount,
    SUM(CASE WHEN genres LIKE '%Family%' THEN 1 ELSE 0 END) AS FamilyCount,
    SUM(CASE WHEN genres LIKE '%Fantasy%' THEN 1 ELSE 0 END) AS FantasyCount,
    SUM(CASE WHEN genres LIKE '%Comedy%' THEN 1 ELSE 0 END) AS ComedyCount,
    SUM(CASE WHEN genres LIKE '%Crime%' THEN 1 ELSE 0 END) AS CrimeCount,
    SUM(CASE WHEN genres LIKE '%Romance%' THEN 1 ELSE 0 END) AS RomanceCount,
    SUM(CASE WHEN genres LIKE '%Drama%' THEN 1 ELSE 0 END) AS DramaCount,
    SUM(CASE WHEN genres LIKE '%Thriller%' THEN 1 ELSE 0 END) AS ThrillerCount,
    SUM(CASE WHEN genres LIKE '%Fiction%' THEN 1 ELSE 0 END) AS FictionCount,
    SUM(CASE WHEN genres LIKE '%Horror%' THEN 1 ELSE 0 END) AS HorrorCount,
    SUM(CASE WHEN genres LIKE '%War%' THEN 1 ELSE 0 END) AS WarCount,
    SUM(CASE WHEN genres LIKE '%Science Fiction%' THEN 1 ELSE 0 END) AS ScienceFictionCount
FROM movies.top1000;

SELECT * FROM movies.GenreTable;

-- 6. pct of the genres 
WITH GenreCounts AS (
    SELECT
        SUM(
            ActionCount + AdventureCount + AnimationCount + FamilyCount + FantasyCount +
            ComedyCount + CrimeCount + RomanceCount + DramaCount + ThrillerCount +
            FictionCount + HorrorCount + WarCount + ScienceFictionCount
        ) AS TotalSum,
        SUM(ActionCount) AS ActionCount,
        SUM(AdventureCount) AS AdventureCount,
        SUM(AnimationCount) AS AnimationCount,
        SUM(FamilyCount) AS FamilyCount,
        SUM(FantasyCount) AS FantasyCount,
        SUM(ComedyCount) AS ComedyCount,
        SUM(CrimeCount) AS CrimeCount,
        SUM(RomanceCount) AS RomanceCount,
        SUM(DramaCount) AS DramaCount,
        SUM(ThrillerCount) AS ThrillerCount,
        SUM(FictionCount) AS FictionCount,
        SUM(HorrorCount) AS HorrorCount,
        SUM(WarCount) AS WarCount,
        SUM(ScienceFictionCount) AS ScienceFictionCount
    FROM GenreTable
)

SELECT
    (ActionCount / TotalSum) AS Pct_Action,
    (AdventureCount / TotalSum) AS Pct_Adventure,
    (AnimationCount / TotalSum) AS Pct_Animation,
    (FamilyCount / TotalSum) AS Pct_Family,
    (FantasyCount / TotalSum) AS Pct_Fantasy,
    (ComedyCount / TotalSum) AS Pct_Comedy,
    (CrimeCount / TotalSum) AS Pct_Crime,
    (RomanceCount / TotalSum) AS Pct_Romance,
    (DramaCount / TotalSum) AS Pct_Drama,
    (ThrillerCount / TotalSum) AS Pct_Thriller,
    (FictionCount / TotalSum) AS Pct_Fiction,
    (HorrorCount / TotalSum) AS Pct_Horror,
    (WarCount / TotalSum) AS Pct_War,
    (ScienceFictionCount / TotalSum) AS Pct_ScienceFiction
    
FROM GenreCounts;


-- 5. Cleaning dates by creating a new table with cleanedate and removing irrelevent lines 
USE movies;

CREATE TABLE cleandate AS
SELECT release_date, title
FROM movies.top1000
WHERE release_date IS NOT NULL
   AND release_date <> ''
   AND TRIM(release_date) NOT LIKE '###############################################################################################################################################################################################################################################################'
   AND TRIM(release_date) NOT LIKE 'into meeting Perdita''s owner'
   AND TRIM(release_date) NOT LIKE 'her built-up frustrations explode and she gets into a physical altercation with her daughter."'
   AND TRIM(release_date) NOT LIKE 'plunging the world into a global war.'
   AND TRIM(release_date) NOT LIKE "['NUT']";



-- 6. amount of movies per year, show top 10 
SELECT YEAR(STR_TO_DATE(release_date, '%d/%m/%Y')) AS release_year, COUNT(title) AS total_movies
FROM movies.cleandate
GROUP BY release_year
ORDER BY total_movies desc limit 10;




-- 7. the top 10 margin revenue 
SELECT YEAR(STR_TO_DATE(release_date, '%d/%m/%Y')) AS release_year,title, budget, revenue , 
CONCAT(ROUND(((revenue - budget) / revenue * 100)),'%')as margin_revenue
from movies.top1000
WHERE budget != 0 AND revenue != 0
ORDER BY margin_revenue DESC LIMIT 10;


-- 8. top 10 budgets and their margin revenue 
SELECT YEAR(STR_TO_DATE(release_date, '%d/%m/%Y')) AS release_year,title, budget, revenue , 
CONCAT(ROUND(((revenue - budget) / revenue * 100)),'%')as margin_revenue
FROM
  movies.top1000
WHERE
  budget != 0 AND revenue != 0
ORDER BY
  budget DESC
LIMIT 10;

