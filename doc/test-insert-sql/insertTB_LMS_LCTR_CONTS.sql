DECLARE
    v_seq NUMBER;
BEGIN
    FOR r IN (
        SELECT LCTR_ID
        FROM DEV_LMS.TB_LMS_LCTR
        WHERE DELYN = 'N'
        ORDER BY LCTR_ID
    ) LOOP

        FOR v_seq IN 1..3 LOOP
            INSERT INTO DEV_LMS.TB_LMS_LCTR_CONTS (
                LCTR_CONTS_ID,
                LCTR_ID,
                CONTS_SEQNO,
                UP_LCTR_CONTS_ID,
                CONTS_FILE_ID,
                CONTSNM,
                LCTR_CONTS_TYCD,
                CONTS_URL,
                CONTS_PATH,
                CONTS_PSTN_CD,
                CONTS_FILE_EXT,
                VDO_MNTS,
                ATNDC_RFLTYN,
                OYN,
                EXRCS_QSTN_ID,
                RGTR_ID,
                REG_DTTM
            ) VALUES (
                'CONTS_' || r.LCTR_ID || '_' || LPAD(v_seq, 2, '0'), -- LCTR_CONTS_ID
                r.LCTR_ID,                                          -- LCTR_ID
                v_seq,                                              -- CONTS_SEQNO
                NULL,                                               -- UP_LCTR_CONTS_ID
                DBMS_RANDOM.STRING('X', 30),                         -- ★ 30자리 난수
                '컨텐츠 ' || v_seq,                                 -- CONTSNM
                'VIDEO',                                            -- LCTR_CONTS_TYCD
                'https://vod.test/' || r.LCTR_ID || '/' || v_seq,   -- CONTS_URL
                '/vod/' || r.LCTR_ID,                               -- CONTS_PATH
                'MAIN',                                             -- CONTS_PSTN_CD
                'MP4',                                              -- CONTS_FILE_EXT
                30,                                                  -- VDO_MNTS
                'Y',                                                 -- ATNDC_RFLTYN
                'Y',                                                 -- OYN
                NULL,                                                -- EXRCS_QSTN_ID
                'ADMIN',                                            -- RGTR_ID
                SYSDATE                                             -- REG_DTTM
            );
        END LOOP;

    END LOOP;

    COMMIT;
END;
