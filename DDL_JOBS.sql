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


select	title, 
	count(*)
	from jobs_data
	group by title
	having count(*) >= 2;























select top(10) * from JOBS_DATA;