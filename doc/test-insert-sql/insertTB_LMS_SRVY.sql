INSERT INTO DEV_LMS.TB_LMS_SRVY
(
    SRVY_ID,
    SRVY_GRP_ID,
    LCTR_WKNO_SCHDL_ID,
    UP_SRVY_ID,
    SRVY_WRT_TYCD,
    SRVY_GBNCD,
    SRVY_TYCD,
    SRVY_TRGT_GBNCD,
    SRVY_TTL,
    SRVY_CTS,
    SRVY_QSTNS_CMPTNYN,
    RSLT_OPEN_TYCD,
    DVCLAS_REGYN,
    SRVY_SDTTM,
    SRVY_EDTTM,
    EVL_SCR_TYCD,
    QSTN_DSPLY_GBNCD,
    USEYN,
    DELYN,
    MRK_RFLTYN,
    MRK_RFLTRT,
    MRK_OYN,
    EXTD_PTCPYN,
    EXTD_EDTTM,
    RGTR_ID,
    REG_DTTM,
    SBJCT_ID
)
VALUES
(
    'SRVY_0001',                 -- 설문 ID
    'SRVY_GRP_ID00001',               -- 설문 그룹 ID
    'WKNO_SCHDL_01',             -- 주차 스케줄 ID
    NULL,                        -- 상위 설문 ID
    'WRT01',                     -- 설문 작성 유형
    'GBN01',                     -- 설문 구분
    'TY01',                      -- 설문 유형
    'TRGT01',                    -- 설문 대상 구분
    '1주차 만족도 설문',         -- 설문 제목
    '설문 테스트 내용입니다.',   -- 설문 내용
    'N',                         -- 문항 완료 필수 여부
    'OPEN01',                    -- 결과 공개 유형
    'N',                         -- 분반 등록 여부
    '20260203090000',            -- 설문 시작일시
    '20260210235959',            -- 설문 종료일시
    'SCR01',                     -- 평가 점수 유형
    'DSP01',                     -- 문항 표시 구분
    'Y',                         -- 사용 여부
    'N',                         -- 삭제 여부
    'Y',                         -- 성적 반영 여부
    0,                           -- 성적 반영 비율
    'Y',                         -- 성적 공개 여부
    'Y',                         -- 연장 참여 여부
    '20260212235959',            -- 연장 종료일시
    'admin',                     -- 등록자
    '20260203083000',            -- 등록일시
    'SBJCT20260001'                   -- 과목 개설 ID
);