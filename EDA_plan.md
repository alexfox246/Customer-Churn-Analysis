1. What is the overall churn rate?
2. How does churn vary by key segments?
3. What factors seem most related to churn?

## Data preperation in BigQuery
After importing the cleaned CSV into BigQuery, several numeric fields were automaticallu interpreted as STRING types. This caused errors when running analytical queries. 
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