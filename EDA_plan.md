1. What is the overall churn rate?
2. How does churn vary by key segments?
3. What factors seem most related to churn?

## Data preperation in BigQuery
After importing the cleaned CSV into BigQuery, several numeric fields were automatically interpreted as STRING types. This caused errors when running analytical queries. 
To resolve this issue I created a new table using SAFE_CAST to convert these feilds into the correct numeric types. The SQL query I used to create the new table is as follows:

```sql
CREATE TABLE project-1-481514.churn_analysis.cleaned_telco_churn_fixed AS
SELECT 
CustomerID,
Gender,SAFE_CAST(SeniorCitizen AS INT64) AS SeniorCitizen,
Partner,
Dependents,
SAFE_CAST(Tenure AS INT64) AS Tenure,
PhoneService,
MultipleLines,
InternetService,
OnlineSecurity,
OnlineBackup,
DeviceProtection,
TechSupport,
StreamingTV,
StreamingMovies,
Contract,
PaperlessBilling,
PaymentMethod,
SAFE_CAST(MonthlyCharges AS FLOAT64) AS MonthlyCharges,
SAFE_CAST(TotalCharges AS FLOAT64) AS TotalCharges,
Churn
 FROM `project-1-481514.churn_analysis.cleaned_telco_churn`
```
The data is now ready for analysis in SQL

## 1. Overall churn rate
Churn rate = customers lost during period / customers at start of period  
In our dataset we are given 'churn' as a boolean string type so our new equation will be:  
Churn rate = Churn=true / customers at start of period  

```sql
-- Total customers
SELECT COUNT(*) AS total_customers
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed;
```
The total number of customers is 7043

```sql
-- Churned customers
SELECT COUNT(*) AS churned_customers
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
WHERE Churn = true;
```
The total number of churned customers is 1869

```sql
-- Churn rate
SELECT COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed;
```
1869/7043 = 0.265369...  
Therefore our churn rate equals 26.54%

## 2. Churn by customer segments 
In this part we will answer:  
- Which segments churn the most?
- How does churn vary by contract, tenure, charges, etc.?

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

