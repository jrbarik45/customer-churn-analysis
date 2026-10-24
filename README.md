# Customer Churn Analysis & Retention Insights

Analysis of telecom customer data to find why customers leave and which segments are at highest risk, using Python, MySQL and Power BI.

## Business Problem
A telecom company loses customers every month. The retention team needs to know who leaves, why, and which customers to target first. This project answers those questions using SQL analysis and an interactive dashboard.

## Dataset
- **Source:** [Telco Customer Churn on Kaggle](https://www.kaggle.com/datasets/blastchar/telco-customer-churn)
- **Size:** about 7,000 customers, 21 columns
- **Key columns:** `Contract`, `tenure`, `MonthlyCharges`, `TotalCharges`, `PaymentMethod`, `InternetService`, `TechSupport`, `Churn`

## Tools Used
Python (Pandas) | MySQL | Power BI

## Project Workflow
1. **Data cleaning** (`clean_churn.py`): converted `TotalCharges` from text to numeric, handled blank values, simplified "No internet service" and "No phone service" labels, created tenure groups and a churn flag
2. **SQL analysis** (`analysis.sql`): churn rate overall and by contract, tenure, payment method, and tech support; high-risk segment using a CTE; payment-method ranking using a window function; revenue at risk
3. **Dashboard** (`dashboard.pbix`): KPI cards, churn by contract, tenure group and payment method, and a high-risk segment view with slicers
4. **Insights and recommendations** (below)

## Key Insights
1. Overall churn rate is **[X%]**
2. **[Month-to-month]** customers churn at **[X%]**, compared with **[Y%]** for two-year contracts
3. Customers in their first **[12 months]** churn at **[X%]**
4. The **[payment method]** group has the highest churn at **[X%]**

## Recommendations
- Offer incentives to move month-to-month customers to annual contracts
- Run an onboarding and check-in program for customers in their first year
- Promote tech support add-ons, since **[customers with tech support churn less]**
- Target the high-risk segment with retention offers first

## Repository Structure
```
├── clean_churn.py
├── analysis.sql
├── dashboard.pbix
├── screenshots/
│   └── dashboard.png
└── README.md
```

## How to Run
1. Download the dataset from the Kaggle link above
2. Install the libraries: `pip install pandas sqlalchemy pymysql`
3. In MySQL, run `CREATE DATABASE churn_db;`
4. Edit the password in `clean_churn.py`, then run `python clean_churn.py`
5. Run `analysis.sql` in MySQL Workbench
6. Open `dashboard.pbix` in Power BI Desktop

## Contact
Jyoti Ranjan Barik | jrbarik45@gmail.com | [LinkedIn](https://linkedin.com/in/jyoti-ranjan-barik-38b691413)
