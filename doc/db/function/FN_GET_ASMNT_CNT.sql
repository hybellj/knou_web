-- FN_GET_ASMNT_CNT
CREATE FUNCTION FN_GET_ASMNT_CNT (
		inCrsCreCd varchar(30), 
		inStdNo varchar(30)
	) RETURNS int
	READS SQL DATA
	COMMENT '수강생 과제수 조회'
BEGIN
	DECLARE asmntCnt int;

	SELECT IFNULL(SUM(R.CNT),0) INTO asmntCnt
	FROM ( 
		SELECT  
			CASE WHEN A.ASMNT_CTGR_CD = 'TEAM' THEN (
				SELECT COUNT(*) FROM tb_lms_asmnt_join_user B 
				WHERE B.ASMNT_CD = A.ASMNT_CD 
					AND B.TEAM_CD = FN_GET_STD_TEAM(inStdNo, A.CRS_CRE_CD) 
					AND B.STD_NO = inStdNo
					AND B.ASMNT_SUBMIT_STATUS_CD IN ('Submit', 'Late', 'ReSubmit')
			)
			ELSE (
				SELECT COUNT(*) FROM tb_lms_asmnt_join_user B 
				WHERE B.ASMNT_CD = A.ASMNT_CD 
					AND B.STD_NO = inStdNo 
					AND B.ASMNT_SUBMIT_STATUS_CD IN ('Submit', 'Late', 'ReSubmit')
			) 
			END AS CNT
		FROM tb_lms_asmnt A
		WHERE A.CRS_CRE_CD = inCrsCreCd
			AND A.DEL_YN = 'N'
	) R;

	RETURN asmntCnt;
END