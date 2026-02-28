-- FN_ENC
CREATE FUNCTION FN_ENC (
		inEncKey varchar(256), 
		inEncText varchar(2000)
	) RETURNS varchar(2000)
	DETERMINISTIC
	COMMENT '데이터 암호화'
BEGIN
	RETURN HEX(AES_ENCRYPT(inEncText, SHA2(inEncKey,256)));
END