

-- 0) Drop existing objects if they exist
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE income CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE expense CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE budget CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE category CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE users CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE income_seq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE expense_seq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE budget_seq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE category_seq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE users_seq';
EXCEPTION WHEN OTHERS THEN NULL;
END;
/

-- 1) USERS
CREATE SEQUENCE users_seq START WITH 1 INCREMENT BY 1 NOCACHE;
/
CREATE TABLE users (
  user_id     NUMBER          PRIMARY KEY,
  username    VARCHAR2(50)    NOT NULL,
  email       VARCHAR2(100)   NOT NULL,
  password    VARCHAR2(255)   NOT NULL,
  created_at  DATE            DEFAULT SYSDATE NOT NULL,
  CONSTRAINT users_uk_username UNIQUE(username),
  CONSTRAINT users_uk_email    UNIQUE(email)
);
/
CREATE OR REPLACE TRIGGER trg_users_bir
  BEFORE INSERT ON users
  FOR EACH ROW
BEGIN
  :NEW.user_id := users_seq.NEXTVAL;
END;
/

-- 2) CATEGORY
CREATE SEQUENCE category_seq START WITH 1 INCREMENT BY 1 NOCACHE;
/
CREATE TABLE category (
  category_id    NUMBER          PRIMARY KEY,
  user_id        NUMBER          NOT NULL,
  category_name  VARCHAR2(50)    NOT NULL,
  monthly_budget NUMBER(10,2),
  CONSTRAINT category_fk_user FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
  CONSTRAINT category_uk_user_cat UNIQUE(user_id, category_name)
);
/
CREATE OR REPLACE TRIGGER trg_category_bir
  BEFORE INSERT ON category
  FOR EACH ROW
BEGIN
  :NEW.category_id := category_seq.NEXTVAL;
END;
/

-- 3) BUDGET
CREATE SEQUENCE budget_seq START WITH 1 INCREMENT BY 1 NOCACHE;
/
CREATE TABLE budget (
  budget_id     NUMBER          PRIMARY KEY,
  user_id       NUMBER          NOT NULL,
  budget_name   VARCHAR2(50)    NOT NULL,
  start_date    DATE            NOT NULL,
  end_date      DATE,
  total_budget  NUMBER(10,2)    NOT NULL,
  current_spent NUMBER(10,2)    DEFAULT 0 NOT NULL,
  CONSTRAINT budget_fk_user FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
  CONSTRAINT budget_ck_total CHECK (total_budget >= 0),
  CONSTRAINT budget_ck_spent CHECK (current_spent >= 0)
);
/
CREATE OR REPLACE TRIGGER trg_budget_bir
  BEFORE INSERT ON budget
  FOR EACH ROW
BEGIN
  :NEW.budget_id := budget_seq.NEXTVAL;
END;
/

-- 4) EXPENSE
CREATE SEQUENCE expense_seq START WITH 1 INCREMENT BY 1 NOCACHE;
/
CREATE TABLE expense (
  expense_id    NUMBER          PRIMARY KEY,
  user_id       NUMBER          NOT NULL,
  category_id   NUMBER          NOT NULL,
  expense_date  DATE            NOT NULL,
  amount        NUMBER(10,2)    NOT NULL,
  description   VARCHAR2(255),
  CONSTRAINT expense_fk_user FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
  CONSTRAINT expense_fk_cat FOREIGN KEY(category_id)
    REFERENCES category(category_id),
  CONSTRAINT expense_ck_amount CHECK (amount > 0)
);
/
CREATE OR REPLACE TRIGGER trg_expense_bir
  BEFORE INSERT ON expense
  FOR EACH ROW
BEGIN
  :NEW.expense_id := expense_seq.NEXTVAL;
END;
/

-- 5) INCOME
CREATE SEQUENCE income_seq START WITH 1 INCREMENT BY 1 NOCACHE;
/
CREATE TABLE income (
  income_id     NUMBER          PRIMARY KEY,
  user_id       NUMBER          NOT NULL,
  income_date   DATE            NOT NULL,
  amount        NUMBER(10,2)    NOT NULL,
  source        VARCHAR2(100),
  CONSTRAINT income_fk_user FOREIGN KEY(user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,
  CONSTRAINT income_ck_amount CHECK (amount > 0)
);
/
CREATE OR REPLACE TRIGGER trg_income_bir
  BEFORE INSERT ON income
  FOR EACH ROW
BEGIN
  :NEW.income_id := income_seq.NEXTVAL;
END;
/
