# Customer-Churn-Analysis
## Project overview
A subscription-based company is losing customers at a higher rate than expected and managers want to understand why. In this scenario, churn refers to the rate at which customers cancel their subscriptions over a given period. The objective of this project is to understand which customers are most likely to churn, why they churn, and what actions are needed to reduce churn. 

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
The purpose of this stage is to tranform the raw CSV file into clean, reliable, analysis-ready data. The cleaning process included:
- Intial inspection
- Duplicate checks
- Data type correction
- Handling of missing values
- Categorical standardisation
- Feature engineering
- Final validation

A full step-by-step breakdown of every action applied during the data cleaning process is available in data_cleaning_log.md

## Analysis and insights
The total number of customers is 7043. 1869 of those customers have churned so our overall churn rate is 26.54%. In this section we will analyse which variables have the strongest impact on churn.
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

Customers on month-to-month contracts churn at a significantly higher rate than customers on longer-term contracts, making contract type one of the strongest predictors of churn. This pattern suggests that customers with greater flexibility are more likely to leave, while longer-term contracts create stability and reduce churn.

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

Nearly half of all customers in their first year churn, and almost one-third leave within two years. This tells us that customers who have not yet built loyalty or perceived value are far more likely to leave. Churn declines steadily as tenure increases, indicating that long-standing customers are significantly more stable. 

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

Churn increases significantly as monthly charges rise, indicating that higher-paying customers are more likely to feel dissatisfied or perceive lower value for money. The jump from low to medium charges is especially steep, indicating that customers moving into mid-tier plans experience a mismatch between expectations and actual service quality. Retaining medium and high charge customers should be a priority, as they contribute more revenue and churn at higher rates. 

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
![Churn by internet_service](./Screenshots/churn_internet_service.png)

Customers using fiber optic internet churn at significantly higher rates than those using DSL and those with no internet service. Fiber optic customers tend to pay higher monthly charges for their internet in return for faster browsing speeds and reliability. If those expectations are not met - or if competitors offer similar speeds at lower prices - these customers may be more likely to switch providers.

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
![Churn by payment_method](./Screenshots/churn_payment_method.png)

Customers who pay via electronic check churn at significantly higher rates than customers using other payment methods, indicating that billing experience and payment preferences are key drivers of churn. The findings tell us that customers using manual or less convenient payment methods may experience more dissatisfaction, while automatic payment users are more stable. 

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
![Churn by contract chargebucket](./Screenshots/churn_contract_chargebucket.png)

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
![Churn by tenure_payment](./Screenshots/churn_tenure_payment.png)

Tenure and payment method interact strongly: early-tenure customers using manual payment methods (electronic and mailed checks) churn at significantly higher rates than long-tenure customers using automatic payments. This shows that churn is driven by both customer maturity and billing friction. 

### Executive summary

Churn in this dataset is driven by a number of different factors including:
- Contract flexibility
- Early-tenure vulnerability
- High monthly charges
- Manual payment methods

Customers who fall into more than one of these categories churn at dramatically higher rates.

## Key insights
#### - Tenure Group is the strongest single predictor of churn   
Customers in their first year of subscribing churn at a rate of 47.44%.

#### - Payment method strongly influences churn   
Manual payment methods (especially electronic check) add friction and correlates with churn. Shifting customers to automatic payment methods is a low-cost, high-impact retention strategy.

#### - Contract type is a significant single predictor of churn  
Customers on month-to-month contracts churn at a rate of 42.71%

#### - Combined churn analysis shows that churn is driven by multiple overlapping risk factors, not single variables   
Month-to-month + high monthly charges = 52.15%   
Month-to-month + medium monthly charges = 42.15%   
New customers paying via electronic check = 61.96%

## Business recommendations   
### 1. Targeted retention for month‑to‑month customers   
Month-to-month customers churn at a rate of 42.71% making them the third-highest single risk group. These customers have no commitment barrier and can leave at any time.   
Recommended actions:
- Introduce contract-upgrade incentives, such as discounted first-year pricing or added service benefits like free installations or service add-ons.
- Offer loyalty rewards for switching to annual or two-year contracts.
- Provide personalised outreach to month-to-month customers within their first 90 days, when churn is highest.

### 2. Stronger onboarding for first‑year customers  
Customers in their first 12 months churn at a rate of 47.44% making them the highest single predictor of churn. Focusing retention strategies on these customers offers the greatest opportunity to reduce overall churn.   
Recommended actions:
- Implement a structured onboarding programme that includes welcome emails, service tips, and support check-ins.
- Monitor early-tenure customers for service issues, billing problems, or usage drops.
- Provide proactive support and usage education during the first 30-90 days, when dissatisfaction typically emerges.

### 3. Encourage customers to switch to automatic payments
Electronic check users churn at 45.29%, the highest of all payment methods. Manual payment methods introduce friction and increase the likelihood of missed or late payments.
Recommended actions:
- Offer small incentives such as, £5 credit vouchers or loyalty points, for switching to automatic payments.
- Highlight and emphasise the convenience and reliability of automatic billing during onboarding.
- Identify electronic check users in early tenure and target them with payment method upgrade campaigns.
- Set up a payment failure alert system to prevent involuntary churn.

### 4. Review pricing and value for medium and high charge buckets
Customers paying higher monthly charges show significantly higher churn rates. This suggests there is price sensitivity or a mismatch between cost and perceived value.
Recommended actions:
- Conduct a value-perception review for medium and high charge plans and improve the value proposition through pricing adjustments.
- Offer enhanced business services, loyalty discounts, or exclusive benefits to justify higher pricing.
- Provide transparent communication about what customers receive for their plan tier.

