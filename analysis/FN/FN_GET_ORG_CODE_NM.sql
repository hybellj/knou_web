CREATE OR REPLACE FUNCTION LMSUSER.FN_GET_ORG_CODE_NM(
    inOrgCd      VARCHAR2,
    inCodeCtgrCd VARCHAR2,
    inCodeCd     VARCHAR2
)
RETURN VARCHAR2
IS
    codeNm VARCHAR2(100);
BEGIN
    SELECT CODE_NM INTO codeNm
    FROM TB_ORG_CODE
    WHERE ORG_CD = inOrgCd
        AND CODE_CTGR_CD = inCodeCtgrCd
        AND CODE_CD = inCodeCd;

    RETURN codeNm;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'No data found';
    WHEN OTHERS THEN
        RETURN 'Error occurred';
END;
