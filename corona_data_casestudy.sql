use corona_database; 



ALTER TABLE corona_data
ADD COLUMN new_date_column date; 




ALTER TABLE corona_data
DROP COLUMN Date; 

ALTER TABLE corona_data
RENAME COLUMN new_date_column to Date;

SELECT STR_TO_DATE(Date, '%m/%d/%Y') from corona_data; 

UPDATE corona_data
SET new_date_column = STR_TO_DATE(Date, '%m/%d/%Y'); 

select  new_date_column from corona_data;

select Date from corona_data;

ALTER TABLE corona_data
ADD COLUMN new_date_column date; 

select count(*) from corona_data; 

describe corona_data;





 ALTER TABLE `corona_data`
RENAME COLUMN `Country/Region` to  `Country_Region`; 

-- Q1. Write a code to check NULL values  
SELECT
    SUM(CASE WHEN Province IS NULL THEN 1 ELSE 0 END) AS Province_null_count,
    SUM(CASE WHEN Country_Region IS NULL THEN 1 ELSE 0 END) AS Country_Region_null_count,
    SUM(CASE WHEN Latitude IS NULL THEN 1 ELSE 0 END) AS Latitude_null_count,
    SUM(CASE WHEN Longitude IS NULL THEN 1 ELSE 0 END) AS Longitude_null_count,
    SUM(CASE WHEN Confirmed IS NULL THEN 1 ELSE 0 END) AS Confirmed_null_count,
    SUM(CASE WHEN Deaths IS NULL THEN 1 ELSE 0 END) AS Deaths_null_count,
    SUM(CASE WHEN Recovered IS NULL THEN 1 ELSE 0 END) AS Recovered_null_count,
    SUM(CASE WHEN new_date_column IS NULL THEN 1 ELSE 0 END) AS new_date_column_null_count
    FROM
    corona_data; 
    
    -- Q2. If NULL values are present, update them with zeros for all columns. 
    -- "The corona_data table does not contain any null values in any column." 
    
    
    -- Q3. check total number of rows corona_data
    
    select count(*) from corona_data; 
    -- Total number of rows on corora_data is 78386 
    
    -- Q4. Check what is start_date and end_date 
    
 select new_date_column from corona_data; 
 
 SELECT
    MIN(new_date_column) AS start_date,
    MAX(new_date_column) AS end_date
FROM
    corona_data; 
    
    
    -- Q5. Number of month present in dataset  

SELECT COUNT(DISTINCT MONTH(new_date_column)) AS num_unique_months
FROM corona_data; 
  
  
  -- Q6. Find monthly average for confirmed, deaths, recovered 
  
  select month(new_date_column) as month,
  round(avg(Confirmed)) as average_confirmed_case,
  round(avg(Deaths)) as average_death_cases,
  round(avg(Recovered))as average_revered_cases
  from corona_data
  group by  month(new_date_column)
   order by average_confirmed_case, average_death_cases,average_revered_cases desc; 
  
  
  -- Q7. Find most frequent value for confirmed, deaths, recovered each month 
  select month(new_date_column), max(confirmed) as most_frequent_cases, count(*) as confirmed_count from corona_data
  group by month(new_date_column)
  order by confirmed_count; 
  


select 
confirmed_counts.months, 
max(most_frequent_count), 
max(most_frequent_count_deaths),
max(most_frequent_count_recovered)
from(
 SELECT 
    MONTH(new_date_column) as months,
    Confirmed,
    COUNT(*) AS most_frequent_count
FROM 
    corona_data
where Confirmed > 0  
GROUP BY 
    months, Confirmed 
ORDER BY most_frequent_count DESC
    ) as confirmed_counts 
join 
(SELECT 
    MONTH(new_date_column) as months,
    Deaths,
    COUNT(*) AS most_frequent_count_deaths
FROM 
    corona_data
where Deaths > 0  
GROUP BY 
    months, Deaths 
ORDER BY most_frequent_count_deaths DESC
    ) as Deaths_counts 
    ON confirmed_counts.months = Deaths_counts.months
    join 
    (SELECT 
    MONTH(new_date_column) as months,
    Recovered,
    COUNT(*) AS most_frequent_count_recovered
FROM 
    corona_data
where Recovered > 0  
GROUP BY 
    months, Recovered 
ORDER BY most_frequent_count_recovered DESC
    ) as recovered_counts 
    ON confirmed_counts.months = recovered_counts.months
    group by confirmed_counts.months;

  
  
