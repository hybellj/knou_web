BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO DEV_LMS.TB_LMS_USER
        (
            USER_ID,
            USER_RPRS_ID,
            ORG_ID,
            USERNM,
            USER_ENNM,
            USER_TYCD,
            USER_STNG_CTS,
            DEPT_ID,
            PHOTO_FILE_ID,
            USER_STSCD,
            MN_DSBL_CD,
            MN_DSBL_GRDCD,
            SCND_DSBL_CD,
            SCND_DSBL_GRDCD,
            EXAM_SPRT_APLY_TYCD,
            SNRYN,
            GNDR_TYCD,
            USER_ENV_STNG_CTS,
            USER_ID_ENCPSWD,
            USER_ID_APLY_DTTM,
            LGN_CNTNU_FAIL_CNT,
            USER_ID_LOCKYN,
            LGN_MTHD_GBNCD,
            USER_ID_APRV_DTTM,
            USER_ID_LEAVE_DTTM,
            USER_ID_STSCD,
            USER_ID_MIGYN,
            DUP_LGN_PRMYN,
            AUTO_LGN_USEYN,
            RGTR_ID,
            REG_DTTM,
            MDFR_ID,
            MOD_DTTM,
            PUSH_TALK_SMS_FLAG,
            SHRTNT_ALIM_RCVYN,
            EML_NOTI_RCVYN
        )
        VALUES
        (
            'USER2026' || LPAD(i, 4, '0'),           -- USER_ID
            'USER2026' || LPAD(i, 4, '0'),           -- USER_RPRS_ID
            'LMSBASIC',                                -- ORG_ID
            '테스트사용자' || i,                     -- USERNM
            'TEST_USER_' || i,                      -- USER_ENNM
            'STDNT',                                   -- USER_TYCD (학생)
            NULL,                                    -- USER_STNG_CTS
            'DEPT001',                               -- DEPT_ID
            NULL,                                    -- PHOTO_FILE_ID
            'ACT',                                   -- USER_STSCD
            NULL, NULL, NULL, NULL,                  -- 장애정보
            NULL,                                    -- 시험지원유형
            'N',                                     -- SNRYN
            CASE MOD(i,2) WHEN 0 THEN 'F' ELSE 'M' END, -- GNDR_TYCD
            NULL,                                    -- USER_ENV_STNG_CTS
            '0ffe1abd1a08215353c233d6e009613e95eec4253832a761af28ff37ac5a150c',                         -- USER_ID_ENCPSWD
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),    -- USER_ID_APLY_DTTM
            0,                                       -- LGN_CNTNU_FAIL_CNT
            'N',                                     -- USER_ID_LOCKYN
            'IDPWD',                                     -- LGN_MTHD_GBNCD
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),    -- USER_ID_APRV_DTTM
            NULL,                                    -- USER_ID_LEAVE_DTTM
            'N',                                     -- USER_ID_STSCD
            'N',                                     -- USER_ID_MIGYN
            'N',                                     -- DUP_LGN_PRMYN
            'N',                                     -- AUTO_LGN_USEYN
            'SYSTEM',                                -- RGTR_ID
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),    -- REG_DTTM
            'SYSTEM',                                -- MDFR_ID
            TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS'),    -- MOD_DTTM
            '0000000111',                            -- PUSH_TALK_SMS_FLAG
            'N',                                     -- SHRTNT_ALIM_RCVYN
            'N'                                      -- EML_NOTI_RCVYN
        );
    END LOOP;

    COMMIT;
END;