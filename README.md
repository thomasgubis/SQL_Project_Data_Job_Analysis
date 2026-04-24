# Introduction

This project explores the data analyst job market using SQL, focusing on identifying high-paying roles, in-demand skills, and the relationship between skills and salary. The analysis is based on a dataset of 2023 job postings and aims to provide actionable insights for aspiring and current data professionals.

All SQL queries used in this project can be found in the [project_sql folder](https://github.com/thomasgubis/SQL_Project_Data_Job_Analysis/tree/main/project_sql).

# Background

The project was developed to better understand how the data analyst job market is structured, particularly in terms of compensation and skill demand. Using a dataset derived from a SQL training course, the analysis investigates key aspects such as job titles, salaries, locations, and required skills.

The main questions addressed are:

- What are the top-paying data analyst jobs?
- What skills are required for these roles?
- Which skills are most in demand?
- Which skills are associated with higher salaries?
- What are the most valuable skills to learn?

# Tools I Used
- SQL – Core tool for querying and analyzing the dataset
- PostgreSQL – Database system used to manage and process the data
- Visual Studio Code – Environment for writing and executing SQL queries
- Git & GitHub – Version control and project sharing
- Excel – Used for data visualization and exploratory analysis

These tools enabled efficient data extraction, transformation, and interpretation throughout the project.

# The Analysis

The analysis is structured around five key questions:

1. Top-Paying Data Analyst Jobs

Identified the highest-paying remote data analyst roles by filtering for salary and location. This highlights where the most lucrative opportunities exist.

```sql
SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE 
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```

2. Skills Required for Top-Paying Jobs

Analyzed the skill sets associated with high-paying roles to understand what employers value most at the upper end of the market.

```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM 
    top_paying_jobs
INNER JOIN skills_job_dim AS skill_to_job ON top_paying_jobs.job_id = skill_to_job.job_id
INNER JOIN skills_dim AS skills ON skill_to_job.skill_id = skills.skill_id
ORDER BY
    salary_year_avg DESC;
```

3. Most In-Demand Skills

Measured frequency of skills across job postings to determine which competencies are most commonly required.

```sql
SELECT
    skills,
    COUNT(skill_to_job.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN skills_job_dim AS skill_to_job ON job_postings_fact.job_id = skill_to_job.job_id
INNER JOIN skills_dim AS skills ON skill_to_job.skill_id = skills.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```

4. Skills Associated with Higher Salaries

Compared average salaries by skill to identify which technologies and tools correlate with higher compensation.

```sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg)) AS salary_avg
FROM 
    job_postings_fact
INNER JOIN skills_job_dim AS skill_to_job ON job_postings_fact.job_id = skill_to_job.job_id
INNER JOIN skills_dim AS skills ON skill_to_job.skill_id = skills.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    salary_avg DESC
LIMIT 25;
```

5. Optimal Skills to Learn

Combined demand and salary insights to determine which skills provide the best return on investment for career growth.

```sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg)) AS avg_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True 
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```

# What I Learned

Developed strong SQL fundamentals, including joins, aggregations, subqueries, and CTEs
Improved ability to analyze real-world datasets and extract meaningful insights
Learned how to structure queries to answer business-driven questions
Gained experience translating raw data into clear, actionable conclusions
Strengthened data visualization skills using Excel

More importantly, this project reinforced how data analysis is not just about querying data, but about asking the right questions and interpreting results effectively.

# Conclusions

### Key Insights

- High-paying data analyst roles vary widely in responsibilities and seniority, with some positions offering exceptionally high compensation
- SQL remains a core requirement for top-paying roles, often alongside Python and Excel
- Demand is concentrated around a small set of foundational skills, making them essential for entry and growth
- Niche or specialized skills can be associated with higher salaries, but are less universally required
- The most valuable skill set combines high demand and strong salary potential, particularly SQL and Python

### Final Thoughts

This project highlights that career growth in data analytics is driven not by the number of tools learned, but by mastering core skills and understanding how they apply to real-world problems. It also emphasizes the importance of aligning skill development with market demand to maximize career opportunities.

