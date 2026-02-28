-- FN_GET_STD_MOBILE_NO
CREATE FUNCTION FN_GET_STD_MOBILE_NO (
		inStdNo varchar(30)
	) RETURNS varchar(30)
	READS SQL DATA
	COMMENT '수강생 휴대폰번호 조회'
BEGIN
	DECLARE mobileNo varchar(30);

	SELECT A.MOBILE_NO INTO mobileNo
	FROM tb_home_user_info A, tb_lms_std B
	WHERE A.USER_ID = B.USER_ID
		AND B.STD_NO = inStdNo;

   RETURN mobileNo;
END