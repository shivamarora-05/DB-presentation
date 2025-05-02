

/* 1 - List All Expenses for User 1 */
SELECT 
  expense_id,
  TO_CHAR(expense_date, 'DD-MON-YYYY') AS expense_date,
  amount,
  description
FROM expense
WHERE user_id = 1
ORDER BY expense_date;

/* 2 - Show All Categories & Their Budgets for User 1 */
SELECT
  category_id,
  category_name,
  monthly_budget
FROM category
WHERE user_id = 1
ORDER BY category_name;

/* 3 - Find the Single Highest Expense (Top Spender) */
SELECT expense_id, expense_date, amount, description
FROM (
  SELECT expense_id, expense_date, amount, description,
         ROW_NUMBER() OVER (ORDER BY amount DESC) AS rn
  FROM expense
  WHERE user_id = 1
) sub
WHERE rn = 1;

/* 4 - Month-to-Date Total for Current Month */
SELECT
  SUM(amount) AS month_to_date_spent
FROM expense
WHERE user_id = 1
  AND expense_date 
      BETWEEN ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1)
          AND (TRUNC(SYSDATE,'MM') - 1); /* slighty modified to display last month (april) as now its May */
          


/* 5 - Average Expense by Category for April 2025 */
SELECT 
  c.category_name,
  ROUND(AVG(e.amount),2) AS avg_spent
FROM expense e
JOIN category c ON e.category_id = c.category_id
WHERE e.user_id = 1
  AND TO_CHAR(e.expense_date, 'MM-YYYY') = '04-2025'
GROUP BY c.category_name;

/* 6 - Budget vs Actual Spend per Budget Period */
SELECT
  b.budget_name,
  b.total_budget,
  NVL(SUM(e.amount),0) AS actual_spent,
  (b.total_budget - NVL(SUM(e.amount),0)) AS variance
FROM budget b
LEFT JOIN expense e
  ON b.user_id = e.user_id
 AND e.expense_date BETWEEN b.start_date AND NVL(b.end_date, b.start_date)
WHERE b.user_id = 1
GROUP BY b.budget_name, b.total_budget;
