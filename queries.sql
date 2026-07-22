-- showing all the withdrawl transactions using view
SELECT *
FROM "withdraw_transactions";

SELECT "category_type"
FROM "categories"
WHERE "category_type" = "expense";

-- adding new users information
INSERT INTO "users" ("first_name","last_name","email","date_of_birth","password")
VALUES ("Niayesh","Talaie","ntalaie@gmail.com","08-05-2000","Niayesh1234");


-- creating a new category
INSERT INTO "categories" (
    "user_id",
    "name",
    "category_type"
)
VALUES
    (1, 'Salary', 'income'),
    (1, 'Groceries', 'expense');

-- creating 2 accounts
INSERT INTO "accounts" (
    "user_id",
    "account_type",
    "institution",
    "starting_balance"
)
VALUES
(1, 'checking', 'Bank of America', 500),
(1, 'savings', 'Wells Fargo', 1000);

-- adding new transaction information - deposit and withdrawl

INSERT INTO "transactions" (
    "account_id",
    "category_id",
    "amount",
    "transaction_type",
    "transaction_date"
)
VALUES (1,1,1200, 'deposit', '2025-07-16');

INSERT INTO "transactions" (
		"account_id",
        "category_id",
        "amount",
        "transaction_type",
        "transaction_date" )

VALUES (1,2,350,'withdrawal','2025-07-20');



