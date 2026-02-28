-- FN_GET_DEPT_NM
CREATE FUNCTION FN_GET_DEPT_NM (
		inOrgId varchar(30), 
		inDeptCd varchar(30)
	) RETURNS varchar(200)
	READS SQL DATA
	COMMENT '소속명 조회'
BEGIN
	DECLARE deptNm varchar(200);

	SELECT DEPT_NM INTO deptNm
	FROM tb_home_user_dept_cd
	WHERE DEPT_CD = inDeptCd
		AND ORG_ID = inOrgId
		AND USE_YN = 'Y';
	
	RETURN deptNm;
END