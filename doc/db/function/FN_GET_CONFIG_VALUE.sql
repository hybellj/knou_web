-- FN_GET_CONFIG_VALUE
CREATE FUNCTION FN_GET_CONFIG_VALUE (
		inCfgCtgrCd varchar(10), 
		inCfgCd varchar(10)
	) RETURNS varchar(100)
	READS SQL DATA
	COMMENT '환경설정값 조회'
BEGIN
	DECLARE cfgVal varchar(100);
	SET cfgVal := '';

	SELECT CFG_VAL INTO cfgVal
	FROM tb_sys_cfg
	WHERE CFG_CTGR_CD = inCfgCtgrCd
		AND CFG_CD = inCfgCd;

	RETURN cfgVal;
END