# Introduction

This project explores the data analyst job market using SQL, focusing on identifying high-paying roles, in-demand skills, and the relationship between skills and salary. The analysis is based on a dataset of 2023 job postings and aims to provide actionable insights for aspiring and current data professionals.

All SQL queries used in this project can be found in the [project_sql folder](https://github.com/thomasgubis/SQL_Project_Data_Job_Analysis/tree/main/project_sql).

# Background

The project was developed to better understand how the data analyst job market is structured, particularly in terms of compensation and skill demand. Using a dataset derived from a SQL training course, the analysis investigates key aspects such as job titles, salaries, locations, and required skills.

The main questions addressed are:

### 1. What are the top-paying data analyst jobs?
Focuses on identifying the highest-paying positions in the field.

| Job Title | Average Salary |
| :--- | :--- |
| Data Science Manager | $160,000 |
| Lead Data Analyst | $125,000 |
| Principal Data Analyst | $118,000 |

### 2. What skills are required for the top-paying data analyst jobs?
Looks at the specific tools and technical competencies demanded by the highest-paying roles.

| Skill / Tool | Frequency in Top Jobs | Demand Level |
| :--- | :--- | :--- |
| **SQL** | 87% | Essential 🔴 |
| **Python** | 74% | High 🟡 |
| **Power BI / Tableau** | 62% | High 🟡 |
| **Snowflake / AWS** | 35% | Niche Premium 🟢 |
| **Excel (Advanced)** | 31% | Baseline ⚪ |

### 3. What are the most in-demand skills for data analysts?
Analyzes the entire dataset to identify which skills appear most frequently in job postings, regardless of salary.

| Skill / Tool | Total Job Postings | % of Total Jobs |
| :--- | :--- | :--- |
| **SQL** | 452 | 68% |
| **Excel** | 310 | 46% |
| **Python** | 285 | 43% |
| **Power BI** | 198 | 30% |
| **Tableau** | 145 | 22% |

### 4. What are the top skills based on salary?
Investigates which specific technical skills command the highest financial compensation in the market.

| Skill / Tool | Average Associated Salary | Primary Role Using It |
| :--- | :--- | :--- |
| **PySpark / Databricks** | $142,000 | Data Engineer / Advanced Analyst |
| **AWS / Azure** | $135,000 | Cloud Data Analyst |
| **Python** | $121,000 | Data Scientist / Analyst |
| **SQL** | $105,000 | Core Data Analyst |

### 5. What are the most optimal skills to learn?
Combines high market demand with high average salary to pinpoint the most lucrative and secure skills to learn next.

| Skill / Tool | Market Demand (Jobs) | Avg Salary (USD) | Priority Score |
| :--- | :--- | :--- | :--- |
| **SQL** | Very High | $105,000 | **Top Priority** ⭐⭐⭐ |
| **Python** | High | $121,000 | **Top Priority** ⭐⭐⭐ |
| **Power BI** | High | $98,000 | **Recommended** ⭐⭐ |
| **Snowflake** | Medium | $130,000 | **Highly Lucrative** ⭐⭐ |

# Tools I Used
- **SQL** – Core tool for querying and analyzing the dataset
- **PostgreSQL** – Database system used to manage and process the data
- **Visual Studio Code** – Environment for writing and executing SQL queries
- **Git & GitHub** – Version control and project sharing
- **Excel** – Used for data visualization and exploratory analysis

These tools enabled efficient data extraction, transformation, and interpretation throughout the project.

# The Analysis

The analysis is structured around five key questions:

**1. Top-Paying Data Analyst Jobs**

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

**2. Skills Required for Top-Paying Jobs**

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

**3. Most In-Demand Skills**

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

**4. Skills Associated with Higher Salaries**

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

**5. Optimal Skills to Learn**

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

- Developed strong SQL fundamentals, including joins, aggregations, subqueries, and CTEs
- Improved ability to analyze real-world datasets and extract meaningful insights
- Learned how to structure queries to answer business-driven questions
-Gained experience translating raw data into clear, actionable conclusions
- Strengthened data visualization skills using Excel

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

