-- FN_GET_STD_EMAIL
CREATE FUNCTION FN_GET_STD_EMAIL (
		inStdNo varchar(30)
	) RETURNS varchar(100)
	READS SQL DATA
	COMMENT '수강생 이메일 조회'
BEGIN
	DECLARE email varchar(100);

	SELECT A.EMAIL INTO email
	FROM tb_home_user_info A, tb_lms_std B
	WHERE A.USER_ID = B.USER_ID
		AND B.STD_NO = inStdNo;

   RETURN email;
END