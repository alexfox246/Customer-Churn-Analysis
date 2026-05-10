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
### Churn by contract type
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

### Churn by tenure group
```sql
-- Churn by tenure group
SELECT 
 TenureGroup,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY TenureGroup
ORDER BY churn_rate DESC;
```
![Churn by tenure group](./Screenshots/churn_tenure.png)  

Nearly half of all customers in their first year churn, and almost one-third leave within two years. This tells us that customers who have not yet built loyalty or perceived value are far more likely to leave. Churn declines steadily as tenure increases, indicating that long-standing customers are significantly more stable. Focusing retention strategies on customers in their first 12 to 24 months offers the greatest opportunity to reduce overall churn. Improving onboarding, providing early-life support and proactively adressing service issues could improve retention. 

### Churn by monthly charge 
```sql
-- Churn by monthly charge bucket
SELECT 
 ChargeBucket,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY ChargeBucket
ORDER BY churn_rate DESC;
```
![Churn by monthly charge bucket](./Screenshots/churn_chargebucket.png)

Churn increases significantly as monthly charges rise, indicating that higher-paying customers are more likley to feel dissatisfied or perceive lower value for money. The jump from low to medium charges is especially steep, indicating that customers moving into mid-tier plans experience a mismatch between expectations and actual service quality. Retaining medium and high charge customers should be a priority, as they contribute more revenue and churn at higher rates. Improving the value proposition in these segments through pricing adjustments,  exclusive benefits and enhanced service experince could reduce churn.

### Churn by internet service type
```sql
-- Churn by internet service type
SELECT 
 InternetService,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY InternetService
ORDER BY churn_rate DESC;
```
![Churn by monthly charge bucket](./Screenshots/churn_internet_service.png)

Customers using fiber optic internet churn at significantly higher rates than those using DSL and those with no internet service. Fiber optic customers tend to pay higher monthly charges for their internet in return for faster browsing speeds and reliability. If those expectations are not met - or if competitors offer similar speeds at lower prices - these customers may be more likely to switch providers. Improving reliability, reviewing pricing, and offering targeted retention incentives could meaningfully reduce churn.

### Churn by payment method
```sql
-- Churn by Payment method
SELECT 
 PaymentMethod,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY PaymentMethod
ORDER BY churn_rate DESC;
```
![Churn by monthly charge bucket](./Screenshots/churn_payment_method.png)

Customers who pay via electronic check churn at significantly higher rates than customers using other payment methods, indicating that billing experience and payment preferences are key drivers of churn. The findings tell us that customers using manual or less convenient payment methods may experience more dissatisfaction, while automatic payment users are more stable. Encouraging customers to switch to automatic payments could significantly reduce churn.

## Churn by combined factors
### Contract type vs Monthly charge
```sql
SELECT 
 Contract,
 ChargeBucket,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY Contract, ChargeBucket
ORDER BY churn_rate DESC;
```
![Churn by monthly charge bucket](./Screenshots/churn_contract_chargebucket.png)

When multiple risk factors overlap - in this case contract type and monthly charges - churn rates rise sharply. Churn is highest when customers are both on month-to-month contracts and paying medium or high monthly charges. This makes sense from a behaviour perspective:
- Month-to-month customers can switch easily.
- Higher-paying customers are more price-sensitive and expect more value.

In contrast, customers on one or two year contracts paying lower charges are far more stable.

### Tenure group vs Payment method
```sql
SELECT 
 TenureGroup,
 PaymentMethod,
 COUNT(*) AS total_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END) AS churned_customers,
 COUNT(CASE WHEN Churn = true THEN 1 END)*1.0/COUNT(*) AS churn_rate
FROM project-1-481514.churn_analysis.cleaned_telco_churn_fixed 
GROUP BY TenureGroup, PaymentMethod
ORDER BY churn_rate DESC;
```
![Churn by monthly charge bucket](./Screenshots/churn_tenure_payment.png)

Tenure and payment method interact strongly: early-tenure customers using manual payment methods (electronic and mailed checks) churn at significantly higher rates than long-tenure customers using automatic payments. This shows that churn is driven by both customer maturity and billing friction. 

### Executive summary

Churn in this dataset is driven by a number of different factors including:
- Contract flexibility
- Early-tenure vulnerability
- High monthly charges
- Manual payment methods

Customers who fall into more than one of these categories churn at dramatically higher rates.

# Key insights
- Tenure Group is the strongest single predictor of churn   
Customers in their first year of subscribing churn at a rate of 47.44%.

- Payment method strongly influences churn   
Manual payment methods (especially electronic check) adds friction and correlates with churn. Shifting customrs to automatic payment methods is a low-cost, high-impact retention strategy.

- Customers on month to month contracts paying high and medium monthly charges churn at significantly high rates

- Combined churn analysis shows that churn is driven by multiple overlapping risk factors, not single variables

## Recommendations
