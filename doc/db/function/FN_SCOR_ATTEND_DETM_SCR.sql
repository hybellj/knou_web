-- FN_SCOR_ATTEND_DETM_SCR
CREATE FUNCTION FN_SCOR_ATTEND_DETM_SCR (
		IN_CONT_CNT INT, 
		IN_ATTD_CNT INT
	) RETURNS float(5,2)
	DETERMINISTIC
	COMMENT '출석점수 계산'
BEGIN
	DECLARE V_RESULT FLOAT(5,2) DEFAULT 0;

	IF IN_CONT_CNT = 13 THEN
		IF IN_ATTD_CNT >= 13 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT >= 11 AND IN_ATTD_CNT < 13  THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT >= 10 AND IN_ATTD_CNT < 11  THEN
            SET V_RESULT := 60;
        ELSEIF IN_ATTD_CNT <= 9 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 12 THEN
		IF IN_ATTD_CNT >= 12 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT >= 10 AND IN_ATTD_CNT < 12  THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT >= 9  AND IN_ATTD_CNT < 10  THEN
            SET V_RESULT := 60;
        ELSEIF IN_ATTD_CNT <= 8 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 11 THEN
		IF IN_ATTD_CNT >= 11 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT >= 10 AND IN_ATTD_CNT < 11  THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT >= 9  AND IN_ATTD_CNT < 10  THEN
            SET V_RESULT := 60;
        ELSEIF IN_ATTD_CNT <= 8 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 10 THEN
		IF IN_ATTD_CNT >= 10 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT >= 9  AND IN_ATTD_CNT < 10  THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT >= 8  AND IN_ATTD_CNT <  9  THEN
            SET V_RESULT := 60;
        ELSEIF IN_ATTD_CNT <= 7 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 9 THEN
		IF IN_ATTD_CNT >= 9 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT >= 8  AND IN_ATTD_CNT <  9  THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT >= 7  AND IN_ATTD_CNT <  8  THEN
            SET V_RESULT := 60;
        ELSEIF IN_ATTD_CNT <= 6 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 8 THEN
		IF IN_ATTD_CNT >= 8 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT >= 7  AND IN_ATTD_CNT <  8  THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT >= 6  AND IN_ATTD_CNT <  7  THEN
            SET V_RESULT := 60;
        ELSEIF IN_ATTD_CNT <= 5 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 7 THEN
		IF IN_ATTD_CNT >= 7 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT = 6 THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT <= 5 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 6 THEN
		IF IN_ATTD_CNT >= 6 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT  = 5 THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT <= 4 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 5 THEN
		IF IN_ATTD_CNT >= 5 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT  = 4 THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT <= 3 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 4 THEN
		IF IN_ATTD_CNT >= 4 THEN 
            SET V_RESULT := 100;
        ELSEIF IN_ATTD_CNT  = 3 THEN
            SET V_RESULT := 80;
        ELSEIF IN_ATTD_CNT <= 2 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 3 THEN
		IF IN_ATTD_CNT >= 3 THEN 
            SET V_RESULT := 100;        
        ELSEIF IN_ATTD_CNT <= 2 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 2 THEN
		IF IN_ATTD_CNT >= 2 THEN 
            SET V_RESULT := 100;        
        ELSEIF IN_ATTD_CNT <= 1 THEN
            SET V_RESULT := 0;
        END IF;
	ELSEIF IN_CONT_CNT = 1 THEN
   		 IF IN_ATTD_CNT >= 1 THEN 
            SET V_RESULT := 100;        
        ELSEIF IN_ATTD_CNT < 1 THEN
            SET V_RESULT := 0;
        END IF;
    END IF;

    RETURN V_RESULT;
END