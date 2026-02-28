-- FN_GET_USER_NM
CREATE FUNCTION FN_GET_USER_NM (
		inUserId VARCHAR(30)
	) RETURNS varchar(200)
	READS SQL DATA
	COMMENT '사용자명 조회'
BEGIN
	DECLARE userNm varchar(200) DEFAULT '';
	
	IF inUserId = '000000000000' THEN
		SET userNm := '관리자';
	ELSE
		SELECT USER_NM INTO userNm
		FROM tb_home_user_info
		WHERE USER_ID = inUserId;
		
		IF userNm IS null THEN 
			SET userNm := 'UnKnown';
		END IF;
	END IF;
	
	RETURN userNm;
END