with c1 as (select months,
 max(most_frequent_count) as max_most_frequent_count,
 Confirmed
 from
  (SELECT 
    MONTH(new_date_column) as months,
    Confirmed,
    COUNT(*) AS most_frequent_count
FROM 
    corona_data
where Confirmed > 0  
GROUP BY 
    months, Confirmed 
ORDER BY most_frequent_count DESC) as Confirmed_counts
group by  months), d1 as
(select months,
 max(most_frequent_count_Deaths) as max_most_frequent_count_Deaths, 
 Deaths
 from
  (SELECT 
    MONTH(new_date_column) as months,
    Deaths,
    COUNT(*) AS most_frequent_count_Deaths
FROM 
    corona_data
where Deaths > 0  
GROUP BY 
    months, Deaths 
ORDER BY most_frequent_count_Deaths DESC) as Deaths_counts
group by  months), r1 as
(select months,
 max(most_frequent_count_Recovered) as max_most_frequent_count_Recovered,
 Recovered
 from
  (SELECT 
    MONTH(new_date_column) as months,
    Recovered,
    COUNT(*) AS most_frequent_count_Recovered
FROM 
    corona_data
where Recovered > 0  
GROUP BY 
    months, Recovered 
ORDER BY most_frequent_count_Recovered DESC) as Recovered_counts
group by  months) 
SELECT 
c1.months,
c1.max_most_frequent_count,
c1.Confirmed,
d1.months,
d1.max_most_frequent_count_Deaths,
d1.Deaths,
r1.months,
r1.max_most_frequent_count_Recovered,
r1.Recovered
FROM c1
JOIN d1 ON c1.months = d1.months
JOIN r1 ON c1.months = r1.months;


-- Q8. Find minimum values for confirmed, deaths, recovered per year 

select year(new_date_column) as Year_wise, 
min(Confirmed) as MinConfirmed,
min(Deaths) as MinDeaths, 
min(Recovered) as MinRecovered
from 
corona_data 
group by Year_wise;  


-- Q9. Find maximum values of confirmed, deaths, recovered per year 
select year(new_date_column) as Year_wise, 
max(Confirmed) as MaxConfirmed,
max(Deaths) as MaxDeaths, 
max(Recovered) as MaxRecovered
from 
corona_data 
group by Year_wise;  

-- Q10. The total number of case of confirmed, deaths, recovered each month 

select Month(new_date_column) as Month_wise, 
sum(Confirmed) as TotalConfirmed,
sum(Deaths) as TotalDeaths, 
sum(Recovered) as TotalRecovered
from 
corona_data 
group by Month_wise; 


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV ) 

SELECT Round(SUM(Confirmed)) AS total_confirmed_cases,
Round(AVG(Confirmed)) AS average_confirmed_cases,
Round(VARIANCE(Confirmed)) AS variance_confirmed_cases,
Round(STDDEV(Confirmed)) AS stddev_confirmed_cases

FROM corona_data; 


-- A steep increase in total confirmed cases and average case counts may indicate rapid community transmission and the potential for exponential growth of the outbreak.
-- High variance and standard deviation could suggest inconsistent testing or reporting practices, localized outbreaks, or fluctuations in transmission rates.

-- low variance and standard deviation might indicate effective containment measures, widespread testing, or a stable epidemiological situation.

-- The average confirmed cases indicate the typical or mean number of new cases reported per unit of time (e.g., per day, per week). Calculating the average helps identify trends and patterns in the spread of the virus over time, smoothing out any fluctuations in daily case counts.
-- Variance measures the degree of dispersion or spread in the distribution of confirmed cases around the mean (average). A higher variance suggests greater variability in daily case counts, while a lower variance indicates more consistency or stability in the spread of the virus.
-- The standard deviation quantifies the amount of dispersion or deviation from the average number of confirmed cases. 
-- A higher standard deviation signifies greater variability or volatility in case counts, whereas a lower standard deviation implies more stability and predictability in the spread of the virus. 



-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV ) 
SELECT month(new_date_column) as Months,
Round(SUM(Deaths)) AS total_Deaths_cases,
Round(AVG(Deaths)) AS average_Deaths_cases,
Round(VARIANCE(Deaths)) AS variance_Deaths_cases,
Round(STDDEV(Deaths)) AS stddev_Deaths_cases

FROM corona_data 
group by Months; 


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )  

SELECT month(new_date_column) as months,Round(SUM(Recovered)) AS total_Recovered_cases,
Round(AVG(Recovered)) AS average_Recovered_cases,
Round(VARIANCE(Recovered)) AS variance_Recovered_cases,
Round(STDDEV(Recovered)) AS stddev_Recovered_cases

FROM corona_data
group by months;  


-- Q14. Find Country having highest number of the Confirmed case 
select Country_Region, 
max(Confirmed) from corona_data;  


-- Q15. Find Country having lowest number of the death case 
select Country_Region, min(Deaths) from corona_data ; 

-- Q16. Find top 5 countries having highest recovered case 
select Country_Region, sum(Recovered) from corona_data
GROUP BY Country_Region 
order by  Recovered desc limit 5 ; 


