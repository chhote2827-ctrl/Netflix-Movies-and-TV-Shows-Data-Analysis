<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/82fb3c4e-7e64-4baa-a25e-6d6a33926f89" /># 🎬 Netflix Movies and TV Shows Data Analysis

> **An End-to-End Data Analysis project exploring Netflix content catalogs using Python, PostgreSQL, and data visualization techniques to uncover business insights.**

---

## 📋 Table of Contents
1. [Project Overview](#-project-overview)
2. [Tech Stack](#-tech-stack)
3. [Dataset Schema & Preparation](#-dataset-schema--preparation)
4. [Data Cleaning & Processing (Python)](#-data-cleaning--processing-python)
5. [SQL Analysis & Business Questions](#-sql-analysis--business-questions)
6. [Key Insights & Findings](#-key-insights--findings)
7. [Visualizations](#-visualizations)
8. ![Netflix_Titles Preview]("C:\Users\Yogesh Kumar\OneDrive\Pictures\Screenshots\Screenshot 2026-10-18 214851.png")
9. [Conclusion & Future Scope](#-conclusion--future-scope)

---

## 🚀 1. Project Overview
Yeh project Netflix ke content catalog ko analyze karne ke liye banaya gaya hai. Iska main focus yeh samajhna hai ki Netflix par kis tarah ka content available hai, kis country se sabse zyada production hota hai, aur saalo-saal content growth ka trend kaisa raha hai. Is project mein Python (Pandas) se data cleaning, PostgreSQL se analytical querying, aur data visualization ka use kiya gaya hai.

---

## 🛠️ 2. Tech Stack
* **Language:** Python
* **Data Processing Libraries:** Pandas, NumPy
* **Visualization Libraries:** Matplotlib, Seaborn
* **Database Management:** PostgreSQL, pgAdmin
* **Version Control:** Git & GitHub

---

## 📂 3. Dataset Schema & Preparation
Dataset mein Netflix par available movies aur TV shows ki details hain:

| Column Name | Description |
| :--- | :--- |
| `show_id` | Unique ID for every movie/show |
| `type` | Identifier (Movie or TV Show) |
| `title` | Title of the content |
| `director` | Director(s) of the content |
| `cast` | Actors involved |
| `country` | Country of production |
| `date_added` | Date added on Netflix |
| `release_year` | Actual release year |
| `rating` | TV rating (e.g., PG-13, TV-MA) |
| `duration` | Duration in minutes or number of seasons |
| `listed_in` | Genres / Categories |

---

## 🧹 4. Data Cleaning & Processing (Python)
Data quality enhance karne ke liye Pandas ka use karke cleaning operations execute kiye gaye:
* `director`, `cast`, aur `country` columns ke missing values ko `'Unknown'` se handle kiya gaya.
* `date_added` column ko standard datetime format mein parse kiya gaya.
* Duplicates ko remove karke clean dataframe export kiya gaya.

```python
import pandas as pd
import numpy as np

# Load dataset
df = pd.read_csv('netflix_titles.csv')

# Handle missing values
df['director'] = df['director'].fillna('Unknown')
df['cast'] = df['cast'].fillna('Unknown')
df['country'] = df['country'].fillna('Unknown')

# Convert date_added to datetime
df['date_added'] = pd.to_datetime(df['date_added'].str.strip(), format='mixed', errors='coerce')
df['year_added'] = df['date_added'].dt.year
