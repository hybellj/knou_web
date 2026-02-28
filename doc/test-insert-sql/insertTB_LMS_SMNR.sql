INSERT INTO DEV_LMS.TB_LMS_SMNR
(
    SMNR_ID,
    LCTR_WKNO_SCHDL_ID,
    SMNR_GRP_ID,
    SMNRNM,
    SMNR_CTS,
    SMNR_TYCD,
    SMNR_SDTTM,
    SMNR_EDTTM,
    SMNR_MNTS,
    SMNR_GBNCD,
    ATNDC_PROCYN,
    AUTO_RCDYN,
    PROF_ONLY_URL,
    DELYN,
    RGTR_ID,
    REG_DTTM,
    SBJCT_ID
)
VALUES
(
    'SMNR_0001',                 -- 세미나 ID
    'WKNO_SCHDL_01',             -- 주차 스케줄 ID
    'SMNR_GRP_ID00001',               -- 세미나 그룹 ID
    '1주차 온라인 세미나',      -- 세미나명
    '세미나 테스트 내용입니다.', -- 세미나 내용
    'SMNR01',                    -- 세미나 유형 코드
    '20260203121110',                     -- 세미나 시작일시
    '20260204121110',              -- 세미나 종료일시 (1시간)
    60,                           -- 세미나 시간(분)
    'GBN01',                     -- 세미나 구분 코드
    'Y',                          -- 출석 처리 여부
    'N',                          -- 자동 녹화 여부
    'N',                          -- 교수 전용 URL 여부
    'N',                          -- 삭제 여부
    'admin',                      -- 등록자
    '20260203121110',                      -- 등록일시
    'SBJCT20260001'                   -- 과목 개설 ID
);