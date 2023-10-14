-- 01 - User-defined function full name
CREATE FUNCTION fn_full_name(
	first_name VARCHAR(50),
	last_name VARCHAR(50)
) RETURNS VARCHAR(101)
AS
$$
DECLARE
full_name VARCHAR(101);
BEGIN
	full_name := INITCAP(first_name) || ' ' || INITCAP(last_name);
	RETURN full_name;
END;
$$
LANGUAGE plpgsql;


-- 02 - User-defined function future value
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	initial_sum INT,
	yearly_interest_rate FLOAT,
	number_of_years INT
) RETURNS DECIMAL
AS
$$
DECLARE
future_value DECIMAL;
BEGIN
	future_value = initial_sum;
	for _ in 1..number_of_years loop
		future_value := future_value + (future_value * yearly_interest_rate);
	end loop;
	RETURN TRUNC(future_value,4);
END;
$$
LANGUAGE plpgsql;

-- simpler way
CREATE OR REPLACE FUNCTION fn_calculate_future_value(
	initial_sum DECIMAL,
	yearly_interest_rate DECIMAL,
	number_of_years INT
) RETURNS DECIMAL
AS
$$
BEGIN
	RETURN TRUNC(initial_sum * POWER(1 + yearly_interest_rate, number_of_years), 4);
END;
$$
LANGUAGE plpgsql;


-- 03 - User-defined func 'is word comprised'
CREATE OR REPLACE FUNCTION fn_is_word_comprised(
	set_of_letters VARCHAR(50),
	word VARCHAR(50)
) RETURNS BOOLEAN
AS
$$
BEGIN
	RETURN TRIM(LOWER(word), LOWER(set_of_letters)) = '';
END;
$$
LANGUAGE plpgsql;


-- 04 - Game over
CREATE OR REPLACE FUNCTION fn_is_game_over(
	is_game_over BOOL
) RETURNS TABLE(
	name VARCHAR(50),
	game_type_id INT,
	is_finished BOOL
)
AS
$$
BEGIN
	RETURN QUERY
	SELECT
		g.name,
		g.game_type_id,
		g.is_finished
	FROM
		games as g
	WHERE
		g.is_finished = is_game_over;
END;
$$
LANGUAGE plpgsql;


-- 05 - Difficulty level
CREATE OR REPLACE FUNCTION fn_difficulty_level(
	level INT
) RETURNS VARCHAR(20)
AS
$$
DECLARE
	difficulty_level VARCHAR(20);
BEGIN
	IF (level <= 40) THEN
		difficulty_level := 'Normal Difficulty';
	ELSIF (level BETWEEN 41 AND 60) THEN
		difficulty_level := 'Nightmare Difficulty';
	ELSE
		difficulty_level := 'Hell Difficulty';
	END IF;

	RETURN difficulty_level;
END;
$$
LANGUAGE plpgsql;


-- 06 - Cash in user games odd rows*
CREATE OR REPLACE FUNCTION fn_cash_in_users_games(
	game_name VARCHAR(50)
) RETURNS TABLE(
	total_cash NUMERIC
)
AS
$$
BEGIN
	RETURN QUERY
	WITH ranked_games AS (
		SELECT
			cash,
			ROW_NUMBER () OVER(ORDER BY cash DESC) as rn
		FROM
			users_games
		JOIN
			games
		ON
			games.id = users_games.game_id
		WHERE
			game_name = games.name
	)
	
	SELECT
		ROUND(SUM(cash), 2) AS total_cash
	FROM
		ranked_games
	WHERE
		rn % 2 <> 0;
END;
$$
LANGUAGE plpgsql;


-- 07 - Retrieving Account Holders**
CREATE OR REPLACE PROCEDURE 
	sp_retrieving_holders_with_balance_higher_than(
		searched_balance NUMERIC
	)
