BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO DEV_LMS.TB_LMS_SBJCT_ADM
        (
            SBJCT_ADM_ID,
            SBJCT_ID,
            USER_ID,
            SBJCT_ADM_TYCD,
            SBJCT_ADM_SQNO,
            RGTR_ID,
            REG_DTTM,
            MDFR_ID,
            MOD_DTTM
        )
        VALUES
        (
            'SBJCT_ADM_20260126_' || LPAD(i, 3, '0'),  -- 과목관리자 ID
            'SBJCT20260001',                           -- 과목 ID
            'TUTOR2026' || LPAD(i, 4, '0'),            -- 사용자 ID
            'TUT',                                   -- 관리자 유형
            i-1,                                         -- 순번
            'ADMIN',                                  -- 등록자
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),      -- 등록일시
            'ADMIN',                                  -- 수정자
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')       -- 수정일시
        );
    END LOOP;

    COMMIT;
END;
/