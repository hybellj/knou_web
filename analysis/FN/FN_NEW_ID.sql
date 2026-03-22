CREATE OR REPLACE FUNCTION LMSUSER.FN_NEW_ID(inName IN VARCHAR2) RETURN VARCHAR2 IS
    digits      CONSTANT VARCHAR2(36) := 'abcdefghijklmnopqrstuvwxyz0123456789';
    id_buf      VARCHAR2(30) := '';
    time_str    VARCHAR2(10);
    i           NUMBER := 1;
    char_index  NUMBER;
    random_char VARCHAR2(1);
	name        VARCHAR2(10);
BEGIN
	/** 
	 * »õ ID »ý¼º
	 */
    IF inName IS NULL OR LENGTH(inName) = 0 THEN
        name := 'ID';
    ELSE
        name := UPPER(SUBSTR(inName, 1, 5));
    END IF;

    time_str := TO_CHAR(SYSTIMESTAMP, 'MI') || TO_CHAR(SYSTIMESTAMP, 'SS') || TO_CHAR(SYSTIMESTAMP, 'FF3');

    id_buf := name || '_' ||
              SUBSTR(digits, MOD(TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'YYYY')), 25) + 1, 1) ||
              SUBSTR(digits, TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'MM')) + 1, 1) ||
              SUBSTR(digits, TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'DD')) + 1, 1) ||
              SUBSTR(digits, TO_NUMBER(TO_CHAR(SYSTIMESTAMP, 'HH24')) + 1, 1);

    FOR i IN 1 .. LENGTH(time_str) LOOP
        char_index := TO_NUMBER(SUBSTR(time_str, i, 1)) + 1;
        id_buf := id_buf || SUBSTR(digits, char_index, 1);
    END LOOP;
	    

	FOR i IN 1 .. 8 LOOP
	    random_char := SUBSTR(digits, TRUNC(DBMS_RANDOM.VALUE(1, 36)), 1);
	    id_buf := id_buf || random_char;
	END LOOP;

    RETURN id_buf;
END;
