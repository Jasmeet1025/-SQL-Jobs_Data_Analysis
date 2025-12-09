# 📊 Jobs Data Analysis Project

A SQL-based Exploratory Data Analysis (EDA) of a real-world jobs dataset
to uncover insights about job markets, salary trends, remote work,
posting sources, and role classifications.

## 🚀 Project Overview

This project focuses on analyzing job postings to understand hiring
patterns, salary variations, remote job availability, skill demand, and
job posting behavior across companies.\
All analysis was done using SQL Server, covering data cleaning,
transformations, and answering business-oriented questions.

## 🗂 Dataset Description

The dataset contains job postings scraped from various sources.\
Key fields include:

-   job_id\
-   title\
-   company_name\
-   location\
-   salary_standardized\
-   salary_rate\
-   description_tokens\
-   via\
-   posted_at\
-   work_from_home\
-   commute_time

## 🛠 Tools & Technologies Used

-   SQL Server (T-SQL)
-   DQL & DML queries
-   CTEs
-   Window functions
-   Case statements
-   String functions

## 🔍 Key Analysis Performed

1.  Data quality checks\
2.  Company-level insights\
3.  Salary analysis (Hourly vs Yearly, Remote vs On-site)\
4.  Source platform salary contribution\
5.  Remote work proportion by job title\
6.  Tech role classification\
7.  Location-based developer job analysis\
8.  Recent job salary comparison\
9.  Days since posting calculations\
10. Salary tier categorization\
11. Commute time conversion & categorization\
12. Ranking top frequent roles

## 🧠 Key Insights

-   A few companies dominate total job postings.\
-   Remote jobs offer strong average salaries.\
-   Data/AI/ML roles appear frequently based on keyword classification.\
-   Certain job posting platforms contribute the highest cumulative
    salary offerings.\
-   Developer roles cluster heavily in specific non-remote cities.\
-   Yearly rate roles show higher standardized salaries overall.

## 📁 Folder Structure

    Jobs-Data-Analysis/
    │
    ├── sql/
    │   ├── DDL_JOBS.sql
    │   └── JOBS_DATA_ANALYSIS_PROJECT.sql
    │
    ├── data/              (optional)
    ├── notebooks/         (optional)
    ├── images/            (optional)
    │
    └── README.md

## 📌 How to Use

1.  Import dataset into SQL Server\
2.  Run DDL_JOBS.sql to create schema\
3.  Run JOBS_DATA_ANALYSIS_PROJECT.sql for full analysis\
4.  Modify queries as needed

## 📬 Future Enhancements

-   Add Jupyter Notebook visualizations\
-   Build Power BI/Tableau dashboard\
-   Add data cleaning steps\
-   Explore more salary benchmarks
