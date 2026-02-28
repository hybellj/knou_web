INSERT INTO DEV_LMS.TB_LMS_DSCS
(
    DSCS_ID,
    LCTR_WKNO_SCHDL_ID,
    DSCS_GRP_ID,
    DSCS_TYCD,
    DSCS_GBNCD,
    DSCS_UNIT_TYCD,
    EVL_SCR_TYCD,
    DSCS_TTL,
    DSCS_CTS,
    DSCS_SDTTM,
    DSCS_EDTTM,
    EVL_SDTTM,
    EVL_EDTTM,
    EXTD_SDTTM,
    EXTD_EDTTM,
    EXTD_EVL_SDTTM,
    EXTD_EVL_EDTTM,
    DVCLS_ID,
    LRN_GRP_ID,
    DELYN,
    OATCL_INQYN,
    OKNOKRT_OYN,
    OKNOK_MODYN,
    MLT_OPNN_REGYN,
    EXTD_USEYN,
    CMNT_RSPNS_REQYN,
    MRK_RFLTYN,
    MRK_OYN,
    MRK_OPEN_SDTTM,
    MRK_OPEN_EDTTM,
    RGTR_ID,
    REG_DTTM,
    SBJCT_ID
)
VALUES
(
    'DSCS_0001',              -- 토론 ID
    'WKNO_SCHDL_01',          -- 주차 스케줄 ID
    'DSCS_GRP_ID00001',            -- 토론 그룹 ID
    'DSCS01',                 -- 토론 유형 코드
    'GBN01',                  -- 구분 코드
    'UNIT01',                 -- 단위 유형 코드
    'SCR01',                  -- 평가 점수 유형
    '1주차 토론 주제',        -- 토론 제목
    '토론 내용 테스트입니다.', -- 토론 내용
    '20260203121110',                  -- 토론 시작일시
    '20260603121110',              -- 토론 종료일시
    '20260603121110',                  -- 평가 시작일시
    '20260703121110',              -- 평가 종료일시
    NULL,                     -- 연장 시작일시
    NULL,                     -- 연장 종료일시
    NULL,                     -- 연장 평가 시작일시
    NULL,                     -- 연장 평가 종료일시
    'DVCLS_01',               -- 분반 ID
    'LRN_GRP_01',             -- 학습 그룹 ID
    'N',                      -- 삭제 여부
    'Y',                      -- 공지글 조회 여부
    'N',                      -- OK/NO 평가 여부
    'N',                      -- OK/NO 수정 여부
    'Y',                      -- 다중 의견 등록 여부
    'N',                      -- 연장 사용 여부
    'Y',                      -- 댓글 응답 필수 여부
    'Y',                      -- 성적 반영 여부
    'Y',                      -- 성적 공개 여부
    '20260703121110',                  -- 성적 공개 시작일시
    '20260703121110',             -- 성적 공개 종료일시
    'admin',                  -- 등록자
    '20260203121110'                  -- 등록일시
    'SBJCT20260001'                -- 과목 개설 ID
);