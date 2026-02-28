INSERT INTO DEV_LMS.TB_LMS_SMSTR_CHRT
(
    SMSTR_CHRT_ID,
    ORG_ID,
    DGRS_YR,
    DGRS_SMSTR_CHRT,
    SMSTR_CHRT_GBNCD,
    SMSTR_CHRT_TYCD,
    SMSTR_CHRT_STSCD,
    SMSTR_CHRT_DATA_LNKGYN,
    SMSTR_CHRTNM,
    SMSTR_CHRT_OP_SDTTM,
    SMSTR_CHRT_OP_EDTTM,
    OFLN_LRN_MNGYN,
    ATNDLC_APLY_SDTTM,
    ATNDLC_APLY_EDTTM,
    ATNDLC_MOD_SDTTM,
    ATNDLC_MOD_EDTTM,
    ATNDLC_SDTTM,
    ATNDLC_EDTTM,
    MRK_EVL_SDTTM,
    MRK_EVL_EDTTM,
    MRK_OPEN_SDTTM,
    MRK_OPEN_EDTTM,
    MBL_ATNDC_USEYN,
    NOW_SMSTRYN,
    RVW_EDTTM,
    PROF_ACCSS_PBL_SDTTM,
    RGTR_ID,
    REG_DTTM,
    MDFR_ID,
    MOD_DTTM
)
VALUES
(
    'SMSTR01',                 -- 학기기수ID
    'LMSBASIC',                       -- 기관ID
    '2026',                         -- 학년도
    '01',                           -- 학기(1학기)
    'REG',                          -- 학기구분코드
    'NORMAL',                       -- 학기유형코드
    'OPEN',                         -- 학기상태코드
    'N',                            -- 데이터연계여부
    '2026학년도 1학기',              -- 학기명
    TO_DATE('20260201090000','YYYYMMDDHH24MISS'), -- 학기운영시작
    TO_DATE('20260630235959','YYYYMMDDHH24MISS'), -- 학기운영종료
    'Y',                            -- 오프라인학습관리여부
    TO_DATE('20260201000000','YYYYMMDDHH24MISS'), -- 출석적용시작
    TO_DATE('20260630235959','YYYYMMDDHH24MISS'), -- 출석적용종료
    TO_DATE('20260201000000','YYYYMMDDHH24MISS'), -- 출석수정시작
    TO_DATE('20260630235959','YYYYMMDDHH24MISS'), -- 출석수정종료
    TO_DATE('20260201000000','YYYYMMDDHH24MISS'), -- 출석시작
    TO_DATE('20260630235959','YYYYMMDDHH24MISS'), -- 출석종료
    TO_DATE('20260601000000','YYYYMMDDHH24MISS'), -- 성적평가시작
    TO_DATE('20260620235959','YYYYMMDDHH24MISS'), -- 성적평가종료
    TO_DATE('20260621000000','YYYYMMDDHH24MISS'), -- 성적공개시작
    TO_DATE('20260630235959','YYYYMMDDHH24MISS'), -- 성적공개종료
    'Y',                            -- 모바일출석사용여부
    'Y',                            -- 현재학기여부
    TO_DATE('20260630235959','YYYYMMDDHH24MISS'), -- 복습종료일시
    TO_DATE('20260201000000','YYYYMMDDHH24MISS'), -- 교수접근공개시작
    'admin',                        -- 등록자
    SYSDATE,                        -- 등록일시
    'admin',                        -- 수정자
    SYSDATE                         -- 수정일시
);