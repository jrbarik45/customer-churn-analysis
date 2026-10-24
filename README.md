Customer Churn Analysis & Retention Insights
Analysis of telecom customer data to find why customers leave and which segments are at highest risk, using Python, MySQL and Power BI.
Business Problem
A telecom company loses customers every month. The retention team needs to know who leaves, why, and which customers to target first. This project answers those questions using SQL analysis and an interactive dashboard.
Dataset
Source: Telco Customer Churn on Kaggle
Size: about 7,000 customers, 21 columns
Key columns: `Contract`, `tenure`, `MonthlyCharges`, `TotalCharges`, `PaymentMethod`, `InternetService`, `TechSupport`, `Churn`
Tools Used
Python (Pandas) | MySQL | Power BI
Project Workflow
Data cleaning (`clean_churn.py`): converted `TotalCharges` from text to numeric, handled blank values, simplified "No internet service" and "No phone service" labels, created tenure groups and a churn flag
SQL analysis (`analysis.sql`): churn rate overall and by contract, tenure, payment method, and tech support; high-risk segment using a CTE; payment-method ranking using a window function; revenue at risk
Dashboard (`dashboard.pbix`): KPI cards, churn by contract, tenure group and payment method, and a high-risk segment view with slicers
Insights and recommendations (below)
Key Insights
> Replace these with your own results from the SQL queries and dashboard.
Overall churn rate is [X%]
[Month-to-month] customers churn at [X%], compared with [Y%] for two-year contracts
Customers in their first [12 months] churn at [X%]
The [payment method] group has the highest churn at [X%]
The high-risk segment (month-to-month, tenure up to 12 months, monthly charge above 70) churns at [X%]
Recommendations
Offer discounts or incentives to move month-to-month customers to annual contracts
Run an onboarding and check-in program for customers in their first year
Promote tech support and security add-ons, since [customers with tech support churn less]
Target the high-risk segment with retention offers first
Dashboard Preview
![Dashboard](screenshots/dashboard.png)
Repository Structure
```
├── data/
│   └── telco_churn_clean.csv
├── clean_churn.py
├── analysis.sql
├── dashboard.pbix
├── screenshots/
│   └── dashboard.png
└── README.md
```
How to Run
Download the dataset from the Kaggle link above and place the CSV in the project folder
Install the libraries: `pip install pandas sqlalchemy pymysql`
In MySQL, run `CREATE DATABASE churn_db;`
Open `clean_churn.py`, replace `YOUR_PASSWORD` with your MySQL password, and run `python clean_churn.py`
Run `analysis.sql` in MySQL Workbench
Open `dashboard.pbix` in Power BI Desktop
Challenges and What I Learned
`TotalCharges` was stored as text with blank values for brand-new customers. I converted it to numeric and set those blanks to 0 because their tenure was 0.
I learned to combine CASE statements, CTEs and window functions to segment customers and rank risk factors.
Contact
Jyoti Ranjan Barik | jrbarik45@gmail.com | LinkedIn
