-- FN_GET_STD_TEAM
CREATE FUNCTION FN_GET_STD_TEAM (
		inStdNo varchar(30), 
		inCrsCreCd varchar(30)
	) RETURNS varchar(30)
	READS SQL DATA
	COMMENT '수강생 팀 조회'
BEGIN
	DECLARE teamCd varchar(30);
	
	SELECT A.TEAM_CD INTO teamCd
	FROM tb_lms_team A, tb_lms_team_ctgr B, tb_lms_team_member C
	WHERE 1=1
		AND A.TEAM_CD = C.TEAM_CD 
		AND A.TEAM_CTGR_CD = B.TEAM_CTGR_CD
		AND B.CRS_CRE_CD = inCrsCreCd
		AND C.STD_NO = inStdNo;

	RETURN teamCd;
END