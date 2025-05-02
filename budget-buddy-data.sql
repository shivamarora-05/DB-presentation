
-- 1) Ensure Sample User exists
MERGE INTO users u
USING (SELECT 'shiv' AS username, 'shiv@example.com' AS email, 'securePass123' AS password FROM dual) src
  ON (u.username = src.username)
WHEN NOT MATCHED THEN
  INSERT (username, email, password)
  VALUES (src.username, src.email, src.password);

-- 2)  Categories for user_id=1 (re-create all)
DELETE FROM category WHERE user_id = 1;
INSERT INTO category (user_id, category_name, monthly_budget) VALUES (1, 'Food',          200.00);
INSERT INTO category (user_id, category_name, monthly_budget) VALUES (1, 'Rent',          800.00);
INSERT INTO category (user_id, category_name, monthly_budget) VALUES (1, 'Entertainment', 100.00);
INSERT INTO category (user_id, category_name, monthly_budget) VALUES (1, 'Transport',     150.00);
INSERT INTO category (user_id, category_name, monthly_budget) VALUES (1, 'Books',         120.00);
INSERT INTO category (user_id, category_name, monthly_budget) VALUES (1, 'Utilities',     180.00);

-- 3)  Budget for April 2025 
DELETE FROM budget WHERE user_id = 1 AND budget_name = 'April 2025 Budget';
INSERT INTO budget (user_id, budget_name, start_date, end_date, total_budget, current_spent)
VALUES (
  1,
  'April 2025 Budget',
  TO_DATE('01-APR-2025','DD-MON-YYYY'),
  TO_DATE('30-APR-2025','DD-MON-YYYY'),
  1600.00,
  0
);

-- 4) Static Expenses for April 2025 (20 entries)
DELETE FROM expense WHERE user_id = 1 AND expense_date BETWEEN TO_DATE('01-APR-2025','DD-MON-YYYY') AND TO_DATE('30-APR-2025','DD-MON-YYYY');
-- Rent
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (
  1,
  (SELECT category_id FROM category WHERE user_id=1 AND category_name='Rent'),
  TO_DATE('01-APR-2025','DD-MON-YYYY'), 800.00, 'April Rent'
);
-- Food (4 entries)
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Food'), TO_DATE('03-APR-2025','DD-MON-YYYY'), 15.00, 'Lunch');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Food'), TO_DATE('05-APR-2025','DD-MON-YYYY'), 20.00, 'Groceries');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Food'), TO_DATE('07-APR-2025','DD-MON-YYYY'), 10.00, 'Coffee');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Food'), TO_DATE('09-APR-2025','DD-MON-YYYY'), 25.00, 'Dinner');
-- Entertainment (3 entries)
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Entertainment'), TO_DATE('10-APR-2025','DD-MON-YYYY'), 30.00, 'Movie');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Entertainment'), TO_DATE('12-APR-2025','DD-MON-YYYY'), 20.00, 'Concert');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Entertainment'), TO_DATE('14-APR-2025','DD-MON-YYYY'), 15.00, 'Subscription');
-- Transport (3 entries)
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Transport'), TO_DATE('15-APR-2025','DD-MON-YYYY'), 5.00, 'Bus Fare');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Transport'), TO_DATE('17-APR-2025','DD-MON-YYYY'), 12.00, 'Taxi');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Transport'), TO_DATE('19-APR-2025','DD-MON-YYYY'), 7.00, 'Train Ticket');
-- Books (3 entries)
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Books'), TO_DATE('20-APR-2025','DD-MON-YYYY'), 30.00, 'Textbook');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Books'), TO_DATE('21-APR-2025','DD-MON-YYYY'), 15.00, 'Notebook');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Books'), TO_DATE('22-APR-2025','DD-MON-YYYY'), 20.00, 'Stationery');
-- Utilities (4 entries)
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Utilities'), TO_DATE('23-APR-2025','DD-MON-YYYY'), 30.00, 'Electricity');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Utilities'), TO_DATE('24-APR-2025','DD-MON-YYYY'), 25.00, 'Water');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Utilities'), TO_DATE('25-APR-2025','DD-MON-YYYY'), 20.00, 'Internet');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Utilities'), TO_DATE('26-APR-2025','DD-MON-YYYY'), 15.00, 'Gas');
-- Combo entries (2 entries)
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Food'), TO_DATE('27-APR-2025','DD-MON-YYYY'), 70.00, 'Combo Meal');
INSERT INTO expense (user_id, category_id, expense_date, amount, description) VALUES (1, (SELECT category_id FROM category WHERE user_id=1 AND category_name='Entertainment'), TO_DATE('28-APR-2025','DD-MON-YYYY'), 70.00, 'Combo Tickets');

-- 5) Static Income entries
DELETE FROM income WHERE user_id=1;
INSERT INTO income (user_id, income_date, amount, source) VALUES (1, TO_DATE('01-APR-2025','DD-MON-YYYY'), 1500.00, 'Part-time Job');
INSERT INTO income (user_id, income_date, amount, source) VALUES (1, TO_DATE('15-APR-2025','DD-MON-YYYY'), 500.00,  'Scholarship');

COMMIT;
