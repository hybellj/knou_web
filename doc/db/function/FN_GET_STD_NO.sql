-- FN_GET_STD_NO
CREATE FUNCTION FN_GET_STD_NO (
		inUserId varchar(30), 
		inCrsCreCd varchar(30)
	) RETURNS varchar(40)
	READS SQL DATA
	COMMENT '수강생 번호 조회'
BEGIN
	DECLARE stdNo VARCHAR(40);

	SELECT STD_NO INTO stdNo
	FROM tb_lms_std
	WHERE USER_ID = inUserId   
		AND ENRL_STS = 'S'
		AND CRS_CRE_CD = inCrsCreCd;

   RETURN stdNo;
END