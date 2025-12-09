-- Select the database 
use job;

-- # DQL STATEMENTS # --

-- 1. How many records does this table has?

select count(*) as Total_Records
from JOBS_DATA;

-- 2. Does the data has duplicates?

select count(*) as Total_Records ,
	count(distinct(job_id)) as Unique_Jobs	
	from JOBS_DATA;

-- 3. List the top 5 companies and the number of exact job posting.

select top 5 company_name, count(*) as number_of_jobs
	from JOBS_DATA
	group by company_name
	order by 2 desc;

-- 4. List first 6 fields and description token for five random rows.

select	top 5 [index],
	title,
	company_name,
	[location],
	via,
	[description],
	description_tokens
from jobs_data
order by NEWID();


/* 5. Average Standardized Salary by Schedule Type and Remote Status 
What is the average salary_standardized for jobs, broken down by schedule_type and whether 
they are work_from_home or not?
Include only Full-time and contract jobs for this analysis. */

-- salary_standardized , schedule_type, work_from_home

select schedule_type as Schedule_Type,
	case
	when work_from_home = 1 
	then 'Remote'
	else 'On-Site'
	end as Work_Location, 
	round(avg(salary_standardized),0) as Average_Standardized_Salary
	from jobs_data
	where schedule_type != 'Part-time'
	group by schedule_type, work_from_home
	order by 3 desc;
	

/* 6. Top Job Posting Sources by Total Standardized Salary Offered 
Which three job posting sources (via) collectively represent the highest sum 
of Standardized salaries (salary_standardized)? */

-- Via  , Salary Standardized 


select top 1 via, sum(salary_standardized) as 'Total Salary'
	from Jobs_data
	group by via
	order by 2 desc;



/* 7. Job Titles with the Highest Proportion of Remote Opportunities
List the top 5 job titles that have the highest proportion of
work_from_home positions among all their postings. Consider only titles with at least 3 total postings.*/


select	title ,
	cast(sum(case when work_from_home = 1 then 1 else 0 end)/count(*) as float) as proportions
	from jobs_data
	group by title
	having count(*) >= 2


/* 8. Overall Average Standardized Salary for Hourly vs. Yearly Rates
   Compare the overall average standardized salary (salary_standardized)
   for jobs listed as 'hourly' (salary_rate = 'hour') versus 'yearly' (salary_rate = 'year'). */


select
	salary_rate,
	round(avg(salary_standardized),0) as Average_Salary
	from JOBS_DATA
group by salary_rate
order by 2 desc;


/* 9. Locations with a High Concentration of Specific Tech Jobs
   Identify locations (excluding 'Remote') that contains "developer" AND ("frontend" or "backend")
   in their description_tokens. Count how many such jobs each identified location has.*/


select
	[location], count(*) as Countofjobs
	from JOBS_DATA
	where [location] <> 'Remote'
	and lower(description_tokens) like '%developer%' 
	and (lower(description_tokens) like '%frontend%'
	or  lower(description_tokens) like '%backend%')
	group by [location]
	order by 2;



/* 10. Salary Comparison for Recently Posted Jobs
   Compare the average salary_standardized for jobs posted in the last 130 days (relative to the
   date_time column, assuming date_time represents "now" for the data point) versus jobs posted earlier. */



select getdate(), dateadd(day,-130, getdate());


select case
		when posted_at >= dateadd(day, -130 , getdate()) then 'Posted in last 130 days' 
		else 'Posted Earlier'
	end as Posted_date ,
	round(avg(salary_standardized),0) standard_avg_salary
from JOBS_DATA
group by 
	case
		when posted_at >= dateadd(day, -130 , getdate()) then 'Posted in last 130 days' 
		else 'Posted Earlier'
	end 
	order by 2 desc;



/* 11. Determine Days Since Job Posting
   Show the title, company_name, posted_at, date_time (the timestamp of when the record was observed),
   and a new calculated column DaysSincePosting which represents how many days have passed between
   the posted_at date and the date_time of the record. */



select title, company_name,
	posted_at, date_time,
	DATEDIFF(day, posted_at, date_time ) as DaysSincePosting
