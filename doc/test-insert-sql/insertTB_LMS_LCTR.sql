DECLARE
    v_wkno   VARCHAR2(10);
    v_idx    VARCHAR2(3);
BEGIN
    FOR i IN 1..15 LOOP
        -- WKNO001 ~ WKNO015
        v_wkno := 'WKNO' || LPAD(i, 3, '0');

        FOR j IN 1..5 LOOP
            v_idx := LPAD(j, 3, '0');

            INSERT INTO DEV_LMS.TB_LMS_LCTR (
                LCTR_ID,
                LCTR_WKNO_SCHDL_ID,
                LCTRNM,
                LCTR_SEQNO,
                LCTR_GBNCD,
                LCTR_TYCD,
                PRG_RFLTYN,
                LCTR_SDTTM,
                LCTR_EDTTM,
                RCMD_ATNDLC_MNTS,
                PRGRT_GBNCD,
                INQYN,
                OTSDPRD_ATNDLCYN,
                OTSDPRD_ATNDLC_DAY_CNT,
                OTSDPRD_ATNDLC_RCG_STSCD,
                ATNDLC_STS_CHKYN,
                ATNDLC_NWIN_USEYN,
                ATNDLC_SCNDS,
                MKUP_CLAS_GBNCD,
                VDOCLAS_SDTTM,
                VDOCLAS_EDTTM,
                VDOCLAS_RM_PSWD,
                VDOCLAS_EXPLN,
                VDOCLAS_RM_CNTN_ID,
                DELYN,
                RGTR_ID,
                REG_DTTM
            ) VALUES (
                'LCTR_ID_' || v_wkno || '_' || v_idx, -- LCTR_ID
                v_wkno,                        -- LCTR_WKNO_SCHDL_ID
                '강의 ' || v_wkno || '_' || v_idx,               -- LCTRNM
                j,                             -- LCTR_SEQ (1~5)
                'ONLINE',                      -- LCTR_GBNCD
                'NORMAL',                      -- LCTR_TYCD
                'Y',                           -- PRG_RFLTYN
                '20260201090000',              -- LCTR_SDTTM
                '20260201100000',              -- LCTR_EDTTM
                60,                            -- RCMD_ATNDLC_MNTS
                'RATE',                        -- PRGRT_GBNCD
                'Y',                           -- INQYN
                'N',                           -- OTSDPRD_ATNDLCYN
                0,                             -- OTSDPRD_ATNDLC_DAY_CNT
                'NONE',                        -- OTSDPRD_ATNDLC_RCG_STSCD
                'Y',                           -- ATNDLC_STS_CHKYN
                'N',                           -- ATNDLC_NWIN_USEYN
                3600,                          -- ATNDLC_SCNDS
                'NONE',                        -- MKUP_CLAS_GBNCD
                NULL,                          -- VDOCLAS_SDTTM
                NULL,                          -- VDOCLAS_EDTTM
                NULL,                          -- VDOCLAS_RM_PSWD
                NULL,                          -- VDOCLAS_EXPLN
                NULL,                          -- VDOCLAS_RM_CNTN_ID
                'N',                           -- DELYN
                'ADMIN',                       -- RGTR_ID
                SYSDATE                        -- REG_DTTM
            );
        END LOOP;
    END LOOP;

    COMMIT;
END;