INSERT INTO DEV_LMS.TB_LMS_BBS
(
    BBS_ID,
    ORG_ID,
    SBJCT_ID,
    BBS_REF_TYPE_ID,
    BBS_REF_TYCD,
    BBSNM,
    BBS_ENNM,
    BBS_EXPLN,
    BBS_TYCD,
    BBS_LANG_CD,
    MENU_ID,
    MN_IMG_FILE_ID,
    LIST_CNT,
    ATFL_MAX_CNT,
    ATFL_MAXSZ,
    ATFL_USEYN,
    DELYN,
    RGTR_ID,
    REG_DTTM,
    MDFR_ID,
    MOD_DTTM
)
VALUES
(
    'BBS20260123001',      -- 게시판 ID
    'LMSBASIC',              -- 기관 ID
    'SBJCT20260001',        -- 과목 개설 ID
    'REF001',              -- 게시판 참조 타입 ID
    'SBJCT',               -- 참조 구분 코드 (과목)
    '공지사항',            -- 게시판명
    'Notice',              -- 게시판 영문명
    '과목 공지사항 게시판', -- 설명
    'NOTICE',              -- 게시판 유형 코드
    'ko',                  -- 언어 코드
    'MENU_BBS_01',         -- 메뉴 ID
    NULL,                  -- 메인 이미지 파일 ID
    20,                    -- 목록 출력 건수
    5,                     -- 첨부파일 최대 개수
    10485760,              -- 첨부파일 최대 용량 (10MB)
    'Y',                   -- 첨부파일 사용 여부
    'N',                   -- 삭제 여부
    'ADMIN',               -- 등록자 ID
    SYSDATE,               -- 등록일시
    'ADMIN',               -- 수정자 ID
    SYSDATE                -- 수정일시
);