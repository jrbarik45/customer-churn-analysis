"""
Project 1: Customer Churn Analysis - data cleaning
Dataset: Telco Customer Churn (Kaggle) -> WA_Fn-UseC_-Telco-Customer-Churn.csv
Run: python clean_churn.py
Needs: pip install pandas sqlalchemy pymysql
"""
import pandas as pd
from sqlalchemy import create_engine

# ---------- 1. Load ----------
df = pd.read_csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")
print("Shape:", df.shape)
print(df.info())

# ---------- 2. Fix data types ----------
# TotalCharges has blank strings (" ") for customers with tenure = 0
df["TotalCharges"] = pd.to_numeric(df["TotalCharges"], errors="coerce")
print("Null TotalCharges:", df["TotalCharges"].isna().sum())

# These customers are brand new (tenure 0), so their total charges are 0
df["TotalCharges"] = df["TotalCharges"].fillna(0)

# SeniorCitizen is 0/1 -> make it readable
df["SeniorCitizen"] = df["SeniorCitizen"].map({0: "No", 1: "Yes"})

# ---------- 3. Duplicates and missing values ----------
print("Duplicate customerIDs:", df["customerID"].duplicated().sum())
df = df.drop_duplicates(subset="customerID")
print("Missing values per column:\n", df.isna().sum())

# ---------- 4. Clean text categories ----------
# "No internet service" / "No phone service" -> "No" for simpler analysis
cols_to_fix = [
    "MultipleLines", "OnlineSecurity", "OnlineBackup", "DeviceProtection",
    "TechSupport", "StreamingTV", "StreamingMovies",
]
for c in cols_to_fix:
    df[c] = df[c].replace({"No internet service": "No", "No phone service": "No"})

# Strip stray spaces in all text columns
for c in df.select_dtypes(include="object").columns:
    df[c] = df[c].str.strip()

# ---------- 5. New columns ----------
df["tenure_group"] = pd.cut(
    df["tenure"],
    bins=[-1, 12, 24, 48, 72],
    labels=["0-12 months", "13-24 months", "25-48 months", "49+ months"],
)
df["churn_flag"] = (df["Churn"] == "Yes").astype(int)

# ---------- 6. Quick EDA ----------
print("\nOverall churn rate: {:.2f}%".format(df["churn_flag"].mean() * 100))
print("\nChurn rate by contract:\n",
      df.groupby("Contract")["churn_flag"].mean().mul(100).round(2))
print("\nChurn rate by tenure group:\n",
      df.groupby("tenure_group", observed=True)["churn_flag"].mean().mul(100).round(2))

# ---------- 7. Save ----------
df.to_csv("telco_churn_clean.csv", index=False)
print("\nSaved telco_churn_clean.csv")

# ---------- 8. Load into MySQL ----------
# Create the database first in MySQL:  CREATE DATABASE churn_db;
# Change user, password and host below.
engine = create_engine("mysql+pymysql://root:YOUR_PASSWORD@localhost:3306/churn_db")
df["tenure_group"] = df["tenure_group"].astype(str)
df.to_sql("telco_churn", engine, if_exists="replace", index=False)
print("Loaded table telco_churn into MySQL")
