SELECT TOP (1000) [id]
      ,[address_state]
      ,[application_type]
      ,[emp_length]
      ,[emp_title]
      ,[grade]
      ,[home_ownership]
      ,[issue_date]
      ,[last_credit_pull_date]
      ,[last_payment_date]
      ,[loan_status]
      ,[next_payment_date]
      ,[member_id]
      ,[purpose]
      ,[sub_grade]
      ,[term]
      ,[verification_status]
      ,[annual_income]
      ,[dti]
      ,[installment]
      ,[int_rate]
      ,[loan_amount]
      ,[total_acc]
      ,[total_payment]
  FROM [Bank-Loan].[dbo].[Bank_Loan]

 --   USE [Bank-Loan]
  SELECT * FROM [Bank_Loan]

--Total Loan Application Received
--MTD measured by Isuue Date 
SELECT COUNT(id) AS MTD FROM Bank_Loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)= 2021

--Total Loan Application Received - Month On Month(MOM) measured by Isuue Date 
--Year Specified for the data with multiple Years. It gives clarity to Deveopers
SELECT COUNT(id) AS MoM_Total_Loan_Application FROM Bank_Loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)= 2021

--Total Loan Amount disbursed
SELECT SUM(loan_amount) AS Total_Loan_Disbursed FROM Bank_Loan

--Total Loan Amount disbursed - MTD
SELECT SUM(loan_amount) AS MTD_Loan_Amount 
FROM Bank_Loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date)=2021

--Total Loan Amount disbursed - MoM Month-to-Month
SELECT SUM(loan_amount) AS PMTD_Loan_Amount 
FROM Bank_Loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date)=2021

--Total Amount Received from Customers - MTD Month To Date
SELECT SUM(total_payment) AS MTD_Total_Amount_Received
FROM Bank_Loan
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

--Total Amount Received from Customers - MoM 
SELECT SUM(total_payment) AS PMTD_Total_Amount_Received
FROM Bank_Loan
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

--Average Interest Rate %
SELECT ROUND(AVG(int_rate), 4) * 100  AS Avg_Interest_Rate 
FROM Bank_Loan

--Average Interest Rate % - Month-to-Date
SELECT ROUND(AVG(int_rate), 4) * 100  AS MTD_Avg_Interest_Rate 
FROM Bank_Loan
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021

--Average Interest Rate % - Month-Over-Month(MoM) 
SELECT ROUND(AVG(int_rate), 4) * 100  AS PMTD_Avg_Interest_Rate 
FROM Bank_Loan
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021

--AVG Debt-to-Income Ratio 
SELECT ROUND(AVG(dti), 4)  * 100 AS AVG_DTI FROM Bank_Loan

--AVG Debt-to-Income Ratio - Month-to-Date
SELECT ROUND(AVG(dti), 4)  * 100 AS MTD_AVG_DTI  
FROM Bank_Loan
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021

--AVG Debt-to-Income Ratio - Month-Over-Month
SELECT ROUND(AVG(dti), 4)  * 100 AS PMTD_AVG_DTI  
FROM Bank_Loan
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021

--Good LOan Application Percentage 
SELECT (COUNT(CASE WHEN loan_status='Fully Paid' OR loan_status='Current' THEN id END) * 100)
 / COUNT(id) AS Good_Loan_Application
FROM Bank_Loan

--Total Good LOan Application 
SELECT COUNT(id) AS Good_Loan_Application 
FROM  Bank_Loan
WHERE loan_status='Fully Paid' OR loan_status='Current'

--Good Loan Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Good_Loan 
FROM Bank_Loan
WHERE loan_status='Fully Paid' OR loan_status='Current'

--Good Loan Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Receive_GoodLoan 
FROM Bank_Loan
WHERE loan_status='Fully Paid' OR loan_status='Current'

--Bad LOan KPI's
SELECT (COUNT(CASE WHEN loan_status='Charged off' THEN id END) * 100) 
		/ COUNT(id) AS Bad_Loan_Application
FROM Bank_Loan

--Total No of Bad Loan Applications
SELECT COUNT(id) AS Total_Bad_Loan_Application 
FROM Bank_Loan
WHERE loan_status='Charged Off'

--BAD loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM Bank_Loan
WHERE loan_status='Charged Off'

--BAD loan Received Amount
SELECT SUM(total_payment) AS Bad_Loan_Received_Amount
FROM Bank_Loan
WHERE loan_status='Charged Off'

--LOan Status Grid View 
SELECT loan_status,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received,
	AVG(int_rate)*100 AS AVG_Interest_Rate,
	AVG(dti)* 100 AS Avg_DTI
FROM Bank_Loan
GROUP BY loan_status

SELECT  loan_status,
		SUM(loan_amount) AS MTD_Funded_Amount,
		SUM(total_payment) AS MTD_Amount_Received
FROM Bank_Loan
WHERE YEAR(issue_date)= 2021
GROUP BY loan_status

--Overview Dashboard2 - Monthly Trends by Issue_date
SELECT 
	MONTH(issue_date) AS Month_No,
	DATENAME(MONTH, issue_date) AS Month_name,
	COUNT(id) AS Total_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan
GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
ORDER BY MONTH(issue_date)

--Regional Analysis by State 
-- We can aggregate the same result by changing Order by. 
SELECT 
	address_state,
	COUNT(id) AS Total_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan
GROUP BY address_state
ORDER BY address_state

--LOan Term Analysis 
SELECT 
	term AS Term,
	COUNT(id) AS Total_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan
GROUP BY term
ORDER BY term

--Employee Length Analysis 
SELECT 
	emp_length AS Employee_length,
	COUNT(id) AS Total_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan
GROUP BY emp_length
ORDER BY COUNT(id) DESC

--Loan Purpose Analysis 
SELECT 
	purpose AS Loan_Purpose,
	COUNT(id) AS Total_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan
GROUP BY purpose
ORDER BY purpose

SELECT * FROM Bank_Loan

--Home Ownership Analysis 
SELECT 
	home_ownership AS Home_Ownership,
	COUNT(id) AS Total_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan
GROUP BY home_ownership
ORDER BY  Count(id) DESC