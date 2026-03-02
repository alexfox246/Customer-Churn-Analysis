## Step 1: Import and inspect the raw data
Goal: Understand what you're dealing with before changing anything.
Action: Loaded raw dataset: 7043 rows, 21 columns. Columns include CustomerID, Gender, Tenure, MonthlyCharges, TotalCharges, Churn.

## Step 2: Check for duplicates
Goal: Ensure each custoer appears once.
Action: Checked duplicates on customerID: 0 duplicates found.

## Step 3: Fix data types
Action: Converted Tenure, MonthylyCharges and TotalCharges to numeric types.

## Step 4: Handle missing or invalid values
Goal: Decide what to do with blanks and inconsistent values.
Action: Found 11 rows with blank TotalCharges where Tenure = 0 (new customers). Inputed TotalCharges as 0 for these rows.

## Step 5: Standardise categorical values 
Goal: Make categroies consistent and clean
Action: Trimmed spaces and recoded 'No internet service' to 'No' to simplify analysis and create binary service indicators. Customers without internet cannot use these services; grouping them under 'No' improves interpretability.
Columns affected: OnlineSecurity, OnlineBackup, DeviceProtection, TechSupport, StreamingTV, StreamingMovies.

## Step 6: Create useful derived columns 
Action: Created 2 new columns based on business logic. 
1st column: TenureGroup based on Tenure: 0-12 = 'New', 13-24 = '1-2 years', 25-48 = '2-4 years', 49+ = '4+years'.
2nd column: ChargeBucket based on MonthlyCharges: <40 = 'Low', 40-80 = 'Medium', >80 = 'High'.

## Step 7: Final sanity checks
Final dataset shows 7043 rows, 23 columns. Spot checked 10 random rows - data types and derived fields correct.
