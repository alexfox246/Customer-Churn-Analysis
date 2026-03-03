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