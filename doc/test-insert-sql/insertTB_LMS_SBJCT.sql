INSERT INTO DEV_LMS.TB_LMS_SBJCT
(
 SBJCT_ID, PROF_ID, SBJCT_REF_TYCD, CRS_MSTR_ID, SMSTR_CHRT_ID,
 SBJCT_GBNCD, SBJCT_TYCD, EDU_MTHD_TYCD, RGLRYN, CRCLMN_NO,
 SBJCTNM, SBJCT_EXPLN, SBJCT_ENNM, SBJCT_YR, SBJCT_SMSTR,
 CRDTS, RVW_PSBL_GBNCD, RVW_SDTTM, RVW_EDTTM,
 DVCLAS_GRPCD, DVCLAS_NO, DVCLAS_NCKNM, WHOL_WKCNT,
 DEPT_ID, CMCRS_GBNCD, CMCRS_GBNNM, LRN_CNTRL_GBNCD,
 FNSH_PROC_MTHD_CD, FNSH_SCR, FNSH_SCR_DELRT,
 ETC_DELRT, ATNDC_DELRT, ASMT_DELRT, DSCS_DELRT,
 EXAM_DELRT, TEAM_ACTV_DELRT,
 LCTR_SDTTM, LCTR_EDTTM,
 ATNDLC_CERT_PROC_MTHD_CD, ATNDLC_QUOTA, ATNDLC_CERT_STSCD,
 ATNDLC_APLY_SDTTM, ATNDLC_APLY_EDTTM,
 ATNDLC_SDTTM, ATNDLC_EDTTM,
 AUDIT_SDTTM, AUDIT_EDTTM,
 MRK_PROC_SDTTM, MRK_PROC_EDTTM,
 MRK_EVL_GBNCD, MRK_INQ_SRVY_ID,
 USEYN, DELYN, SCR_EVL_GBNCD, KYWD,
 LCTR_FRMT_GBNCD, RGTR_ID, REG_DTTM, MDFR_ID, MOD_DTTM
)
VALUES
(
 'SBJCT20260001',        -- SBJCT_ID
 'prof1',                -- PROF_ID
 'MAJOR',                -- SBJCT_REF_TYCD
 'CRS2026',              -- CRS_MSTR_ID
 'SMSTR01',              -- SMSTR_CHRT_ID
 'REQ',                  -- SBJCT_GBNCD
 'ONLINE',               -- SBJCT_TYCD
 'ON',                   -- EDU_MTHD_TYCD
 'Y',                    -- RGLRYN
 '101',                  -- CRCLMN_NO
 '자바 프로그래밍',        -- SBJCTNM
 '자바 기초 및 객체지향 개념 학습', -- SBJCT_EXPLN
 'Java Programming',     -- SBJCT_ENNM
 '2026',                 -- SBJCT_YR
 '1',                    -- SBJCT_SMSTR
 3,                      -- CRDTS
 'Y',                    -- RVW_PSBL_GBNCD
 '20260301121110', -- RVW_SDTTM
 '20260331121110', -- RVW_EDTTM
 'A',                    -- DVCLAS_GRPCD
 '01',                   -- DVCLAS_NO
 '분반1',                -- DVCLAS_NCKNM
 15,                     -- WHOL_WKCNT
 'DEPT001',              -- DEPT_ID
 'CM',                   -- CMCRS_GBNCD
 '공통과정',               -- CMCRS_GBNNM
 'PROF',                 -- LRN_CNTRL_GBNCD
 'SCORE',                -- FNSH_PROC_MTHD_CD
 60,                     -- FNSH_SCR
 40,                     -- FNSH_SCR_DELRT
 0,                      -- ETC_DELRT
 20,                     -- ATNDC_DELRT
 20,                     -- ASMT_DELRT
 10,                     -- DSCS_DELRT
 40,                     -- EXAM_DELRT
 10,                     -- TEAM_ACTV_DELRT
 '20260301121110', -- LCTR_SDTTM
 '20260630121110', -- LCTR_EDTTM
 'AUTO',                 -- ATNDLC_CERT_PROC_MTHD_CD
 80,                     -- ATNDLC_QUOTA
 'OPEN',                 -- ATNDLC_CERT_STSCD
 '20260220121110', -- ATNDLC_APLY_SDTTM
 '20260305121110', -- ATNDLC_APLY_EDTTM
 '20260301121110', -- ATNDLC_SDTTM
 '20260630121110', -- ATNDLC_EDTTM
 NULL,                   -- AUDIT_SDTTM
 NULL,                   -- AUDIT_EDTTM
 '20260701121110', -- MRK_PROC_SDTTM
 '20260715121110', -- MRK_PROC_EDTTM
 'ABS',                  -- MRK_EVL_GBNCD
 NULL,                   -- MRK_INQ_SRVY_ID
 'Y',                    -- USEYN
 'N',                    -- DELYN
 'REL',                  -- SCR_EVL_GBNCD
 '자바,객체지향,OOP',        -- KYWD
 'VIDEO',                -- LCTR_FRMT_GBNCD
 'admin',                -- RGTR_ID
 SYSDATE,                -- REG_DTTM
 'admin',                -- MDFR_ID
 SYSDATE                 -- MOD_DTTM
);