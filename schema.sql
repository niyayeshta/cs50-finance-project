-- users info table
CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "date_of_birth" TEXT NOT NULL,
    "email" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "accounts" (
    "id" INTEGER,
    "user_id" INTEGER NOT NULL,
    "account_type"  TEXT
       NOT NULL CHECK ("account_type" IN ('checking', 'savings', 'credit', 'investment')),
	"institution" TEXT,
    "starting_balance" NUMERIC NOT NULL DEFAULT 0,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id")
);

CREATE TABLE "categories" (
    "id" INTEGER,
    "user_id" INTEGER,
    "name" TEXT,
    "category_type" TEXT
        CHECK ("category_type" IN ('income', 'expense')),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    UNIQUE ("user_id", "name")
);

CREATE TABLE "transactions" (
    "id" INTEGER,
    "account_id" INTEGER NOT NULL,
    "amount" NUMERIC NOT NULL
        CHECK ("amount" > 0),
    "transaction_type" TEXT NOT NULL
        CHECK ("transaction_type" IN ('deposit', 'withdrawal', 'transfer_in','transfer_out')),
    "transaction_date" TEXT NOT NULL,
	"category_id" integer,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("account_id") REFERENCES "accounts"("id"),
	FOREIGN KEY ("category_id") REFERENCES "categories"("id")
);

CREATE TABLE "budgets" (
	"id" integer,
	"category_id" integer,
	"amount" numeric,
	"month" integer,
	"year" integer,
	PRIMARY KEY ("id"),
	FOREIGN KEY("category_id") REFERENCES "categories"("id")
);


CREATE TABLE "transfers" (
    "id" INTEGER,
    "from_account_id" INTEGER NOT NULL,
    "to_account_id" INTEGER NOT NULL,
    "amount" NUMERIC NOT NULL
        CHECK ("amount" > 0),
    "transfer_date" TEXT NOT NULL, --the date should be stored as YYYY-MM-DD
    PRIMARY KEY ("id"),
    FOREIGN KEY ("from_account_id") REFERENCES "accounts"("id"),
    FOREIGN KEY ("to_account_id") REFERENCES "accounts"("id"),
	CHECK ("from_account_id" != "to_account_id")
);

CREATE VIEW deposit_transactions AS
SELECT
	t."id",
	t."transaction_date",
	c."name" AS Category,
	t."amount"
FROM
"transactions" as t
JOIN "categories" as c ON c."id" = t."category_id"
WHERE t.transaction_type = 'deposit';


CREATE VIEW withdraw_transactions AS
SELECT
	t."id",
	t."transaction_date",
	c."name" AS Category,
	t."amount"
FROM
"transactions" as t
JOIN "categories" as c ON c."id" = t."category_id"
WHERE t.transaction_type = 'withdrawal';

CREATE VIEW "account_balances" AS
SELECT
    a."user_id",
    a."account_type",
    a."institution",
    a."starting_balance"
    + COALESCE(
        SUM(
            CASE
                WHEN t."transaction_type" = 'deposit'
                    THEN t."amount"

                WHEN t."transaction_type" = 'withdrawal'
                    THEN -t."amount"

                WHEN t."transaction_type" = 'transfer_in'
                    THEN t."amount"

                WHEN t."transaction_type" = 'transfer_out'
                    THEN -t."amount"

                ELSE 0
            END
        ),
        0
    ) AS "current_balance"
FROM "accounts" AS a
LEFT JOIN "transactions" AS t
    ON a."id" = t."account_id"
GROUP BY
    a."id",
    a."user_id",
    a."institution",
    a."account_type",
    a."starting_balance";


CREATE INDEX "transactions_by_account"
ON "transactions" ("account_id");

CREATE INDEX "transaction_date"
ON "transactions"("transaction_date");

CREATE INDEX "transfers_by_source_account"
ON "transfers" ("from_account_id");

CREATE INDEX "transfers_by_destination_account"
ON "transfers" ("to_account_id");
