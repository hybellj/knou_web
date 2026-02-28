BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO DEV_LMS.TB_LMS_USER_RPRS
        (
            USER_RPRS_ID,
            RGTR_ID,
            REG_DTTM,
            MDFR_ID,
            MOD_DTTM
        )
        VALUES
        (
            'USER2026' || LPAD(i, 4, '0'),          -- USER_RPRS_ID
            'SYSTEM',                               -- 등록자
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),   -- 등록일시
            'SYSTEM',                               -- 수정자
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')    -- 수정일시
        );
    END LOOP;

    COMMIT;
END;