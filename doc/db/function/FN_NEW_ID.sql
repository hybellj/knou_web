--- FN_NEW_ID
CREATE FUNCTION FN_NEW_ID (name varchar(10))
	RETURNS varchar(30)
	READS SQL DATA
	COMMENT '새 ID 생성'
BEGIN
	DECLARE digits CHAR(36) DEFAULT 'abcdefghijklmnopqrstuvwxyz0123456789';
	DECLARE id_buf VARCHAR(30) DEFAULT '';
	DECLARE time_str VARCHAR(10);
	DECLARE i INT DEFAULT 1;
	DECLARE char_index INT;
	
	IF CHAR_LENGTH(name) = 0 THEN
		SET name = 'ID';
	ELSE
		SET name = UCASE(LEFT(name, 5));
	END IF;
	
	SET time_str = CONCAT(LPAD(MINUTE(NOW()), 2, '0'), LPAD(SECOND(NOW()), 2, '0'), LPAD(RIGHT(NOW(3), 3), 3, '0'));

	SET id_buf = CONCAT(name, '_', 
		SUBSTRING(digits, MOD(YEAR(NOW()), 25) + 1, 1),
		SUBSTRING(digits, MONTH(NOW()) + 1, 1),
		SUBSTRING(digits, DAY(NOW()) + 1, 1),
		SUBSTRING(digits, HOUR(NOW()) + 1, 1));

	WHILE i <= CHAR_LENGTH(time_str) DO
		SET char_index = CAST(SUBSTRING(time_str, i, 1) AS UNSIGNED) + 1;
		SET id_buf = CONCAT(id_buf, SUBSTRING(digits, char_index, 1));
		SET i = i + 1;
	END WHILE;

	SET i = 1;

	WHILE i <= 8 DO
		SET id_buf = CONCAT(id_buf, MID(digits, FLOOR(1 + (RAND() * 36)), 1));
		SET i = i + 1;
	END WHILE;

	RETURN id_buf;
END