AS
$$
	DECLARE
		holder_info RECORD;
	BEGIN
		FOR holder_info IN
			SELECT
				CONCAT(first_name, ' ', last_name) AS "full_name",
				SUM(balance) AS "total_balance"
			FROM
				account_holders AS ah
			JOIN
				accounts AS a
			ON
				ah.id = a.account_holder_id
			GROUP BY
				full_name
			HAVING
				SUM(balance) > searched_balance
			ORDER BY
				full_name
		LOOP
			RAISE NOTICE '% - %', holder_info.full_name, holder_info.total_balance;
		END LOOP;
	END;
$$
LANGUAGE plpgsql;


-- 08 - Deposit money
CREATE OR REPLACE PROCEDURE sp_deposit_money(
	account_id INT,
	money_amount NUMERIC(10,4)
) AS
$$
	BEGIN
	UPDATE 
		accounts
	SET
		balance = balance + money_amount
	WHERE
		account_id = id;
	END;
$$
LANGUAGE plpgsql;


-- 09 - Withdraw Money
CREATE OR REPLACE PROCEDURE sp_withdraw_money(
	account_id INT,
	money_amount NUMERIC(10,4)
) AS
$$
	DECLARE
		money_balance NUMERIC;
	BEGIN
		money_balance=(
			SELECT balance FROM accounts WHERE id = account_id
		);
		
		IF (money_balance - money_amount >= 0) THEN
			UPDATE 
				accounts
			SET
				balance = balance - money_amount
			WHERE
				id = account_id;
		ELSE
			RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
		END IF;
	END;
$$
LANGUAGE plpgsql;


-- 10 - Money Transfer
CREATE OR REPLACE PROCEDURE sp_transfer_money(
	sender_id INT,
	receiver_id INT,
	amount NUMERIC(10,4)
) AS
$$
	DECLARE
		current_balance NUMERIC(10,4);
	BEGIN
		CALL sp_withdraw_money(sender_id, amount);
		
		CALL sp_deposit_money(receiver_id, amount);
		
		SELECT balance INTO current_balance FROM accounts WHERE id = sender_id;
		
		-- The purpose of this task is to use rollback
		IF (current_balance < 0) THEN
			ROLLBACK;
		END IF;
	END;
$$
LANGUAGE plpgsql;


-- 11 Delete Procedure
DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;


-- 12 Log Accounts Trigger
CREATE TABLE logs(
	id SERIAL PRIMARY KEY,
	account_id INT,
	old_sum NUMERIC(10,4),
	new_sum NUMERIC(10,4)
);


CREATE OR REPLACE FUNCTION 
	trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS
$$
	BEGIN
		INSERT INTO 
			logs (account_id, old_sum, new_sum)
		VALUES
			(OLD.id, OLD.balance, NEW.balance);
		
		RETURN NEW;
	END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER 
	tr_account_balance_change
AFTER UPDATE OF 
	balance ON accounts
FOR EACH ROW 
	WHEN 
		(NEW.balance <> OLD.balance)
EXECUTE FUNCTION
	trigger_fn_insert_new_entry_into_logs();



-- 13 - Notification Email on Balance Change
CREATE TABLE notification_emails(
	id SERIAL PRIMARY KEY,
	recipient_id INT,
	subject VARCHAR(255),
	body TEXT
);


CREATE OR REPLACE FUNCTION 
	trigger_fn_send_email_on_balance_change(
) RETURNS TRIGGER
AS
$$
	BEGIN
		INSERT INTO 
			notification_emails(recipient_id, subject, body)
		VALUES
			(
				NEW.account_id,
				'Balance change for account: %', NEW.account_id,
				'On % your balance was changed from % to %.', DATE(), NEW.old_sum, NEW.new_sum
			);
	END;
$$
LANGUAGE plpgsql;


CREATE TRIGGER 
	tr_send_email_on_balance_change
AFTER UPDATE ON 
	logs
FOR EACH ROW 
	WHEN 
		(OLD.new_sum <> NEW.new_sum)
EXECUTE FUNCTION
	trigger_fn_send_email_on_balance_change();
	