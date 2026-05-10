# Customer-Churn-Analysis
## Project overview
A subscription-based company is losing customers at a higher rate than expected. Managers want to understand which customers are most likely to churn, why, and what actions are needed to reduce churn.

## Key questions to answer:
- What is the overall churn rate?
- Which customer segments churn the most?
- What factors (price, contract type, tenure, support calls, demographics) predict churn?
- What actions could reduce churn?

## Dataset
Source: Telco Customer Churn dataset (Kaggle)  
Rows: 7043  
Original columns: 21  
Key fields: CustomerID, Tenure, MonthlyCharges, TotalCharges, InternetService, Contract, PaymentMethod, Churn.

## Data cleaning summary
The purpose of this stage is to tranform the raw CSV file into clean, reliable, analysis-ready data. The cleaning process included intial inspection, duplicate checks, data type correction, handling of missing values, categorical standardisation, feature engineering and final validation.

A full step-by-step breakdown of every action applied during the data cleaning is available in the file data_cleaning_log.md

## Analysis and insights
# Churn by contract type
```sql
-- Churn by contract type
SELECT 
 Contract,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY Contract
ORDER BY churn_rate DESC;
```
![Churn by contract type](./Screenshots/churn_contract.png)  

Customers on month-to-month contracts churn at a significantly higher rate than customers on longer-term contracts, making contract type one of the strongest predictors of churn. This pattern suggests that customers with greater flexibility are more likely to leave, while longer-term contracts create stability and reduce churn. Focusing retention strategies on month-to-month customers such as offering discounts for contract upgrades or improving early stage onboarding could reduce churn.

## Recommendations