from JOBS_DATA
order by 5 desc;



-- Find the Difference between the current date and the posted date.

select title, company_name,
	posted_at, date_time,
	DATEDIFF(day, posted_at, GETDATE()) as DaysSinceCurrentDate
from JOBS_DATA
order by 5 desc;




/* 12. Categorize Salary Ranges

   Create a new column SalaryTier that categorizes jobs based on their salary_standardized:
   'High' if salary_standardized is greater than 120,000
   'Medium' if salary_standardized is between 75,000 and 120,000 (inclusive)
   'Low' if salary_standardized is less than 75,000
   'Unspecified' if salary_standardized is NULL. */


select 
	title,
	company_name,
	salary_standardized ,
case
	when salary_standardized > 120000 then 'High-Salary'
	when salary_standardized between 75000 and 120000 then 'Medium-Salary'
	when salary_standardized < 75000 then 'Low-Salary'
	else 'Unspecified'
end as SalaryTier
from JOBS_DATA;



/* 13. Identify Potential Data/AI/ML Roles

   For each job, display its title, company_name, and a boolean-like calculated column IsDataAIMLRole
   that is 1 if "data", "ai", or "machine learning" (or "ml") is present in description_tokens
   (case-insensitive), otherwise 0. */


with Dsjobs as 
(select
	title,	company_name,	description_tokens,	
	case 
		when lower (description_tokens) like '%ai%'
			or
			lower (description_tokens) like '%data%'
			or 
			lower (description_tokens) like '%machine learning%'
			or 
			lower (description_tokens) like '%ml%'
		then 1
		else 0
	end as IsDataAIMLRole
from JOBS_DATA)

select * 
	from dsjobs
		where IsDataAIMLRole = 1;


/* 14. Standardized Commute Category and Estimated Commute Time in Hours

   Create two calculated columns:
   1. commuteCategory: 'Short' (<= 20 mins), 'Medium' (>20 and <= 45 mins),
      'Long' (>45 mins), or 'N/A' if commute_time is not numeric.
   2. CommuteTimeInHours: Converts the commute_time (assuming it's in 'X mins' format) to hours. */

with Timetable as (
select 
	title, company_name, commute_time ,
	replace(commute_time, 'mins','') as CommutedTime 
from JOBS_DATA) 

select title, company_name , commute_time,
	case
		when 
			ISNUMERIC(CommutedTime) = 0 then 'N/A' 
		when
			CommutedTime <= 20 then 'Short'
		when
			CommutedTime between 21 and 45 then 'Medium'
		when 
			CommutedTime > 45 then 'Long'
	end as CommuteCategory ,

	case
		when try_cast (replace  (commute_time , 'mins' , '') as int) is NULL then 'N/A' 
		else cast( round(try_cast (replace  (commute_time , 'mins' , '')  as float)  / 60 , 2) as nvarchar)
	end as CommutetimeInHours
from Timetable;

/* 	[0 = False / 1 = True] 
	IsNumeric checks whether the CommutedTime is a number or not.
	If the CommutedTime "Value" is a number then Isnumeric function 
	will return True [ 1 ] , Else it will return False [ 0 ].*/




/* 6. Analyze Average Salary and Remote Job Proportion for Top 5 Job Titles

   For the 5 most frequently posted titles (excluding 'Remote' locations),
   calculate their average salary_standardized. Then, for each of these top 5 titles,
   determine the percentage of jobs that are work_from_home.
   Rank these top titles by their average standardized salary. */

with Titles as
(select top 5
	title
from JOBS_DATA
	where [location] <> 'Remote'
	group by title
	order by count(title) desc)
select t.title , avg(j.salary_standardized) as AvgSalStd , 
	cast (
	sum ( case
		when work_from_home = 1 then 1 else 0
		end) as float)*100/ count(j.job_id) RemoteJobs ,
	rank() over (order by avg(salary_standardized) desc) as Stdsalary
from Titles t
inner join JOBS_DATA j
on t.title = j.title
group by t.title










select top(10) * from JOBS_DATA;