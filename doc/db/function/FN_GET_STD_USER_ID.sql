-- FN_GET_STD_USER_ID
CREATE FUNCTION FN_GET_STD_USER_ID (
		inStdNo varchar(30)
	) RETURNS varchar(30)
	READS SQL DATA
	COMMENT '수강생 사용자 ID 조회'
BEGIN
	DECLARE userId varchar(30);

	SELECT A.USER_ID INTO userId
	FROM tb_home_user_login A, tb_lms_std B
	WHERE A.USER_ID = b.USER_ID 
		AND B.STD_NO = inStdNo;

	RETURN userId;
END