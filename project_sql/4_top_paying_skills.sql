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

/*
Highest compensation is associated with technical depth and system-level responsibility, not isolated tools
The most valuable profiles combine:
- data skills (analysis, modeling)
- engineering skills (pipelines, infrastructure)
Pure analytics roles are generally lower-paying than hybrid data-engineering or platform-oriented roles

[
  {
    "skills": "svn",
    "salary_avg": "400000"
  },
  {
    "skills": "solidity",
    "salary_avg": "179000"
  },
  {
    "skills": "couchbase",
    "salary_avg": "160515"
  },
  {
    "skills": "datarobot",
    "salary_avg": "155486"
  },
  {
    "skills": "golang",
    "salary_avg": "155000"
  },
  {
    "skills": "mxnet",
    "salary_avg": "149000"
  },
  {
    "skills": "dplyr",
    "salary_avg": "147633"
  },
  {
    "skills": "vmware",
    "salary_avg": "147500"
  },
  {
    "skills": "terraform",
    "salary_avg": "146734"
  },
  {
    "skills": "twilio",
    "salary_avg": "138500"
  },
  {
    "skills": "gitlab",
    "salary_avg": "134126"
  },
  {
    "skills": "kafka",
    "salary_avg": "129999"
  },
  {
    "skills": "puppet",
    "salary_avg": "129820"
  },
  {
    "skills": "keras",
    "salary_avg": "127013"
  },
  {
    "skills": "pytorch",
    "salary_avg": "125226"
  },
  {
    "skills": "perl",
    "salary_avg": "124686"
  },
  {
    "skills": "ansible",
    "salary_avg": "124370"
  },
  {
    "skills": "hugging face",
    "salary_avg": "123950"
  },
  {
    "skills": "tensorflow",
    "salary_avg": "120647"
  },
  {
    "skills": "cassandra",
    "salary_avg": "118407"
  },
  {
    "skills": "notion",
    "salary_avg": "118092"
  },
  {
    "skills": "atlassian",
    "salary_avg": "117966"
  },
  {
    "skills": "bitbucket",
    "salary_avg": "116712"
  },
  {
    "skills": "airflow",
    "salary_avg": "116387"
  },
  {
    "skills": "scala",
    "salary_avg": "115480"
  }
]
*/