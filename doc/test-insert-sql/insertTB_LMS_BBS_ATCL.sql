INSERT INTO DEV_LMS.TB_LMS_BBS_ATCL
(
    ATCL_ID,
    BBS_ID,
    USER_ID,
    UP_ATCL_ID,
    DVCLAS_REG_ATCL_ID,
    ATCL_TTL,
    ATCL_CTS,
    ATCL_HASH_TAG_CTS,
    ATCL_LV,
    ATCL_SEQNO,
    FVRT_CNT,
    INQ_CNT,
    REF_CMNT_ID,
    THMB_FILE_ID,
    PROC_STSCD,
    HDR_TYCD,
    ATHR_ID,
    DSCSN_PROF_ID,
    RGTR_ID,
    REG_DTTM,
    MDFR_ID,
    MOD_DTTM
)
VALUES
(
    'ATCL20260123001',             -- 게시글 ID
    'BBS20260123001',              -- 게시판 ID
    'prof1',                  -- 작성 사용자 ID
    NULL,                          -- 상위 게시글 ID (일반글)
    NULL,                          -- 분반 등록 게시글 ID
    '강의 일정 안내',               -- 게시글 제목
    '이번 주 강의 일정은 변경 없이 진행됩니다.', -- 게시글 내용
    '#공지#강의일정',               -- 해시태그
    0,                             -- 게시글 레벨
    1,                             -- 게시글 순번
    0,                             -- 즐겨찾기 수
    0,                             -- 조회 수
    NULL,                          -- 참조 댓글 ID
    NULL,                          -- 썸네일 파일 ID
    'COMP',                        -- 처리 상태 코드 (완료)
    'NOTICE',                      -- 헤더 유형 코드
    'prof1',                     -- 작성자 ID
    'prof1',                     -- 토론 교수 ID
    'prof1',                     -- 등록자 ID
    SYSDATE,                       -- 등록일시
    'prof1',                     -- 수정자 ID
    SYSDATE                        -- 수정일시
);
