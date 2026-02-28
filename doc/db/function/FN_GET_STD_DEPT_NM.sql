-- FN_GET_STD_DEPT_NM
CREATE FUNCTION FN_GET_STD_DEPT_NM (
		inStdNo varchar(40)
	) RETURNS varchar(200)
	READS SQL DATA
	COMMENT '수강생 소속명 조회'
BEGIN
	DECLARE deptNm varchar(200);

	SELECT DEPT.DEPT_NM INTO deptNm
	FROM tb_home_user_dept_cd DEPT, tb_home_user_info USR, tb_lms_std STD 
	WHERE 1=1
		AND DEPT.ORG_ID = USR.ORG_ID
		AND DEPT.DEPT_CD = USR.DEPT_CD
		AND USR.USER_ID = STD.USER_ID
		AND STD.STD_NO = inStdNo;

	RETURN deptNm;
END