BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO DEV_LMS.TB_LMS_ATNDLC
        (
            ATNDLC_ID,
            SBJCT_ID,
            USER_ID,
            RPTYN,
            ATNDLC_APLY_DTTM,
            ATNDLC_CNCL_DTTM,
            ATNDLC_CERT_DTTM,
            ATNDLC_FNSH_DTTM,
            FNSH_NO,
            ACQS_CRDTS,
            SCYR,
            CMCRS_GBNCD,
            DGRS_CRS_GBNCD,
            AUDITYN,
            RGTR_ID,
            REG_DTTM,
            MDFR_ID,
            MOD_DTTM,
            ATNDLC_STSCD
        )
        VALUES
        (
            'ATNDLC2026' || LPAD(i, 4, '0'),     -- ATNDLC_ID
            'SBJCT20260001',                     -- 과목개설ID (고정)
            'USER2026' || LPAD(i, 4, '0'),       -- 사용자ID 100명
            'N',                                 -- 재수강여부
            TO_CHAR(SYSDATE - DBMS_RANDOM.VALUE(0, 5),
                    'YYYYMMDDHH24MISS'),         -- 신청일시 랜덤
            NULL,
            NULL,
            NULL,
            TO_CHAR(i),                          -- 이수번호
            3,                                   -- 취득학점
            '1',                                 -- 학년
            '01',                                -- 과정구분
            '01',                                -- 학위과정구분
            'N',                                 -- 청강여부
            'ADMIN',
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),
            'ADMIN',
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),
            'ING'                                -- 수강중
        );
    END LOOP;

    COMMIT;
END;