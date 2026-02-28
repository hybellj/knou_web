-- (기타) 학사일정
CREATE TABLE tb_home_acad_sch (
	ACAD_SCH_SN     VARCHAR(30)  NOT NULL COMMENT '학사 일정 번호', -- 학사 일정 번호
	ORG_ID          VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	CALENDAR_CTGR   VARCHAR(30)  NOT NULL COMMENT '일정 분류', -- 일정 분류
	CALENDAR_REF_CD VARCHAR(30)  NULL     COMMENT '일정 참조 코드', -- 일정 참조 코드
	SCH_START_DT    VARCHAR(14)  NOT NULL COMMENT '일정 시작 일자', -- 일정 시작 일자
	SCH_END_DT      VARCHAR(14)  NOT NULL COMMENT '일정 종료 일자', -- 일정 종료 일자
	ACAD_SCH_NM     VARCHAR(200) NOT NULL COMMENT '학사 일정 명', -- 학사 일정 명
	SCH_CNTS        LONGTEXT     NULL     COMMENT '일정 내용', -- 일정 내용
	SCH_CNTS_TYPE   VARCHAR(30)  NULL     COMMENT '일정 내용 구분', -- 일정 내용 구분
	UNI_CD          VARCHAR(1)   NULL     COMMENT '대학 코드', -- 대학 코드
	USE_YN          CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID          VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기타) 학사일정';

-- (기타) 학사일정
ALTER TABLE tb_home_acad_sch
	ADD CONSTRAINT PK_tb_home_acad_sch -- PK_tb_home_acad_sch
		PRIMARY KEY (
			ACAD_SCH_SN -- 학사 일정 번호
		);

-- (게시판) 게시판 게시글
CREATE TABLE tb_home_bbs_atcl (
	ATCL_ID           VARCHAR(30)  NOT NULL COMMENT '게시글 ID', -- 게시글 ID
	PAR_ATCL_ID       VARCHAR(30)  NULL     COMMENT '상위 게시글 아이디', -- 상위 게시글 ID
	BBS_ID            VARCHAR(30)  NULL     COMMENT '게시판 아이디', -- 게시판 ID
	HEAD_CD           VARCHAR(30)  NULL     COMMENT '말머리 코드', -- 말머리 코드
	CRS_CRE_CD        VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	THUMB_FILE_SN     INT          NULL     COMMENT '썸네일 파일 번호', -- 썸네일 파일 번호
	HAKSA_YEAR        VARCHAR(4)   NULL     COMMENT '학사 년도', -- 학사 년도
	HAKSA_TERM        VARCHAR(4)   NULL     COMMENT '학사 학기', -- 학사 학기
	ATCL_TITLE        VARCHAR(200) NULL     COMMENT '게시글 제목', -- 게시글 제목
	ATCL_CTS          LONGTEXT     NULL     COMMENT '게시글 내용', -- 게시글 내용
	ATCL_TAG          VARCHAR(100) NULL     COMMENT '게시글 태그', -- 게시글 태그
	ATCL_LVL          INT          NULL     COMMENT '게시글 레벨', -- 게시글 레벨
	ATCL_ODR          INT          NULL     COMMENT '게시글 순서', -- 게시글 순서
	NOTICE_YN         CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '공지 여부', -- 공지 여부
	CMNT_USE_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '댓글 사용 여부', -- 댓글 사용 여부
	NOTICE_START_DTTM VARCHAR(14)  NULL     COMMENT '공지 시작 일시 ', -- 공지 시작 일시 
	NOTICE_END_DTTM   VARCHAR(14)  NULL     COMMENT '공지 종료 일시', -- 공지 종료 일시
	PRCS_STATUS_CD    VARCHAR(30)  NULL     DEFAULT 'R' COMMENT '처리 상태 코드', -- 처리 상태 코드
	LOCK_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '잠금 여부', -- 잠금 여부
	ORIGIN_RGTR_ID     VARCHAR(30)  NULL     COMMENT '출처 등록자 번호', -- 출처 등록자 번호
	EDITOR_YN         CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '에디터 여부', -- 에디터 여부
	HITS              INT          NOT NULL COMMENT '조회 수', -- 조회 수
	GOOD_USE_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '좋아요 사용 여부', -- 좋아요 사용 여부
	GOOD_CNT          INT          NULL     COMMENT '좋아요 수', -- 좋아요 수
	RSRV_USE_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '예약 여부', -- 예약 여부
	RSRV_DTTM         VARCHAR(14)  NULL     COMMENT '예약 일시', -- 예약 일시
	IMPT_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '중요글 여부', -- 중요글 여부
	COUNCEL_PROF      VARCHAR(30)  NULL     COMMENT '상담 교수', -- 상담 교수
	DEL_YN            CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	UNI_CD            VARCHAR(1)   NOT NULL DEFAULT 'P' COMMENT '대학 코드', -- 대학 코드
	UNIV_GBN          VARCHAR(10)  NOT NULL DEFAULT '0' COMMENT '대학교 구분', -- 대학교 구분
	REG_CMNT_SN       VARCHAR(30)  NULL     COMMENT '참조 댓글 고유번호', -- 참조 댓글 고유번호
	DECLS_ATCL_IDS    VARCHAR(200) NULL     COMMENT '분반 등록 게시글 ID', -- 분반 등록 게시글 ID
	RGTR_ID            VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_NM            VARCHAR(100) NULL     COMMENT '등록자 이름', -- 등록자 이름
	REG_DTTM          VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(게시판) 게시판 게시글';

-- (게시판) 게시판 게시글
ALTER TABLE tb_home_bbs_atcl
	ADD CONSTRAINT PK_tb_home_bbs_atcl -- PK_tb_home_bbs_atcl
		PRIMARY KEY (
			ATCL_ID -- 게시글 ID
		);

-- IX_tb_home_bbs_atcl
CREATE INDEX IX_tb_home_bbs_atcl
	ON tb_home_bbs_atcl( -- (게시판) 게시판 게시글
		BBS_ID ASC,      -- 게시판 ID
		CRS_CRE_CD ASC,  -- 과정개설 코드
		ATCL_ID ASC,     -- 게시글 ID
		PAR_ATCL_ID ASC  -- 상위 게시글 ID
	);

-- IX_tb_home_bbs_atcl2
CREATE INDEX IX_tb_home_bbs_atcl2
	ON tb_home_bbs_atcl( -- (게시판) 게시판 게시글
		BBS_ID ASC,     -- 게시판 ID
		HAKSA_YEAR ASC, -- 학사 년도
		HAKSA_TERM ASC  -- 학사 학기
	);

-- (게시판) 게시판 댓글
CREATE TABLE tb_home_bbs_cmnt (
	CMNT_ID     VARCHAR(30)  NOT NULL COMMENT '댓글 ID', -- 댓글 ID
	ATCL_ID     VARCHAR(30)  NOT NULL COMMENT '게시글 ID', -- 게시글 ID
	PAR_CMNT_ID VARCHAR(30)  NULL     COMMENT '상위 댓글 ID', -- 상위 댓글 ID
	CMNT_CTS    LONGTEXT     NULL     COMMENT '댓글 내용', -- 댓글 내용
	EMOTICON_NO INT          NULL     COMMENT '이모티콘 번호', -- 이모티콘 번호
	DEL_YN      CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID      VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_NM      VARCHAR(100) NULL     COMMENT '등록자 이름', -- 등록자 이름
	REG_DTTM    VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(게시판) 게시판 댓글';

-- (게시판) 게시판 댓글
ALTER TABLE tb_home_bbs_cmnt
	ADD CONSTRAINT PK_tb_home_bbs_cmnt -- PK_tb_home_bbs_cmnt
		PRIMARY KEY (
			CMNT_ID, -- 댓글 ID
			ATCL_ID  -- 게시글 ID
		);

-- IX_tb_home_bbs_cmnt
CREATE INDEX IX_tb_home_bbs_cmnt
	ON tb_home_bbs_cmnt( -- (게시판) 게시판 댓글
		RGTR_ID ASC -- 등록자 번호
	);

-- (게시판) 게시판 말머리
CREATE TABLE tb_home_bbs_head (
	HEAD_CD  VARCHAR(30)  NOT NULL COMMENT '말머리 코드', -- 말머리 코드
	BBS_ID   VARCHAR(30)  NOT NULL COMMENT '게시판 아이디', -- 게시판 ID
	HEAD_NM  VARCHAR(200) NOT NULL COMMENT '말머리 명', -- 말머리 명
	HEAD_ODR INT          NULL     COMMENT '말머리 순서', -- 말머리 순서
	USE_YN   CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID   VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID   VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(게시판) 게시판 말머리';

-- (게시판) 게시판 말머리
ALTER TABLE tb_home_bbs_head
	ADD CONSTRAINT PK_tb_home_bbs_head -- PK_tb_home_bbs_head
		PRIMARY KEY (
			HEAD_CD, -- 말머리 코드
			BBS_ID   -- 게시판 ID
		);

-- (게시판) 게시판 정보
CREATE TABLE tb_home_bbs_info (
	BBS_ID               VARCHAR(30)   NOT NULL COMMENT '게시판 ID', -- 게시판 ID
	ORG_ID               VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	BBS_CD               VARCHAR(30)   NOT NULL COMMENT '게시판 코드', -- 게시판 코드
	BBS_NM               VARCHAR(200)  NOT NULL COMMENT '게시판 명', -- 게시판 명
	BBS_NM_EN            VARCHAR(200)  NOT NULL DEFAULT 'Board' COMMENT '게시판 명_영문', -- 게시판 명_영문
	BBS_DESC             VARCHAR(2000) NULL     COMMENT '게시판 설명', -- 게시판 설명
	BBS_TYPE_CD          VARCHAR(30)   NOT NULL COMMENT '게시판 유형 코드', -- 게시판 유형 코드
	DFLT_LANG_CD         VARCHAR(30)   NOT NULL DEFAULT 'ko' COMMENT '기본 언어 코드', -- 기본 언어 코드
	MENU_CD              VARCHAR(30)   NULL     COMMENT '메뉴 코드', -- 메뉴 코드
	MAIN_IMG_FILE_SN     INT           NULL     COMMENT '메인 이미지 파일 번호', -- 메인 이미지 파일 번호
	SYS_USE_YN           CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '시스템 사용 여부', -- 시스템 사용 여부
	SYS_DEFAULT_YN       CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '시스템 기본 제공 여부', -- 시스템 기본 제공 여부
	WRITE_USE_YN         CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '쓰기 사용 여부', -- 쓰기 사용 여부
	CMNT_USE_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '댓글 사용 여부', -- 댓글 사용 여부
	ANSR_USE_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '답글 사용 여부', -- 답글 사용 여부
	NOTI_USE_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '공지 사용 여부', -- 공지 사용 여부
	GOOD_USE_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '좋아요 사용 여부', -- 좋아요 사용 여부
	ATCH_USE_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '첨부 사용 여부', -- 첨부 사용 여부
	ATCH_FILE_CNT        INT           NULL     COMMENT '첨부 파일 수', -- 첨부 파일 수
	ATCH_FILE_SIZE_LIMIT INT           NOT NULL DEFAULT 1000 COMMENT '첨부 파일 용량 제한', -- 첨부 파일 용량 제한
	ATCH_CVSN_USE_YN     CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '첨부 문서 변환 사용 여부', -- 첨부 문서 변환 사용 여부
	EDITOR_USE_YN        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '에디터 사용 여부', -- 에디터 사용 여부
	MOBILE_USE_YN        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '모바일 사용 여부', -- 모바일 사용 여부
	SECRT_ATCL_USE_YN    CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '비밀글 사용 여부', -- 비밀글 사용 여부
	VIWR_USE_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '뷰어 사용 여부', -- 뷰어 사용 여부
	NMBR_VIEW_YN         CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '비회원 조회 여부', -- 비회원 조회 여부
	NMBR_CRE_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '비회원 등록 여부', -- 비회원 등록 여부
	HEAD_USE_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '말머리 사용 여부', -- 말머리 사용 여부
	LIST_VIEW_CNT        INT           NOT NULL DEFAULT 10 COMMENT '목록 보기 수', -- 목록 보기 수
	USE_YN               CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	DEL_YN               CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	LOCK_USE_YN          CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '잠금 사용 여부', -- 잠금 사용 여부
	UNI_CD               VARCHAR(1)    NOT NULL DEFAULT 'P' COMMENT '대학 코드', -- 대학 코드
	STD_VIEW_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '학생 보기 여부', -- 학생 보기 여부
	RGTR_ID               VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM             VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID               VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM             VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(게시판) 게시판 정보';

-- (게시판) 게시판 정보
ALTER TABLE tb_home_bbs_info
	ADD CONSTRAINT PK_tb_home_bbs_info -- PK_tb_home_bbs_info
		PRIMARY KEY (
			BBS_ID -- 게시판 ID
		);

-- IX_(게시판) 게시판 정보
CREATE INDEX IX_tb_home_bbs_info
	ON tb_home_bbs_info( -- (게시판) 게시판 정보
		SYS_USE_YN ASC -- 시스템 사용 여부
	);

-- IX_(게시판) 게시판 정보2
CREATE INDEX IX_tb_home_bbs_info2
	ON tb_home_bbs_info( -- (게시판) 게시판 정보
		SYS_DEFAULT_YN ASC -- 시스템 기본 제공 여부
	);

-- IX_(게시판) 게시판 정보3
CREATE INDEX IX_tb_home_bbs_info3
	ON tb_home_bbs_info( -- (게시판) 게시판 정보
		BBS_ID ASC,         -- 게시판 ID
		ORG_ID ASC,         -- 기관 코드
		BBS_CD ASC,         -- 게시판 코드
		SYS_DEFAULT_YN ASC, -- 시스템 기본 제공 여부
		DEL_YN ASC,         -- 삭제 여부
		BBS_NM ASC          -- 게시판 명
	);

-- IX_(게시판) 게시판 정보4
CREATE INDEX IX_tb_home_bbs_info4
	ON tb_home_bbs_info( -- (게시판) 게시판 정보
		USE_YN ASC,         -- 사용 여부
		DEL_YN ASC,         -- 삭제 여부
		LOCK_USE_YN ASC,    -- 잠금 사용 여부
		SYS_DEFAULT_YN ASC, -- 시스템 기본 제공 여부
		SYS_USE_YN ASC      -- 시스템 사용 여부
	);

-- (게시판) 게시판 정보 언어
CREATE TABLE tb_home_bbs_info_lang (
	BBS_ID   VARCHAR(30)   NOT NULL COMMENT '게시판 아이디', -- 게시판 ID
	LANG_CD  VARCHAR(30)   NOT NULL COMMENT '언어 코드', -- 언어 코드
	BBS_NM   VARCHAR(200)  NOT NULL COMMENT '게시판 명', -- 게시판 명
	BBS_DESC VARCHAR(2000) NULL     COMMENT '게시판 설명' -- 게시판 설명
)
COMMENT '(게시판) 게시판 정보 언어';

-- (게시판) 게시판 정보 언어
ALTER TABLE tb_home_bbs_info_lang
	ADD CONSTRAINT PK_tb_home_bbs_info_lang -- PK_tb_home_bbs_info_lang
		PRIMARY KEY (
			BBS_ID,  -- 게시판 ID
			LANG_CD  -- 언어 코드
		);

-- (게시판) 게시판 정보 연결
CREATE TABLE tb_home_bbs_rltn (
	BBS_ID      VARCHAR(30) NOT NULL COMMENT '게시판 아이디', -- 게시판 ID
	RLTN_REF_CD VARCHAR(30) NOT NULL COMMENT '연결 참조 코드', -- 연결 참조 코드
	RLTN_TYPE   VARCHAR(10) NOT NULL COMMENT '연결 유형' -- 연결 유형
)
COMMENT '(게시판) 게시판 정보 연결';

-- (게시판) 게시판 정보 연결
ALTER TABLE tb_home_bbs_rltn
	ADD CONSTRAINT PK_tb_home_bbs_rltn -- PK_tb_home_bbs_rltn
		PRIMARY KEY (
			BBS_ID,      -- 게시판 ID
			RLTN_REF_CD  -- 연결 참조 코드
		);

-- IX_(게시판) 게시판 정보 연결
CREATE INDEX IX_tb_home_bbs_rltn
	ON tb_home_bbs_rltn( -- (게시판) 게시판 정보 연결
		BBS_ID ASC,      -- 게시판 ID
		RLTN_REF_CD ASC, -- 연결 참조 코드
		RLTN_TYPE ASC    -- 연결 유형
	);

-- IX_(게시판) 게시판 정보 연결2
CREATE INDEX IX_tb_home_bbs_rltn2
	ON tb_home_bbs_rltn( -- (게시판) 게시판 정보 연결
		RLTN_REF_CD ASC -- 연결 참조 코드
	);

-- (게시판) 게시글 조회
CREATE TABLE tb_home_bbs_view (
	VIEW_ID       VARCHAR(30)  NOT NULL COMMENT '조회 ID', -- 조회 ID
	ATCL_ID       VARCHAR(30)  NOT NULL COMMENT '게시글 아이디', -- 게시글 ID
	USER_ID       VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	HITS          INT          NOT NULL DEFAULT 0 COMMENT '조회 수', -- 조회 수
	LAST_INQ_DTTM VARCHAR(14)  NULL     COMMENT '마지막 조회 일시', -- 마지막 조회 일시
	REG_NM        VARCHAR(100) NOT NULL COMMENT '등록자 이름', -- 등록자 이름
	REG_DTTM      VARCHAR(14)  NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(게시판) 게시글 조회';

-- (게시판) 게시글 조회
ALTER TABLE tb_home_bbs_view
	ADD CONSTRAINT PK_tb_home_bbs_view -- PK_tb_home_bbs_view
		PRIMARY KEY (
			VIEW_ID -- 조회 ID
		);

-- UX_(게시판) 게시글 조회
CREATE UNIQUE INDEX UX_tb_home_bbs_view
	ON tb_home_bbs_view ( -- (게시판) 게시글 조회
		ATCL_ID ASC, -- 게시글 ID
		USER_ID ASC  -- 사용자 번호
	);

-- (기타) 팝업 공지
CREATE TABLE tb_home_pop_notice (
	POP_NOTICE_SN      VARCHAR(30)  NOT NULL COMMENT '팝업공지 번호', -- 팝업공지 번호
	ORG_ID             VARCHAR(30)  NULL     COMMENT '기관 코드', -- 기관 코드
	NOTICE_TITLE       VARCHAR(200) NOT NULL COMMENT '팝업공지 제목', -- 팝업공지 제목
	NOTICE_CNTS        LONGTEXT     NULL     COMMENT '팝업공지 내용', -- 팝업공지 내용
	POP_TYPE_CD        VARCHAR(30)  NOT NULL DEFAULT 'ETC' COMMENT '팝업 유형', -- 팝업 유형
	POP_TARGET_CD      VARCHAR(30)  NOT NULL COMMENT '팝업공지 대상', -- 팝업공지 대상
	USE_YN             CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	NO_MORE_DAY_USE_YN CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '닫기 일수 옵션 추가 여부', -- 닫기 일수 옵션 추가 여부
	NO_MORE_DAY        INT          NULL     COMMENT '닫기 일수', -- 닫기 일수
	X_SIZE             INT          NOT NULL DEFAULT 800 COMMENT '팝업창 너비', -- 팝업창 너비
	Y_SIZE             INT          NOT NULL DEFAULT 600 COMMENT '팝업창 높이', -- 팝업창 높이
	X_POS              INT          NULL     COMMENT '팝업창 X 좌표', -- 팝업창 X 좌표
	Y_POS              INT          NULL     COMMENT '팝업창 Y 좌표', -- 팝업창 Y 좌표
	X_PERCENT          INT          NULL     COMMENT '팝업창 너비 비율', -- 팝업창 너비 비율
	POP_START_DTTM     VARCHAR(14)  NULL     COMMENT '팝업공지 시작 일시', -- 팝업공지 시작 일시
	POP_END_DTTM       VARCHAR(14)  NULL     COMMENT '팝업공지 종료 일시', -- 팝업공지 종료 일시
	LEGAL_STD_OPEN_YN  CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '법정교육 수강 대상 여부', -- 법정교육 수강 대상 여부
	ONE_SESSION_YN     CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '단일 세션 사용 여부', -- 단일 세션 사용 여부
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기타) 팝업 공지';

-- (기타) 팝업 공지
ALTER TABLE tb_home_pop_notice
	ADD CONSTRAINT PK_tb_home_pop_notice -- PK_tb_home_pop_notice
		PRIMARY KEY (
			POP_NOTICE_SN -- 팝업공지 번호
		);

-- (회원정보) 사용자 권한 그룹
CREATE TABLE tb_home_user_auth_grp (
	MENU_TYPE       VARCHAR(30) NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	AUTH_GRP_CD     VARCHAR(30) NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	USER_ID         VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	FILE_LIMIT_SIZE INT         NULL     COMMENT '파일 용량 제한 크기', -- 파일 용량 제한 크기
	RGTR_ID          VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(회원정보) 사용자 권한 그룹';

-- (회원정보) 사용자 권한 그룹
ALTER TABLE tb_home_user_auth_grp
	ADD CONSTRAINT PK_tb_home_user_auth_grp -- PK_tb_home_user_auth_grp
		PRIMARY KEY (
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD, -- 권한 그룹 코드
			USER_ID      -- 사용자 번호
		);

-- (회원정보) 부서 코드
CREATE TABLE tb_home_user_dept_cd (
	DEPT_CD     VARCHAR(30)  NOT NULL COMMENT '부서 코드', -- 부서 코드
	ORG_ID      VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	DEPT_NM     VARCHAR(200) NOT NULL COMMENT '부서 명', -- 부서 명
	DEPT_NM_EN  VARCHAR(200) NULL     COMMENT '부서 명_영문', -- 부서 명_영문
	PAR_DEPT_CD VARCHAR(30)  NULL     COMMENT '상위 부서 코드', -- 상위 부서 코드
	DEPT_CD_LVL INT          NULL     COMMENT '부서 코드 레벨', -- 부서 코드 레벨
	DEPT_CD_ODR INT          NULL     COMMENT '부서 코드 순서', -- 부서 코드 순서
	USE_YN      CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	UNI_GBN     VARCHAR(10)  NOT NULL DEFAULT 'U' COMMENT '대학 구분', -- 대학 구분
	RGTR_ID      VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(회원정보) 부서 코드';

-- (회원정보) 부서 코드
ALTER TABLE tb_home_user_dept_cd
	ADD CONSTRAINT PK_tb_home_user_dept_cd -- PK_tb_home_user_dept_cd
		PRIMARY KEY (
			DEPT_CD, -- 부서 코드
			ORG_ID   -- 기관 코드
		);

-- (회원정보) 이메일 인증
CREATE TABLE tb_home_user_email_auth (
	USER_EMAIL_AUTH_ID VARCHAR(30)  NOT NULL COMMENT '회원 이메일 인증 ID', -- 회원 이메일 인증 ID
	USE_YN             CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	SENDER_NM          VARCHAR(100) NOT NULL COMMENT '발송자 명', -- 발송자 명
	SENDER_EMAIL       VARCHAR(100) NOT NULL COMMENT '발송자 이메일', -- 발송자 이메일
	TITLE              VARCHAR(200) NOT NULL COMMENT '제목', -- 제목
	CTS                LONGTEXT     NOT NULL COMMENT '내용', -- 내용
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(회원정보) 이메일 인증';

-- (회원정보) 이메일 인증
ALTER TABLE tb_home_user_email_auth
	ADD CONSTRAINT PK_tb_home_user_email_auth -- PK_tb_home_user_email_auth
		PRIMARY KEY (
			USER_EMAIL_AUTH_ID -- 회원 이메일 인증 ID
		);

-- (회원정보) 비밀번호 찾기
CREATE TABLE tb_home_user_find_pswd (
	USER_FIND_PSWD_SN VARCHAR(30)  NOT NULL COMMENT '회원 비밀번호 찾기 번호', -- 회원 비밀번호 찾기 번호
	FIND_PSWD_TYPE_CD VARCHAR(30)  NOT NULL COMMENT '비밀번호 찾기 유형 코드', -- 비밀번호 찾기 유형 코드
	SENDER_NM         VARCHAR(100) NOT NULL COMMENT '발송자 명', -- 발송자 명
	SENDER_EMAIL      VARCHAR(100) NOT NULL COMMENT '발송자 이메일', -- 발송자 이메일
	TITLE             VARCHAR(200) NOT NULL COMMENT '제목', -- 제목
	CTS               LONGTEXT     NOT NULL COMMENT '내용', -- 내용
	RGTR_ID            VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(회원정보) 비밀번호 찾기';

-- (회원정보) 비밀번호 찾기
ALTER TABLE tb_home_user_find_pswd
	ADD CONSTRAINT PK_tb_home_user_find_pswd -- PK_tb_home_user_find_pswd
		PRIMARY KEY (
			USER_FIND_PSWD_SN -- 회원 비밀번호 찾기 번호
		);

-- (회원정보) 사용자 정보
CREATE TABLE tb_home_user_info (
	USER_ID               VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	DEPT_CD               VARCHAR(30)   NULL     COMMENT '부서 코드', -- 부서 코드
	ORG_ID                VARCHAR(30)   NULL     COMMENT '기관 코드', -- 기관 코드
	DEPT_NM               VARCHAR(200)  NULL     COMMENT '부서 명', -- 부서 명
	PHOTO_FILE_SN         INT           NULL     COMMENT '사진 파일 번호', -- 사진 파일 번호
	DUP_INFO              VARCHAR(100)  NULL     COMMENT '중복 정보', -- 중복 정보
	USER_NM               VARCHAR(100)  NOT NULL COMMENT '사용자 이름', -- 사용자 이름
	USER_NM_ENG           VARCHAR(100)  NULL     COMMENT '사용자 이름_영문', -- 사용자 이름_영문
	MOBILE_NO             VARCHAR(30)   NULL     COMMENT '휴대폰 번호', -- 휴대폰 번호
	EMAIL                 VARCHAR(100)  NULL     COMMENT '이메일', -- 이메일
	DISABLILITY_YN        CHAR(1)       NULL     DEFAULT 'N' COMMENT '장애인 여부', -- 장애인 여부
	DISABILITY_LV         VARCHAR(30)   NULL     COMMENT '장애인 등급', -- 장애인 등급
	DISABILITY_CD         VARCHAR(30)   NULL     COMMENT '장애인 유형', -- 장애인 유형
	DISABLILITY_EXAM_YN   CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '장애인 시험지원 신청 여부', -- 장애인 시험지원 신청 여부
	DISABILITY_DTTM       VARCHAR(30)   NULL     COMMENT '장애인 시험지원 신청 일시', -- 장애인 시험지원 신청 일시
	DISABILITY_CANCEL_GBN VARCHAR(30)   NULL     COMMENT '장애인 시험지원 취소 신청 구분', -- 장애인 시험지원 취소 신청 구분
	SMS_RECV              CHAR(1)       NULL     COMMENT 'SMS 수신', -- SMS 수신
	EMAIL_RECV            CHAR(1)       NULL     COMMENT '이메일 수신', -- 이메일 수신
	MSG_RECV              CHAR(1)       NULL     COMMENT '메시지 수신', -- 메시지 수신
	USER_GRADE            VARCHAR(1)    NULL     COMMENT '사용자 학년', -- 사용자 학년
	OFCE_TELNO            VARCHAR(30)   NULL     COMMENT '사무실 전화', -- 사무실 전화
	PHT_FILE              LONGBLOB      NULL     COMMENT '사진 파일', -- 사진 파일
	HAK_MODIFY_AT         DATETIME      NULL     COMMENT '학사 수정 일시', -- 학사 수정 일시
	TC_EMAIL              VARCHAR(100)  NULL     COMMENT '토큰 이메일', -- 토큰 이메일
	TC_PW                 VARCHAR(512)  NULL     COMMENT '토큰 암호', -- 토큰 암호
	TC_ID                 VARCHAR(100)  NULL     COMMENT '토큰 ID', -- 토큰 ID
	TC_ROLE               VARCHAR(6)    NULL     COMMENT '토큰 권한', -- 토큰 권한
	USER_CONF             VARCHAR(1000) NULL     COMMENT '사용자 환경 설정', -- 사용자 환경 설정
	ENTR_YY               VARCHAR(4)    NULL     COMMENT '입학 년도', -- 입학 년도
	ENTR_HY               VARCHAR(2)    NULL     COMMENT '입학 학년', -- 입학 학년
	READMI_YY             VARCHAR(4)    NULL     COMMENT '재입학 년도', -- 재입학 년도
	ENTR_GBN              VARCHAR(8)    NULL     COMMENT '입학 구분', -- 입학 구분
	ENTR_GBN_NM           VARCHAR(30)   NULL     COMMENT '입학 구분 명', -- 입학 구분 명
	UNI_CD                VARCHAR(1)    NULL     COMMENT '대학 코드', -- 대학 코드
	SCHREG_GBN            VARCHAR(10)   NULL     COMMENT '학생 재적 상태', -- 학생 재적 상태
	SCHREG_GBN_CD         VARCHAR(10)   NULL     COMMENT '학생 재적 상태 코드', -- 학생 재적 상태 코드
	STD_DETA_GBN          VARCHAR(2)    NULL     COMMENT '학생 세부 구분', -- 학생 세부 구분
	USER_TYPE_DETAIL      VARCHAR(3)    NULL     COMMENT '사용자 상세 구분', -- 사용자 상세 구분
	MNGT_DEPT_CD          VARCHAR(30)   NULL     COMMENT '관장학과 코드', -- 관장학과 코드
	SUB_DISABILITY_CD     VARCHAR(30)   NULL     COMMENT '부장애인 유형', -- 부장애인 유형
	SUB_DISABILITY_LV     VARCHAR(30)   NULL     COMMENT '부장애인 등급', -- 부장애인 등급
	ENTR_TM_GBN           VARCHAR(8)    NULL     COMMENT '입학 학기', -- 입학 학기
	STD_GBN               VARCHAR(8)    NULL     COMMENT '학생 구분', -- 학생 구분
	STATUS                CHAR(1)       NULL     COMMENT '상태' -- 상태
)
COMMENT '(회원정보) 사용자 정보';

-- (회원정보) 사용자 정보
ALTER TABLE tb_home_user_info
	ADD CONSTRAINT PK_tb_home_user_info -- PK_tb_home_user_info
		PRIMARY KEY (
			USER_ID -- 사용자 번호
		);

-- IX_tb_home_user_info
CREATE INDEX IX_tb_home_user_info
	ON tb_home_user_info( -- (회원정보) 사용자 정보
		USER_NM ASC -- 사용자 이름
	);

-- (회원정보) 사용자 정보 변경 기록
CREATE TABLE tb_home_user_info_chg_hsty (
	REG_DTTM             VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	USER_ID              VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	USER_INFO_CHG_DIV_CD VARCHAR(30)   NOT NULL COMMENT '사용자 정보 변경 구분 코드', -- 사용자 정보 변경 구분 코드
	USER_INFO_CTS        LONGTEXT      NULL     COMMENT '사용자 정보 내용', -- 사용자 정보 내용
	RGTR_ID               VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	CHG_TARGET           VARCHAR(1000) NULL     COMMENT '변경 내역', -- 변경 내역
	CONN_IP              VARCHAR(50)   NULL     COMMENT '접속 IP' -- 접속 IP
)
COMMENT '(회원정보) 사용자 정보 변경 기록';

-- (회원정보) 사용자 정보 변경 기록
ALTER TABLE tb_home_user_info_chg_hsty
	ADD CONSTRAINT PK_tb_home_user_info_chg_hsty -- PK_tb_home_user_info_chg_hsty
		PRIMARY KEY (
			REG_DTTM, -- 등록 일시
			USER_ID   -- 사용자 번호
		);

-- (회원정보) 로그인
CREATE TABLE tb_home_user_login (
	USER_ID                 VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	USER_ID                 VARCHAR(30)  NOT NULL COMMENT '사용자 ID', -- 사용자 ID
	USER_PASS               VARCHAR(100) NOT NULL COMMENT '사용자 암호', -- 사용자 암호
	ADMIN_LOGIN_ACPT_DIV_CD VARCHAR(30)  NULL     COMMENT '관리자 로그인 허용 구분 코드', -- 관리자 로그인 허용 구분 코드
	LOGIN_FAIL_CNT          INT          NULL     COMMENT '로그인 실패 횟수', -- 로그인 실패 횟수
	LOGIN_FAIL_DTTM         VARCHAR(14)  NULL     COMMENT '로그인 실패 일시', -- 로그인 실패 일시
	LAST_LOGIN_DTTM         VARCHAR(14)  NULL     COMMENT '마지막 로그인 일시', -- 마지막 로그인 일시
	LOGIN_CNT               INT          NULL     COMMENT '로그인 수', -- 로그인 수
	APLC_DTTM               VARCHAR(14)  NULL     COMMENT '신청 일시', -- 신청 일시
	APRV_DTTM               VARCHAR(14)  NULL     COMMENT '승인 일시', -- 승인 일시
	SECEDE_DTTM             VARCHAR(14)  NULL     COMMENT '탈퇴 일시', -- 탈퇴 일시
	USER_STS                CHAR(1)      NOT NULL DEFAULT 'U' COMMENT '사용자 상태', -- 사용자 상태
	RGTR_ID                  VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM                VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                  VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM                VARCHAR(14)  NULL     COMMENT '수정 일시', -- 수정 일시
	MIG_CHK                 VARCHAR(10)  NULL     COMMENT '마이그레이션 체크', -- 마이그레이션 체크
	PSWD_CHG_REQ_DTTM       VARCHAR(14)  NULL     COMMENT '암호 변경 요청 일시', -- 암호 변경 요청 일시
	SNS_KEY                 VARCHAR(100) NULL     COMMENT '소셜 키', -- 소셜 키
	SNS_DIV                 VARCHAR(50)  NULL     COMMENT '소셜 구분', -- 소셜 구분
	TMP_PASS                VARCHAR(100) NULL     COMMENT '임시 비밀번호', -- 임시 비밀번호
	OTP_USE_YN              CHAR(1)      NULL     DEFAULT 'Y' COMMENT 'OTP 사용 여부', -- OTP 사용 여부
	DUP_LOGIN_ACPT_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '중복 로그인 허용 여부', -- 중복 로그인 허용 여부
	LOGIN_ACPT_DIV_CD       VARCHAR(30)  NOT NULL DEFAULT 'ACCEPT' COMMENT '로그인 허용 구분 코드' -- 로그인 허용 구분 코드
)
COMMENT '(회원정보) 로그인';

-- (회원정보) 로그인
ALTER TABLE tb_home_user_login
	ADD CONSTRAINT PK_tb_home_user_login -- PK_tb_home_user_login
		PRIMARY KEY (
			USER_ID -- 사용자 번호
		);

-- (회원정보) 사용자 관장학과
CREATE TABLE tb_home_user_mgnt_dept (
	USER_ID          VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	USER_TYPE_DETAIL VARCHAR(3)  NOT NULL COMMENT '사용자 상세 구분', -- 사용자 상세 구분
	DEPT_CD          VARCHAR(30) NOT NULL COMMENT '부서 코드', -- 부서 코드
	RGTR_ID           VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(회원정보) 사용자 관장학과';

-- (회원정보) 사용자 관장학과
ALTER TABLE tb_home_user_mgnt_dept
	ADD CONSTRAINT PK_tb_home_user_mgnt_dept -- PK_tb_home_user_mgnt_dept
		PRIMARY KEY (
			USER_ID,          -- 사용자 번호
			USER_TYPE_DETAIL  -- 사용자 상세 구분
		);

-- (통계) 학업중단 위험 지수
CREATE TABLE tb_learn_stop_risk_index (
	CRE_YEAR   VARCHAR(4)   NOT NULL COMMENT '과정 년도', -- 과정 년도
	CRE_TERM   VARCHAR(2)   NOT NULL COMMENT '과정 학기', -- 과정 학기
	USER_ID    VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	PUB_YEAR   VARCHAR(4)   NOT NULL COMMENT '게시 년도', -- 게시 년도
	PUB_TERM   VARCHAR(4)   NOT NULL COMMENT '게시 학기', -- 게시 학기
	RISK_INDEX DECIMAL(5,2) NOT NULL COMMENT '위험 지수', -- 위험 지수
	RISK_GRADE VARCHAR(30)  NOT NULL COMMENT '위험 등급', -- 위험 등급
	RGTR_ID     VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM   VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID     VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM   VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 학업중단 위험 지수';

-- (통계) 학업중단 위험 지수
ALTER TABLE tb_learn_stop_risk_index
	ADD CONSTRAINT PK_tb_learn_stop_risk_index -- PK_tb_learn_stop_risk_index
		PRIMARY KEY (
			CRE_YEAR, -- 과정 년도
			CRE_TERM, -- 과정 학기
			USER_ID   -- 사용자 번호
		);

-- UX_tb_learn_stop_risk_index
CREATE UNIQUE INDEX UX_tb_learn_stop_risk_index
	ON tb_learn_stop_risk_index ( -- (통계) 학업중단 위험 지수
		PUB_YEAR ASC, -- 게시 년도
		PUB_TERM ASC, -- 게시 학기
		USER_ID ASC   -- 사용자 번호
	);

-- (통계) 학습 진도율
CREATE TABLE tb_learner_prog (
	LEARNER_PROG_ID VARCHAR(50)  NOT NULL COMMENT '진도율 통계 ID', -- 진도율 통계 ID
	CRS_CRE_CD      VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	CRE_YEAR        VARCHAR(4)   NULL     COMMENT '과정 년도', -- 과정 년도
	CRE_TERM        VARCHAR(2)   NULL     COMMENT '과정 학기', -- 과정 학기
	DECLS_NO        VARCHAR(3)   NULL     COMMENT '분반 번호', -- 분반 번호
	UNI_CD          VARCHAR(1)   NULL     COMMENT '대학 코드', -- 대학 코드
	CRS_CRE_NM      VARCHAR(200) NULL     COMMENT '과정개설 명', -- 과정개설 명
	USER_ID         VARCHAR(30)  NULL     COMMENT '사용자 번호', -- 사용자 번호
	CMPL_WEEK_CNT   INT          NULL     DEFAULT 0 COMMENT '학습 주차수', -- 학습 주차수
	TOT_WEEK_CNT    INT          NULL     DEFAULT 0 COMMENT '전체 주차수', -- 전체 주차수
	PROG_RATIO      VARCHAR(20)  NULL     COMMENT '진도율', -- 진도율
	CORS_URL        VARCHAR(500) NULL     COMMENT '강의실 URL', -- 강의실 URL
	HY              VARCHAR(1)   NULL     COMMENT '학년', -- 학년
	REG_DTTM        VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MOD_DTTM        VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 학습 진도율';

-- (통계) 학습 진도율
ALTER TABLE tb_learner_prog
	ADD CONSTRAINT PK_tb_learner_prog -- PK_tb_learner_prog
		PRIMARY KEY (
			LEARNER_PROG_ID -- 진도율 통계 ID
		);

-- IX_tb_learner_prog
CREATE INDEX IX_tb_learner_prog
	ON tb_learner_prog( -- (통계) 학습 진도율
		CRS_CRE_CD ASC, -- 과정개설 코드
		CRE_YEAR ASC,   -- 과정 년도
		CRE_TERM ASC,   -- 과정 학기
		DECLS_NO ASC,   -- 분반 번호
		USER_ID ASC     -- 사용자 번호
	);

-- (통계) 주차별 진도율
CREATE TABLE tb_learner_week_prog (
	LEARNER_WEEK_PROG_ID  VARCHAR(50)  NOT NULL COMMENT '주차별 진도율 통계 ID', -- 주차별 진도율 통계 ID
	CRS_CRE_CD            VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	CRE_YEAR              VARCHAR(4)   NULL     COMMENT '과정 년도', -- 과정 년도
	CRE_YEAR2             VARCHAR(4)   NULL     COMMENT '과정 년도2', -- 과정 년도2
	CRE_TERM              VARCHAR(2)   NULL     COMMENT '과정 학기', -- 과정 학기
	DECLS_NO              VARCHAR(3)   NULL     COMMENT '분반 번호', -- 분반 번호
	UNI_CD                VARCHAR(1)   NULL     COMMENT '대학 코드', -- 대학 코드
	CRS_CRE_NM            VARCHAR(200) NULL     COMMENT '과정개설 명', -- 과정개설 명
	USER_ID               VARCHAR(30)  NULL     COMMENT '사용자 번호', -- 사용자 번호
	LESSON_SCHEDULE_ORDER INT          NOT NULL COMMENT '학습 일정 순서', -- 학습 일정 순서
	HY                    VARCHAR(1)   NULL     COMMENT '학년', -- 학년
	PROG_RATIO            VARCHAR(20)  NULL     COMMENT '진도율', -- 진도율
	REG_DTTM              VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MOD_DTTM              VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 주차별 진도율';

-- (통계) 주차별 진도율
ALTER TABLE tb_learner_week_prog
	ADD CONSTRAINT PK_tb_learner_week_prog -- PK_tb_learner_week_prog
		PRIMARY KEY (
			LEARNER_WEEK_PROG_ID -- 주차별 진도율 통계 ID
		);

-- IX_tb_learner_week_prog
CREATE INDEX IX_tb_learner_week_prog
	ON tb_learner_week_prog( -- (통계) 주차별 진도율
		CRS_CRE_CD ASC, -- 과정개설 코드
		CRE_YEAR ASC,   -- 과정 년도
		CRE_YEAR2 ASC,  -- 과정 년도2
		DECLS_NO ASC,   -- 분반 번호
		USER_ID ASC     -- 사용자 번호
	);

-- (과제) 과제 정보
CREATE TABLE tb_lms_asmnt (
	ASMNT_CD           VARCHAR(30)  NOT NULL COMMENT '과제 코드', -- 과제 코드
	CRS_CRE_CD         VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	ASMNT_CTGR_CD      VARCHAR(30)  NULL     COMMENT '과제 분류 코드', -- 과제 분류 코드
	ASMNT_TITLE        VARCHAR(200) NOT NULL COMMENT '과제 제목', -- 과제 제목
	ASMNT_CTS          LONGTEXT     NULL     COMMENT '과제 내용', -- 과제 내용
	SEND_START_DTTM    VARCHAR(14)  NULL     COMMENT '과제 시작 일시', -- 과제 시작 일시
	SEND_END_DTTM      VARCHAR(14)  NULL     COMMENT '과제 종료 일시', -- 과제 종료 일시
	PRTC_YN            CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '실기과제 여부', -- 실기과제 여부
	SEND_TYPE          CHAR(1)      NULL     COMMENT '제출 유형', -- 제출 유형
	SBMT_FILE_TYPE     VARCHAR(30)  NULL     COMMENT '제출 파일 형식', -- 제출 파일 형식
	ASMNT_OPEN_YN      CHAR(1)      NULL     COMMENT '과제 공개 여부', -- 과제 공개 여부
	EXT_SEND_ACPT_YN   CHAR(1)      NULL     COMMENT '연장 제출 허용 여부', -- 연장 제출 허용 여부
	EXT_SEND_DTTM      VARCHAR(14)  NULL     COMMENT '연장 제출 일시', -- 연장 제출 일시
	TEAM_ASMNT_CFG_YN  CHAR(1)      NULL     COMMENT '팀과제 설정 여부', -- 팀과제 설정 여부
	TEAM_CTGR_CD       VARCHAR(30)  NULL     COMMENT '팀 분류 코드', -- 팀 분류 코드
	TEAM_EVAL_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '팀내 상호평가 여부', -- 팀내 상호평가 여부
	MEMBER_SUBMIT_YN   CHAR(1)      NULL     COMMENT '팀원 제출 가능 여부', -- 팀원 제출 가능 여부
	EVAL_USE_YN        CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '평가 사용 여부', -- 평가 사용 여부
	EVAL_START_DTTM    VARCHAR(14)  NULL     COMMENT '평가 시작 일시', -- 평가 시작 일시
	EVAL_END_DTTM      VARCHAR(14)  NULL     COMMENT '평가 종료 일시', -- 평가 종료 일시
	EVAL_CTGR          CHAR(1)      NULL     COMMENT '평가 방식', -- 평가 방식
	EVAL_RSLT_OPEN_YN  CHAR(1)      NULL     COMMENT '평가 결과 공개 여부', -- 평가 결과 공개 여부
	EVAL_CRIT_USE_YN   CHAR(1)      NULL     COMMENT '평가 기준 사용 여부', -- 평가 기준 사용 여부
	SCORE_APLY_YN      CHAR(1)      NULL     COMMENT '성적 반영 여부', -- 성적 반영 여부
	SCORE_RATIO        INT          NULL     COMMENT '성적 반영 비율', -- 성적 반영 비율
	SCORE_OPEN_YN      CHAR(1)      NULL     COMMENT '성적 공개 여부', -- 성적 공개 여부
	VIEW_SCORE_DTTM    VARCHAR(14)  NULL     COMMENT '성적 조회 가능 일시', -- 성적 조회 가능 일시
	AVG_OPEN_YN        CHAR(1)      NULL     COMMENT '평균 점수 공개 여부', -- 평균 점수 공개 여부
	DECLS_REG_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '분반 등록 여부', -- 분반 등록 여부
	PUSH_NOTICE_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '푸시 알림 여부', -- 푸시 알림 여부
	SBMT_OPEN_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '제출과제 타학생 공개 여부', -- 제출과제 타학생 공개 여부
	SBMT_START_DTTM    VARCHAR(14)  NULL     COMMENT '제출과제 타학생 공개 시작 일시', -- 제출과제 타학생 공개 시작 일시
	SBMT_END_DTTM      VARCHAR(14)  NULL     COMMENT '제출과제 타학생 공개 종료 일시', -- 제출과제 타학생 공개 종료 일시
	IND_YN             CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '개별과제 여부', -- 개별과제 여부
	RESEND_START_DTTM  VARCHAR(14)  NULL     COMMENT '재제출 시작 일시', -- 재제출 시작 일시
	RESEND_END_DTTM    VARCHAR(14)  NULL     COMMENT '재제출 종료 일시', -- 재제출 종료 일시
	RESCORE_RATIO      INT          NULL     COMMENT '재제출 성적 반영 비율', -- 재제출 성적 반영 비율
	LESSON_SCHEDULE_ID VARCHAR(30)  NULL     COMMENT '학습 일정 ID', -- 학습 일정 ID
	DEL_YN             CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	REG_YN             CHAR(1)      NULL     COMMENT '등록 여부', -- 등록 여부
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 정보';

-- (과제) 과제 정보
ALTER TABLE tb_lms_asmnt
	ADD CONSTRAINT PK_tb_lms_asmnt -- PK_tb_lms_asmnt
		PRIMARY KEY (
			ASMNT_CD -- 과제 코드
		);

-- IX_(과제) 과제 정보
CREATE INDEX IX_tb_lms_asmnt
	ON tb_lms_asmnt( -- (과제) 과제 정보
		LESSON_SCHEDULE_ID ASC -- 학습 일정 ID
	);

-- (과제) 과제 코멘트
CREATE TABLE tb_lms_asmnt_cmnt (
	CMNT_ID     VARCHAR(30) NOT NULL COMMENT '댓글 ID', -- 댓글 ID
	ASMNT_CD    VARCHAR(30) NOT NULL COMMENT '과제 코드', -- 과제 코드
	STD_NO      VARCHAR(40) NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	CRS_CRE_CD  VARCHAR(30) NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	PAR_CMNT_ID VARCHAR(30) NULL     COMMENT '상위 댓글 ID', -- 상위 댓글 ID
	CMNT_CTS    LONGTEXT    NULL     COMMENT '댓글 내용', -- 댓글 내용
	DEL_YN      CHAR(1)     NULL     COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID      VARCHAR(30) NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14) NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 코멘트';

-- (과제) 과제 코멘트
ALTER TABLE tb_lms_asmnt_cmnt
	ADD CONSTRAINT PK_tb_lms_asmnt_cmnt -- PK_tb_lms_asmnt_cmnt
		PRIMARY KEY (
			CMNT_ID,  -- 댓글 ID
			ASMNT_CD, -- 과제 코드
			STD_NO    -- 수강생 번호
		);

-- (과제) 개설과정 과제 연결
CREATE TABLE tb_lms_asmnt_cre_crs_rltn (
	CRS_CRE_CD VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	ASMNT_CD   VARCHAR(30) NOT NULL COMMENT '과제 코드', -- 과제 코드
	GRP_CD     VARCHAR(30) NULL     COMMENT '그룹 코드', -- 그룹 코드
	DEL_YN     CHAR(1)     NULL     DEFAULT 'N' COMMENT '삭제 여부' -- 삭제 여부
)
COMMENT '(과제) 개설과정 과제 연결';

-- (과제) 개설과정 과제 연결
ALTER TABLE tb_lms_asmnt_cre_crs_rltn
	ADD CONSTRAINT PK_tb_lms_asmnt_cre_crs_rltn -- PK_tb_lms_asmnt_cre_crs_rltn
		PRIMARY KEY (
			CRS_CRE_CD, -- 과정개설 코드
			ASMNT_CD    -- 과제 코드
		);

-- (과제) 과제 피드백
CREATE TABLE tb_lms_asmnt_fdbk (
	ASMNT_FDBK_CD     VARCHAR(30)  NOT NULL COMMENT '과제 피드백 코드', -- 과제 피드백 코드
	PAR_ASMNT_FDBK_CD VARCHAR(30)  NULL     COMMENT '상위 과제 피드백 코드', -- 상위 과제 피드백 코드
	ASMNT_CD          VARCHAR(30)  NULL     COMMENT '과제 코드', -- 과제 코드
	FDBK_TGT_CD       VARCHAR(30)  NOT NULL DEFAULT 'std' COMMENT '피드백 대상 코드', -- 피드백 대상 코드
	STD_NO            VARCHAR(40)  NULL     COMMENT '수강생 번호', -- 수강생 번호
	TEAM_CD           VARCHAR(30)  NULL     COMMENT '팀 코드', -- 팀 코드
	FDBK_CTS          LONGTEXT     NULL     COMMENT '피드백 내용', -- 피드백 내용
	DEL_YN            CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	REG_NM            VARCHAR(100) NULL     COMMENT '등록자 이름', -- 등록자 이름
	RGTR_ID            VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 피드백';

-- (과제) 과제 피드백
ALTER TABLE tb_lms_asmnt_fdbk
	ADD CONSTRAINT PK_tb_lms_asmnt_fdbk -- PK_tb_lms_asmnt_fdbk
		PRIMARY KEY (
			ASMNT_FDBK_CD -- 과제 피드백 코드
		);

-- (과제) 과제 참여자 이력
CREATE TABLE tb_lms_asmnt_join_hsty (
	HSTY_CD        VARCHAR(30)   NOT NULL COMMENT '이력 코드', -- 이력 코드
	ASMNT_SEND_CD  VARCHAR(30)   NOT NULL COMMENT '과제 제출 코드', -- 과제 제출 코드
	ASMNT_CD       VARCHAR(30)   NOT NULL COMMENT '과제 코드', -- 과제 코드
	STD_NO         VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	TEAM_CD        VARCHAR(30)   NULL     COMMENT '팀 코드', -- 팀 코드
	SEND_CTS       LONGTEXT      NULL     COMMENT '제출 내용', -- 제출 내용
	SBMT_FILE_INFO VARCHAR(2000) NULL     COMMENT '제출 파일 정보', -- 제출 파일 정보
	CONN_IP        VARCHAR(50)   NULL     COMMENT '접속 IP', -- 접속 IP
	RGTR_ID         VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 참여자 이력';

-- (과제) 과제 참여자 이력
ALTER TABLE tb_lms_asmnt_join_hsty
	ADD CONSTRAINT PK_tb_lms_asmnt_join_hsty -- PK_tb_lms_asmnt_join_hsty
		PRIMARY KEY (
			HSTY_CD -- 이력 코드
		);

-- (과제) 과제 참여자
CREATE TABLE tb_lms_asmnt_join_user (
	ASMNT_SEND_CD          VARCHAR(30)   NOT NULL COMMENT '과제 제출 코드', -- 과제 제출 코드
	ASMNT_CD               VARCHAR(30)   NOT NULL COMMENT '과제 코드', -- 과제 코드
	STD_NO                 VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	JOIN_TYPE              VARCHAR(30)   NOT NULL DEFAULT 'std' COMMENT '참여 유형', -- 참여 유형
	TEAM_CD                VARCHAR(30)   NULL     COMMENT '팀 코드', -- 팀 코드
	SEND_CTS               LONGTEXT      NULL     COMMENT '제출 내용', -- 제출 내용
	SEND_TEXT              LONGTEXT      NULL     COMMENT '제출 텍스트', -- 제출 텍스트
	SCORE                  DECIMAL(5,2)  NULL     COMMENT '점수', -- 점수
	ASMNT_SUBMIT_STATUS_CD VARCHAR(30)   NULL     COMMENT '과제 제출 상태 코드', -- 과제 제출 상태 코드
	SEND_CNT               INT           NULL     COMMENT '제출 횟수', -- 제출 횟수
	CONN_IP                VARCHAR(50)   NULL     COMMENT '접속 IP', -- 접속 IP
	EVAL_YN                CHAR(1)       NOT NULL COMMENT '평가 여부', -- 평가 여부
	PROF_MEMO              VARCHAR(2000) NULL     COMMENT '교수 메모', -- 교수 메모
	DEL_YN                 CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	BEST_YN                CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '우수 과제 여부', -- 우수 과제 여부
	RESEND_YN              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '재제출 여부', -- 재제출 여부
	KONAN_COMP_DT          VARCHAR(14)   NULL     COMMENT '모사 비교 일시', -- 모사 비교 일시
	KONAN_MAX_COPY_RATE    DECIMAL(5,2)  NULL     COMMENT '모사율', -- 모사율
	KONAN_MAX_COPY_ID      VARCHAR(100)  NULL     COMMENT '모사 참조 ID', -- 모사 참조 ID
	RGTR_ID                 VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM               VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                 VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM               VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 참여자';

-- (과제) 과제 참여자
ALTER TABLE tb_lms_asmnt_join_user
	ADD CONSTRAINT PK_tb_lms_asmnt_join_user -- PK_tb_lms_asmnt_join_user
		PRIMARY KEY (
			ASMNT_SEND_CD -- 과제 제출 코드
		);

-- (과제) 과제 상호평가
CREATE TABLE tb_lms_asmnt_mut_eval (
	ASMNT_SEND_CD VARCHAR(30)   NULL     COMMENT '과제 제출 코드', -- 과제 제출 코드
	ASMNT_CD      VARCHAR(30)   NULL     COMMENT '과제 코드', -- 과제 코드
	SCORE         DECIMAL(5,2)  NULL     COMMENT '점수', -- 점수
	SCORE_CMNT    VARCHAR(2000) NULL     COMMENT '코멘트', -- 코멘트
	RGTR_ID        VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 상호평가';

-- (과제) 과제 상호평가 결과
CREATE TABLE tb_lms_asmnt_mut_eval_rslt (
	MUT_EVAL_CD VARCHAR(30) NOT NULL COMMENT '상호평가 코드', -- 상호평가 코드
	EVAL_CD     VARCHAR(30) NOT NULL COMMENT '평가 코드', -- 평가 코드
	RLTN_CD     VARCHAR(30) NOT NULL COMMENT '연결 코드', -- 연결 코드
	STD_NO      VARCHAR(40) NULL     COMMENT '수강생 번호', -- 수강생 번호
	EVAL_DTTM   VARCHAR(14) NULL     COMMENT '평가 일시', -- 평가 일시
	QSTN_CD     VARCHAR(30) NULL     COMMENT '문제 코드', -- 문제 코드
	GRADE_CD    VARCHAR(30) NULL     COMMENT '등급 코드', -- 등급 코드
	EVAL_SCORE  INT         NULL     COMMENT '평가 점수', -- 평가 점수
	RGTR_ID      VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 상호평가 결과';

-- (과제) 과제 상호평가 결과
ALTER TABLE tb_lms_asmnt_mut_eval_rslt
	ADD CONSTRAINT PK_tb_lms_asmnt_mut_eval_rslt -- PK_tb_lms_asmnt_mut_eval_rslt
		PRIMARY KEY (
			MUT_EVAL_CD, -- 상호평가 코드
			EVAL_CD,     -- 평가 코드
			RLTN_CD      -- 연결 코드
		);

-- IX_(과제) 과제 상호평가 결과
CREATE INDEX IX_tb_lms_asmnt_mut_eval_rslt
	ON tb_lms_asmnt_mut_eval_rslt( -- (과제) 과제 상호평가 결과
		EVAL_CD ASC, -- 평가 코드
		RLTN_CD ASC  -- 연결 코드
	);

-- (과제) 과제 제출 파일
CREATE TABLE tb_lms_asmnt_sbmt_file (
	ASMNT_CD      VARCHAR(30) NOT NULL COMMENT '과제 코드', -- 과제 코드
	ASMNT_SEND_CD VARCHAR(30) NOT NULL COMMENT '과제 제출 코드', -- 과제 제출 코드
	TEAM_CD       VARCHAR(30) NULL     COMMENT '팀 코드', -- 팀 코드
	FILE_SN       VARCHAR(30) NOT NULL COMMENT '파일 번호', -- 파일 번호
	RGTR_ID        VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과제) 과제 제출 파일';

-- (과제) 과제 제출 파일
ALTER TABLE tb_lms_asmnt_sbmt_file
	ADD CONSTRAINT PK_tb_lms_asmnt_sbmt_file -- PK_tb_lms_asmnt_sbmt_file
		PRIMARY KEY (
			ASMNT_CD,      -- 과제 코드
			ASMNT_SEND_CD  -- 과제 제출 코드
		);

-- (기타) 학업코치
CREATE TABLE tb_lms_coach (
	USER_ID        VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	YY             VARCHAR(4)   NOT NULL COMMENT '년', -- 년
	TM_GBN         VARCHAR(8)   NOT NULL COMMENT '학기 구분', -- 학기 구분
	TM_GBN_NM      VARCHAR(200) NULL     COMMENT '학기 구분 명', -- 학기 구분 명
	ECSHG_COACH_NO VARCHAR(10)  NULL     COMMENT '전담코드 사번', -- 전담코드 사번
	COACH_NM       VARCHAR(100) NULL     COMMENT '코치 명', -- 코치 명
	COUNSL_GVUP_YN CHAR(1)      NULL     COMMENT '상담 포기 구분', -- 상담 포기 구분
	INSERT_AT      DATETIME     NULL     COMMENT '등록 날짜 시간', -- 등록 날짜 시간
	MODIFY_AT      DATETIME     NULL     COMMENT '수정 날짜 시간' -- 수정 날짜 시간
)
COMMENT '(기타) 학업코치';

-- (기타) 학업코치
ALTER TABLE tb_lms_coach
	ADD CONSTRAINT PK_tb_lms_coach -- PK_tb_lms_coach
		PRIMARY KEY (
			USER_ID, -- 사용자 번호
			YY,      -- 년
			TM_GBN   -- 학기 구분
		);

-- (과정) 개설과정
CREATE TABLE tb_lms_cre_crs (
	CRS_CRE_CD             VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	CRS_CD                 VARCHAR(30)   NOT NULL COMMENT '과정 코드', -- 과정 코드
	CRS_CRE_NM             VARCHAR(200)  NOT NULL COMMENT '과정개설 명', -- 과정개설 명
	CRS_CRE_NM_ENG         VARCHAR(200)  NULL     COMMENT '과정개설 명_영문', -- 과정개설 명_영문
	CRE_YEAR               VARCHAR(4)    NULL     COMMENT '과정 년도', -- 과정 년도
	CRE_TERM               VARCHAR(2)    NULL     COMMENT '과정 학기', -- 과정 학기
	DECLS_NO               VARCHAR(3)    NOT NULL COMMENT '분반 번호', -- 분반 번호
	CRS_CRE_DESC           LONGTEXT      NULL     COMMENT '과정개설 설명', -- 과정개설 설명
	CRS_OPER_TYPE_CD       VARCHAR(30)   NULL     DEFAULT 'ONLINE' COMMENT '과정 운영 유형 코드', -- 과정 운영 유형 코드
	DEPT_CD                VARCHAR(30)   NULL     COMMENT '부서 코드', -- 부서 코드
	MNGT_DEPT_CD           VARCHAR(30)   NULL     COMMENT '관장학과 코드', -- 관장학과 코드
	CREDIT                 DECIMAL(5,2)  NULL     COMMENT '학점', -- 학점
	COMP_DV_CD             VARCHAR(30)   NULL     COMMENT '이수구분 코드', -- 이수구분 코드
	CPTN_GBN_NM            VARCHAR(100)  NOT NULL DEFAULT '기타' COMMENT '이수구분 명', -- 이수구분 명
	PROGRESS_TYPE_CD       VARCHAR(30)   NOT NULL DEFAULT 'TOPIC' COMMENT '강의형식 코드', -- 강의형식 코드
	LEARNING_CONTROL       VARCHAR(10)   NULL     DEFAULT 'DATE' COMMENT '학습 제어', -- 학습 제어
	MID_ATTEND_CHK_USE_YN  CHAR(1)       NULL     COMMENT '중간 출석 체크 여부', -- 중간 출석 체크 여부
	CERT_YN                CHAR(1)       NULL     DEFAULT 'N' COMMENT '수료증 출력 여부', -- 수료증 출력 여부
	CERT_SCORE_YN          CHAR(1)       NULL     DEFAULT 'N' COMMENT '수료증 조건', -- 수료증 조건
	CPLT_HANDL_TYPE        VARCHAR(10)   NULL     COMMENT '수료 처리 형태', -- 수료 처리 형태
	CPLT_SCORE             INT           NULL     COMMENT '수료 점수', -- 수료 점수
	CERT_SCORE_DEL         INT           NULL     COMMENT '수료 점수_DEL', -- 수료 점수_DEL
	ATTD_RATIO_DEL         INT           NULL     COMMENT '출석 비율 삭제_DEL', -- 출석 비율 삭제_DEL
	ASMT_RATIO_DEL         INT           NULL     COMMENT '과제 비율 삭제_DEL', -- 과제 비율 삭제_DEL
	FORUM_RATIO_DEL        INT           NULL     COMMENT '토론 비율 삭제_DEL', -- 토론 비율 삭제_DEL
	EXAM_RATIO_DEL         INT           NULL     COMMENT '시험 비율_삭제', -- 시험 비율_삭제
	PROJ_RATIO_DEL         INT           NULL     COMMENT '팀활동 비율 삭제_DEL', -- 팀활동 비율 삭제_DEL
	ETC_RATIO_DEL          INT           NULL     COMMENT '기타 비율 삭제_DEL', -- 기타 비율 삭제_DEL
	ENRL_APLC_MTHD         VARCHAR(10)   NULL     COMMENT '수강 신청 방법', -- 수강 신청 방법
	NOP_LIMIT_YN           CHAR(1)       NULL     COMMENT '인원 제한 여부', -- 인원 제한 여부
	ENRL_NOP               INT           NULL     COMMENT '수강 인원', -- 수강 인원
	ENRL_CERT_STATUS       VARCHAR(10)   NULL     DEFAULT 'NORMAL' COMMENT '수강 인증 상태', -- 수강 인증 상태
	ENRL_APLC_START_DTTM   VARCHAR(14)   NULL     COMMENT '수강 신청 시작 일시', -- 수강 신청 시작 일시
	ENRL_APLC_END_DTTM     VARCHAR(14)   NULL     COMMENT '수강 신청 종료 일시', -- 수강 신청 종료 일시
	ENRL_START_DTTM        VARCHAR(14)   NULL     COMMENT '수강 시작 일시', -- 수강 시작 일시
	ENRL_END_DTTM          VARCHAR(14)   NULL     COMMENT '수강 종료 일시', -- 수강 종료 일시
	AUDIT_END_DTTM         VARCHAR(14)   NULL     COMMENT '청강 종료 일시', -- 청강 종료 일시
	SCORE_HANDL_START_DTTM VARCHAR(14)   NULL     COMMENT '성적 처리 시작 일시', -- 성적 처리 시작 일시
	SCORE_HANDL_END_DTTM   VARCHAR(14)   NULL     COMMENT '성적 처리 종료 일시', -- 성적 처리 종료 일시
	SCORE_OPEN_YN          CHAR(1)       NULL     COMMENT '성적 공개 여부', -- 성적 공개 여부
	SCORE_OPEN_DTTM        VARCHAR(14)   NULL     COMMENT '성적 공개 일시', -- 성적 공개 일시
	SCORE_VIEW_RESCH_YN    CHAR(1)       NULL     COMMENT '성적 조회 설문 여부', -- 성적 조회 설문 여부
	SCORE_VIEW_RESCH_CD    VARCHAR(30)   NULL     COMMENT '성적 조회 설문 코드', -- 성적 조회 설문 코드
	USE_YN                 CHAR(1)       NULL     COMMENT '사용 여부', -- 사용 여부
	HAKSA_DATA_YN          CHAR(1)       NULL     COMMENT '학사 자료 여부', -- 학사 자료 여부
	KEYWORD                VARCHAR(2000) NULL     COMMENT '키워드', -- 키워드
	DEL_YN                 CHAR(1)       NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	UNI_CD                 VARCHAR(1)    NOT NULL DEFAULT 'C' COMMENT '대학 코드', -- 대학 코드
	REVIEW_STATUS          VARCHAR(30)   NULL     DEFAULT '1' COMMENT '복습기간 상태', -- 복습기간 상태
	REVIEW_START_DTTM      VARCHAR(14)   NULL     COMMENT '복습시간 시작 일시', -- 복습시간 시작 일시
	REVIEW_END_DTTM        VARCHAR(14)   NULL     COMMENT '복습기간 종료 일시', -- 복습기간 종료 일시
	CRS_TYPE_CD            VARCHAR(30)   NOT NULL DEFAULT 'UNI' COMMENT '과정 유형 코드', -- 과정 유형 코드
	ALL_LESSON_OPEN_YN     CHAR(1)       NULL     DEFAULT 'N' COMMENT '모든주차 오픈 여부', -- 모든주차 오픈 여부
	GRDT_SC_YN             CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '졸업과목 여부', -- 졸업과목 여부
	TMSW_PRE_SC_YN         CHAR(1)       NULL     DEFAULT 'N' COMMENT '선수과목 여부', -- 선수과목 여부
	LCDMS_LINK_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT 'LCDMS 연동 여부', -- LCDMS 연동 여부
	ERP_LESSON_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT 'ERP 주차 연동 여부', -- ERP 주차 연동 여부
	UNIV_GBN               VARCHAR(10)   NULL     COMMENT '대학교 구분', -- 대학교 구분
	TMSW_PRE_TRANS_YN      CHAR(1)       NULL     COMMENT '선수과목 이전 여부', -- 선수과목 이전 여부
	RGTR_ID                 VARCHAR(30)   NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM               VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                 VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM               VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 개설과정';

-- (과정) 개설과정
ALTER TABLE tb_lms_cre_crs
	ADD CONSTRAINT PK_tb_lms_cre_crs -- PK_tb_lms_cre_crs
		PRIMARY KEY (
			CRS_CRE_CD -- 과정개설 코드
		);

-- IX_(과정) 개설과정
CREATE INDEX IX_tb_lms_cre_crs
	ON tb_lms_cre_crs( -- (과정) 개설과정
		CRS_CRE_NM ASC -- 과정개설 명
	);

-- IX_(과정) 개설과정2
CREATE INDEX IX_tb_lms_cre_crs2
	ON tb_lms_cre_crs( -- (과정) 개설과정
		CRE_YEAR ASC, -- 과정 년도
		CRE_TERM ASC  -- 과정 학기
	);

-- (과정) 개설과정 평가 방법
CREATE TABLE tb_lms_cre_crs_eval (
	CRS_CRE_CD       VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	SCORE_EVAL_TYPE  VARCHAR(10)  NULL     DEFAULT 'ABSOLUTE' COMMENT '성적 평가 유형', -- 성적 평가 유형
	SCORE_GRADE_TYPE VARCHAR(10)  NULL     DEFAULT 'FIXED' COMMENT '성적 등급 유형', -- 성적 등급 유형
	PASS_SCORE       DECIMAL(5,2) NULL     COMMENT '통과 점수', -- 통과 점수
	FIXED_A          INT          NULL     COMMENT '고정등급 A', -- 고정등급 A
	FIXED_B          INT          NULL     COMMENT '고정등급 B', -- 고정등급 B
	FIXED_C          INT          NULL     COMMENT '고정등급 C', -- 고정등급 C
	FIXED_D          INT          NULL     COMMENT '고정등급 D', -- 고정등급 D
	FIXED_F          INT          NULL     COMMENT '고정등급 F', -- 고정등급 F
	RATIO_A1         INT          NULL     COMMENT '비율등급 A+', -- 비율등급 A+
	RATIO_A2         INT          NULL     COMMENT '비율등급 A', -- 비율등급 A
	RATIO_B          INT          NULL     COMMENT '비율등급 B' -- 비율등급 B
)
COMMENT '(과정) 개설과정 평가 방법';

-- (과정) 개설과정 평가 방법
ALTER TABLE tb_lms_cre_crs_eval
	ADD CONSTRAINT PK_tb_lms_cre_crs_eval -- PK_tb_lms_cre_crs_eval
		PRIMARY KEY (
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 개설과정 파일 용량 제한
CREATE TABLE tb_lms_cre_crs_file_size_limit (
	CRS_CRE_CD       VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	BBS_LIMIT_SIZE   INT         NULL     COMMENT '게시판 용량 제한', -- 게시판 용량 제한
	ASMT_LIMIT_SIZE  INT         NULL     COMMENT '과제 용량 제한', -- 과제 용량 제한
	EXAM_LIMIT_SIZE  INT         NULL     COMMENT '시험 용량 제한', -- 시험 용량 제한
	FORUM_LIMIT_SIZE INT         NULL     COMMENT '토론 용량 제한', -- 토론 용량 제한
	TEAM_LIMIT_SIZE  INT         NULL     COMMENT '팀활동 용량 제한', -- 팀활동 용량 제한
	LEC_LIMIT_SIZE   INT         NULL     COMMENT '강의 제한 크기', -- 강의 제한 크기
	RGTR_ID           VARCHAR(30) NULL     DEFAULT 'NULL' COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14) NULL     DEFAULT 'NULL' COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30) NULL     DEFAULT 'NULL' COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14) NULL     DEFAULT 'NULL' COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 개설과정 파일 용량 제한';

-- (과정) 개설과정 파일 용량 제한
ALTER TABLE tb_lms_cre_crs_file_size_limit
	ADD CONSTRAINT PK_tb_lms_cre_crs_file_size_limit -- PK_tb_lms_cre_crs_file_size_limit
		PRIMARY KEY (
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 개설과정 주차 일정
CREATE TABLE tb_lms_cre_crs_lesson_plan (
	CRS_CRE_CD      VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	LESSON_ORDER    INT           NOT NULL COMMENT '학습 목차 순서', -- 학습 목차 순서
	START_DT        VARCHAR(8)    NOT NULL COMMENT '시작 일자', -- 시작 일자
	END_DT          VARCHAR(8)    NOT NULL COMMENT '종료 일자', -- 종료 일자
	LESSON_OBJECT   VARCHAR(2000) NULL     COMMENT '학습 목표', -- 학습 목표
	LESSON_CONTENTS LONGTEXT      NULL     COMMENT '학습 내용', -- 학습 내용
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 개설과정 주차 일정';

-- (과정) 개설과정 주차 일정
ALTER TABLE tb_lms_cre_crs_lesson_plan
	ADD CONSTRAINT PK_tb_lms_cre_crs_lesson_plan -- PK_tb_lms_cre_crs_lesson_plan
		PRIMARY KEY (
			CRS_CRE_CD,   -- 과정개설 코드
			LESSON_ORDER  -- 학습 목차 순서
		);

-- (과정) 개설과정 성적 평가 구분
CREATE TABLE tb_lms_cre_crs_score_gbn (
	CRS_CRE_CD      VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	SCORE_EVAL_GBN  VARCHAR(10) NOT NULL COMMENT '평가 구분', -- 평가 구분
	SCORE_GRANT_GBN VARCHAR(10) NOT NULL COMMENT '성적 부여 방법', -- 성적 부여 방법
	RGTR_ID          VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 개설과정 성적 평가 구분';

-- (과정) 개설과정 성적 평가 구분
ALTER TABLE tb_lms_cre_crs_score_gbn
	ADD CONSTRAINT PK_tb_lms_cre_crs_score_gbn -- PK_tb_lms_cre_crs_score_gbn
		PRIMARY KEY (
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 개설과정 강사 연결
CREATE TABLE tb_lms_cre_crs_tch_rltn (
	CRS_CRE_CD VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	USER_ID    VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	TCH_TYPE   VARCHAR(30) NOT NULL COMMENT '강사 유형', -- 강사 유형
	REP_YN     CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '대표 여부', -- 대표 여부
	HAKSA_YN   CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '학사 데이터 여부', -- 학사 데이터 여부
	RGTR_ID     VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM   VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID     VARCHAR(30) NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM   VARCHAR(14) NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 개설과정 강사 연결';

-- (과정) 개설과정 강사 연결
ALTER TABLE tb_lms_cre_crs_tch_rltn
	ADD CONSTRAINT PK_tb_lms_cre_crs_tch_rltn -- PK_tb_lms_cre_crs_tch_rltn
		PRIMARY KEY (
			CRS_CRE_CD, -- 과정개설 코드
			USER_ID     -- 사용자 번호
		);

-- (과정) 과정 테마 분류
CREATE TABLE tb_lms_cre_tm_ctgr (
	CRE_TM_CTGR_CD     VARCHAR(30)   NOT NULL COMMENT '테마 분류 코드', -- 테마 분류 코드
	ORG_ID             VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	PAR_CRE_TM_CTGR_CD VARCHAR(30)   NULL     COMMENT '상위 테마 분류 코드', -- 상위 테마 분류 코드
	CRE_TM_CTGR_NM     VARCHAR(200)  NULL     COMMENT '테마 분류 명', -- 테마 분류 명
	CRE_TM_CTGR_DESC   VARCHAR(2000) NULL     COMMENT '테마 분류 설명', -- 테마 분류 설명
	CRE_TM_CTGR_LVL    INT           NULL     COMMENT '테마 분류 레벨', -- 테마 분류 레벨
	CRE_TM_CTGR_ODR    INT           NULL     COMMENT '테마 분류 순서', -- 테마 분류 순서
	USE_YN             CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	RGTR_ID             VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 과정 테마 분류';

-- (과정) 과정 테마 분류
ALTER TABLE tb_lms_cre_tm_ctgr
	ADD CONSTRAINT PK_tb_lms_cre_tm_ctgr -- PK_tb_lms_cre_tm_ctgr
		PRIMARY KEY (
			CRE_TM_CTGR_CD -- 테마 분류 코드
		);

-- (과정) 과정
CREATE TABLE tb_lms_crs (
	CRS_CD           VARCHAR(30)  NOT NULL COMMENT '과정 코드', -- 과정 코드
	CRS_CTGR_CD      VARCHAR(30)  NULL     COMMENT '과정 분류 코드', -- 과정 분류 코드
	CRE_TM_CTGR_CD   VARCHAR(30)  NULL     COMMENT '테마 분류 코드', -- 테마 분류 코드
	ORG_ID           VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	CRS_TYPE_CD      VARCHAR(30)  NULL     COMMENT '과정 유형 코드', -- 과정 유형 코드
	CRS_OPER_TYPE_CD VARCHAR(30)  NULL     COMMENT '과정 운영 유형 코드', -- 과정 운영 유형 코드
	CRS_NM           VARCHAR(200) NOT NULL COMMENT '과정 명', -- 과정 명
	CRS_DESC         LONGTEXT     NULL     COMMENT '과정 설명', -- 과정 설명
	ENRL_CERT_MTHD   VARCHAR(10)  NULL     COMMENT '수강 인증 방법', -- 수강 인증 방법
	NOP_LIMIT_YN     CHAR(1)      NULL     COMMENT '인원 제한 여부', -- 인원 제한 여부
	EDU_NOP          VARCHAR(100) NULL     COMMENT '교육 인원', -- 교육 인원
	ATTD_RATIO       INT          NULL     COMMENT '출석 비율_DEL', -- 출석 비율_DEL
	ASMT_RATIO       INT          NULL     COMMENT '과제 비율_DEL', -- 과제 비율_DEL
	FORUM_RATIO      INT          NULL     COMMENT '토론 비율_DEL', -- 토론 비율_DEL
	EXAM_RATIO       INT          NULL     COMMENT '시험 비율_DEL', -- 시험 비율_DEL
	PROJ_RATIO       INT          NULL     COMMENT '팀활동 비율_DEL', -- 팀활동 비율_DEL
	ETC_RATIO        INT          NULL     COMMENT '기타 비율_DEL', -- 기타 비율_DEL
	CPLT_SCORE       INT          NULL     COMMENT '수료 점수', -- 수료 점수
	CPLT_HANDL_TYPE  VARCHAR(10)  NULL     COMMENT '수료 처리 형태', -- 수료 처리 형태
	CERT_ISSUE_YN    CHAR(1)      NULL     COMMENT '수료증 발급 여부', -- 수료증 발급 여부
	USE_YN           CHAR(1)      NULL     COMMENT '사용 여부', -- 사용 여부
	DEL_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID           VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14)  NULL     COMMENT '수정 일시', -- 수정 일시
	CRS_NO           VARCHAR(30)  NULL     COMMENT '학수 번호' -- 학수 번호
)
COMMENT '(과정) 과정';

-- (과정) 과정
ALTER TABLE tb_lms_crs
	ADD CONSTRAINT PK_tb_lms_crs -- PK_tb_lms_crs
		PRIMARY KEY (
			CRS_CD -- 과정 코드
		);

-- IX_(과정) 과정
CREATE INDEX IX_tb_lms_crs
	ON tb_lms_crs( -- (과정) 과정
		CRE_TM_CTGR_CD ASC -- 테마 분류 코드
	);

-- IX_(과정) 과정2
CREATE INDEX IX_tb_lms_crs2
	ON tb_lms_crs( -- (과정) 과정
		CRS_CTGR_CD ASC -- 과정 분류 코드
	);

-- (과정) 개설과정 평가 비율
CREATE TABLE tb_lms_crs_cre_score_rel (
	CRS_CRE_CD VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	CALC_TYPE  VARCHAR(10)  NULL     COMMENT '계산 유형', -- 계산 유형
	RATIO_A1   DECIMAL(5,2) NULL     COMMENT '비율등급 A+', -- 비율등급 A+
	CNT_A1     INT          NULL     COMMENT '비율등급 A+ 인원수', -- 비율등급 A+ 인원수
	RATIO_A2   DECIMAL(5,2) NULL     COMMENT '비율등급 A', -- 비율등급 A
	CNT_A2     INT          NULL     COMMENT '비율등급 A 인원수', -- 비율등급 A 인원수
	RATIO_B1   DECIMAL(5,2) NULL     COMMENT '비율등급 B+', -- 비율등급 B+
	CNT_B1     INT          NULL     COMMENT '비율등급 B+ 인원수', -- 비율등급 B+ 인원수
	RATIO_B2   DECIMAL(5,2) NULL     COMMENT '비율등급 B', -- 비율등급 B
	CNT_B2     INT          NULL     COMMENT '비율등급 B 인원수', -- 비율등급 B 인원수
	RATIO_C1   DECIMAL(5,2) NULL     COMMENT '비율등급 C+', -- 비율등급 C+
	CNT_C1     INT          NULL     COMMENT '비율등급 C+ 인원수', -- 비율등급 C+ 인원수
	RATIO_C2   DECIMAL(5,2) NULL     COMMENT '비율등급 C', -- 비율등급 C
	CNT_C2     INT          NULL     COMMENT '비율등급 C 인원수', -- 비율등급 C 인원수
	RATIO_D1   DECIMAL(5,2) NULL     COMMENT '비율등급 D+', -- 비율등급 D+
	CNT_D1     INT          NULL     COMMENT '비율등급 D+ 인원수', -- 비율등급 D+ 인원수
	RATIO_D2   DECIMAL(5,2) NULL     COMMENT '비율등급 D', -- 비율등급 D
	CNT_D2     INT          NULL     COMMENT '비율등급 D 인원수', -- 비율등급 D 인원수
	RATIO_F    DECIMAL(5,2) NULL     COMMENT '비율등급 F', -- 비율등급 F
	CNT_F      INT          NULL     COMMENT '비율등급 F 인원수', -- 비율등급 F 인원수
	RGTR_ID     VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM   VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID     VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM   VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 개설과정 평가 비율';

-- (과정) 개설과정 평가 비율
ALTER TABLE tb_lms_crs_cre_score_rel
	ADD CONSTRAINT PK_tb_lms_crs_cre_score_rel -- PK_tb_lms_crs_cre_score_rel
		PRIMARY KEY (
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 과정 분류
CREATE TABLE tb_lms_crs_ctgr (
	CRS_CTGR_CD     VARCHAR(30)   NOT NULL COMMENT '과정 분류 코드', -- 과정 분류 코드
	ORG_ID          VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	PAR_CRS_CTGR_CD VARCHAR(30)   NULL     COMMENT '상위 과정 분류 코드', -- 상위 과정 분류 코드
	CRS_CTGR_NM     VARCHAR(200)  NULL     COMMENT '과정 분류 명', -- 과정 분류 명
	CRS_CTGR_DESC   VARCHAR(2000) NULL     COMMENT '강좌 분류 설명', -- 강좌 분류 설명
	CRS_CTGR_LVL    INT           NULL     COMMENT '과정 분류 레벨', -- 과정 분류 레벨
	CRS_CTGR_ODR    INT           NULL     COMMENT '과정 분류 순서', -- 과정 분류 순서
	USE_YN          CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 과정 분류';

-- (과정) 과정 분류
ALTER TABLE tb_lms_crs_ctgr
	ADD CONSTRAINT PK_tb_lms_crs_ctgr -- PK_tb_lms_crs_ctgr
		PRIMARY KEY (
			CRS_CTGR_CD -- 과정 분류 코드
		);

-- (과정) 과정 정보 콘텐츠
CREATE TABLE tb_lms_crs_info_cnts (
	CRS_CD               VARCHAR(30)  NOT NULL COMMENT '과정 코드', -- 과정 코드
	CRS_INFO_CNTS_CD     VARCHAR(30)  NOT NULL COMMENT '과정정보 콘텐츠 코드', -- 과정정보 콘텐츠 코드
	CRS_INFO_CNTS_DIV_CD VARCHAR(30)  NULL     COMMENT '과정정보 콘텐츠 구분 코드', -- 과정정보 콘텐츠 구분 코드
	CNTS_ORDER           INT          NOT NULL COMMENT '콘텐츠 순서', -- 콘텐츠 순서
	CNTS_FILE_LOC_CD     VARCHAR(30)  NULL     COMMENT '콘텐츠 파일 위치 코드', -- 콘텐츠 파일 위치 코드
	CNTS_FILE_NM         VARCHAR(200) NULL     COMMENT '콘텐츠 파일명', -- 콘텐츠 파일명
	CNTS_FILE_PATH       VARCHAR(200) NULL     COMMENT '콘텐츠 파일 경로', -- 콘텐츠 파일 경로
	CNTS_URL             VARCHAR(500) NULL     COMMENT '콘텐츠 URL', -- 콘텐츠 URL
	RGTR_ID               VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM             VARCHAR(14)  NULL     COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(과정) 과정 정보 콘텐츠';

-- (과정) 과정 정보 콘텐츠
ALTER TABLE tb_lms_crs_info_cnts
	ADD CONSTRAINT PK_tb_lms_crs_info_cnts -- PK_tb_lms_crs_info_cnts
		PRIMARY KEY (
			CRS_CD,           -- 과정 코드
			CRS_INFO_CNTS_CD  -- 과정정보 콘텐츠 코드
		);

-- (시험) 시험 정보
CREATE TABLE tb_lms_exam (
	EXAM_CD               VARCHAR(30)  NOT NULL COMMENT '시험 코드', -- 시험 코드
	EXAM_CTGR_CD          VARCHAR(30)  NOT NULL COMMENT '시험 분류 코드', -- 시험 분류 코드
	ORG_ID                VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	EXAM_TITLE            VARCHAR(200) NOT NULL COMMENT '시험 제목', -- 시험 제목
	EXAM_CTS              LONGTEXT     NULL     COMMENT '시험 내용', -- 시험 내용
	EXAM_TYPE_CD          VARCHAR(30)  NOT NULL COMMENT '시험 유형 코드', -- 시험 유형 코드
	EXAM_STARE_TYPE_CD    VARCHAR(30)  NOT NULL COMMENT '시험 응시 유형 코드', -- 시험 응시 유형 코드
	INS_REF_CD            VARCHAR(30)  NULL     COMMENT '대체 참조 번호', -- 대체 참조 번호
	EXAM_TM_TYPE_CD       VARCHAR(30)  NULL     COMMENT '시험 시간 배정 방식', -- 시험 시간 배정 방식
	VIEW_TM_TYPE_CD       VARCHAR(30)  NULL     COMMENT '시험 시간 노출 방식', -- 시험 시간 노출 방식
	VIEW_QSTN_TYPE_CD     VARCHAR(30)  NULL     COMMENT '문제 표시 방식', -- 문제 표시 방식
	QSTN_SET_TYPE_CD      VARCHAR(30)  NOT NULL COMMENT '시험 문제 출제 방식', -- 시험 문제 출제 방식
	EXAM_STARE_TM         INT          NULL     COMMENT '시험 응시 시간', -- 시험 응시 시간
	EMPL_RANDOM_YN        CHAR(1)      NULL     COMMENT '문항 보기 랜덤 여부', -- 문항 보기 랜덤 여부
	SCORE_APLY_YN         CHAR(1)      NOT NULL COMMENT '성적 반영 여부', -- 성적 반영 여부
	USE_YN                CHAR(1)      NOT NULL COMMENT '사용 여부', -- 사용 여부
	EXAM_SUBMIT_YN        CHAR(1)      NULL     COMMENT '시험 문제 제출 완료 여부', -- 시험 문제 제출 완료 여부
	TM_LIMIT_YN           CHAR(1)      NULL     COMMENT '제한시간 배정 여부', -- 제한시간 배정 여부
	GRADE_VIEW_YN         CHAR(1)      NULL     COMMENT '시험지 공개 여부', -- 시험지 공개 여부
	DECLS_REG_YN          CHAR(1)      NULL     COMMENT '분반 등록 여부', -- 분반 등록 여부
	PUSH_NOTICE_YN        CHAR(1)      NULL     COMMENT '푸시 알림 여부', -- 푸시 알림 여부
	AVG_SCORE_OPEN_YN     CHAR(1)      NULL     COMMENT '평균 성적 공개 여부', -- 평균 성적 공개 여부
	STARE_TM_USE_YN       CHAR(1)      NULL     COMMENT '응시 시간 사용 여부', -- 응시 시간 사용 여부
	STARE_LIMIT_CNT       INT          NULL     COMMENT '응시 제한 횟수', -- 응시 제한 횟수
	STARE_CRIT_PRGR_RATIO INT          NULL     COMMENT '응시 기준 진도율', -- 응시 기준 진도율
	SCORE_RATIO           INT          NULL     COMMENT '성적 반영 비율', -- 성적 반영 비율
	EXAM_START_DTTM       VARCHAR(14)  NULL     COMMENT '시험 시작 일시', -- 시험 시작 일시
	EXAM_END_DTTM         VARCHAR(14)  NULL     COMMENT '시험 종료 일시', -- 시험 종료 일시
	RE_EXAM_YN            CHAR(1)      NOT NULL COMMENT '재시험 여부', -- 재시험 여부
	RE_EXAM_START_DTTM    VARCHAR(14)  NULL     COMMENT '재시험 시작 일시', -- 재시험 시작 일시
	RE_EXAM_END_DTTM      VARCHAR(14)  NULL     COMMENT '재시험 종료 일시', -- 재시험 종료 일시
	RE_EXAM_APLY_RATIO    INT          NULL     COMMENT '재시험 적용 비율', -- 재시험 적용 비율
	RE_EXAM_STARE_TM      INT          NULL     COMMENT '재시험 응시 시간', -- 재시험 응시 시간
	PASS_SCORE            DECIMAL(5,2) NULL     COMMENT '통과 점수', -- 통과 점수
	DSBD_YN               CHAR(1)      NULL     COMMENT '장애 여부', -- 장애 여부
	DSBD_TM               INT          NULL     COMMENT '장애인 배려 추가 시간', -- 장애인 배려 추가 시간
	SCORE_OPEN_YN         CHAR(1)      NOT NULL COMMENT '성적 공개 여부', -- 성적 공개 여부
	SCORE_OPEN_DTTM       VARCHAR(14)  NULL     COMMENT '성적 공개 일시', -- 성적 공개 일시
	SEC_CERT_CD           VARCHAR(30)  NULL     COMMENT '인증 코드', -- 인증 코드
	DSBL_ADD_TM           INT          NULL     COMMENT '장애인 시험 추가시간', -- 장애인 시험 추가시간
	DEL_YN                CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	IMDT_ANSR_VIEW_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '즉시 답안 보기 여부', -- 즉시 답안 보기 여부
	LESSON_SCHEDULE_ID    VARCHAR(30)  NULL     COMMENT '학습 일정 ID', -- 학습 일정 ID
	LT_WEEK               INT          NULL     COMMENT '강의 주차', -- 강의 주차
	REG_YN                CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '등록 여부', -- 등록 여부
	RGTR_ID                VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM              VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                VARCHAR(30)  NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM              VARCHAR(14)  NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 정보';

-- (시험) 시험 정보
ALTER TABLE tb_lms_exam
	ADD CONSTRAINT PK_tb_lms_exam -- PK_tb_lms_exam
		PRIMARY KEY (
			EXAM_CD -- 시험 코드
		);

-- IX_tb_lms_exam
CREATE INDEX IX_tb_lms_exam
	ON tb_lms_exam( -- (시험) 시험 정보
		EXAM_CTGR_CD ASC -- 시험 분류 코드
	);

-- IX_tb_lms_exam2
CREATE INDEX IX_tb_lms_exam2
	ON tb_lms_exam( -- (시험) 시험 정보
		LESSON_SCHEDULE_ID ASC -- 학습 일정 ID
	);

-- IX_tb_lms_exam3
CREATE INDEX IX_tb_lms_exam3
	ON tb_lms_exam( -- (시험) 시험 정보
		INS_REF_CD ASC -- 대체 참조 번호
	);

-- (시험) 시험 결시원
CREATE TABLE tb_lms_exam_absent (
	EXAM_ABSENT_CD VARCHAR(30)   NOT NULL COMMENT '결시원 코드', -- 결시원 코드
	CRS_CRE_CD     VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	EXAM_CD        VARCHAR(30)   NOT NULL COMMENT '시험 코드', -- 시험 코드
	STD_NO         VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	ABSENT_TITLE   VARCHAR(200)  NOT NULL COMMENT '결시원 제목', -- 결시원 제목
	ABSENT_CTS     LONGTEXT      NULL     COMMENT '결시원 내용', -- 결시원 내용
	APPR_STAT      VARCHAR(10)   NOT NULL DEFAULT 'req' COMMENT '승인 상태', -- 승인 상태
	APPR_CTS       LONGTEXT      NULL     COMMENT '승인 내용', -- 승인 내용
	MGR_CMNT       VARCHAR(2000) NULL     COMMENT '관리자 의견', -- 관리자 의견
	RGTR_ID         VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 결시원';

-- (시험) 시험 결시원
ALTER TABLE tb_lms_exam_absent
	ADD CONSTRAINT PK_tb_lms_exam_absent -- PK_tb_lms_exam_absent
		PRIMARY KEY (
			EXAM_ABSENT_CD -- 결시원 코드
		);

-- IX-tb_lms_exam_absent
CREATE INDEX IX_tb_lms_exam_absent
	ON tb_lms_exam_absent( -- (시험) 시험 결시원
		EXAM_CD ASC, -- 시험 코드
		STD_NO ASC   -- 수강생 번호
	);

-- (시험) 시험 개설과정 연결
CREATE TABLE tb_lms_exam_cre_crs_rltn (
	EXAM_CD    VARCHAR(30) NOT NULL COMMENT '시험 코드', -- 시험 코드
	CRS_CRE_CD VARCHAR(30) NOT NULL DEFAULT 'LEB' COMMENT '과정개설 코드', -- 과정개설 코드
	GRP_CD     VARCHAR(30) NULL     COMMENT '그룹 코드', -- 그룹 코드
	DEL_YN     CHAR(1)     NULL     DEFAULT 'N' COMMENT '삭제 여부' -- 삭제 여부
)
COMMENT '(시험) 시험 개설과정 연결';

-- (시험) 시험 개설과정 연결
ALTER TABLE tb_lms_exam_cre_crs_rltn
	ADD CONSTRAINT PK_tb_lms_exam_cre_crs_rltn -- PK_tb_lms_exam_cre_crs_rltn
		PRIMARY KEY (
			EXAM_CD,    -- 시험 코드
			CRS_CRE_CD  -- 과정개설 코드
		);

-- IX_tb_lms_exam_cre_crs_rltn
CREATE INDEX IX_tb_lms_exam_cre_crs_rltn
	ON tb_lms_exam_cre_crs_rltn( -- (시험) 시험 개설과정 연결
		CRS_CRE_CD ASC, -- 과정개설 코드
		EXAM_CD ASC     -- 시험 코드
	);

-- (시험) 시험 분류
CREATE TABLE tb_lms_exam_ctgr (
	EXAM_CTGR_CD     VARCHAR(30)   NOT NULL COMMENT '시험 분류 코드', -- 시험 분류 코드
	ORG_ID           VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	PAR_EXAM_CTGR_CD VARCHAR(30)   NULL     COMMENT '상위 시험 분류 코드', -- 상위 시험 분류 코드
	EXAM_CTGR_NM     VARCHAR(200)  NOT NULL COMMENT '시험 분류 명', -- 시험 분류 명
	EXAM_CTGR_DESC   VARCHAR(2000) NULL     COMMENT '시험 분류 설명', -- 시험 분류 설명
	EXAM_CTGR_LVL    INT           NULL     COMMENT '시험 분류 레벨', -- 시험 분류 레벨
	EXAM_CTGR_ODR    INT           NULL     COMMENT '시험 분류 순서', -- 시험 분류 순서
	USE_YN           CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	DEL_YN           CHAR(1)       NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID           VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 분류';

-- (시험) 시험 분류
ALTER TABLE tb_lms_exam_ctgr
	ADD CONSTRAINT PK_tb_lms_exam_ctgr -- PK_tb_lms_exam_ctgr
		PRIMARY KEY (
			EXAM_CTGR_CD, -- 시험 분류 코드
			ORG_ID        -- 기관 코드
		);

-- IX_tb_lms_exam_ctgr
CREATE INDEX IX_tb_lms_exam_ctgr
	ON tb_lms_exam_ctgr( -- (시험) 시험 분류
		PAR_EXAM_CTGR_CD ASC -- 상위 시험 분류 코드
	);

-- IX_tb_lms_exam_ctgr2
CREATE INDEX IX_tb_lms_exam_ctgr2
	ON tb_lms_exam_ctgr( -- (시험) 시험 분류
		PAR_EXAM_CTGR_CD ASC, -- 상위 시험 분류 코드
		ORG_ID ASC            -- 기관 코드
	);

-- IX_tb_lms_exam_ctgr3
CREATE INDEX IX_tb_lms_exam_ctgr3
	ON tb_lms_exam_ctgr( -- (시험) 시험 분류
		ORG_ID ASC,           -- 기관 코드
		PAR_EXAM_CTGR_CD ASC  -- 상위 시험 분류 코드
	);

-- (시험) 장애인 시험 지원 신청
CREATE TABLE tb_lms_exam_dsbl_req (
	DSBL_REQ_CD     VARCHAR(30) NOT NULL COMMENT '장애인 지원 신청 코드', -- 장애인 지원 신청 코드
	CRS_CRE_CD      VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	STD_NO          VARCHAR(40) NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	MID_APPR_STAT   VARCHAR(10) NOT NULL DEFAULT 'req' COMMENT '중간고사 승인 상태', -- 중간고사 승인 상태
	MID_ADD_TIME    INT         NOT NULL DEFAULT 0 COMMENT '중간고사 추가 시간(분)', -- 중간고사 추가 시간(분)
	END_APPR_STAT   VARCHAR(10) NOT NULL DEFAULT 'req' COMMENT '기말고사 승인 상태', -- 기말고사 승인 상태
	END_ADD_TIME    INT         NOT NULL DEFAULT 0 COMMENT '기말고사 추가 시간', -- 기말고사 추가 시간
	CANCEL_REQ_STAT VARCHAR(10) NULL     COMMENT '취소 요청 상태', -- 취소 요청 상태
	PROF_EDIT_YN    CHAR(1)     NULL     DEFAULT 'N' COMMENT '연장 시간 변경 여부', -- 연장 시간 변경 여부
	RGTR_ID          VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 장애인 시험 지원 신청';

-- (시험) 장애인 시험 지원 신청
ALTER TABLE tb_lms_exam_dsbl_req
	ADD CONSTRAINT PK_tb_lms_exam_dsbl_req -- PK_tb_lms_exam_dsbl_req
		PRIMARY KEY (
			DSBL_REQ_CD -- 장애인 지원 신청 코드
		);

-- (시험) 시험응시 서약서
CREATE TABLE tb_lms_exam_oath (
	OATH_CD    VARCHAR(30) NOT NULL COMMENT '서약서 코드', -- 서약서 코드
	TERM_CD    VARCHAR(30) NOT NULL COMMENT '학기 코드', -- 학기 코드
	ORG_ID     VARCHAR(30) NOT NULL COMMENT '기관 코드', -- 기관 코드
	HAKSA_YEAR VARCHAR(4)  NOT NULL COMMENT '학사 년도', -- 학사 년도
	HAKSA_TERM VARCHAR(4)  NOT NULL COMMENT '학사 학기', -- 학사 학기
	USER_ID    VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	MID_OATH   CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '중간고사 서약', -- 중간고사 서약
	END_OATH   CHAR(1)     NOT NULL DEFAULT 'N' COMMENT '기말고사 서약', -- 기말고사 서약
	RGTR_ID     VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM   VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID     VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM   VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험응시 서약서';

-- (시험) 시험응시 서약서
ALTER TABLE tb_lms_exam_oath
	ADD CONSTRAINT PK_tb_lms_exam_oath -- PK_tb_lms_exam_oath
		PRIMARY KEY (
			OATH_CD -- 서약서 코드
		);

-- (시험) 문제은행 분류
CREATE TABLE tb_lms_exam_qbank_ctgr (
	EXAM_QBANK_CTGR_CD     VARCHAR(30)   NOT NULL COMMENT '문제은행 분류 코드', -- 문제은행 분류 코드
	ORG_ID                 VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	PAR_EXAM_QBANK_CTGR_CD VARCHAR(30)   NULL     COMMENT '상위 문제은행 시험 분류 코드', -- 상위 문제은행 시험 분류 코드
	CRS_NO                 VARCHAR(30)   NULL     COMMENT '학수 번호', -- 학수 번호
	USER_ID                VARCHAR(30)   NULL     COMMENT '사용자 번호', -- 사용자 번호
	EXAM_CTGR_NM           VARCHAR(200)  NOT NULL COMMENT '시험 분류 명', -- 시험 분류 명
	EXAM_CTGR_DESC         VARCHAR(2000) NULL     COMMENT '시험 분류 설명', -- 시험 분류 설명
	EXAM_CTGR_LVL          INT           NULL     COMMENT '시험 분류 레벨', -- 시험 분류 레벨
	EXAM_CTGR_ODR          INT           NULL     COMMENT '시험 분류 순서', -- 시험 분류 순서
	USE_YN                 CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	DEL_YN                 CHAR(1)       NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID                 VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM               VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                 VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM               VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 문제은행 분류';

-- (시험) 문제은행 분류
ALTER TABLE tb_lms_exam_qbank_ctgr
	ADD CONSTRAINT PK_tb_lms_exam_qbank_ctgr -- PK_tb_lms_exam_qbank_ctgr
		PRIMARY KEY (
			EXAM_QBANK_CTGR_CD -- 문제은행 분류 코드
		);

-- IX_tb_lms_exam_qbank_ctgr
CREATE INDEX IX_tb_lms_exam_qbank_ctgr
	ON tb_lms_exam_qbank_ctgr( -- (시험) 문제은행 분류
		PAR_EXAM_QBANK_CTGR_CD ASC -- 상위 문제은행 시험 분류 코드
	);

-- (시험) 문제은행 문제
CREATE TABLE tb_lms_exam_qbank_qstn (
	EXAM_QBANK_QSTN_SN       INT           NOT NULL COMMENT '문제은행 문제 번호', -- 문제은행 문제 번호
	EXAM_QBANK_CTGR_CD       VARCHAR(30)   NULL     COMMENT '문제은행 분류 코드', -- 문제은행 분류 코드
	QSTN_NO                  INT           NOT NULL COMMENT '문제 번호', -- 문제 번호
	SUB_NO                   INT           NULL     COMMENT '후보 번호', -- 후보 번호
	CRS_NO                   VARCHAR(30)   NULL     COMMENT '학수 번호', -- 학수 번호
	TITLE                    VARCHAR(200)  NOT NULL COMMENT '제목', -- 제목
	QSTN_CTS                 LONGTEXT      NULL     COMMENT '문제 내용', -- 문제 내용
	EMPL_1                   TEXT          NULL     COMMENT '예시 1', -- 예시 1
	EMPL_2                   TEXT          NULL     COMMENT '예시 2', -- 예시 2
	EMPL_3                   TEXT          NULL     COMMENT '예시 3', -- 예시 3
	EMPL_4                   TEXT          NULL     COMMENT '예시 4', -- 예시 4
	EMPL_5                   TEXT          NULL     COMMENT '예시 5', -- 예시 5
	EMPL_6                   TEXT          NULL     COMMENT '예시 6', -- 예시 6
	EMPL_7                   TEXT          NULL     COMMENT '예시 7', -- 예시 7
	EMPL_8                   TEXT          NULL     COMMENT '예시 8', -- 예시 8
	EMPL_9                   TEXT          NULL     COMMENT '예시 9', -- 예시 9
	EMPL_10                  TEXT          NULL     COMMENT '예시 10', -- 예시 10
	MULTI_RGT_CHOICE_YN      CHAR(1)       NULL     DEFAULT 'N' COMMENT '멀티 정답 허용 여부', -- 멀티 정답 허용 여부
	MULTI_RGT_CHOICE_TYPE_CD VARCHAR(30)   NULL     COMMENT '멀티 정답 구분', -- 멀티 정답 구분
	MULTI_RGT_ANSR           VARCHAR(100)  NULL     COMMENT '멀티 정답', -- 멀티 정답
	RGT_ANSR                 VARCHAR(1000) NULL     COMMENT '정답', -- 정답
	RGT_ANSR1                VARCHAR(1000) NULL     COMMENT '정답1', -- 정답1
	RGT_ANSR2                VARCHAR(1000) NULL     COMMENT '정답2', -- 정답2
	RGT_ANSR3                VARCHAR(1000) NULL     COMMENT '정답3', -- 정답3
	RGT_ANSR4                VARCHAR(1000) NULL     COMMENT '정답4', -- 정답4
	RGT_ANSR5                VARCHAR(1000) NULL     COMMENT '정답5', -- 정답5
	QSTN_EXPL                TEXT          NULL     COMMENT '문제 해설', -- 문제 해설
	QSTN_TYPE_CD             VARCHAR(30)   NULL     COMMENT '문제 유형', -- 문제 유형
	QSTN_SCORE               DECIMAL(5,2)  NULL     COMMENT '문제 점수', -- 문제 점수
	QSTN_DIFF                VARCHAR(50)   NULL     COMMENT '문제 난이도', -- 문제 난이도
	ERROR_ANSR_YN            CHAR(1)       NULL     COMMENT '전체 정답 처리 여부', -- 전체 정답 처리 여부
	EDITOR_YN                CHAR(1)       NOT NULL COMMENT '에디터 여부', -- 에디터 여부
	DEL_YN                   CHAR(1)       NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID                   VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM                 VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                   VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM                 VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 문제은행 문제';

-- (시험) 문제은행 문제
ALTER TABLE tb_lms_exam_qbank_qstn
	ADD CONSTRAINT PK_tb_lms_exam_qbank_qstn -- PK_tb_lms_exam_qbank_qstn
		PRIMARY KEY (
			EXAM_QBANK_QSTN_SN -- 문제은행 문제 번호
		);

-- IX_tb_lms_exam_qbank_qstn
CREATE INDEX IX_tb_lms_exam_qbank_qstn
	ON tb_lms_exam_qbank_qstn( -- (시험) 문제은행 문제
		EXAM_QBANK_CTGR_CD ASC -- 문제은행 분류 코드
	);

-- (시험) 시험 문제
CREATE TABLE tb_lms_exam_qstn (
	EXAM_CD                  VARCHAR(30)   NOT NULL COMMENT '시험 코드', -- 시험 코드
	EXAM_QSTN_SN             BIGINT        NOT NULL COMMENT '시험 문제 번호', -- 시험 문제 번호
	QSTN_NO                  INT           NULL     COMMENT '문제 번호', -- 문제 번호
	SUB_NO                   INT           NULL     COMMENT '후보 번호', -- 후보 번호
	TITLE                    VARCHAR(200)  NOT NULL COMMENT '제목', -- 제목
	QSTN_CTS                 LONGTEXT      NULL     COMMENT '문제 내용', -- 문제 내용
	EMPL_1                   TEXT          NULL     COMMENT '예시 1', -- 예시 1
	EMPL_2                   TEXT          NULL     COMMENT '예시 2', -- 예시 2
	EMPL_3                   TEXT          NULL     COMMENT '예시 3', -- 예시 3
	EMPL_4                   TEXT          NULL     COMMENT '예시 4', -- 예시 4
	EMPL_5                   TEXT          NULL     COMMENT '예시 5', -- 예시 5
	EMPL_6                   TEXT          NULL     COMMENT '예시 6', -- 예시 6
	EMPL_7                   TEXT          NULL     COMMENT '예시 7', -- 예시 7
	EMPL_8                   TEXT          NULL     COMMENT '예시 8', -- 예시 8
	EMPL_9                   TEXT          NULL     COMMENT '예시 9', -- 예시 9
	EMPL_10                  TEXT          NULL     COMMENT '예시 10', -- 예시 10
	MULTI_RGT_CHOICE_YN      CHAR(1)       NULL     COMMENT '멀티 정답 허용 여부', -- 멀티 정답 허용 여부
	MULTI_RGT_CHOICE_TYPE_CD VARCHAR(30)   NULL     COMMENT '멀티 정답 구분', -- 멀티 정답 구분
	MULTI_RGT_ANSR           VARCHAR(100)  NULL     COMMENT '멀티 정답', -- 멀티 정답
	RGT_ANSR                 VARCHAR(1000) NULL     COMMENT '정답', -- 정답
	RGT_ANSR1                VARCHAR(1000) NULL     COMMENT '정답1', -- 정답1
	RGT_ANSR2                VARCHAR(1000) NULL     COMMENT '정답2', -- 정답2
	RGT_ANSR3                VARCHAR(1000) NULL     COMMENT '정답3', -- 정답3
	RGT_ANSR4                VARCHAR(1000) NULL     COMMENT '정답4', -- 정답4
	RGT_ANSR5                VARCHAR(1000) NULL     COMMENT '정답5', -- 정답5
	QSTN_EXPL                TEXT          NULL     COMMENT '문제 해설', -- 문제 해설
	QSTN_TYPE_CD             VARCHAR(30)   NULL     COMMENT '문제 유형', -- 문제 유형
	QSTN_SCORE               DECIMAL(5,2)  NULL     COMMENT '문제 점수', -- 문제 점수
	QSTN_DIFF                VARCHAR(50)   NULL     COMMENT '문제 난이도', -- 문제 난이도
	ERROR_ANSR_YN            CHAR(1)       NULL     COMMENT '전체 정답 처리 여부', -- 전체 정답 처리 여부
	EDITOR_YN                CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '에디터 여부', -- 에디터 여부
	DEL_YN                   CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID                   VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM                 VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                   VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM                 VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 문제';

-- (시험) 시험 문제
ALTER TABLE tb_lms_exam_qstn
	ADD CONSTRAINT PK_tb_lms_exam_qstn -- PK_tb_lms_exam_qstn
		PRIMARY KEY (
			EXAM_CD,      -- 시험 코드
			EXAM_QSTN_SN  -- 시험 문제 번호
		);

-- (시험) 시험 응시
CREATE TABLE tb_lms_exam_stare (
	STD_NO              VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	EXAM_CD             VARCHAR(30)   NOT NULL COMMENT '시험 코드', -- 시험 코드
	STARE_SN            VARCHAR(100)  NOT NULL COMMENT '시험 응시 번호', -- 시험 응시 번호
	TOT_GET_SCORE       DECIMAL(5,2)  NULL     COMMENT '총 취득 점수', -- 총 취득 점수
	STARE_CNT           INT           NULL     COMMENT '응시 횟수', -- 응시 횟수
	STARE_TM            INT           NULL     COMMENT '응시 시간', -- 응시 시간
	START_DTTM          VARCHAR(14)   NULL     COMMENT '시작 일시', -- 시작 일시
	END_DTTM            VARCHAR(14)   NULL     COMMENT '종료 일시', -- 종료 일시
	ATCH_CTS            LONGTEXT      NULL     COMMENT '첨언 내용', -- 첨언 내용
	EVAL_DTTM           VARCHAR(14)   NULL     COMMENT '평가 일시', -- 평가 일시
	EVAL_YN             CHAR(1)       NOT NULL COMMENT '평가 여부', -- 평가 여부
	RE_EXAM_YN          CHAR(1)       NULL     DEFAULT 'N' COMMENT '재시험 여부', -- 재시험 여부
	PROF_MEMO           VARCHAR(2000) NULL     COMMENT '교수 메모', -- 교수 메모
	DEL_YN              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	KONAN_COMP_DT       VARCHAR(14)   NULL     COMMENT '모사 비교 일시', -- 모사 비교 일시
	KONAN_MAX_COPY_RATE DECIMAL(5,2)  NULL     COMMENT '모사율', -- 모사율
	KONAN_MAX_COPY_ID   VARCHAR(100)  NULL     COMMENT '모사 참조 ID', -- 모사 참조 ID
	RGTR_ID              VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID              VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM            VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 응시';

-- (시험) 시험 응시
ALTER TABLE tb_lms_exam_stare
	ADD CONSTRAINT PK_tb_lms_exam_stare -- PK_tb_lms_exam_stare
		PRIMARY KEY (
			STD_NO,  -- 수강생 번호
			EXAM_CD  -- 시험 코드
		);

-- UX_(시험) 시험 응시
CREATE UNIQUE INDEX UX_tb_lms_exam_stare
	ON tb_lms_exam_stare ( -- (시험) 시험 응시
		STARE_SN ASC -- 시험 응시 번호
	);

-- (시험) 시험 응시 이력
CREATE TABLE tb_lms_exam_stare_hsty (
	STARE_HSTY_SN INT          NOT NULL COMMENT '시험 응시 이력 번호', -- 시험 응시 이력 번호
	STD_NO        VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	EXAM_CD       VARCHAR(30)  NOT NULL COMMENT '시험 코드', -- 시험 코드
	TOT_GET_SCORE DECIMAL(5,2) NULL     COMMENT '총 취득 점수', -- 총 취득 점수
	STARE_CNT     INT          NULL     COMMENT '응시 횟수', -- 응시 횟수
	STARE_TM      INT          NULL     COMMENT '응시 시간', -- 응시 시간
	START_DTTM    VARCHAR(14)  NULL     COMMENT '시작 일시', -- 시작 일시
	END_DTTM      VARCHAR(14)  NULL     DEFAULT 'NULL' COMMENT '종료 일시', -- 종료 일시
	ATCH_CTS      LONGTEXT     NULL     COMMENT '첨언 내용', -- 첨언 내용
	EVAL_DTTM     VARCHAR(14)  NULL     COMMENT '평가 일시', -- 평가 일시
	EVAL_YN       CHAR(1)      NOT NULL COMMENT '평가 여부', -- 평가 여부
	RE_EXAM_YN    CHAR(1)      NOT NULL COMMENT '재시험 여부', -- 재시험 여부
	DEL_YN        CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	HSTY_TYPE_CD  VARCHAR(30)  NULL     COMMENT '이력 구분 코드', -- 이력 구분 코드
	CONN_IP       VARCHAR(50)  NULL     COMMENT '접속 IP', -- 접속 IP
	RGTR_ID        VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 응시 이력';

-- (시험) 시험 응시 이력
ALTER TABLE tb_lms_exam_stare_hsty
	ADD CONSTRAINT PK_tb_lms_exam_stare_hsty -- PK_tb_lms_exam_stare_hsty
		PRIMARY KEY (
			STARE_HSTY_SN, -- 시험 응시 이력 번호
			STD_NO,        -- 수강생 번호
			EXAM_CD        -- 시험 코드
		);

-- IX_tb_lms_exam_stare_hsty
CREATE INDEX IX_tb_lms_exam_stare_hsty
	ON tb_lms_exam_stare_hsty( -- (시험) 시험 응시 이력
		STD_NO ASC,       -- 수강생 번호
		HSTY_TYPE_CD ASC  -- 이력 구분 코드
	);

-- IX_tb_lms_exam_stare_hsty2
CREATE INDEX IX_tb_lms_exam_stare_hsty2
	ON tb_lms_exam_stare_hsty( -- (시험) 시험 응시 이력
		EXAM_CD ASC -- 시험 코드
	);

-- (시험) 시험 응시 시험지
CREATE TABLE tb_lms_exam_stare_paper (
	EXAM_CD      VARCHAR(30)  NOT NULL COMMENT '시험 코드', -- 시험 코드
	EXAM_QSTN_SN BIGINT       NOT NULL COMMENT '시험 문제 번호', -- 시험 문제 번호
	STD_NO       VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	QSTN_NO      INT          NOT NULL COMMENT '문제 번호', -- 문제 번호
	SUB_NO       INT          NULL     COMMENT '후보 번호', -- 후보 번호
	STARE_ANSR   LONGTEXT     NULL     COMMENT '응시 답', -- 응시 답
	GET_SCORE    DECIMAL(5,2) NULL     DEFAULT 0.00 COMMENT '취득 점수', -- 취득 점수
	EXAM_ODR     VARCHAR(20)  NULL     COMMENT '문항 보기 순번', -- 문항 보기 순번
	FDBK_CTS     LONGTEXT     NULL     COMMENT '피드백 내용', -- 피드백 내용
	FDBK_DTTM    VARCHAR(14)  NULL     COMMENT '피드백 일시', -- 피드백 일시
	RGTR_ID       VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 응시 시험지';

-- (시험) 시험 응시 시험지
ALTER TABLE tb_lms_exam_stare_paper
	ADD CONSTRAINT PK_tb_lms_exam_stare_paper -- PK_tb_lms_exam_stare_paper
		PRIMARY KEY (
			EXAM_CD,      -- 시험 코드
			EXAM_QSTN_SN, -- 시험 문제 번호
			STD_NO        -- 수강생 번호
		);

-- (시험) 시험 응시 시험지 이력
CREATE TABLE tb_lms_exam_stare_paper_hsty (
	EXAM_STARE_PAPER_HSTY_SN INT          NOT NULL COMMENT '응시 시험지 이력 번호', -- 응시 시험지 이력 번호
	STARE_HSTY_SN            INT          NULL     COMMENT '시험 응시 이력 번호', -- 시험 응시 이력 번호
	EXAM_CD                  VARCHAR(30)  NOT NULL COMMENT '시험 코드', -- 시험 코드
	EXAM_QSTN_SN             BIGINT       NOT NULL COMMENT '시험 문제 번호', -- 시험 문제 번호
	STD_NO                   VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	QSTN_NO                  INT          NOT NULL COMMENT '문제 번호', -- 문제 번호
	SUB_NO                   INT          NULL     COMMENT '후보 번호', -- 후보 번호
	STARE_ANSR               LONGTEXT     NULL     COMMENT '응시 답', -- 응시 답
	GET_SCORE                DECIMAL(5,2) NULL     COMMENT '취득 점수', -- 취득 점수
	EXAM_ODR                 VARCHAR(20)  NULL     COMMENT '문항 보기 순번', -- 문항 보기 순번
	FDBK_CTS                 LONGTEXT     NULL     COMMENT '피드백 내용', -- 피드백 내용
	FDBK_DTTM                VARCHAR(14)  NULL     COMMENT '피드백 일시', -- 피드백 일시
	RGTR_ID                   VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM                 VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                   VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM                 VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시험) 시험 응시 시험지 이력';

-- (시험) 시험 응시 시험지 이력
ALTER TABLE tb_lms_exam_stare_paper_hsty
	ADD CONSTRAINT PK_tb_lms_exam_stare_paper_hsty -- PK_tb_lms_exam_stare_paper_hsty
		PRIMARY KEY (
			EXAM_STARE_PAPER_HSTY_SN, -- 응시 시험지 이력 번호
			EXAM_CD,                  -- 시험 코드
			EXAM_QSTN_SN,             -- 시험 문제 번호
			STD_NO                    -- 수강생 번호
		);

-- IX_tb_lms_exam_stare_paper_hsty
CREATE INDEX IX_tb_lms_exam_stare_paper_hsty
	ON tb_lms_exam_stare_paper_hsty( -- (시험) 시험 응시 시험지 이력
		STARE_HSTY_SN ASC -- 시험 응시 이력 번호
	);

-- (토론) 토론 정보
CREATE TABLE tb_lms_forum (
	FORUM_CD               VARCHAR(30)  NOT NULL COMMENT '토론 코드', -- 토론 코드
	CRS_CRE_CD             VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	FORUM_CTGR_CD          VARCHAR(30)  NULL     COMMENT '토론 분류 코드', -- 토론 분류 코드
	FORUM_TITLE            VARCHAR(200) NULL     COMMENT '토론 제목', -- 토론 제목
	FORUM_ARTL             LONGTEXT     NULL     COMMENT '토론 내용', -- 토론 내용
	FORUM_START_DTTM       VARCHAR(14)  NULL     COMMENT '토론 시작 일시', -- 토론 시작 일시
	FORUM_END_DTTM         VARCHAR(14)  NULL     COMMENT '토론 종료 일시', -- 토론 종료 일시
	EXT_START_DTTM         VARCHAR(14)  NULL     COMMENT '연장 시작 일시', -- 연장 시작 일시
	EXT_END_DTTM           VARCHAR(14)  NULL     COMMENT '연장 종료 일시', -- 연장 종료 일시
	SCORE_APLY_YN          CHAR(1)      NULL     COMMENT '성적 반영 여부', -- 성적 반영 여부
	SCORE_OPEN_YN          CHAR(1)      NULL     COMMENT '성적 공개 여부', -- 성적 공개 여부
	PERIOD_AFTER_WRITE_YN  CHAR(1)      NULL     COMMENT '기간후 작성 여부', -- 기간후 작성 여부
	FORUM_OPEN_YN          CHAR(1)      NULL     COMMENT '토론 공개 여부', -- 토론 공개 여부
	TEAM_FORUM_CFG_YN      CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '팀토론 설정 여부', -- 팀토론 설정 여부
	TEAM_CTGR_CD           VARCHAR(30)  NULL     COMMENT '팀 분류 코드', -- 팀 분류 코드
	TEAM_ATCL_OPEN_YN      CHAR(1)      NULL     COMMENT '팀토론 게시글 공개 여부', -- 팀토론 게시글 공개 여부
	PROS_CONS_FORUM_CFG    CHAR(1)      NULL     COMMENT '찬성반대 토론 설정', -- 찬성반대 토론 설정
	PROS_CONS_RATE_OPEN_YN CHAR(1)      NULL     COMMENT '찬성반대 비율 공개 여부', -- 찬성반대 비율 공개 여부
	PROS_CONS_MOD_YN       CHAR(1)      NULL     COMMENT '찬성반대 수정 여부', -- 찬성반대 수정 여부
	REG_OPEN_YN            CHAR(1)      NULL     COMMENT '등록자 공개 여부', -- 등록자 공개 여부
	MULTI_ATCL_YN          CHAR(1)      NULL     COMMENT '다중의견 등록 여부', -- 다중의견 등록 여부
	EVAL_RSLT_OPEN_YN      CHAR(1)      NULL     COMMENT '평가 결과 공개 여부', -- 평가 결과 공개 여부
	EVAL_CRIT_USE_YN       CHAR(1)      NULL     COMMENT '평가 기준 사용 여부', -- 평가 기준 사용 여부
	EVAL_CTGR              CHAR(1)      NULL     COMMENT '평가 방식', -- 평가 방식
	EVAL_START_DTTM        VARCHAR(14)  NULL     COMMENT '평가 시작 일시', -- 평가 시작 일시
	EVAL_END_DTTM          VARCHAR(14)  NULL     COMMENT '평가 종료 일시', -- 평가 종료 일시
	MUT_EVAL_YN            CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '상호평가 여부', -- 상호평가 여부
	SCORE_OPEN_DTTM        VARCHAR(14)  NULL     COMMENT '성적 공개 일시', -- 성적 공개 일시
	SCORE_RATIO            INT          NULL     COMMENT '성적 반영 비율', -- 성적 반영 비율
	AVG_SCORE_OPEN_YN      CHAR(1)      NULL     COMMENT '평균 성적 공개 여부', -- 평균 성적 공개 여부
	DECLS_REG_YN           CHAR(1)      NULL     COMMENT '분반 등록 여부', -- 분반 등록 여부
	PUSH_NOTICE_YN         CHAR(1)      NOT NULL COMMENT '푸시 알림 여부', -- 푸시 알림 여부
	APLY_ASN_YN            CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '댓글 답변 요청', -- 댓글 답변 요청
	DEL_YN                 CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	OTHER_VIEW_YN          CHAR(1)      NULL     DEFAULT 'N' COMMENT '타게시글 열람 여부', -- 타게시글 열람 여부
	OTHER_TEAM_VIEW_YN     CHAR(1)      NULL     DEFAULT 'N' COMMENT '다른팀 토론 보기 여부', -- 다른팀 토론 보기 여부
	OTHER_TEAM_APLY_YN     CHAR(1)      NULL     DEFAULT 'N' COMMENT '다른팀 댓글 작성 가능 여부', -- 다른팀 댓글 작성 가능 여부
	LESSON_SCHEDULE_ID     VARCHAR(30)  NULL     COMMENT '학습 일정 ID', -- 학습 일정 ID
	RGTR_ID                 VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM               VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                 VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM               VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(토론) 토론 정보';

-- (토론) 토론 정보
ALTER TABLE tb_lms_forum
	ADD CONSTRAINT PK_tb_lms_forum -- PK_tb_lms_forum
		PRIMARY KEY (
			FORUM_CD -- 토론 코드
		);

-- IX_tb_lms_forum
CREATE INDEX IX_tb_lms_forum
	ON tb_lms_forum( -- (토론) 토론 정보
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- IX_tb_lms_forum2
CREATE INDEX IX_tb_lms_forum2
	ON tb_lms_forum( -- (토론) 토론 정보
		LESSON_SCHEDULE_ID ASC -- 학습 일정 ID
	);

-- (토론) 토론 게시글
CREATE TABLE tb_lms_forum_atcl (
	ATCL_SN             VARCHAR(30)  NOT NULL COMMENT '게시글 번호', -- 게시글 번호
	FORUM_CD            VARCHAR(30)  NOT NULL COMMENT '토론 코드', -- 토론 코드
	PAR_ATCL_SN         VARCHAR(30)  NULL     COMMENT '상위 게시글 번호', -- 상위 게시글 번호
	ATCL_LVL            INT          NULL     DEFAULT 0 COMMENT '게시글 레벨', -- 게시글 레벨
	ATCL_ODR            INT          NULL     COMMENT '게시글 순서', -- 게시글 순서
	ATCL_TYPE_CD        VARCHAR(30)  NULL     COMMENT '게시글 유형 코드', -- 게시글 유형 코드
	PROS_CONS_TYPE_CD   CHAR(1)      NULL     COMMENT '찬성반대 유형 코드', -- 찬성반대 유형 코드
	TITLE               VARCHAR(200) NULL     COMMENT '제목', -- 제목
	CTS                 LONGTEXT     NULL     COMMENT '내용', -- 내용
	HITS                INT          NULL     COMMENT '조회 수', -- 조회 수
	STD_NO              VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	EDITOR_YN           CHAR(1)      NULL     DEFAULT 'N' COMMENT '에디터 여부', -- 에디터 여부
	CTS_LEN             INT          NOT NULL DEFAULT 0 COMMENT '내용 길이', -- 내용 길이
	DEL_YN              CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	KONAN_COMP_DT       VARCHAR(14)  NULL     COMMENT '모사 비교 일시', -- 모사 비교 일시
	KONAN_MAX_COPY_RATE DECIMAL(5,2) NULL     COMMENT '모사율', -- 모사율
	KONAN_MAX_COPY_ID   VARCHAR(100) NULL     COMMENT '모사 참조 ID', -- 모사 참조 ID
	REG_NM              VARCHAR(100) NULL     COMMENT '등록자 이름', -- 등록자 이름
	RGTR_ID              VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID              VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM            VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(토론) 토론 게시글';

-- (토론) 토론 게시글
ALTER TABLE tb_lms_forum_atcl
	ADD CONSTRAINT PK_tb_lms_forum_atcl -- PK_tb_lms_forum_atcl
		PRIMARY KEY (
			ATCL_SN -- 게시글 번호
		);

-- (토론) 토론 댓글
CREATE TABLE tb_lms_forum_cmnt (
	CMNT_SN      VARCHAR(30)  NOT NULL COMMENT '댓글 번호', -- 댓글 번호
	FORUM_CD     VARCHAR(30)  NOT NULL COMMENT '토론 코드', -- 토론 코드
	ATCL_SN      VARCHAR(30)  NOT NULL COMMENT '게시글 번호', -- 게시글 번호
	PAR_CMNT_SN  VARCHAR(30)  NULL     COMMENT '상위 댓글 번호', -- 상위 댓글 번호
	CMNT_CTS     LONGTEXT     NULL     COMMENT '댓글 내용', -- 댓글 내용
	EMOTICON_NO  INT          NULL     COMMENT '이모티콘 번호', -- 이모티콘 번호
	STD_NO       VARCHAR(40)  NULL     COMMENT '수강생 번호', -- 수강생 번호
	DEL_YN       CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	ANS_REQ_YN   CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '답변 요청 여부', -- 답변 요청 여부
	CMNT_CTS_LEN INT          NOT NULL DEFAULT 0 COMMENT '댓글 내용 길이', -- 댓글 내용 길이
	REG_NM       VARCHAR(100) NULL     COMMENT '등록자 이름', -- 등록자 이름
	RGTR_ID       VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(토론) 토론 댓글';

-- (토론) 토론 댓글
ALTER TABLE tb_lms_forum_cmnt
	ADD CONSTRAINT PK_tb_lms_forum_cmnt -- PK_tb_lms_forum_cmnt
		PRIMARY KEY (
			CMNT_SN,  -- 댓글 번호
			FORUM_CD, -- 토론 코드
			ATCL_SN   -- 게시글 번호
		);

-- IX_tb_lms_forum_cmnt
CREATE INDEX IX_tb_lms_forum_cmnt
	ON tb_lms_forum_cmnt( -- (토론) 토론 댓글
		FORUM_CD ASC, -- 토론 코드
		ATCL_SN ASC   -- 게시글 번호
	);

-- (토론) 토론 개설과정 연결
CREATE TABLE tb_lms_forum_cre_crs_rltn (
	FORUM_CD   VARCHAR(30) NOT NULL COMMENT '토론 코드', -- 토론 코드
	CRS_CRE_CD VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	GRP_CD     VARCHAR(30) NULL     COMMENT '그룹 코드', -- 그룹 코드
	DEL_YN     CHAR(1)     NULL     DEFAULT 'N' COMMENT '삭제 여부' -- 삭제 여부
)
COMMENT '(토론) 토론 개설과정 연결';

-- (토론) 토론 개설과정 연결
ALTER TABLE tb_lms_forum_cre_crs_rltn
	ADD CONSTRAINT PK_tb_lms_forum_cre_crs_rltn -- PK_tb_lms_forum_cre_crs_rltn
		PRIMARY KEY (
			FORUM_CD,   -- 토론 코드
			CRS_CRE_CD  -- 과정개설 코드
		);

-- (토론) 토론 피드백
CREATE TABLE tb_lms_forum_fdbk (
	FORUM_FDBK_CD     VARCHAR(30)  NOT NULL COMMENT '토론 피드백 코드', -- 토론 피드백 코드
	FORUM_CD          VARCHAR(30)  NOT NULL COMMENT '토론 코드', -- 토론 코드
	STD_NO            VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	PAR_FORUM_FDBK_CD VARCHAR(30)  NULL     COMMENT '상위 토론 피드백 코드', -- 상위 토론 피드백 코드
	TEAM_CD           VARCHAR(30)  NULL     COMMENT '팀 코드', -- 팀 코드
	FDBK_CTS          LONGTEXT     NULL     COMMENT '피드백 내용', -- 피드백 내용
	DEL_YN            CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	REG_NM            VARCHAR(100) NULL     COMMENT '등록자 이름', -- 등록자 이름
	RGTR_ID            VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(토론) 토론 피드백';

-- (토론) 토론 피드백
ALTER TABLE tb_lms_forum_fdbk
	ADD CONSTRAINT PK_tb_lms_forum_fdbk -- PK_tb_lms_forum_fdbk
		PRIMARY KEY (
			FORUM_FDBK_CD -- 토론 피드백 코드
		);

-- IX_tb_lms_forum_fdbk
CREATE INDEX IX_tb_lms_forum_fdbk
	ON tb_lms_forum_fdbk( -- (토론) 토론 피드백
		FORUM_CD ASC -- 토론 코드
	);

-- (토론) 토론 참여자
CREATE TABLE tb_lms_forum_join_user (
	STD_NO              VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	FORUM_CD            VARCHAR(30)   NOT NULL COMMENT '토론 코드', -- 토론 코드
	TEAM_CD             VARCHAR(30)   NULL     COMMENT '팀 코드', -- 팀 코드
	SCORE               DECIMAL(5,2)  NULL     COMMENT '점수', -- 점수
	EVAL_YN             CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '평가 여부', -- 평가 여부
	PROF_MEMO           VARCHAR(2000) NULL     COMMENT '교수 메모', -- 교수 메모
	DEL_YN              CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	KONAN_COMP_DT       VARCHAR(14)   NULL     COMMENT '모사 비교 일시', -- 모사 비교 일시
	KONAN_MAX_COPY_RATE DECIMAL(5,2)  NULL     COMMENT '모사율', -- 모사율
	KONAN_MAX_COPY_ID   VARCHAR(100)  NULL     COMMENT '모사 참조 ID', -- 모사 참조 ID
	RGTR_ID              VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID              VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM            VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(토론) 토론 참여자';

-- (토론) 토론 참여자
ALTER TABLE tb_lms_forum_join_user
	ADD CONSTRAINT PK_tb_lms_forum_join_user -- PK_tb_lms_forum_join_user
		PRIMARY KEY (
			STD_NO,   -- 수강생 번호
			FORUM_CD  -- 토론 코드
		);

-- (토론) 토론 상호평가
CREATE TABLE tb_lms_forum_mut (
	STD_NO   VARCHAR(40)   NULL     COMMENT '수강생 번호', -- 수강생 번호
	FORUM_CD VARCHAR(30)   NULL     COMMENT '토론 코드', -- 토론 코드
	MUT_SN   VARCHAR(30)   NULL     COMMENT '상호평가 번호', -- 상호평가 번호
	SCORE    DECIMAL(5,2)  NULL     COMMENT '점수', -- 점수
	CMNT     VARCHAR(2000) NULL     COMMENT '의견', -- 의견
	RGTR_ID   VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID   VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(토론) 토론 상호평가';

-- IX_tb_lms_forum_mut
CREATE INDEX IX_tb_lms_forum_mut
	ON tb_lms_forum_mut( -- (토론) 토론 상호평가
		STD_NO ASC,   -- 수강생 번호
		FORUM_CD ASC  -- 토론 코드
	);

-- (기타) 학점 교류생 수강 정보
CREATE TABLE tb_lms_hp_intch (
	YY              VARCHAR(4)    NOT NULL COMMENT '년', -- 년
	TM_GBN          VARCHAR(8)    NOT NULL COMMENT '학기 구분', -- 학기 구분
	STUNO           VARCHAR(30)   NOT NULL COMMENT '학번', -- 학번
	SC_CD           VARCHAR(8)    NOT NULL COMMENT '교과목 코드', -- 교과목 코드
	LT_NO           VARCHAR(10)   NOT NULL COMMENT '분반 분류 번호', -- 분반 분류 번호
	DEPT_NM         VARCHAR(200)  NULL     COMMENT '부서 명', -- 부서 명
	STD_COR_NM      VARCHAR(100)  NULL     COMMENT '학점교류 수강생 명', -- 학점교류 수강생 명
	HP_INTCH_GBN    VARCHAR(8)    NULL     COMMENT '학점교류 구분', -- 학점교류 구분
	HP_INTCH_GBN_NM VARCHAR(2000) NULL     COMMENT '학점교류 구분명', -- 학점교류 구분명
	SC_NM           VARCHAR(255)  NULL     COMMENT '교과목 명', -- 교과목 명
	HYU_STUNO       VARCHAR(30)   NULL     COMMENT '한양대학번', -- 한양대학번
	CPTN_GBN        VARCHAR(10)   NULL     COMMENT '이수구분', -- 이수구분
	CPTN_GBN_NM     VARCHAR(100)  NULL     COMMENT '이수구분 명', -- 이수구분 명
	TLSN_APLY_HP    INT           NULL     COMMENT '수강신청 학점', -- 수강신청 학점
	ENROLL_YN       CHAR(1)       NULL     COMMENT '수강신청 여부', -- 수강신청 여부
	URL_NM          VARCHAR(100)  NULL     COMMENT 'URL 명', -- URL 명
	URL             VARCHAR(500)  NULL     COMMENT 'URL', -- URL
	INSERT_AT       DATETIME      NULL     COMMENT '등록 날짜 시간', -- 등록 날짜 시간
	MODIFY_AT       DATETIME      NULL     COMMENT '수정 날짜 시간' -- 수정 날짜 시간
)
COMMENT '(기타) 학점 교류생 수강 정보';

-- (기타) 학점 교류생 수강 정보
ALTER TABLE tb_lms_hp_intch
	ADD CONSTRAINT PK_tb_lms_hp_intch -- PK_tb_lms_hp_intch
		PRIMARY KEY (
			YY,     -- 년
			TM_GBN, -- 학기 구분
			STUNO,  -- 학번
			SC_CD,  -- 교과목 코드
			LT_NO   -- 분반 분류 번호
		);

-- (강의) 학습 콘텐츠
CREATE TABLE tb_lms_lesson_cnts (
	LESSON_CNTS_ID             VARCHAR(30)   NOT NULL COMMENT '학습 콘텐츠 ID', -- 학습 콘텐츠 ID
	CRS_CRE_CD                 VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	LESSON_TIME_ID             VARCHAR(30)   NOT NULL COMMENT '교시 ID', -- 교시 ID
	LESSON_SCHEDULE_ID         VARCHAR(30)   NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	LESSON_TYPE_CD             VARCHAR(30)   NOT NULL COMMENT '학습 유형 코드', -- 학습 유형 코드
	LESSON_CNTS_NM             VARCHAR(200)  NOT NULL COMMENT '학습 콘텐츠 명', -- 학습 콘텐츠 명
	LESSON_CNTS_ORDER          INT           NOT NULL COMMENT '학습 콘텐츠 순서', -- 학습 콘텐츠 순서
	CNTS_GBN                   VARCHAR(10)   NOT NULL DEFAULT 'ETC' COMMENT '콘텐츠 구분', -- 콘텐츠 구분
	PRGR_YN                    CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '진도 반영 여부', -- 진도 반영 여부
	LESSON_START_DTTM          VARCHAR(14)   NULL     COMMENT '학습 시작 일시', -- 학습 시작 일시
	LESSON_END_DTTM            VARCHAR(14)   NULL     COMMENT '학습 종료 일시', -- 학습 종료 일시
	LESSON_CNTS_FILE_LOC_CD    VARCHAR(30)   NULL     COMMENT '학습 파일 위치 코드', -- 학습 파일 위치 코드
	LESSON_CNTS_FILE_NM        VARCHAR(200)  NULL     COMMENT '학습 파일 명', -- 학습 파일 명
	LESSON_CNTS_FILE_PATH      VARCHAR(200)  NULL     COMMENT '학습 파일 경로', -- 학습 파일 경로
	LESSON_CNTS_URL            VARCHAR(2000) NULL     COMMENT '학습 콘텐츠 URL', -- 학습 콘텐츠 URL
	LESSON_CNTS_FILE_LOC_CD_M  VARCHAR(30)   NULL     COMMENT '모바일 학습 파일위치 코드', -- 모바일 학습 파일위치 코드
	LESSON_CNTS_FILE_NM_M      VARCHAR(200)  NULL     COMMENT '모바일 학습 파일명', -- 모바일 학습 파일명
	LESSON_CNTS_FILE_PATH_M    VARCHAR(200)  NULL     COMMENT '모바일 학습 파일경로', -- 모바일 학습 파일경로
	LESSON_CNTS_URL_M          VARCHAR(500)  NULL     COMMENT '모바일 학습 URL', -- 모바일 학습 URL
	RECMMD_STUDY_TIME          INT           NULL     COMMENT '권장 학습 시간', -- 권장 학습 시간
	PRGR_RATIO_TYPE_CD         VARCHAR(30)   NULL     COMMENT '진도율 체크 방식 코드', -- 진도율 체크 방식 코드
	VIEW_YN                    CHAR(1)       NOT NULL COMMENT '조회 여부', -- 조회 여부
	PERIOD_OUT_LEARN_YN        CHAR(1)       NULL     COMMENT '기간외 학습 여부', -- 기간외 학습 여부
	PERIOD_OUT_LEARN_DAY_CNT   INT           NULL     COMMENT '기간외 학습 일수', -- 기간외 학습 일수
	PERIOD_OUT_LEARN_STATUS_CD VARCHAR(30)   NULL     COMMENT '기간외 학습 인정 상태', -- 기간외 학습 인정 상태
	LEARN_STATUS_CHECK_YN      CHAR(1)       NULL     COMMENT '학습 상태 체크 여부', -- 학습 상태 체크 여부
	NEW_WINDOW_LEARN_YN        CHAR(1)       NULL     COMMENT '새창 학습 여부', -- 새창 학습 여부
	LESSON_DATA_FILE_YN        CHAR(1)       NULL     COMMENT '학습 자료 파일 여부', -- 학습 자료 파일 여부
	LESSON_DATA_FILE_NM        VARCHAR(200)  NULL     COMMENT '학습 자료 파일 명', -- 학습 자료 파일 명
	LESSON_DATA_FILE_PATH      VARCHAR(200)  NULL     COMMENT '학습 자료 경로', -- 학습 자료 경로
	LESSON_DATA_FILE_URL       VARCHAR(500)  NULL     COMMENT '학습 자료 URL', -- 학습 자료 URL
	ATTPLAN_TIME               INT           NULL     COMMENT '출석 시간', -- 출석 시간
	SKPLC_DIV_CD               VARCHAR(30)   NULL     COMMENT '휴보강 구분 코드', -- 휴보강 구분 코드
	VC_LEARN_START_DTTM        VARCHAR(14)   NULL     COMMENT '화상학습 시작 일시', -- 화상학습 시작 일시
	VC_LEARN_END_DTTM          VARCHAR(14)   NULL     COMMENT '화상학습 종료 일시', -- 화상학습 종료 일시
	VC_LEARN_ROOM_PWD          VARCHAR(30)   NULL     COMMENT '화상학습방비밀번호', -- 화상학습방비밀번호
	VC_LEARN_DESC              VARCHAR(2000) NULL     COMMENT '화상학습 설명', -- 화상학습 설명
	VC_ROOM_REL_ID             VARCHAR(500)  NULL     COMMENT '화상학습 연결 ID', -- 화상학습 연결 ID
	CNTS_TEXT                  TEXT          NULL     COMMENT '콘텐츠 텍스트', -- 콘텐츠 텍스트
	SUBTIT_KO                  VARCHAR(500)  NULL     COMMENT '자막_한글', -- 자막_한글
	SUBTIT_EN                  VARCHAR(500)  NULL     COMMENT '자막_영어', -- 자막_영어
	SCRIPT_KO                  VARCHAR(500)  NULL     COMMENT '스크립트_한글', -- 스크립트_한글
	SCRIPT_EN                  VARCHAR(500)  NULL     COMMENT '스크립트_영어', -- 스크립트_영어
	DEL_YN                     CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID                     VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM                   VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                     VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM                   VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 콘텐츠';

-- (강의) 학습 콘텐츠
ALTER TABLE tb_lms_lesson_cnts
	ADD CONSTRAINT PK_tb_lms_lesson_cnts -- PK_tb_lms_lesson_cnts
		PRIMARY KEY (
			LESSON_CNTS_ID -- 학습 콘텐츠 ID
		);

-- IX_(강의) 학습 콘텐츠
CREATE INDEX IX_tb_lms_lesson_cnts
	ON tb_lms_lesson_cnts( -- (강의) 학습 콘텐츠
		LESSON_SCHEDULE_ID ASC -- 학습 일정 ID
	);

-- (강의) 학습 페이지
CREATE TABLE tb_lms_lesson_page (
	LESSON_CNTS_ID VARCHAR(30)  NOT NULL COMMENT '학습 콘텐츠 ID', -- 학습 콘텐츠 ID
	PAGE_CNT       VARCHAR(40)  NOT NULL COMMENT '페이지 순번', -- 페이지 순번
	UPLOAD_GBN     VARCHAR(4)   NULL     COMMENT '업로드 구분', -- 업로드 구분
	PAGE_NM        VARCHAR(300) NOT NULL COMMENT '페이지 명', -- 페이지 명
	URL            VARCHAR(500) NULL     COMMENT 'URL', -- URL
	VIDEO_TM       INT          NULL     DEFAULT 0 COMMENT '비디오 시간', -- 비디오 시간
	ATND_YN        CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '출석 반영 여부', -- 출석 반영 여부
	OPEN_YN        CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '오픈 여부', -- 오픈 여부
	RGTR_ID         VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 페이지';

-- (강의) 학습 페이지
ALTER TABLE tb_lms_lesson_page
	ADD CONSTRAINT PK_tb_lms_lesson_page -- PK_tb_lms_lesson_page
		PRIMARY KEY (
			LESSON_CNTS_ID, -- 학습 콘텐츠 ID
			PAGE_CNT        -- 페이지 순번
		);

-- (강의) 학습 일정
CREATE TABLE tb_lms_lesson_schedule (
	LESSON_SCHEDULE_ID    VARCHAR(30)   NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	CRS_CRE_CD            VARCHAR(30)   NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	LESSON_SCHEDULE_NM    VARCHAR(200)  NOT NULL COMMENT '학습 일정 명', -- 학습 일정 명
	LESSON_SCHEDULE_ORDER INT           NOT NULL COMMENT '학습 일정 순서', -- 학습 일정 순서
	ENRL_TYPE             VARCHAR(10)   NOT NULL DEFAULT 'ONLINE' COMMENT '수강 유형', -- 수강 유형
	LESSON_OBJECT         VARCHAR(2000) NULL     COMMENT '학습 목표', -- 학습 목표
	LESSON_SUMMARY        VARCHAR(2000) NULL     COMMENT '학습 개요', -- 학습 개요
	LESSON_REF_DATA       VARCHAR(2000) NULL     COMMENT '학습 참고 자료', -- 학습 참고 자료
	LESSON_START_DT       VARCHAR(8)    NULL     COMMENT '학습 시작 일자', -- 학습 시작 일자
	LESSON_END_DT         VARCHAR(8)    NULL     COMMENT '학습 종료 일자', -- 학습 종료 일자
	LT_DETM_FR_DT         VARCHAR(8)    NULL     COMMENT '강의인정 시작 일자', -- 강의인정 시작 일자
	LT_DETM_TO_DT         VARCHAR(8)    NULL     COMMENT '강의인정 종료 일자', -- 강의인정 종료 일자
	OPEN_YN               CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '오픈 여부', -- 오픈 여부
	LBN_TM                INT           NOT NULL DEFAULT 0 COMMENT '목차 학습 시간', -- 목차 학습 시간
	LT_NOTE               VARCHAR(2000) NULL     COMMENT '강의노트', -- 강의노트
	LT_NOTE2              VARCHAR(2000) NULL     COMMENT '강의노트2', -- 강의노트2
	LT_NOTE_OFFER_YN      CHAR(1)       NULL     DEFAULT 'N' COMMENT '강의노트 제공 여부', -- 강의노트 제공 여부
	WEK_CLSF_GBN          VARCHAR(10)   NOT NULL DEFAULT '01' COMMENT '주차별 강의 구분', -- 주차별 강의 구분
	DEL_YN                CHAR(1)       NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID                VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM              VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM              VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 일정';

-- (강의) 학습 일정
ALTER TABLE tb_lms_lesson_schedule
	ADD CONSTRAINT PK_tb_lms_lesson_schedule -- PK_tb_lms_lesson_schedule
		PRIMARY KEY (
			LESSON_SCHEDULE_ID -- 학습 일정 ID
		);

-- IX_tb_lms_lesson_schedule
CREATE INDEX IX_tb_lms_lesson_schedule
	ON tb_lms_lesson_schedule( -- (강의) 학습 일정
		CRS_CRE_CD ASC,            -- 과정개설 코드
		LESSON_SCHEDULE_ID ASC,    -- 학습 일정 ID
		LESSON_START_DT ASC,       -- 학습 시작 일자
		LESSON_END_DT ASC,         -- 학습 종료 일자
		LESSON_SCHEDULE_ORDER ASC, -- 학습 일정 순서
		DEL_YN ASC                 -- 삭제 여부
	);

-- (강의) 학습 기록 상세
CREATE TABLE tb_lms_lesson_study_detail (
	STUDY_DETAIL_ID  VARCHAR(30)  NOT NULL COMMENT '학습 기록 상세 ID', -- 학습 기록 상세 ID
	STD_NO           VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	LESSON_CNTS_ID   VARCHAR(30)  NOT NULL COMMENT '학습 콘텐츠 ID', -- 학습 콘텐츠 ID
	CRS_CRE_CD       VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	STUDY_CNT        INT          NULL     COMMENT '학습 횟수', -- 학습 횟수
	STUDY_TM         INT          NULL     COMMENT '학습 시간', -- 학습 시간
	STUDY_BROWSER_CD VARCHAR(50)  NULL     COMMENT '학습 브라우저 코드', -- 학습 브라우저 코드
	STUDY_DEVICE_CD  VARCHAR(30)  NULL     COMMENT '학습 기기 코드', -- 학습 기기 코드
	STUDY_CLIENT_ENV VARCHAR(200) NULL     COMMENT '학습자 환경', -- 학습자 환경
	REG_IP           VARCHAR(50)  NOT NULL COMMENT '등록자 IP', -- 등록자 IP
	RGTR_ID           VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 기록 상세';

-- (강의) 학습 기록 상세
ALTER TABLE tb_lms_lesson_study_detail
	ADD CONSTRAINT PK_tb_lms_lesson_study_detail -- PK_tb_lms_lesson_study_detail
		PRIMARY KEY (
			STUDY_DETAIL_ID -- 학습 기록 상세 ID
		);

-- IX_(강의) 학습 기록 상세
CREATE INDEX IX_tb_lms_lesson_study_detail
	ON tb_lms_lesson_study_detail( -- (강의) 학습 기록 상세
		LESSON_CNTS_ID ASC -- 학습 콘텐츠 ID
	);

-- (강의) 학습 메모
CREATE TABLE tb_lms_lesson_study_memo (
	STUDY_MEMO_ID      VARCHAR(30)  NOT NULL COMMENT '학습 메모 ID', -- 학습 메모 ID
	STD_NO             VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	USER_ID            VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	CRS_CRE_CD         VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	LESSON_SCHEDULE_ID VARCHAR(30)  NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	LESSON_CNTS_ID     VARCHAR(30)  NOT NULL COMMENT '학습 콘텐츠 ID', -- 학습 콘텐츠 ID
	STUDY_SESSION_LOC  VARCHAR(30)  NULL     COMMENT '최근 학습 위치', -- 최근 학습 위치
	MEMO_TITLE         VARCHAR(200) NOT NULL COMMENT '메모 제목', -- 메모 제목
	MEMO_CNTS          LONGTEXT     NULL     COMMENT '메모 내용', -- 메모 내용
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 메모';

-- (강의) 학습 메모
ALTER TABLE tb_lms_lesson_study_memo
	ADD CONSTRAINT PK_tb_lms_lesson_study_memo -- PK_tb_lms_lesson_study_memo
		PRIMARY KEY (
			STUDY_MEMO_ID -- 학습 메모 ID
		);

-- (강의) 페이지 학습 기록
CREATE TABLE tb_lms_lesson_study_page (
	LESSON_CNTS_ID     VARCHAR(30) NOT NULL COMMENT '학습 콘텐츠 ID', -- 학습 콘텐츠 ID
	STD_NO             VARCHAR(40) NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	PAGE_CNT           VARCHAR(40) NOT NULL COMMENT '페이지 순번', -- 페이지 순번
	CRS_CRE_CD         VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	STUDY_CNT          INT         NULL     COMMENT '학습 횟수', -- 학습 횟수
	STUDY_SESSION_TM   INT         NULL     COMMENT '최근 학습 시간(초)', -- 최근 학습 시간
	STUDY_START_DTTM   VARCHAR(14) NULL     COMMENT '학습 시작 일시', -- 학습 시작 일시
	STUDY_SESSION_DTTM VARCHAR(14) NULL     COMMENT '최근 학습 일시', -- 최근 학습 일시
	STUDY_SESSION_LOC  VARCHAR(30) NULL     COMMENT '최근 학습 위치', -- 최근 학습 위치
	PRGR_RATIO         INT         NULL     DEFAULT 0 COMMENT '진도 비율', -- 진도 비율
	RGTR_ID             VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 페이지 학습 기록';

-- (강의) 페이지 학습 기록
ALTER TABLE tb_lms_lesson_study_page
	ADD CONSTRAINT PK_tb_lms_lesson_study_page -- PK_tb_lms_lesson_study_page
		PRIMARY KEY (
			LESSON_CNTS_ID, -- 학습 콘텐츠 ID
			STD_NO,         -- 수강생 번호
			PAGE_CNT        -- 페이지 순번
		);

-- (강의) 학습 기록
CREATE TABLE tb_lms_lesson_study_record (
	STD_NO              VARCHAR(40) NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	LESSON_CNTS_ID      VARCHAR(30) NOT NULL COMMENT '학습 콘텐츠 ID', -- 학습 콘텐츠 ID
	CRS_CRE_CD          VARCHAR(30) NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	STUDY_STATUS_CD     VARCHAR(30) NULL     COMMENT '학습 상태 코드', -- 학습 상태 코드
	STUDY_STATUS_CD_BAK VARCHAR(30) NULL     COMMENT '학습 상태 코드 백업', -- 학습 상태 코드 백업
	STUDY_CNT           INT         NULL     COMMENT '학습 횟수', -- 학습 횟수
	STUDY_SESSION_TM    INT         NULL     COMMENT '최근 학습 시간(초)', -- 최근 학습 시간
	STUDY_TOTAL_TM      INT         NULL     COMMENT '총 학습 시간(초)', -- 총 학습 시간
	STUDY_AFTER_TM      INT         NULL     COMMENT '기간후 학습 시간 (초)', -- 기간후 학습 시간
	STUDY_START_DTTM    VARCHAR(14) NULL     COMMENT '학습 시작 일시', -- 학습 시작 일시
	STUDY_SESSION_DTTM  VARCHAR(14) NULL     COMMENT '최근 학습 일시', -- 최근 학습 일시
	STUDY_SESSION_LOC   VARCHAR(30) NULL     COMMENT '최근 학습 위치', -- 최근 학습 위치
	STUDY_MAX_LOC       VARCHAR(30) NULL     COMMENT '최대 학습 위치', -- 최대 학습 위치
	PRGR_RATIO          INT         NULL     COMMENT '진도 비율', -- 진도 비율
	RGTR_ID              VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID              VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM            VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 기록';

-- (강의) 학습 기록
ALTER TABLE tb_lms_lesson_study_record
	ADD CONSTRAINT PK_lms_lesson_study_record -- PK_lms_lesson_study_record
		PRIMARY KEY (
			STD_NO,         -- 수강생 번호
			LESSON_CNTS_ID  -- 학습 콘텐츠 ID
		);

-- (강의) 주차 학습 상황
CREATE TABLE tb_lms_lesson_study_state (
	LESSON_SCHEDULE_ID  VARCHAR(30)   NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	STD_NO              VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	CRS_CRE_CD          VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	USER_ID             VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	STUDY_STATUS_CD     VARCHAR(30)   NULL     COMMENT '학습 상태 코드', -- 학습 상태 코드
	STUDY_STATUS_CD_BAK VARCHAR(30)   NULL     COMMENT '학습 상태 코드 백업', -- 학습 상태 코드 백업
	ATTEND_REASON       VARCHAR(1000) NULL     COMMENT '출석 처리 사유', -- 출석 처리 사유
	RGTR_ID              VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID              VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM            VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 주차 학습 상황';

-- (강의) 주차 학습 상황
ALTER TABLE tb_lms_lesson_study_state
	ADD CONSTRAINT PK_tb_lms_lesson_study_state -- PK_tb_lms_lesson_study_state
		PRIMARY KEY (
			LESSON_SCHEDULE_ID, -- 학습 일정 ID
			STD_NO              -- 수강생 번호
		);

-- IX_Ttb_lms_lesson_study_state
CREATE INDEX IX_tb_lms_lesson_study_state
	ON tb_lms_lesson_study_state( -- (강의) 주차 학습 상황
		USER_ID ASC -- 사용자 번호
	);

-- (강의) 학습 일정 교시
CREATE TABLE tb_lms_lesson_time (
	LESSON_TIME_ID     VARCHAR(30)  NOT NULL COMMENT '교시 ID', -- 교시 ID
	LESSON_SCHEDULE_ID VARCHAR(30)  NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	CRS_CRE_CD         VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	LESSON_TIME_NM     VARCHAR(200) NOT NULL COMMENT '교시 명', -- 교시 명
	LESSON_TIME_ORDER  INT          NOT NULL COMMENT '교시 순서', -- 교시 순서
	STDY_METHOD        VARCHAR(10)  NOT NULL DEFAULT 'RND' COMMENT '학습 방법', -- 학습 방법
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 학습 일정 교시';

-- (강의) 학습 일정 교시
ALTER TABLE tb_lms_lesson_time
	ADD CONSTRAINT PK_tb_lms_lesson_time -- PK_tb_lms_lesson_time
		PRIMARY KEY (
			LESSON_TIME_ID -- 교시 ID
		);

-- (상호평가) 상호평가
CREATE TABLE tb_lms_mut_eval (
	EVAL_CD      VARCHAR(30)  NOT NULL COMMENT '평가 코드', -- 평가 코드
	EVAL_TYPE_CD VARCHAR(30)  NOT NULL COMMENT '평가 유형 코드', -- 평가 유형 코드
	EVAL_TITLE   VARCHAR(200) NULL     COMMENT '평가 제목', -- 평가 제목
	DEL_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	USE_YN       CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	ADMIN_YN     CHAR(1)      NULL     DEFAULT 'N' COMMENT '관리자 등록 여부', -- 관리자 등록 여부
	RGTR_ID       VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(상호평가) 상호평가';

-- (상호평가) 상호평가
ALTER TABLE tb_lms_mut_eval
	ADD CONSTRAINT PK_tb_lms_mut_eval -- PK_tb_lms_mut_eval
		PRIMARY KEY (
			EVAL_CD -- 평가 코드
		);

-- (상호평가) 상호평가 등급
CREATE TABLE tb_lms_mut_eval_grade (
	GRADE_CD    VARCHAR(30)   NOT NULL COMMENT '등급 코드', -- 등급 코드
	EVAL_CD     VARCHAR(30)   NOT NULL COMMENT '평가 코드', -- 평가 코드
	QSTN_CD     VARCHAR(30)   NOT NULL COMMENT '문제 코드', -- 문제 코드
	GRADE_TITLE VARCHAR(200)  NULL     COMMENT '등급 제목', -- 등급 제목
	GRADE_CTS   VARCHAR(2000) NULL     COMMENT '등급 설명', -- 등급 설명
	GRADE_SCORE INT           NULL     COMMENT '등급 성적', -- 등급 성적
	RGTR_ID      VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(상호평가) 상호평가 등급';

-- (상호평가) 상호평가 등급
ALTER TABLE tb_lms_mut_eval_grade
	ADD CONSTRAINT PK_tb_lms_mut_eval_grade -- PK_tb_lms_mut_eval_grade
		PRIMARY KEY (
			GRADE_CD, -- 등급 코드
			EVAL_CD,  -- 평가 코드
			QSTN_CD   -- 문제 코드
		);

-- IX_tb_lms_mut_eval_grade
CREATE INDEX IX_tb_lms_mut_eval_grade
	ON tb_lms_mut_eval_grade( -- (상호평가) 상호평가 등급
		EVAL_CD ASC, -- 평가 코드
		QSTN_CD ASC  -- 문제 코드
	);

-- (상호평가) 상호평가 등급 문항
CREATE TABLE tb_lms_mut_eval_qstn (
	EVAL_CD      VARCHAR(30) NOT NULL COMMENT '평가 코드', -- 평가 코드
	QSTN_CD      VARCHAR(30) NOT NULL COMMENT '문제 코드', -- 문제 코드
	EVAL_TYPE_CD VARCHAR(30) NULL     COMMENT '평가 유형 코드', -- 평가 유형 코드
	PAR_QSTN_CD  VARCHAR(30) NULL     COMMENT '상위 문제 코드', -- 상위 문제 코드
	QSTN_NO      INT         NULL     COMMENT '문제 번호', -- 문제 번호
	QSTN_CTS     LONGTEXT    NULL     COMMENT '문제 내용', -- 문제 내용
	EVAL_SCORE   INT         NOT NULL DEFAULT 0 COMMENT '평가 점수', -- 평가 점수
	RGTR_ID       VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(상호평가) 상호평가 등급 문항';

-- (상호평가) 상호평가 등급 문항
ALTER TABLE tb_lms_mut_eval_qstn
	ADD CONSTRAINT PK_tb_lms_mut_eval_qstn -- PK_tb_lms_mut_eval_qstn
		PRIMARY KEY (
			EVAL_CD, -- 평가 코드
			QSTN_CD  -- 문제 코드
		);

-- IX_tb_lms_mut_eval_qstn
CREATE INDEX IX_tb_lms_mut_eval_qstn
	ON tb_lms_mut_eval_qstn( -- (상호평가) 상호평가 등급 문항
		EVAL_CD ASC -- 평가 코드
	);

-- (상호평가) 상호평가 연결
CREATE TABLE tb_lms_mut_eval_rltn (
	EVAL_CD     VARCHAR(30) NOT NULL COMMENT '평가 코드', -- 평가 코드
	RLTN_CD     VARCHAR(30) NOT NULL DEFAULT 'RLTN_00000000000000000001' COMMENT '연결 코드', -- 연결 코드
	EVAL_DIV_CD VARCHAR(30) NULL     COMMENT '평가 구분 코드', -- 평가 구분 코드
	CRS_CRE_CD  VARCHAR(30) NULL     COMMENT '과정개설 코드' -- 과정개설 코드
)
COMMENT '(상호평가) 상호평가 연결';

-- (상호평가) 상호평가 연결
ALTER TABLE tb_lms_mut_eval_rltn
	ADD CONSTRAINT PK_tb_lms_mut_eval_rltn -- PK_tb_lms_mut_eval_rltn
		PRIMARY KEY (
			EVAL_CD, -- 평가 코드
			RLTN_CD  -- 연결 코드
		);

-- (상호평가) 상호평가 결과
CREATE TABLE tb_lms_mut_eval_rslt (
	MUT_EVAL_CD       VARCHAR(30)   NOT NULL COMMENT '상호평가 코드', -- 상호평가 코드
	EVAL_CD           VARCHAR(30)   NOT NULL COMMENT '평가 코드', -- 평가 코드
	RLTN_CD           VARCHAR(30)   NOT NULL COMMENT '연결 코드', -- 연결 코드
	RLTN_TEAM_CD      VARCHAR(30)   NULL     COMMENT '연결 팀 ID', -- 연결 팀 ID
	EVAL_USER_ID      VARCHAR(30)   NULL     COMMENT '평가 사용자 번호', -- 평가 사용자 번호
	EVAL_TRGT_USER_ID VARCHAR(30)   NULL     COMMENT '평가 대상 사용자 번호', -- 평가 대상 사용자 번호
	EVAL_DTTM         VARCHAR(14)   NULL     COMMENT '평가 일시', -- 평가 일시
	QSTN_NOS          VARCHAR(2000) NULL     COMMENT '문항 번호들', -- 문항 번호들
	EVAL_SCORES       VARCHAR(2000) NULL     COMMENT '평가 점수들', -- 평가 점수들
	EVAL_TOTAL        INT           NULL     COMMENT '평가 총점', -- 평가 총점
	EVAL_CTS          LONGTEXT      NULL     COMMENT '평가 내용', -- 평가 내용
	EVAL_STATUS_CD    VARCHAR(30)   NULL     COMMENT '평가 상태', -- 평가 상태
	RGTR_ID            VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(상호평가) 상호평가 결과';

-- (상호평가) 상호평가 결과
ALTER TABLE tb_lms_mut_eval_rslt
	ADD CONSTRAINT PK_tb_lms_mut_eval_rslt -- PK_tb_lms_mut_eval_rslt
		PRIMARY KEY (
			MUT_EVAL_CD, -- 상호평가 코드
			EVAL_CD,     -- 평가 코드
			RLTN_CD      -- 연결 코드
		);

-- IX_tb_lms_mut_eval_rslt
CREATE INDEX IX_tb_lms_mut_eval_rslt
	ON tb_lms_mut_eval_rslt( -- (상호평가) 상호평가 결과
		RLTN_CD ASC, -- 연결 코드
		EVAL_CD ASC  -- 평가 코드
	);

-- (설문) 설문 정보
CREATE TABLE tb_lms_resch (
	RESCH_CD           VARCHAR(30)  NOT NULL COMMENT '설문 코드', -- 설문 코드
	RESCH_CTGR_CD      VARCHAR(30)  NULL     COMMENT '설문 분류 코드', -- 설문 분류 코드
	RESCH_TPL_CD       VARCHAR(30)  NULL     COMMENT '설문 템플릿 코드', -- 설문 템플릿 코드
	RESCH_TPL_YN       CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '설문 템플릿 여부', -- 설문 템플릿 여부
	ORG_ID             VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	RESCH_TITLE        VARCHAR(200) NOT NULL COMMENT '설문 제목', -- 설문 제목
	RESCH_CTS          LONGTEXT     NULL     COMMENT '설문 내용', -- 설문 내용
	RESCH_TYPE_CD      VARCHAR(30)  NOT NULL COMMENT '설문 구분 코드', -- 설문 구분 코드
	JOIN_TRGT          VARCHAR(100) NULL     COMMENT '참여 대상', -- 참여 대상
	RESCH_START_DTTM   VARCHAR(14)  NULL     COMMENT '설문 시작 일시', -- 설문 시작 일시
	RESCH_END_DTTM     VARCHAR(14)  NULL     COMMENT '설문 종료 일시', -- 설문 종료 일시
	RSLT_TYPE_CD       VARCHAR(30)  NULL     COMMENT '결과 공개 유형 코드', -- 결과 공개 유형 코드
	SCORE_VIEW_YN      CHAR(1)      NULL     DEFAULT 'N' COMMENT '성적 조회 여부', -- 성적 조회 여부
	DECLS_REG_YN       CHAR(1)      NULL     COMMENT '분반 등록 여부', -- 분반 등록 여부
	ITEM_COPY_YN       CHAR(1)      NULL     COMMENT '문항 복사 여부', -- 문항 복사 여부
	ITEM_COPY_RESCH_CD VARCHAR(30)  NULL     COMMENT '문항 복사 설문 코드', -- 문항 복사 설문 코드
	USE_YN             CHAR(1)      NULL     DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	DEL_YN             CHAR(1)      NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RESCH_SUBMIT_YN    CHAR(1)      NULL     DEFAULT 'N' COMMENT '설문 출제 완료 여부', -- 설문 출제 완료 여부
	SCORE_APLY_YN      CHAR(1)      NULL     COMMENT '성적 반영 여부', -- 성적 반영 여부
	SCORE_RATIO        INT          NULL     COMMENT '성적 반영 비율', -- 성적 반영 비율
	SCORE_OPEN_YN      CHAR(1)      NULL     COMMENT '성적 공개 여부', -- 성적 공개 여부
	EXT_JOIN_YN        CHAR(1)      NULL     DEFAULT 'N' COMMENT '연장 참여 여부', -- 연장 참여 여부
	EXT_END_DTTM       VARCHAR(14)  NULL     COMMENT '연장 종료 일시', -- 연장 종료 일시
	EVAL_CTGR          CHAR(1)      NULL     COMMENT '평가 방식', -- 평가 방식
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 정보';

-- (설문) 설문 정보
ALTER TABLE tb_lms_resch
	ADD CONSTRAINT PK_tb_lms_resch -- PK_tb_lms_resch
		PRIMARY KEY (
			RESCH_CD -- 설문 코드
		);

-- IX_tb_lms_resch
CREATE INDEX IX_tb_lms_resch
	ON tb_lms_resch( -- (설문) 설문 정보
		RESCH_TPL_CD ASC -- 설문 템플릿 코드
	);

-- (설문) 설문 응답
CREATE TABLE tb_lms_resch_ansr (
	RESCH_ANSR_CD      VARCHAR(30) NOT NULL COMMENT '설문 응답 코드', -- 설문 응답 코드
	USER_ID            VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	RESCH_CD           VARCHAR(30) NULL     COMMENT '설문 코드', -- 설문 코드
	RESCH_QSTN_CD      VARCHAR(30) NULL     COMMENT '설문 항목 코드', -- 설문 항목 코드
	RESCH_QSTN_ITEM_CD VARCHAR(30) NULL     COMMENT '설문 항목 선택지 코드', -- 설문 항목 선택지 코드
	RESCH_SCALE_CD     VARCHAR(30) NULL     COMMENT '설문 척도 코드', -- 설문 척도 코드
	ETC_OPINION        LONGTEXT    NULL     COMMENT '기타 의견', -- 기타 의견
	RGTR_ID             VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 응답';

-- (설문) 설문 응답
ALTER TABLE tb_lms_resch_ansr
	ADD CONSTRAINT PK_tb_lms_resch_ansr -- PK_tb_lms_resch_ansr
		PRIMARY KEY (
			RESCH_ANSR_CD -- 설문 응답 코드
		);

-- (설문) 설문 개설과정 연결
CREATE TABLE tb_lms_resch_cre_crs_rltn (
	CRS_CRE_CD VARCHAR(30) NOT NULL DEFAULT 'LEB' COMMENT '과정개설 코드', -- 과정개설 코드
	RESCH_CD   VARCHAR(30) NOT NULL COMMENT '설문 코드', -- 설문 코드
	GRP_CD     VARCHAR(30) NULL     COMMENT '그룹 코드', -- 그룹 코드
	DEL_YN     CHAR(1)     NULL     DEFAULT 'N' COMMENT '삭제 여부' -- 삭제 여부
)
COMMENT '(설문) 설문 개설과정 연결';

-- (설문) 설문 개설과정 연결
ALTER TABLE tb_lms_resch_cre_crs_rltn
	ADD CONSTRAINT PK_tb_lms_resch_cre_crs_rltn -- PK_tb_lms_resch_cre_crs_rltn
		PRIMARY KEY (
			CRS_CRE_CD, -- 과정개설 코드
			RESCH_CD    -- 설문 코드
		);

-- IX_tb_lms_resch_cre_crs_rltn
CREATE INDEX IX_tb_lms_resch_cre_crs_rltn
	ON tb_lms_resch_cre_crs_rltn( -- (설문) 설문 개설과정 연결
		RESCH_CD ASC,   -- 설문 코드
		CRS_CRE_CD ASC  -- 과정개설 코드
	);

-- (설문) 설문 분류
CREATE TABLE tb_lms_resch_ctgr (
	RESCH_CTGR_CD     VARCHAR(30)   NOT NULL COMMENT '설문 분류 코드', -- 설문 분류 코드
	ORG_ID            VARCHAR(30)   NULL     COMMENT '기관 코드', -- 기관 코드
	PAR_RESCH_CTGR_CD VARCHAR(30)   NULL     COMMENT '상위 설문 분류 코드', -- 상위 설문 분류 코드
	RESCH_CTGR_NM     VARCHAR(200)  NOT NULL COMMENT '설문 분류 명', -- 설문 분류 명
	RESCH_CTGR_DESC   VARCHAR(2000) NULL     COMMENT '설문 분류 설명', -- 설문 분류 설명
	RESCH_CTGR_LVL    INT           NULL     COMMENT '설문 분류 레벨', -- 설문 분류 레벨
	RESCH_CTGR_ODR    INT           NULL     COMMENT '설문 분류 순서', -- 설문 분류 순서
	SHARE_YN          CHAR(1)       NULL     COMMENT '공유 여부', -- 공유 여부
	USE_YN            CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	DEL_YN            CHAR(1)       NULL     DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID            VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 분류';

-- (설문) 설문 분류
ALTER TABLE tb_lms_resch_ctgr
	ADD CONSTRAINT PK_tb_lms_resch_ctgr -- PK_tb_lms_resch_ctgr
		PRIMARY KEY (
			RESCH_CTGR_CD -- 설문 분류 코드
		);

-- (설문) 설문 참여자
CREATE TABLE tb_lms_resch_join_user (
	RESCH_CD            VARCHAR(30)   NOT NULL COMMENT '설문 코드', -- 설문 코드
	USER_ID             VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	STD_NO              VARCHAR(40)   NULL     COMMENT '수강생 번호', -- 수강생 번호
	DEVICE_TYPE_CD      VARCHAR(30)   NULL     COMMENT '접속 환경 코드', -- 접속 환경 코드
	CONN_IP             VARCHAR(50)   NULL     COMMENT '접속 IP', -- 접속 IP
	SCORE               DECIMAL(5,2)  NOT NULL DEFAULT 0 COMMENT '점수', -- 점수
	EVAL_YN             CHAR(1)       NOT NULL COMMENT '평가 여부', -- 평가 여부
	PROF_MEMO           VARCHAR(2000) NULL     COMMENT '교수 메모', -- 교수 메모
	KONAN_COMP_DT       VARCHAR(14)   NULL     COMMENT '과제모사 비교 일시', -- 과제모사 비교 일시
	KONAN_MAX_COPY_RATE DECIMAL(5,2)  NULL     COMMENT '과제모사율', -- 과제모사율
	KONAN_MAX_COPY_ID   VARCHAR(100)  NULL     COMMENT '과제모사 참조 ID', -- 과제모사 참조 ID
	RGTR_ID              VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID              VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM            VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 참여자';

-- (설문) 설문 참여자
ALTER TABLE tb_lms_resch_join_user
	ADD CONSTRAINT PK_tb_lms_resch_join_user -- PK_tb_lms_resch_join_user
		PRIMARY KEY (
			RESCH_CD, -- 설문 코드
			USER_ID   -- 사용자 번호
		);

-- (설문) 설문 페이지
CREATE TABLE tb_lms_resch_page (
	RESCH_PAGE_CD    VARCHAR(30)  NOT NULL COMMENT '설문 페이지 코드', -- 설문 페이지 코드
	RESCH_CD         VARCHAR(30)  NOT NULL COMMENT '설문 코드', -- 설문 코드
	RESCH_PAGE_TITLE VARCHAR(200) NULL     COMMENT '설문 페이지 제목', -- 설문 페이지 제목
	RESCH_PAGE_ARTL  LONGTEXT     NULL     COMMENT '설문 페이지 내용', -- 설문 페이지 내용
	RESCH_PAGE_ODR   INT          NULL     COMMENT '설문 페이지 순서', -- 설문 페이지 순서
	RGTR_ID           VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 페이지';

-- (설문) 설문 페이지
ALTER TABLE tb_lms_resch_page
	ADD CONSTRAINT PK_tb_lms_resch_page -- PK_tb_lms_resch_page
		PRIMARY KEY (
			RESCH_PAGE_CD -- 설문 페이지 코드
		);

-- (설문) 설문 문항
CREATE TABLE tb_lms_resch_qstn (
	RESCH_QSTN_CD      VARCHAR(30)  NOT NULL COMMENT '설문 항목 코드', -- 설문 항목 코드
	RESCH_PAGE_CD      VARCHAR(30)  NULL     COMMENT '설문 페이지 코드', -- 설문 페이지 코드
	RESCH_QSTN_TYPE_CD VARCHAR(30)  NULL     COMMENT '설문 항목 유형 코드', -- 설문 항목 유형 코드
	RESCH_QSTN_TITLE   VARCHAR(200) NULL     COMMENT '설문 항목 제목', -- 설문 항목 제목
	RESCH_QSTN_CTS     LONGTEXT     NULL     COMMENT '설문 항목 내용', -- 설문 항목 내용
	RESCH_QSTN_ODR     INT          NULL     COMMENT '설문 항목 순서', -- 설문 항목 순서
	REQ_CHOICE_YN      CHAR(1)      NULL     COMMENT '필수 선택 여부', -- 필수 선택 여부
	ETC_OPINION_YN     CHAR(1)      NULL     COMMENT '기타 의견 여부', -- 기타 의견 여부
	JUMP_CHOICE_YN     CHAR(1)      NULL     COMMENT '이동 선택 여부', -- 이동 선택 여부
	RESCH_SCALE_LVL    INT          NULL     COMMENT '척도 평가 등급', -- 척도 평가 등급
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 문항';

-- (설문) 설문 문항
ALTER TABLE tb_lms_resch_qstn
	ADD CONSTRAINT PK_tb_lms_resch_qstn -- PK_tb_lms_resch_qstn
		PRIMARY KEY (
			RESCH_QSTN_CD -- 설문 항목 코드
		);

-- (설문) 설문 문항 선택지
CREATE TABLE tb_lms_resch_qstn_item (
	RESCH_QSTN_ITEM_CD    VARCHAR(30)  NOT NULL COMMENT '설문 항목 선택지 코드', -- 설문 항목 선택지 코드
	RESCH_QSTN_CD         VARCHAR(30)  NULL     COMMENT '설문 항목 코드', -- 설문 항목 코드
	RESCH_QSTN_ITEM_TITLE VARCHAR(200) NULL     COMMENT '설문 항목 선택지 제목', -- 설문 항목 선택지 제목
	ITEM_ODR              INT          NULL     COMMENT '항목 순서', -- 항목 순서
	JUMP_PAGE             VARCHAR(30)  NULL     DEFAULT 'NEXT' COMMENT '이동 페이지', -- 이동 페이지
	ETC_ITEM_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '기타 항목 여부', -- 기타 항목 여부
	RGTR_ID                VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM              VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM              VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 문항 선택지';

-- (설문) 설문 문항 선택지
ALTER TABLE tb_lms_resch_qstn_item
	ADD CONSTRAINT PK_tb_lms_resch_qstn_item -- PK_tb_lms_resch_qstn_item
		PRIMARY KEY (
			RESCH_QSTN_ITEM_CD -- 설문 항목 선택지 코드
		);

-- (설문) 설문 평가 척도
CREATE TABLE tb_lms_resch_scale (
	RESCH_SCALE_CD VARCHAR(30)  NOT NULL COMMENT '설문 척도 코드', -- 설문 척도 코드
	RESCH_QSTN_CD  VARCHAR(30)  NULL     COMMENT '설문 항목 코드', -- 설문 항목 코드
	SCALE_ODR      INT          NULL     COMMENT '척도 순서', -- 척도 순서
	SCALE_TITLE    VARCHAR(200) NULL     COMMENT '척도 제목', -- 척도 제목
	SCALE_SCORE    INT          NULL     COMMENT '척도 점수', -- 척도 점수
	RGTR_ID         VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(설문) 설문 평가 척도';

-- (설문) 설문 평가 척도
ALTER TABLE tb_lms_resch_scale
	ADD CONSTRAINT PK_tb_lms_resch_scale -- PK_tb_lms_resch_scale
		PRIMARY KEY (
			RESCH_SCALE_CD -- 설문 척도 코드
		);

-- (성적) 성적 출석 점수기준
CREATE TABLE tb_lms_score_atnd_conf (
	ORG_ID   VARCHAR(30) NOT NULL COMMENT '기관 코드', -- 기관 코드
	CONF_GBN VARCHAR(10) NOT NULL COMMENT '성적 설정 구분', -- 성적 설정 구분
	CONF_CD  VARCHAR(30) NOT NULL COMMENT '성적 설정 코드', -- 성적 설정 코드
	CONF_NM  VARCHAR(50) NULL     COMMENT '성적 설정 코드명', -- 성적 설정 코드명
	CONF_VAL VARCHAR(10) NOT NULL COMMENT '성적 설정 값', -- 성적 설정 값
	USE_YN   CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID   VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID   VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 성적 출석 점수기준';

-- (성적) 성적 출석 점수기준
ALTER TABLE tb_lms_score_atnd_conf
	ADD CONSTRAINT PK_tb_lms_score_atnd_conf -- PK_tb_lms_score_atnd_conf
		PRIMARY KEY (
			ORG_ID,   -- 기관 코드
			CONF_GBN, -- 성적 설정 구분
			CONF_CD   -- 성적 설정 코드
		);

-- (성적) 성적 누적 집계
CREATE TABLE tb_lms_score_cum (
	YY        VARCHAR(4)   NOT NULL COMMENT '년', -- 년
	TM_GBN    VARCHAR(8)   NOT NULL COMMENT '학기 구분', -- 학기 구분
	USER_ID   VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	HY        VARCHAR(1)   NOT NULL COMMENT '학년', -- 학년
	DEPT_CD   VARCHAR(30)  NULL     COMMENT '부서 코드', -- 부서 코드
	AVG_MRKS  DECIMAL(5,2) NULL     COMMENT '평균 평점', -- 평균 평점
	PCT_SCR   DECIMAL(5,2) NULL     COMMENT '백분위 점수', -- 백분위 점수
	CPTN_HP   DECIMAL(5,2) NULL     COMMENT '취득 학점 학사', -- 취득 학점 학사
	INSERT_AT DATETIME     NULL     COMMENT '등록 날짜 시간', -- 등록 날짜 시간
	MODIFY_AT DATETIME     NULL     COMMENT '수정 날짜 시간' -- 수정 날짜 시간
)
COMMENT '(성적) 성적 누적 집계';

-- (성적) 성적 누적 집계
ALTER TABLE tb_lms_score_cum
	ADD CONSTRAINT PK_tb_lms_score_cum -- PK_tb_lms_score_cum
		PRIMARY KEY (
			YY,      -- 년
			TM_GBN,  -- 학기 구분
			USER_ID, -- 사용자 번호
			HY       -- 학년
		);

-- (성적) 성적 환산 등급
CREATE TABLE tb_lms_score_grade_conf (
	ORG_ID     VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	SCOR_CD    VARCHAR(30)  NOT NULL COMMENT '성적 등급 코드', -- 성적 등급 코드
	UNI_CD     VARCHAR(1)   NOT NULL DEFAULT 'C' COMMENT '대학 코드', -- 대학 코드
	AVG_SCOR   DECIMAL(5,2) NULL     COMMENT '평점', -- 평점
	BASE_SCOR  DECIMAL(5,2) NULL     COMMENT '기준 점수', -- 기준 점수
	START_SCOR DECIMAL(5,2) NULL     COMMENT '시작 점수', -- 시작 점수
	END_SCOR   DECIMAL(5,2) NULL     COMMENT '종료 점수', -- 종료 점수
	SCOR_ODR   INT          NULL     COMMENT '등급 순서', -- 등급 순서
	USE_YN     CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID     VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM   VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID     VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM   VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 성적 환산 등급';

-- (성적) 성적 환산 등급
ALTER TABLE tb_lms_score_grade_conf
	ADD CONSTRAINT PK_tb_lms_score_grade_conf -- PK_tb_lms_score_grade_conf
		PRIMARY KEY (
			ORG_ID,  -- 기관 코드
			SCOR_CD, -- 성적 등급 코드
			UNI_CD   -- 대학 코드
		);

-- (성적) 현재 취득 성적
CREATE TABLE tb_lms_score_now (
	USER_ID   VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	AVG_MRKS  DECIMAL(5,2) NULL     COMMENT '평균 평점', -- 평균 평점
	PCT_SCR   DECIMAL(5,2) NULL     COMMENT '백분위 점수', -- 백분위 점수
	CPTN_HP   DECIMAL(5,2) NULL     COMMENT '취득 학점 학사', -- 취득 학점 학사
	INSERT_AT DATETIME     NULL     COMMENT '등록 날짜 시간', -- 등록 날짜 시간
	MODIFY_AT DATETIME     NULL     COMMENT '수정 날짜 시간' -- 수정 날짜 시간
)
COMMENT '(성적) 현재 취득 성적';

-- (성적) 현재 취득 성적
ALTER TABLE tb_lms_score_now
	ADD CONSTRAINT PK_tb_lms_score_now -- PK_tb_lms_score_now
		PRIMARY KEY (
			USER_ID -- 사용자 번호
		);

-- (성적) 성적 상대평가 비율 기준
CREATE TABLE tb_lms_score_rel_conf (
	ORG_ID        VARCHAR(30) NOT NULL COMMENT '기관 코드', -- 기관 코드
	SCOR_REL_CD   VARCHAR(30) NOT NULL COMMENT '평가 기준 코드', -- 평가 기준 코드
	UNI_CD        VARCHAR(1)  NOT NULL DEFAULT 'C' COMMENT '대학 코드', -- 대학 코드
	START_SCOR_CD VARCHAR(30) NOT NULL COMMENT '시작 성적 등급 코드', -- 시작 성적 등급 코드
	END_SCOR_CD   VARCHAR(30) NOT NULL COMMENT '종료 점수 코드', -- 종료 점수 코드
	START_RATIO   INT         NOT NULL COMMENT '시작 백분율', -- 시작 백분율
	END_RATIO     INT         NOT NULL COMMENT '종료 백분율', -- 종료 백분율
	SCOR_ODR      INT         NULL     COMMENT '등급 순서', -- 등급 순서
	USE_YN        CHAR(1)     NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID        VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 성적 상대평가 비율 기준';

-- (성적) 성적 상대평가 비율 기준
ALTER TABLE tb_lms_score_rel_conf
	ADD CONSTRAINT PK_tb_lms_score_rel_conf -- PK_tb_lms_score_rel_conf
		PRIMARY KEY (
			ORG_ID,      -- 기관 코드
			SCOR_REL_CD, -- 평가 기준 코드
			UNI_CD       -- 대학 코드
		);

-- (세미나) 세미나 정보
CREATE TABLE tb_lms_seminar (
	SEMINAR_ID         VARCHAR(30)  NOT NULL COMMENT '세미나 ID', -- 세미나 ID
	CRS_CRE_CD         VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	LESSON_SCHEDULE_ID VARCHAR(30)  NULL     COMMENT '학습 일정 ID', -- 학습 일정 ID
	LESSON_TIME_ID     VARCHAR(30)  NULL     COMMENT '교시 ID', -- 교시 ID
	SEMINAR_NM         VARCHAR(200) NULL     COMMENT '세미나 명', -- 세미나 명
	SEMINAR_CTS        LONGTEXT     NULL     COMMENT '세미나 내용', -- 세미나 내용
	SEMINAR_CTGR_CD    VARCHAR(30)  NULL     COMMENT '세미나 분류 코드', -- 세미나 분류 코드
	SEMINAR_START_DTTM VARCHAR(14)  NULL     COMMENT '세미나 시작 일시', -- 세미나 시작 일시
	SEMINAR_END_DTTM   VARCHAR(14)  NULL     COMMENT '세미나 종료 일시', -- 세미나 종료 일시
	SEMINAR_TIME       VARCHAR(4)   NULL     COMMENT '진행 시간', -- 진행 시간
	HOST_URL           VARCHAR(500) NULL     COMMENT '교수용 URL', -- 교수용 URL
	JOIN_URL           VARCHAR(500) NULL     COMMENT '참가 URL', -- 참가 URL
	ZOOM_ID            VARCHAR(100) NULL     COMMENT 'ZOOM ID', -- ZOOM ID
	ZOOM_PW            VARCHAR(100) NULL     COMMENT 'ZOOM 비밀번호', -- ZOOM 비밀번호
	ATT_PROC_YN        CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '출결 처리 여부', -- 출결 처리 여부
	AUTO_RECORD_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '자동 녹화 여부', -- 자동 녹화 여부
	DEL_YN             CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(세미나) 세미나 정보';

-- (세미나) 세미나 정보
ALTER TABLE tb_lms_seminar
	ADD CONSTRAINT PK_tb_lms_seminar -- PK_tb_lms_seminar
		PRIMARY KEY (
			SEMINAR_ID -- 세미나 ID
		);

-- (세미나) 세미나 참석
CREATE TABLE tb_lms_seminar_atnd (
	SEMINAR_ATND_ID VARCHAR(30)   NOT NULL COMMENT '세미나 참석 ID', -- 세미나 참석 ID
	SEMINAR_ID      VARCHAR(30)   NULL     COMMENT '세미나 ID', -- 세미나 ID
	STD_NO          VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	USER_ID         VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	ATND_DTTM       VARCHAR(14)   NULL     COMMENT '참석 일시', -- 참석 일시
	ATND_TIME       INT           NULL     COMMENT '참석 시간', -- 참석 시간
	ATND_CD         VARCHAR(30)   NULL     COMMENT '참석 상태 코드', -- 참석 상태 코드
	DEVICE_TYPE_CD  VARCHAR(30)   NOT NULL COMMENT '접속 환경 코드', -- 접속 환경 코드
	ATND_MEMO       VARCHAR(1000) NULL     COMMENT '출석 메모', -- 출석 메모
	REG_IP          VARCHAR(50)   NOT NULL COMMENT '등록자 IP', -- 등록자 IP
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(세미나) 세미나 참석';

-- (세미나) 세미나 참석
ALTER TABLE tb_lms_seminar_atnd
	ADD CONSTRAINT PK_tb_lms_seminar_atnd -- PK_tb_lms_seminar_atnd
		PRIMARY KEY (
			SEMINAR_ATND_ID -- 세미나 참석 ID
		);

-- (세미나) 세미나 참석 이력
CREATE TABLE tb_lms_seminar_hsty (
	SEMINAR_HSTY_ID VARCHAR(30) NOT NULL COMMENT '세미나 참석 기록 ID', -- 세미나 참석 기록 ID
	SEMINAR_ID      VARCHAR(30) NULL     COMMENT '세미나 ID', -- 세미나 ID
	STD_NO          VARCHAR(40) NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	ATND_DTTM       VARCHAR(14) NULL     COMMENT '참석 일시', -- 참석 일시
	DEVICE_TYPE_CD  VARCHAR(30) NOT NULL COMMENT '접속 환경 코드', -- 접속 환경 코드
	USER_ID         VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	REG_IP          VARCHAR(50) NOT NULL COMMENT '등록자 IP', -- 등록자 IP
	RGTR_ID          VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14) NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(세미나) 세미나 참석 이력';

-- (세미나) 세미나 참석 이력
ALTER TABLE tb_lms_seminar_hsty
	ADD CONSTRAINT PK_tb_lms_seminar_hsty -- PK_tb_lms_seminar_hsty
		PRIMARY KEY (
			SEMINAR_HSTY_ID -- 세미나 참석 기록 ID
		);

-- (세미나) 세미나 로그
CREATE TABLE tb_lms_seminar_log (
	SEMINAR_LOG_ID VARCHAR(30) NOT NULL COMMENT '세미나 로그 ID', -- 세미나 로그 ID
	SEMINAR_ID     VARCHAR(30) NULL     COMMENT '세미나 ID', -- 세미나 ID
	STD_NO         VARCHAR(40) NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	START_DTTM     VARCHAR(14) NULL     COMMENT '시작 일시', -- 시작 일시
	END_DTTM       VARCHAR(14) NULL     COMMENT '종료 일시', -- 종료 일시
	DEVICE_TYPE_CD VARCHAR(30) NOT NULL COMMENT '접속 환경 코드', -- 접속 환경 코드
	ATND_TIME      INT         NULL     COMMENT '참석 시간', -- 참석 시간
	ATND_CD        VARCHAR(30) NULL     COMMENT '참석 상태 코드', -- 참석 상태 코드
	USER_ID        VARCHAR(30) NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	REG_IP         VARCHAR(50) NOT NULL COMMENT '등록자 IP', -- 등록자 IP
	RGTR_ID         VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14) NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(세미나) 세미나 로그';

-- (세미나) 세미나 로그
ALTER TABLE tb_lms_seminar_log
	ADD CONSTRAINT PK_tb_lms_seminar_log -- PK_tb_lms_seminar_log
		PRIMARY KEY (
			SEMINAR_LOG_ID -- 세미나 로그 ID
		);

-- (세미나) 세미나 사전 참가 등록
CREATE TABLE tb_lms_seminar_reg (
	SEMINAR_REG_ID VARCHAR(30)  NOT NULL COMMENT '세미나 사전등록 ID', -- 세미나 사전등록 ID
	SEMINAR_ID     VARCHAR(30)  NULL     COMMENT '세미나 ID', -- 세미나 ID
	CRS_CRE_CD     VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	ZOOM_ID        VARCHAR(100) NULL     COMMENT 'ZOOM ID', -- ZOOM ID
	STD_NO         VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	USER_ID        VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	REGISTANT_ID   VARCHAR(100) NULL     COMMENT '사전등록 ID', -- 사전등록 ID
	JOIN_URL       VARCHAR(500) NULL     COMMENT '참가 URL', -- 참가 URL
	TC_EMAIL       VARCHAR(100) NULL     COMMENT '토큰 이메일', -- 토큰 이메일
	RGTR_ID         VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)  NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(세미나) 세미나 사전 참가 등록';

-- (세미나) 세미나 사전 참가 등록
ALTER TABLE tb_lms_seminar_reg
	ADD CONSTRAINT PK_tb_lms_seminar_reg -- PK_tb_lms_seminar_reg
		PRIMARY KEY (
			SEMINAR_REG_ID -- 세미나 사전등록 ID
		);

-- (세미나) 세미나 인증 토큰
CREATE TABLE tb_lms_seminar_token (
	TOKEN_ID          VARCHAR(30)   NOT NULL COMMENT '인증토큰 ID', -- 인증토큰 ID
	TC_EMAIL          VARCHAR(100)  NULL     COMMENT '토큰 이메일', -- 토큰 이메일
	ACCES_TOKEN       VARCHAR(1024) NULL     COMMENT '액세스 토큰', -- 액세스 토큰
	EXPIRE_IN         VARCHAR(14)   NULL     COMMENT '토큰 만료일', -- 토큰 만료일
	REFRESH_TOKEN     VARCHAR(1024) NULL     COMMENT '갱신 토큰', -- 갱신 토큰
	REFRESH_EXPIRE_IN VARCHAR(14)   NULL     COMMENT '갱신 토큰 만료일', -- 갱신 토큰 만료일
	RGTR_ID            VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)   NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(세미나) 세미나 인증 토큰';

-- (세미나) 세미나 인증 토큰
ALTER TABLE tb_lms_seminar_token
	ADD CONSTRAINT PK_tb_lms_seminar_token -- PK_tb_lms_seminar_token
		PRIMARY KEY (
			TOKEN_ID -- 인증토큰 ID
		);

-- (강의) 수강생
CREATE TABLE tb_lms_std (
	STD_NO             VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	ORG_ID             VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	CRS_CRE_CD         VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	USER_ID            VARCHAR(30)  NULL     COMMENT '사용자 번호', -- 사용자 번호
	ENRL_STS           CHAR(1)      NULL     COMMENT '수강 상태', -- 수강 상태
	ENRL_START_DTTM    VARCHAR(14)  NULL     COMMENT '수강 시작 일시', -- 수강 시작 일시
	ENRL_END_DTTM      VARCHAR(14)  NULL     COMMENT '수강 종료 일시', -- 수강 종료 일시
	AUDIT_END_DTTM     VARCHAR(14)  NULL     COMMENT '청강 종료 일시', -- 청강 종료 일시
	ENRL_APLC_DTTM     VARCHAR(14)  NULL     COMMENT '수강 신청 일시', -- 수강 신청 일시
	ENRL_CANCEL_DTTM   VARCHAR(14)  NULL     COMMENT '수강 취소 일시', -- 수강 취소 일시
	ENRL_CERT_DTTM     VARCHAR(14)  NULL     COMMENT '수강 인증 일시', -- 수강 인증 일시
	ENRL_CPLT_DTTM     VARCHAR(14)  NULL     COMMENT '수강 수료 일시', -- 수강 수료 일시
	EDU_NO             INT          NULL     COMMENT '수강 번호', -- 수강 번호
	CPLT_NO            VARCHAR(100) NULL     COMMENT '수료 번호', -- 수료 번호
	GET_CREDIT         INT          NULL     COMMENT '취득 학점', -- 취득 학점
	DOC_RECEIPT_YN     CHAR(1)      NULL     COMMENT '문서 접수 여부', -- 문서 접수 여부
	DOC_RECEIPT_NO     VARCHAR(100) NULL     COMMENT '문서 접수 번호', -- 문서 접수 번호
	DEPT_NM            VARCHAR(200) NULL     COMMENT '부서 명', -- 부서 명
	AREA_CD            VARCHAR(30)  NULL     COMMENT '지역 코드', -- 지역 코드
	EMP_NO             VARCHAR(100) NULL     COMMENT '사원 번호', -- 사원 번호
	SCORE_ECLT_YN      CHAR(1)      NULL     COMMENT '점수 우수 여부', -- 점수 우수 여부
	RECV_NOTICE_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '알림 수신 여부', -- 알림 수신 여부
	HAKSA_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '학사 데이터 여부', -- 학사 데이터 여부
	AUDIT_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '청강생 여부', -- 청강생 여부
	REPEAT_YN          CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '재수강 여부', -- 재수강 여부
	MID_LTSATSF_CLS_YN CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '중간 강의 만족도 참여 여부', -- 중간 강의 만족도 참여 여부
	LTSATSF_CLS_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '강의만족도 참여 여부', -- 강의만족도 참여 여부
	HY                 VARCHAR(1)   NULL     COMMENT '학년', -- 학년
	GVUP_YN            CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '수강 포기 여부', -- 수강 포기 여부
	CPTN_GBN           VARCHAR(10)  NULL     COMMENT '이수구분', -- 이수구분
	PRE_SC_YN          CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '선수과목 수강 여부', -- 선수과목 수강 여부
	SUPP_SC_YN         CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '보충과목 여부', -- 보충과목 여부
	GRSC_DEGR_CORS_GBN VARCHAR(8)   NULL     COMMENT '대학원 학위과정 구분', -- 대학원 학위과정 구분
	RGTR_ID             VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(강의) 수강생';

-- (강의) 수강생
ALTER TABLE tb_lms_std
	ADD CONSTRAINT PK_tb_lms_std -- PK_tb_lms_std
		PRIMARY KEY (
			STD_NO -- 수강생 번호
		);

-- IX_tb_lms_std
CREATE INDEX IX_tb_lms_std
	ON tb_lms_std( -- (강의) 수강생
		USER_ID ASC -- 사용자 번호
	);

-- IX_tb_lms_std2
CREATE INDEX IX_tb_lms_std2
	ON tb_lms_std( -- (강의) 수강생
		USER_ID ASC,    -- 사용자 번호
		CRS_CRE_CD ASC, -- 과정개설 코드
		STD_NO ASC      -- 수강생 번호
	);

-- (성적) 기관 성적 항목 설정
CREATE TABLE tb_lms_std_org_score_item_conf (
	ORG_SCORE_ITEM_ID VARCHAR(30)   NOT NULL COMMENT '기관 성적 항목 ID', -- 기관 성적 항목 ID
	ORG_ID            VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	CRS_TYPE_CD       VARCHAR(30)   NULL     COMMENT '과정 유형 코드', -- 과정 유형 코드
	SCORE_ITEM_ORDER  INT           NULL     COMMENT '성적 항목 순서', -- 성적 항목 순서
	SCORE_TYPE_CD     VARCHAR(30)   NULL     COMMENT '성적 유형 코드', -- 성적 유형 코드
	SCORE_ITEM_NM     VARCHAR(50)   NULL     COMMENT '성적 항목 명', -- 성적 항목 명
	SCORE_ITEM_DESC   VARCHAR(2000) NULL     COMMENT '성적 항목 설명', -- 성적 항목 설명
	SCORE_RATIO       INT           NULL     COMMENT '성적 반영 비율', -- 성적 반영 비율
	RGTR_ID            VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM          VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID            VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM          VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 기관 성적 항목 설정';

-- (성적) 기관 성적 항목 설정
ALTER TABLE tb_lms_std_org_score_item_conf
	ADD CONSTRAINT PK_tb_lms_std_org_score_item_conf -- PK_tb_lms_std_org_score_item_conf
		PRIMARY KEY (
			ORG_SCORE_ITEM_ID -- 기관 성적 항목 ID
		);

-- (성적) 수강생 성적
CREATE TABLE tb_lms_std_score (
	STD_NO             VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	TOT_SCORE          DECIMAL(5,2)  NULL     COMMENT '총점', -- 총점
	FINAL_SCORE        DECIMAL(5,2)  NULL     COMMENT '최종 점수', -- 최종 점수
	SCORE_GRADE        VARCHAR(20)   NULL     COMMENT '성적 등급', -- 성적 등급
	PASS_YN            CHAR(1)       NULL     COMMENT '패스 여부', -- 패스 여부
	ADD_SCORE          DECIMAL(5,2)  NULL     DEFAULT 0.00 COMMENT '가산 점수', -- 가산 점수
	SCORE_STATUS       CHAR(1)       NULL     DEFAULT '1' COMMENT '성적 환산 상태', -- 성적 환산 상태
	PROF_MEMO          VARCHAR(2000) NULL     COMMENT '교수 메모', -- 교수 메모
	RGTR_ID             VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시', -- 수정 일시
	EXCH_SCR_MID_TEST  DECIMAL(5,2)  NULL     COMMENT '산출 중간고사 점수', -- 산출 중간고사 점수
	EXCH_SCR_LAST_TEST DECIMAL(5,2)  NULL     COMMENT '산출 기말고사 점수', -- 산출 기말고사 점수
	EXCH_SCR_ASMNT     DECIMAL(5,2)  NULL     COMMENT '산출 과제 점수', -- 산출 과제 점수
	EXCH_SCR_LESSON    DECIMAL(5,2)  NULL     COMMENT '산출 진도 점수', -- 산출 진도 점수
	EXCH_SCR_FORUM     DECIMAL(5,2)  NULL     COMMENT '산출 토론 점수', -- 산출 토론 점수
	EXCH_SCR_TEST      DECIMAL(5,2)  NULL     COMMENT '산출 기타시험 점수', -- 산출 기타시험 점수
	EXCH_SCR_QUIZ      DECIMAL(5,2)  NULL     COMMENT '산출 퀴즈 점수', -- 산출 퀴즈 점수
	EXCH_SCR_RESH      DECIMAL(5,2)  NULL     COMMENT '산출 토론 점수', -- 산출 토론 점수
	EXCH_TOT_SCR       DECIMAL(5,2)  NULL     COMMENT '산출 합계 점수', -- 산출 합계 점수
	MRKS               DECIMAL(5,2)  NULL     COMMENT '산출 등급', -- 산출 등급
	EXCH_GAP_SCR       DECIMAL(5,2)  NULL     COMMENT '환산 점수 차이', -- 환산 점수 차이
	RANKING            INT           NULL     COMMENT '순위', -- 순위
	RANK_RCNT          INT           NULL     COMMENT '순위 인원수', -- 순위 인원수
	RANK_OBJ_YN        CHAR(1)       NULL     COMMENT '순위 대상 여부', -- 순위 대상 여부
	CAL_SCR_MID_TEST   DECIMAL(5,2)  NULL     COMMENT '중간고사 환산 점수', -- 중간고사 환산 점수
	CAL_SCR_LAST_TEST  DECIMAL(5,2)  NULL     COMMENT '기말고사 환산 점수', -- 기말고사 환산 점수
	CAL_SCR_ASMNT      DECIMAL(5,2)  NULL     COMMENT '과제 환산 점수', -- 과제 환산 점수
	CAL_SCR_LESSON     DECIMAL(5,2)  NULL     COMMENT '진도 환산 점수', -- 진도 환산 점수
	CAL_SCR_FORUM      DECIMAL(5,2)  NULL     COMMENT '토론 환산 점수', -- 토론 환산 점수
	CAL_SCR_TEST       DECIMAL(5,2)  NULL     COMMENT '기타시험 환산 점수', -- 기타시험 환산 점수
	CAL_SCR_QUIZ       DECIMAL(5,2)  NULL     COMMENT '퀴즈 환산 점수', -- 퀴즈 환산 점수
	CAL_SCR_RESH       DECIMAL(5,2)  NULL     COMMENT '설문 환산 점수', -- 설문 환산 점수
	CAL_TOT_SCR        DECIMAL(5,2)  NULL     COMMENT '합계 환산 점수' -- 합계 환산 점수
)
COMMENT '(성적) 수강생 성적';

-- (성적) 수강생 성적
ALTER TABLE tb_lms_std_score
	ADD CONSTRAINT PK_tb_lms_std_score -- PK_tb_lms_std_score
		PRIMARY KEY (
			STD_NO -- 수강생 번호
		);

-- (성적) 수강생 성적 이력
CREATE TABLE tb_lms_std_score_hist (
	SCORE_HIST_SN VARCHAR(30)   NOT NULL COMMENT '학생 성적 이력 번호', -- 학생 성적 이력 번호
	CRS_CRE_CD    VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	USER_ID       VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	CHG_CTS       VARCHAR(2000) NULL     COMMENT '변경 내용', -- 변경 내용
	CHG_DTTM      DATETIME      NULL     COMMENT '변경 일시', -- 변경 일시
	RGTR_ID        VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 수강생 성적 이력';

-- (성적) 수강생 성적 이력
ALTER TABLE tb_lms_std_score_hist
	ADD CONSTRAINT PK_tb_lms_std_score_hist -- PK_tb_lms_std_score_hist
		PRIMARY KEY (
			SCORE_HIST_SN -- 학생 성적 이력 번호
		);

-- IX_tb_lms_std_score_hist
CREATE INDEX IX_tb_lms_std_score_hist
	ON tb_lms_std_score_hist( -- (성적) 수강생 성적 이력
		SCORE_HIST_SN ASC -- 학생 성적 이력 번호
	);

-- IX_tb_lms_std_score_hist2
CREATE INDEX IX_tb_lms_std_score_hist2
	ON tb_lms_std_score_hist( -- (성적) 수강생 성적 이력
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (성적) 수강생 아이템별 성적
CREATE TABLE tb_lms_std_score_item (
	STD_NO        VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	SCORE_ITEM_ID VARCHAR(30)  NOT NULL COMMENT '성적 항목 ID', -- 성적 항목 ID
	GET_SCORE     DECIMAL(5,2) NULL     COMMENT '취득 점수', -- 취득 점수
	RGTR_ID        VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 수강생 아이템별 성적';

-- (성적) 수강생 아이템별 성적
ALTER TABLE tb_lms_std_score_item
	ADD CONSTRAINT PK_tb_lms_std_score_item -- PK_tb_lms_std_score_item
		PRIMARY KEY (
			STD_NO,        -- 수강생 번호
			SCORE_ITEM_ID  -- 성적 항목 ID
		);

-- (성적) 성적 항목 설정
CREATE TABLE tb_lms_std_score_item_conf (
	SCORE_ITEM_ID    VARCHAR(30)   NOT NULL COMMENT '성적 항목 ID', -- 성적 항목 ID
	CRS_CRE_CD       VARCHAR(30)   NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	SCORE_ITEM_ORDER INT           NULL     COMMENT '성적 항목 순서', -- 성적 항목 순서
	SCORE_TYPE_CD    VARCHAR(30)   NULL     COMMENT '성적 유형 코드', -- 성적 유형 코드
	SCORE_ITEM_NM    VARCHAR(50)   NULL     COMMENT '성적 항목 명', -- 성적 항목 명
	SCORE_ITEM_DESC  VARCHAR(2000) NULL     COMMENT '성적 항목 설명', -- 성적 항목 설명
	SCORE_RATIO      INT           NULL     COMMENT '성적 반영 비율', -- 성적 반영 비율
	RGTR_ID           VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 성적 항목 설정';

-- (성적) 성적 항목 설정
ALTER TABLE tb_lms_std_score_item_conf
	ADD CONSTRAINT PK_tb_lms_std_score_item_conf -- PK_tb_lms_std_score_item_conf
		PRIMARY KEY (
			SCORE_ITEM_ID -- 성적 항목 ID
		);

-- (성적) 성적 이의 신청
CREATE TABLE tb_lms_std_score_objt (
	SCORE_OBJT_CD VARCHAR(30)  NOT NULL COMMENT '성적 이의 신청 코드', -- 성적 이의 신청 코드
	CRS_CRE_CD    VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	STD_NO        VARCHAR(40)  NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	OBJT_USER_ID  VARCHAR(30)  NOT NULL COMMENT '이의신청 사용자 번호', -- 이의신청 사용자 번호
	OBJT_CTNT     LONGTEXT     NULL     COMMENT '이의신청 사유', -- 이의신청 사유
	OBJT_DTTM     VARCHAR(14)  NULL     COMMENT '이의신청 일시', -- 이의신청 일시
	PROC_USER_ID  VARCHAR(30)  NULL     COMMENT '신청자 번호', -- 신청자 번호
	PROC_CTNT     LONGTEXT     NULL     COMMENT '처리 내용', -- 처리 내용
	PROC_DTTM     VARCHAR(14)  NULL     COMMENT '처리 날짜', -- 처리 날짜
	MOD_SCORE     DECIMAL(5,2) NULL     COMMENT '변경 점수', -- 변경 점수
	MOD_GRADE     VARCHAR(20)  NULL     COMMENT '변경 등급', -- 변경 등급
	PRV_SCORE     DECIMAL(5,2) NULL     COMMENT '변경전 점수', -- 변경전 점수
	PRV_GRADE     VARCHAR(20)  NULL     COMMENT '변경전 등급', -- 변경전 등급
	PROC_CD       CHAR(1)      NULL     COMMENT '처리 코드', -- 처리 코드
	RGTR_ID        VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(성적) 성적 이의 신청';

-- (성적) 성적 이의 신청
ALTER TABLE tb_lms_std_score_objt
	ADD CONSTRAINT PK_tb_lms_std_score_objt -- PK_tb_lms_std_score_objt
		PRIMARY KEY (
			SCORE_OBJT_CD -- 성적 이의 신청 코드
		);

-- UK_tb_lms_std_score_objt
CREATE UNIQUE INDEX UX_tb_lms_std_score_objt
	ON tb_lms_std_score_objt ( -- (성적) 성적 이의 신청
		CRS_CRE_CD ASC, -- 과정개설 코드
		STD_NO ASC      -- 수강생 번호
	);

-- (팀구성) 팀 정보
CREATE TABLE tb_lms_team (
	TEAM_CD      VARCHAR(30)  NOT NULL COMMENT '팀 코드', -- 팀 코드
	TEAM_CTGR_CD VARCHAR(30)  NOT NULL COMMENT '팀 분류 코드', -- 팀 분류 코드
	TEAM_NM      VARCHAR(200) NOT NULL COMMENT '팀 명', -- 팀 명
	RGTR_ID       VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(팀구성) 팀 정보';

-- (팀구성) 팀 정보
ALTER TABLE tb_lms_team
	ADD CONSTRAINT PK_tb_lms_team -- PK_tb_lms_team
		PRIMARY KEY (
			TEAM_CD -- 팀 코드
		);

-- (팀구성) 팀 분류
CREATE TABLE tb_lms_team_ctgr (
	TEAM_CTGR_CD VARCHAR(30)  NOT NULL COMMENT '팀 분류 코드', -- 팀 분류 코드
	CRS_CRE_CD   VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	ORG_ID       VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	TEAM_CTGR_NM VARCHAR(200) NOT NULL COMMENT '팀 분류 명', -- 팀 분류 명
	TEAM_BBS_YN  CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '팀게시판 사용여부', -- 팀게시판 사용여부
	TEAM_SET_YN  CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '팀구성 완료 여부', -- 팀구성 완료 여부
	RGTR_ID       VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(팀구성) 팀 분류';

-- (팀구성) 팀 분류
ALTER TABLE tb_lms_team_ctgr
	ADD CONSTRAINT PK_tb_lms_team_ctgr -- PK_tb_lms_team_ctgr
		PRIMARY KEY (
			TEAM_CTGR_CD -- 팀 분류 코드
		);

-- (팀구성) 팀 멤버
CREATE TABLE tb_lms_team_member (
	TEAM_CD     VARCHAR(30)   NOT NULL COMMENT '팀 코드', -- 팀 코드
	STD_NO      VARCHAR(40)   NOT NULL COMMENT '수강생 번호', -- 수강생 번호
	USER_ID     VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	MEMBER_ROLE VARCHAR(1000) NULL     COMMENT '수강생 역할', -- 수강생 역할
	LEADER_YN   CHAR(1)       NOT NULL DEFAULT 'N' COMMENT '팀장 여부', -- 팀장 여부
	RGTR_ID      VARCHAR(30)   NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(팀구성) 팀 멤버';

-- (팀구성) 팀 멤버
ALTER TABLE tb_lms_team_member
	ADD CONSTRAINT PK_tb_lms_team_member -- PK_tb_lms_team_member
		PRIMARY KEY (
			TEAM_CD, -- 팀 코드
			STD_NO   -- 수강생 번호
		);

-- (과정) 학기
CREATE TABLE tb_lms_term (
	TERM_CD               VARCHAR(30)  NOT NULL COMMENT '학기 코드', -- 학기 코드
	TERM_NM               VARCHAR(100) NULL     COMMENT '학기 명', -- 학기 명
	ORG_ID                VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	DV_CD                 VARCHAR(30)  NOT NULL COMMENT '구분 코드', -- 구분 코드
	HAKSA_YEAR            VARCHAR(4)   NOT NULL COMMENT '학사 년도', -- 학사 년도
	HAKSA_TERM            VARCHAR(4)   NOT NULL COMMENT '학사 학기', -- 학사 학기
	TERM_TYPE             VARCHAR(10)  NULL     COMMENT '학기 유형', -- 학기 유형
	OFF_LESSON_MGT_YN     CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '오프라인 주차 관리 여부', -- 오프라인 주차 관리 여부
	TERM_STATUS           VARCHAR(10)  NOT NULL DEFAULT 'WAIT' COMMENT '학기 상태', -- 학기 상태
	TERM_LINK_YN          CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '학사 연동 여부', -- 학사 연동 여부
	SVC_START_DTTM        VARCHAR(14)  NULL     COMMENT '운영 시작 일자', -- 운영 시작 일자
	SVC_END_DTTM          VARCHAR(14)  NULL     COMMENT '운영 종료 일자', -- 운영 종료 일자
	ENRL_APLC_START_DTTM  VARCHAR(14)  NULL     COMMENT '수강 신청 시작 일시', -- 수강 신청 시작 일시
	ENRL_APLC_END_DTTM    VARCHAR(14)  NULL     COMMENT '수강 신청 종료 일시', -- 수강 신청 종료 일시
	ENRL_MOD_START_DTTM   VARCHAR(14)  NULL     COMMENT '수강 정정 시작 일시', -- 수강 정정 시작 일시
	ENRL_MOD_END_DTTM     VARCHAR(14)  NULL     COMMENT '수강 정정 종료 일시', -- 수강 정정 종료 일시
	ENRL_START_DTTM       VARCHAR(14)  NULL     COMMENT '수강 시작 일시', -- 수강 시작 일시
	ENRL_END_DTTM         VARCHAR(14)  NULL     COMMENT '수강 종료 일시', -- 수강 종료 일시
	SCORE_EVAL_START_DTTM VARCHAR(14)  NULL     COMMENT '성적 평가 시작 일시', -- 성적 평가 시작 일시
	SCORE_EVAL_END_DTTM   VARCHAR(14)  NULL     COMMENT '성적 평가 종료 일시', -- 성적 평가 종료 일시
	SCORE_OPEN_START_DTTM VARCHAR(14)  NULL     COMMENT '성적 공개 시작 일시', -- 성적 공개 시작 일시
	SCORE_OPEN_END_DTTM   VARCHAR(14)  NULL     COMMENT '성적 공개 종료 일시', -- 성적 공개 종료 일시
	SCORE_CALC_CTGR       VARCHAR(10)  NOT NULL DEFAULT 'A' COMMENT '성적 산출 분류', -- 성적 산출 분류
	MOBILE_ATTEND_YN      CHAR(1)      NOT NULL DEFAULT 'Y' COMMENT '모바일 출석 여부', -- 모바일 출석 여부
	CUR_TERM_YN           CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '현재 학기 여부', -- 현재 학기 여부
	RGTR_ID                VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM              VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID                VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM              VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 학기';

-- (과정) 학기
ALTER TABLE tb_lms_term
	ADD CONSTRAINT PK_tb_lms_term -- PK_tb_lms_term
		PRIMARY KEY (
			TERM_CD -- 학기 코드
		);

-- (과정) 학기 개설과정 연결
CREATE TABLE tb_lms_term_cre_crs_rltn (
	TERM_CD    VARCHAR(30) NOT NULL COMMENT '학기 코드', -- 학기 코드
	CRS_CRE_CD VARCHAR(30) NOT NULL COMMENT '과정개설 코드' -- 과정개설 코드
)
COMMENT '(과정) 학기 개설과정 연결';

-- (과정) 학기 개설과정 연결
ALTER TABLE tb_lms_term_cre_crs_rltn
	ADD CONSTRAINT PK_tb_lms_term_cre_crs_rltn -- PK_tb_lms_term_cre_crs_rltn
		PRIMARY KEY (
			TERM_CD,    -- 학기 코드
			CRS_CRE_CD  -- 과정개설 코드
		);

-- IX_(과정) 학기 개설과정 연결
CREATE INDEX IX_tb_lms_term_cre_crs_rltn
	ON tb_lms_term_cre_crs_rltn( -- (과정) 학기 개설과정 연결
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (과정) 학기 주차 일정
CREATE TABLE tb_lms_term_lesson (
	TERM_CD       VARCHAR(30) NOT NULL COMMENT '학기 코드', -- 학기 코드
	UNI_GBN       VARCHAR(10) NOT NULL DEFAULT 'U' COMMENT '대학 구분', -- 대학 구분
	LSN_ODR       INT         NOT NULL COMMENT '목차 순서', -- 목차 순서
	ENRL_TYPE     VARCHAR(10) NOT NULL DEFAULT 'online' COMMENT '수강 유형', -- 수강 유형
	START_DT      VARCHAR(8)  NOT NULL COMMENT '시작 일자', -- 시작 일자
	END_DT        VARCHAR(8)  NOT NULL COMMENT '종료 일자', -- 종료 일자
	LT_DETM_FR_DT VARCHAR(8)  NULL     COMMENT '강의인정 시작 일자', -- 강의인정 시작 일자
	LT_DETM_TO_DT VARCHAR(8)  NULL     COMMENT '강의인정 종료 일자', -- 강의인정 종료 일자
	RGTR_ID        VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 학기 주차 일정';

-- (과정) 학기 주차 일정
ALTER TABLE tb_lms_term_lesson
	ADD CONSTRAINT PK_tb_lms_term_lesson -- PK_tb_lms_term_lesson
		PRIMARY KEY (
			TERM_CD,   -- 학기 코드
			UNI_GBN,   -- 대학 구분
			LSN_ODR,   -- 목차 순서
			ENRL_TYPE  -- 수강 유형
		);

-- (과정) 학사연동 관리
CREATE TABLE tb_lms_term_link_mgr (
	TERM_LINK_MGR_ID VARCHAR(30) NOT NULL COMMENT '학사 연동 관리 ID', -- 학사 연동 관리 ID
	AUTO_LINK_YN     CHAR(1)     NOT NULL COMMENT '자동 연동 여부', -- 자동 연동 여부
	LAST_LINK_DTTM   VARCHAR(14) NULL     COMMENT '최종 연동 일시', -- 최종 연동 일시
	RGTR_ID           VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(과정) 학사연동 관리';

-- (과정) 학사연동 관리
ALTER TABLE tb_lms_term_link_mgr
	ADD CONSTRAINT PK_tb_lms_term_link_mgr -- PK_tb_lms_term_link_mgr
		PRIMARY KEY (
			TERM_LINK_MGR_ID -- 학사 연동 관리 ID
		);

-- (로그) 관리자 접속 로그
CREATE TABLE tb_log_admin_conn_log (
	CONN_LOG_SN VARCHAR(30)  NOT NULL COMMENT '접속로그 번호', -- 접속로그 번호
	USER_ID     VARCHAR(30)  NULL     COMMENT '사용자 번호', -- 사용자 번호
	USER_NM     VARCHAR(100) NULL     COMMENT '사용자 이름', -- 사용자 이름
	USER_ID     VARCHAR(30)  NULL     COMMENT '사용자 ID', -- 사용자 ID
	LOGIN_IP    VARCHAR(50)  NULL     COMMENT '로그인 IP', -- 로그인 IP
	LOGIN_DTTM  VARCHAR(14)  NULL     COMMENT '로그인 일시', -- 로그인 일시
	LOGOUT_DTTM VARCHAR(14)  NULL     COMMENT '로그아웃 일시' -- 로그아웃 일시
)
COMMENT '(로그) 관리자 접속 로그';

-- (로그) 배치 작업 로그
CREATE TABLE tb_log_batch_log (
	BATCH_LOG_SN VARCHAR(30) NOT NULL COMMENT '로그 번호', -- 배치 로그 번호
	ORG_ID       VARCHAR(30) NOT NULL COMMENT '기관 코드', -- 기관 코드
	BATCH_ID     VARCHAR(30) NOT NULL COMMENT '배치 아이디', -- 배치 아이디
	SUC_YN       CHAR(1)     NOT NULL COMMENT '성공 여부', -- 성공 여부
	AUTO_YN      CHAR(1)     NOT NULL COMMENT '자동 배치 여부', -- 자동 배치 여부
	RSLT_CD      VARCHAR(30) NULL     COMMENT '결과 코드', -- 결과 코드
	PRCS_TM      INT         NOT NULL DEFAULT 0 COMMENT '실행 시간', -- 실행 시간
	RSLT_CTS     LONGTEXT    NOT NULL COMMENT '결과 내용', -- 결과 내용
	TRGT_CNT     INT         NOT NULL DEFAULT 0 COMMENT '대상 건수', -- 대상 건수
	PRCS_CNT     INT         NOT NULL DEFAULT 0 COMMENT '처리 건수', -- 처리 건수
	RGTR_ID       VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14) NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(로그) 배치 작업 로그';

-- (로그) 배치 작업 로그
ALTER TABLE tb_log_batch_log
	ADD CONSTRAINT PK_tb_log_batch_log -- PK_tb_log_batch_log
		PRIMARY KEY (
			BATCH_LOG_SN -- 배치 로그 번호
		);

-- IX_tb_log_batch_log
CREATE INDEX IX_tb_log_batch_log
	ON tb_log_batch_log( -- (로그) 배치 작업 로그
		BATCH_ID ASC, -- 배치 아이디
		REG_DTTM ASC  -- 등록 일시
	);

-- (로그) 강의실 활동 이력
CREATE TABLE tb_log_lesson_actn_hsty (
	ACTN_HSTY_SN   VARCHAR(30)  NOT NULL COMMENT '활동 이력 번호', -- 활동 이력 번호
	CRS_CRE_CD     VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	USER_ID        VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	ACTN_HSTY_CD   VARCHAR(100) NOT NULL COMMENT '활동 이력 코드', -- 활동 이력 코드
	ACTN_HSTY_CTS  LONGTEXT     NOT NULL COMMENT '활동 이력 내용', -- 활동 이력 내용
	DEVICE_TYPE_CD VARCHAR(30)  NOT NULL COMMENT '접속 환경 코드', -- 접속 환경 코드
	REG_IP         VARCHAR(50)  NOT NULL COMMENT '등록자 IP', -- 등록자 IP
	RGTR_ID         VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)  NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(로그) 강의실 활동 이력';

-- (로그) 강의실 활동 이력
ALTER TABLE tb_log_lesson_actn_hsty
	ADD CONSTRAINT PK_tb_log_lesson_actn_hsty -- PK_tb_log_lesson_actn_hsty
		PRIMARY KEY (
			ACTN_HSTY_SN -- 활동 이력 번호
		);

-- IX_tb_log_lesson_actn_hsty
CREATE INDEX IX_tb_log_lesson_actn_hsty
	ON tb_log_lesson_actn_hsty( -- (로그) 강의실 활동 이력
		USER_ID ASC,      -- 사용자 번호
		ACTN_HSTY_SN ASC  -- 활동 이력 번호
	);

-- IX_tb_log_lesson_actn_hsty2
CREATE INDEX IX_tb_log_lesson_actn_hsty2
	ON tb_log_lesson_actn_hsty( -- (로그) 강의실 활동 이력
		CRS_CRE_CD ASC,   -- 과정개설 코드
		ACTN_HSTY_CD ASC, -- 활동 이력 코드
		REG_DTTM ASC      -- 등록 일시
	);

-- (로그) 메시지 로그
CREATE TABLE tb_log_msg_log (
	MSG_SN         INT          NOT NULL COMMENT '메시지 번호', -- 메시지 번호
	ORG_ID         VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	MSG_DIV_CD     VARCHAR(30)  NULL     COMMENT '메시지 구분 코드', -- 메시지 구분 코드
	SEND_MENU_CD   VARCHAR(30)  NULL     COMMENT '발신 메뉴 코드', -- 발신 메뉴 코드
	TITLE          VARCHAR(200) NULL     COMMENT '제목', -- 제목
	CTS            LONGTEXT     NULL     COMMENT '내용', -- 내용
	SEND_NM        VARCHAR(100) NULL     COMMENT '발신 이름', -- 발신 이름
	SEND_ADDR      VARCHAR(100) NULL     COMMENT '발신 주소', -- 발신 주소
	RSRV_SEND_DTTM VARCHAR(14)  NULL     COMMENT '예약 발신 일시', -- 예약 발신 일시
	SEND_STS       VARCHAR(10)  NULL     COMMENT '발신 상태', -- 발신 상태
	PERV_MSG_SN    INT          NULL     COMMENT '이전 메시지 번호', -- 이전 메시지 번호
	RGTR_ID         VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)  NULL     COMMENT '수정 일시', -- 수정 일시
	CRS_CRE_CD     VARCHAR(30)  NULL     COMMENT '과정개설 코드' -- 과정개설 코드
)
COMMENT '(로그) 메시지 로그';

-- (로그) 메시지 로그
ALTER TABLE tb_log_msg_log
	ADD CONSTRAINT PK_tb_log_msg_log -- PK_tb_log_msg_log
		PRIMARY KEY (
			MSG_SN -- 메시지 번호
		);

-- (로그) 개인 정보 조회 로그
CREATE TABLE tb_log_private_info_inq_log (
	INQ_LOG_ID      VARCHAR(30)  NOT NULL COMMENT '개인정보조회 로그 ID', -- 개인정보조회 로그 ID
	ORG_ID          VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	INQ_DTTM        VARCHAR(14)  NOT NULL COMMENT '조회 로그 일시', -- 조회 로그 일시
	MENU_CD         VARCHAR(30)  NULL     COMMENT '메뉴 코드', -- 메뉴 코드
	DIV_CD          VARCHAR(30)  NULL     COMMENT '구분 코드', -- 구분 코드
	USER_ID         VARCHAR(30)  NULL     COMMENT '사용자 번호', -- 사용자 번호
	USER_NM         VARCHAR(100) NULL     COMMENT '사용자 이름', -- 사용자 이름
	MOD_CHG_USER_ID VARCHAR(30)  NULL     COMMENT '모드전환 사용자 번호', -- 모드전환 사용자 번호
	MOD_CHG_USRE_NM VARCHAR(100) NULL     COMMENT '모드전환 사용자 이름', -- 모드전환 사용자 이름
	INQ_CTS         LONGTEXT     NULL     COMMENT '조회 내용', -- 조회 내용
	CONN_URL        VARCHAR(500) NULL     COMMENT '연결 URL', -- 연결 URL
	CONN_IP         VARCHAR(50)  NULL     COMMENT '접속 IP' -- 접속 IP
)
COMMENT '(로그) 개인 정보 조회 로그';

-- (로그) 개인 정보 조회 로그
ALTER TABLE tb_log_private_info_inq_log
	ADD CONSTRAINT PK_tb_log_private_info_inq_log -- PK_tb_log_private_info_inq_log
		PRIMARY KEY (
			INQ_LOG_ID -- 개인정보조회 로그 ID
		);

-- (로그) 추천 연결 로그
CREATE TABLE tb_log_recom_rltn (
	RECOM_CD  VARCHAR(30) NOT NULL COMMENT '추천 코드', -- 추천 코드
	RLTN_TYPE VARCHAR(10) NOT NULL COMMENT '연결 유형', -- 연결 유형
	RLTN_CD   VARCHAR(30) NOT NULL COMMENT '연결 코드', -- 연결 코드
	RGTR_ID    VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM  VARCHAR(14) NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(로그) 추천 연결 로그';

-- (로그) 추천 연결 로그
ALTER TABLE tb_log_recom_rltn
	ADD CONSTRAINT PK_tb_log_recom_rltn -- PK_tb_log_recom_rltn
		PRIMARY KEY (
			RECOM_CD -- 추천 코드
		);

-- IX_tb_log_recom_rltn
CREATE INDEX IX_tb_log_recom_rltn
	ON tb_log_recom_rltn( -- (로그) 추천 연결 로그
		RLTN_CD ASC -- 연결 코드
	);

-- (로그) 학사일정 예외 등록 로그
CREATE TABLE tb_log_sys_job_sch_exc (
	EXC_LOG_SN  VARCHAR(30)  NOT NULL COMMENT '예외 로그 번호', -- 예외 로그 번호
	CRS_CRE_CD  VARCHAR(30)  NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	EXC_LOG_CTS VARCHAR(300) NULL     COMMENT '예외 로그 내용', -- 예외 로그 내용
	RGTR_ID      VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)  NULL     COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(로그) 학사일정 예외 등록 로그';

-- (로그) 학사일정 예외 등록 로그
ALTER TABLE tb_log_sys_job_sch_exc
	ADD CONSTRAINT PK_tb_log_sys_job_sch_exc -- PK_tb_log_sys_job_sch_exc
		PRIMARY KEY (
			EXC_LOG_SN -- 예외 로그 번호
		);

-- (로그) 학사 연동 로그
CREATE TABLE tb_log_term_link_log (
	LINK_LOG_ID   VARCHAR(30) NOT NULL COMMENT '연동 로그 ID', -- 연동 로그 ID
	LINK_TYPE_CD  VARCHAR(30) NOT NULL COMMENT '연동 구분 코드', -- 연동 구분 코드
	LINK_SUC_YN   CHAR(1)     NOT NULL COMMENT '연동 성공 여부', -- 연동 성공 여부
	LINK_RSLT_CD  VARCHAR(30) NULL     COMMENT '연동 결과 코드', -- 연동 결과 코드
	LINK_RSLT_CTS LONGTEXT    NOT NULL COMMENT '연동 결과 내용', -- 연동 결과 내용
	ADD_CNT       INT         NOT NULL DEFAULT 0 COMMENT '추가 건수', -- 추가 건수
	MOD_CNT       INT         NOT NULL DEFAULT 0 COMMENT '갱신 건수', -- 갱신 건수
	DEL_CNT       INT         NOT NULL DEFAULT 0 COMMENT '삭제 건수', -- 삭제 건수
	LINK_DTTM     VARCHAR(14) NOT NULL COMMENT '연동 일시' -- 연동 일시
)
COMMENT '(로그) 학사 연동 로그';

-- (로그) 학사 연동 로그
ALTER TABLE tb_log_term_link_log
	ADD CONSTRAINT PK_tb_log_term_link_log -- PK_tb_log_term_link_log
		PRIMARY KEY (
			LINK_LOG_ID -- 연동 로그 ID
		);

-- (로그) 사용자 활동 로그
CREATE TABLE tb_log_user_act (
	ACT_LOG_ID VARCHAR(30)  NOT NULL COMMENT '활동 로그 ID', -- 활동 로그 ID
	MENU_CD    VARCHAR(30)  NOT NULL COMMENT '메뉴 코드', -- 메뉴 코드
	DIV_CD     VARCHAR(30)  NOT NULL COMMENT '구분 코드', -- 구분 코드
	ACT_TITLE  VARCHAR(200) NOT NULL COMMENT '활동 제목', -- 활동 제목
	ACT_CTS    LONGTEXT     NULL     COMMENT '활동 내용', -- 활동 내용
	USER_ID    VARCHAR(30)  NOT NULL COMMENT '사용자 ID', -- 사용자 ID
	CONN_IP    VARCHAR(50)  NULL     COMMENT '접속 IP', -- 접속 IP
	RGTR_ID     VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM   VARCHAR(14)  NULL     COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(로그) 사용자 활동 로그';

-- (로그) 사용자 활동 로그
ALTER TABLE tb_log_user_act
	ADD CONSTRAINT PK_tb_log_user_act -- PK_(로그) 사용자 활동 로그
		PRIMARY KEY (
			ACT_LOG_ID -- 활동 로그 ID
		);

-- (로그) 사용자 접속 현황 로그
CREATE TABLE tb_log_user_conn_stat (
	USER_ID        VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	CONN_GBN       VARCHAR(30)  NULL     COMMENT '접속자 구분', -- 접속자 구분
	CRS_CRE_CD     VARCHAR(30)  NULL     COMMENT '과정개설 코드', -- 과정개설 코드
	WORK_LOC_CD    VARCHAR(30)  NULL     COMMENT '작업 이력 코드', -- 작업 이력 코드
	DEVICE_TYPE_CD VARCHAR(30)  NULL     COMMENT '접속 환경 코드', -- 접속 환경 코드
	SESSION_ID     VARCHAR(100) NOT NULL COMMENT '세션 ID', -- 세션 ID
	REG_IP         VARCHAR(50)  NOT NULL COMMENT '등록자 IP', -- 등록자 IP
	CONN_DTTM      VARCHAR(14)  NOT NULL COMMENT '접속 일시' -- 접속 일시
)
COMMENT '(로그) 사용자 접속 현황 로그';

-- (로그) 사용자 접속 현황 로그
ALTER TABLE tb_log_user_conn_stat
	ADD CONSTRAINT PK_tb_log_user_conn_stat -- PK_tb_log_user_conn_stat
		PRIMARY KEY (
			USER_ID -- 사용자 번호
		);

-- (로그) 사용자 로그인 시도 로그
CREATE TABLE tb_log_user_login_try_log (
	LOGIN_TRY_SN   VARCHAR(30)   NOT NULL COMMENT '로그인 시도 번호', -- 로그인 시도 번호
	USER_ID        VARCHAR(30)   NULL     COMMENT '사용자 번호', -- 사용자 번호
	USER_ID        VARCHAR(30)   NULL     COMMENT '사용자 ID', -- 사용자 ID
	LOGIN_TRY_DTTM VARCHAR(14)   NULL     COMMENT '로그인 시도 일시', -- 로그인 시도 일시
	LOGIN_SUCC_YN  CHAR(1)       NULL     COMMENT '로그인 성공 여부', -- 로그인 성공 여부
	BROWSER_INFO   VARCHAR(2000) NULL     COMMENT '브라우저 정보', -- 브라우저 정보
	CONN_IP        VARCHAR(50)   NULL     COMMENT '접속 IP' -- 접속 IP
)
COMMENT '(로그) 사용자 로그인 시도 로그';

-- (로그) 사용자 로그인 시도 로그
ALTER TABLE tb_log_user_login_try_log
	ADD CONSTRAINT PK_tb_log_user_login_try_log -- PK_tb_log_user_login_try_log
		PRIMARY KEY (
			LOGIN_TRY_SN -- 로그인 시도 번호
		);

-- IX_tb_log_user_login_try_log
CREATE INDEX IX_tb_log_user_login_try_log
	ON tb_log_user_login_try_log( -- (로그) 사용자 로그인 시도 로그
		USER_ID ASC,        -- 사용자 번호
		LOGIN_TRY_DTTM ASC  -- 로그인 시도 일시
	);

-- (기타) 조교 수업 운영 점수
CREATE TABLE tb_opr_score_assist (
	USER_ID            VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	LESSON_SCHEDULE_ID VARCHAR(30)  NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	CRE_YEAR           VARCHAR(4)   NULL     COMMENT '과정 년도', -- 과정 년도
	CRE_TERM           VARCHAR(2)   NULL     COMMENT '과정 학기', -- 과정 학기
	CRS_CD             VARCHAR(30)  NULL     COMMENT '과정 코드', -- 과정 코드
	DECLS_NO           VARCHAR(3)   NULL     COMMENT '분반 번호', -- 분반 번호
	SCORE01            DECIMAL(5,2) NULL     COMMENT '운영점수01', -- 운영점수01
	SCORE02            DECIMAL(5,2) NULL     COMMENT '운영점수02', -- 운영점수02
	SCORE03            DECIMAL(5,2) NULL     COMMENT '운영점수03', -- 운영점수03
	SCORE04            DECIMAL(5,2) NULL     COMMENT '운영점수04', -- 운영점수04
	SCORE05            DECIMAL(5,2) NULL     COMMENT '운영점수05', -- 운영점수05
	SCORE06            DECIMAL(5,2) NULL     COMMENT '운영점수06', -- 운영점수06
	SCORE07            DECIMAL(5,2) NULL     COMMENT '운영점수07', -- 운영점수07
	SCORE08            DECIMAL(5,2) NULL     COMMENT '운영점수08', -- 운영점수08
	TOT_SCORE          DECIMAL(5,2) NULL     COMMENT '총점', -- 총점
	DEL_YN             CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID             VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기타) 조교 수업 운영 점수';

-- (기타) 조교 수업 운영 점수
ALTER TABLE tb_opr_score_assist
	ADD CONSTRAINT PK_tb_opr_score_assist -- PK_tb_opr_score_assist
		PRIMARY KEY (
			USER_ID,            -- 사용자 번호
			LESSON_SCHEDULE_ID  -- 학습 일정 ID
		);

-- (기타) 교수 수업 운영 점수
CREATE TABLE tb_opr_score_prof (
	USER_ID            VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	LESSON_SCHEDULE_ID VARCHAR(30)  NOT NULL COMMENT '학습 일정 ID', -- 학습 일정 ID
	CRE_YEAR           VARCHAR(4)   NULL     COMMENT '과정 년도', -- 과정 년도
	CRE_TERM           VARCHAR(2)   NULL     COMMENT '과정 학기', -- 과정 학기
	CRS_CD             VARCHAR(30)  NULL     COMMENT '과정 코드', -- 과정 코드
	DECLS_NO           VARCHAR(3)   NULL     COMMENT '분반 번호', -- 분반 번호
	SCORE01            DECIMAL(5,2) NULL     COMMENT '운영점수01', -- 운영점수01
	SCORE02            DECIMAL(5,2) NULL     COMMENT '운영점수02', -- 운영점수02
	SCORE03            DECIMAL(5,2) NULL     COMMENT '운영점수03', -- 운영점수03
	SCORE04            DECIMAL(5,2) NULL     COMMENT '운영점수04', -- 운영점수04
	SCORE05            DECIMAL(5,2) NULL     COMMENT '운영점수05', -- 운영점수05
	SCORE06            DECIMAL(5,2) NULL     COMMENT '운영점수06', -- 운영점수06
	SCORE07            DECIMAL(5,2) NULL     COMMENT '운영점수07', -- 운영점수07
	SCORE08            DECIMAL(5,2) NULL     COMMENT '운영점수08', -- 운영점수08
	SCORE09            DECIMAL(5,2) NULL     COMMENT '운영점수09', -- 운영점수09
	SCORE10            DECIMAL(5,2) NULL     COMMENT '운영점수10', -- 운영점수10
	SCORE11            DECIMAL(5,2) NULL     COMMENT '운영점수11', -- 운영점수11
	SCORE12            DECIMAL(5,2) NULL     COMMENT '운영점수12', -- 운영점수12
	SCORE13            DECIMAL(5,2) NULL     COMMENT '운영점수13', -- 운영점수13
	TOT_SCORE          DECIMAL(5,2) NULL     COMMENT '총점', -- 총점
	DEL_YN             CHAR(1)      NOT NULL DEFAULT 'N' COMMENT '삭제 여부', -- 삭제 여부
	RGTR_ID             VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기타) 교수 수업 운영 점수';

-- (기타) 교수 수업 운영 점수
ALTER TABLE tb_opr_score_prof
	ADD CONSTRAINT PK_tb_opr_score_prof -- PK_tb_opr_score_prof
		PRIMARY KEY (
			USER_ID,            -- 사용자 번호
			LESSON_SCHEDULE_ID  -- 학습 일정 ID
		);

-- (기관) 결시원 성적 비율
CREATE TABLE tb_org_absent_ratio (
	ORG_ID      VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	ABSENT_GBN  VARCHAR(30)  NOT NULL COMMENT '결시 구분', -- 결시 구분
	EXAM_GBN    VARCHAR(30)  NOT NULL COMMENT '시험 구분', -- 시험 구분
	SCOR_RATIO  INT          NULL     COMMENT '성적 비율', -- 성적 비율
	ABSENT_DESC VARCHAR(200) NULL     COMMENT '결시 반영 내용', -- 결시 반영 내용
	RGTR_ID      VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 결시원 성적 비율';

-- (기관) 결시원 성적 비율
ALTER TABLE tb_org_absent_ratio
	ADD CONSTRAINT PK_tb_org_absent_ratio -- PK_tb_org_absent_ratio
		PRIMARY KEY (
			ORG_ID,     -- 기관 코드
			ABSENT_GBN, -- 결시 구분
			EXAM_GBN    -- 시험 구분
		);

-- (기관) 권한 그룹
CREATE TABLE tb_org_auth_grp (
	AUTH_GRP_CD     VARCHAR(30)   NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	MENU_TYPE       VARCHAR(30)   NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	ORG_ID          VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	USE_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	AUTH_GRP_NM     VARCHAR(200)  NOT NULL COMMENT '권한 그룹 명', -- 권한 그룹 명
	AUTH_GRP_DESC   VARCHAR(2000) NULL     COMMENT '권한 그룹 설명', -- 권한 그룹 설명
	AUTH_GRP_ODR    INT           NOT NULL COMMENT '권한 그룹 순서', -- 권한 그룹 순서
	FILE_LIMIT_SIZE INT           NULL     COMMENT '파일 용량 제한 크기', -- 파일 용량 제한 크기
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 권한 그룹';

-- (기관) 권한 그룹
ALTER TABLE tb_org_auth_grp
	ADD CONSTRAINT PK_tb_org_auth_grp -- PK_tb_org_auth_grp
		PRIMARY KEY (
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_TYPE,   -- 메뉴 유형
			ORG_ID       -- 기관 코드
		);

-- IX_(기관) 권한 그룹
CREATE INDEX IX_tb_org_auth_grp
	ON tb_org_auth_grp( -- (기관) 권한 그룹
		ORG_ID ASC -- 기관 코드
	);

-- (기관) 권한 그룹 언어
CREATE TABLE tb_org_auth_grp_lang (
	AUTH_GRP_CD   VARCHAR(30)   NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	MENU_TYPE     VARCHAR(30)   NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	ORG_ID        VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	LANG_CD       VARCHAR(30)   NOT NULL COMMENT '언어 코드', -- 언어 코드
	AUTH_GRP_NM   VARCHAR(200)  NOT NULL COMMENT '권한 그룹 명', -- 권한 그룹 명
	AUTH_GRP_DESC VARCHAR(2000) NULL     COMMENT '권한 그룹 설명' -- 권한 그룹 설명
)
COMMENT '(기관) 권한 그룹 언어';

-- (기관) 권한 그룹 언어
ALTER TABLE tb_org_auth_grp_lang
	ADD CONSTRAINT PK_tb_org_auth_grp_lang -- PK_tb_org_auth_grp_lang
		PRIMARY KEY (
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_TYPE,   -- 메뉴 유형
			ORG_ID,      -- 기관 코드
			LANG_CD      -- 언어 코드
		);

-- IX_(기관) 권한 그룹 언어
CREATE INDEX IX_tb_org_auth_grp_lang
	ON tb_org_auth_grp_lang( -- (기관) 권한 그룹 언어
		MENU_TYPE ASC,   -- 메뉴 유형
		AUTH_GRP_CD ASC  -- 권한 그룹 코드
	);

-- (기관) 권한 그룹 메뉴
CREATE TABLE tb_org_auth_grp_menu (
	MENU_TYPE   VARCHAR(30) NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	AUTH_GRP_CD VARCHAR(30) NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	ORG_ID      VARCHAR(30) NOT NULL COMMENT '기관 코드', -- 기관 코드
	MENU_CD     VARCHAR(30) NOT NULL COMMENT '메뉴 코드', -- 메뉴 코드
	VIEW_AUTH   CHAR(1)     NULL     COMMENT '조회 권한', -- 조회 권한
	CRE_AUTH    CHAR(1)     NULL     COMMENT '등록 권한', -- 등록 권한
	MOD_AUTH    CHAR(1)     NULL     COMMENT '수정 권한', -- 수정 권한
	DEL_AUTH    CHAR(1)     NULL     COMMENT '삭제 권한', -- 삭제 권한
	RGTR_ID      VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30) NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14) NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 권한 그룹 메뉴';

-- (기관) 권한 그룹 메뉴
ALTER TABLE tb_org_auth_grp_menu
	ADD CONSTRAINT PK_tb_org_auth_grp_menu -- PK_tb_org_auth_grp_menu
		PRIMARY KEY (
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD, -- 권한 그룹 코드
			ORG_ID,      -- 기관 코드
			MENU_CD      -- 메뉴 코드
		);

-- IX_(기관) 권한 그룹 메뉴
CREATE INDEX IX_tb_org_auth_grp_menu
	ON tb_org_auth_grp_menu( -- (기관) 권한 그룹 메뉴
		ORG_ID ASC,  -- 기관 코드
		MENU_CD ASC  -- 메뉴 코드
	);

-- (기관) 기관 설정
CREATE TABLE tb_org_cfg (
	ORG_ID      VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	CFG_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '설정 분류 코드', -- 설정 분류 코드
	CFG_CD      VARCHAR(30)   NOT NULL COMMENT '설정 코드', -- 설정 코드
	CFG_NM      VARCHAR(50)   NOT NULL COMMENT '설정 명', -- 설정 명
	CFG_VAL     VARCHAR(100)  NOT NULL COMMENT '설정 값', -- 설정 값
	CFG_DESC    VARCHAR(2000) NULL     COMMENT '설정 비고', -- 설정 비고
	USE_YN      CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID      VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 설정';

-- (기관) 기관 설정
ALTER TABLE tb_org_cfg
	ADD CONSTRAINT PK_tb_org_cfg -- PK_tb_org_cfg
		PRIMARY KEY (
			ORG_ID,      -- 기관 코드
			CFG_CTGR_CD, -- 설정 분류 코드
			CFG_CD       -- 설정 코드
		);

-- (기관) 기관 설정 분류
CREATE TABLE tb_org_cfg_ctgr (
	ORG_ID      VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	CFG_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '설정 분류 코드', -- 설정 분류 코드
	CTGR_NM     VARCHAR(200)  NOT NULL COMMENT '분류 명', -- 분류 명
	CTGR_DESC   VARCHAR(2000) NULL     COMMENT '분류 설명', -- 분류 설명
	USE_YN      CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID      VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 설정 분류';

-- (기관) 기관 설정 분류
ALTER TABLE tb_org_cfg_ctgr
	ADD CONSTRAINT PK_tb_org_cfg_ctgr -- PK_tb_org_cfg_ctgr
		PRIMARY KEY (
			ORG_ID,      -- 기관 코드
			CFG_CTGR_CD  -- 설정 분류 코드
		);

-- (기관) 기관 시스템 코드
CREATE TABLE tb_org_code (
	ORG_ID       VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	CODE_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '코드 분류 코드', -- 코드 분류 코드
	CODE_CD      VARCHAR(30)   NOT NULL COMMENT '코드', -- 코드
	CODE_NM      VARCHAR(50)   NOT NULL COMMENT '코드 명', -- 코드 명
	CODE_DESC    VARCHAR(2000) NOT NULL COMMENT '코드 설명', -- 코드 설명
	CODE_OPTN    VARCHAR(100)  NULL     COMMENT '코드 옵션', -- 코드 옵션
	CODE_ODR     INT           NOT NULL COMMENT '코드 순서', -- 코드 순서
	USE_YN       CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID       VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 시스템 코드';

-- (기관) 기관 시스템 코드
ALTER TABLE tb_org_code
	ADD CONSTRAINT PK_tb_org_code -- PK_tb_org_code
		PRIMARY KEY (
			ORG_ID,       -- 기관 코드
			CODE_CTGR_CD, -- 코드 분류 코드
			CODE_CD       -- 코드
		);

-- (기관) 기관 시스템 코드 분류
CREATE TABLE tb_org_code_ctgr (
	ORG_ID         VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	CODE_CTGR_CD   VARCHAR(30)   NOT NULL COMMENT '코드 분류 코드', -- 코드 분류 코드
	CODE_CTGR_NM   VARCHAR(50)   NOT NULL COMMENT '코드 분류 명', -- 코드 분류 명
	CODE_CTGR_DESC VARCHAR(2000) NULL     COMMENT '코드 분류 설명', -- 코드 분류 설명
	CODE_CTGR_ODR  INT           NOT NULL COMMENT '코드 분류 순서', -- 코드 분류 순서
	USE_YN         CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	RGTR_ID         VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 시스템 코드 분류';

-- (기관) 기관 시스템 코드 분류
ALTER TABLE tb_org_code_ctgr
	ADD CONSTRAINT PK_tb_org_code_ctgr -- PK_tb_org_code_ctgr
		PRIMARY KEY (
			ORG_ID,       -- 기관 코드
			CODE_CTGR_CD  -- 코드 분류 코드
		);

-- (기관) 기관 시스템 코드 언어
CREATE TABLE tb_org_code_lang (
	ORG_ID       VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	CODE_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '코드 분류 코드', -- 코드 분류 코드
	CODE_CD      VARCHAR(30)   NOT NULL COMMENT '코드', -- 코드
	LANG_CD      VARCHAR(30)   NOT NULL COMMENT '언어 코드', -- 언어 코드
	CODE_NM      VARCHAR(50)   NOT NULL COMMENT '코드 명', -- 코드 명
	CODE_DESC    VARCHAR(2000) NULL     COMMENT '코드 설명' -- 코드 설명
)
COMMENT '(기관) 기관 시스템 코드 언어';

-- (기관) 기관 시스템 코드 언어
ALTER TABLE tb_org_code_lang
	ADD CONSTRAINT PK_tb_org_code_lang -- PK_tb_org_code_lang
		PRIMARY KEY (
			ORG_ID,       -- 기관 코드
			CODE_CTGR_CD, -- 코드 분류 코드
			CODE_CD,      -- 코드
			LANG_CD       -- 언어 코드
		);

-- IX_tb_org_code_lang
CREATE INDEX IX_tb_org_code_lang
	ON tb_org_code_lang( -- (기관) 기관 시스템 코드 언어
		CODE_CD ASC,      -- 코드
		CODE_CTGR_CD ASC, -- 코드 분류 코드
		ORG_ID ASC        -- 기관 코드
	);

-- (기관) 기관 접속 IP
CREATE TABLE tb_org_conn_ip (
	CONN_IP  VARCHAR(50)  NOT NULL COMMENT '접속 IP', -- 접속 IP
	ORG_ID   VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	DIV_CD   VARCHAR(30)  NULL     COMMENT '구분 코드', -- 구분 코드
	USE_YN   CHAR(1)      NULL     COMMENT '사용 여부', -- 사용 여부
	BAND_YN  CHAR(1)      NULL     COMMENT '대역 여부', -- 대역 여부
	BAND_VAL VARCHAR(100) NULL     COMMENT '대역값', -- 대역값
	RGTR_ID   VARCHAR(30)  NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM VARCHAR(14)  NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID   VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 접속 IP';

-- (기관) 기관 접속 IP
ALTER TABLE tb_org_conn_ip
	ADD CONSTRAINT PK_tb_org_conn_ip -- PK_tb_org_conn_ip
		PRIMARY KEY (
			CONN_IP, -- 접속 IP
			ORG_ID   -- 기관 코드
		);

-- (기관) 기관 메뉴
CREATE TABLE tb_org_menu (
	ORG_ID          VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	MENU_CD         VARCHAR(30)   NOT NULL COMMENT '메뉴 코드', -- 메뉴 코드
	PAR_MENU_CD     VARCHAR(30)   NULL     COMMENT '상위 메뉴 코드', -- 상위 메뉴 코드
	MENU_TYPE       VARCHAR(30)   NULL     COMMENT '메뉴 유형', -- 메뉴 유형
	MENU_NM         VARCHAR(200)  NOT NULL COMMENT '메뉴 명', -- 메뉴 명
	MENU_NM_EN      VARCHAR(200)  NULL     COMMENT '메뉴 명_영문', -- 메뉴 명_영문
	MENU_TITLE      VARCHAR(200)  NULL     COMMENT '메뉴 타이틀', -- 메뉴 타이틀
	MENU_DESC       VARCHAR(2000) NULL     COMMENT '메뉴 설명', -- 메뉴 설명
	MENU_LVL        INT           NULL     COMMENT '메뉴 레벨', -- 메뉴 레벨
	MENU_ODR        INT           NULL     COMMENT '메뉴 순서', -- 메뉴 순서
	MENU_URL        VARCHAR(500)  NULL     COMMENT '메뉴 URL', -- 메뉴 URL
	MENU_PATH       VARCHAR(500)  NULL     COMMENT '메뉴 경로', -- 메뉴 경로
	USE_YN          CHAR(1)       NULL     DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	TOP_MENU_YN     CHAR(1)       NULL     COMMENT '상단 메뉴 여부', -- 상단 메뉴 여부
	TOP_MENU_IMG    VARCHAR(200)  NULL     COMMENT '상단 메뉴 이미지', -- 상단 메뉴 이미지
	LEFT_MENU_IMG   VARCHAR(200)  NULL     COMMENT '좌측 메뉴 이미지', -- 좌측 메뉴 이미지
	LEFT_MENU_TITLE VARCHAR(200)  NULL     COMMENT '좌측 메뉴 타이틀', -- 좌측 메뉴 타이틀
	OPTN_CTGR_CD_1  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드1', -- 옵션 분류 코드1
	OPTN_CD_1       VARCHAR(30)   NULL     COMMENT '옵션 코드1', -- 옵션 코드1
	OPTN_CTGR_CD_2  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드2', -- 옵션 분류 코드2
	OPTN_CD_2       VARCHAR(30)   NULL     COMMENT '옵션 코드2', -- 옵션 코드2
	OPTN_CTGR_CD_3  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드3', -- 옵션 분류 코드3
	OPTN_CD_3       VARCHAR(30)   NULL     COMMENT '옵션 코드3', -- 옵션 코드3
	OPTN_CTGR_CD_4  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드4', -- 옵션 분류 코드4
	OPTN_CD_4       VARCHAR(30)   NULL     COMMENT '옵션 코드4', -- 옵션 코드4
	OPTN_CTGR_CD_5  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드5', -- 옵션 분류 코드5
	OPTN_CD_5       VARCHAR(30)   NULL     COMMENT '옵션 코드5', -- 옵션 코드5
	SSL_YN          CHAR(1)       NULL     COMMENT 'SSL 여부', -- SSL 여부
	DIV_LINE_USE_YN CHAR(1)       NULL     COMMENT '구분선 사용 여부', -- 구분선 사용 여부
	DFLT_YN         CHAR(1)       NULL     COMMENT '기본 여부', -- 기본 여부
	MENU_VIEW_YN    CHAR(1)       NULL     COMMENT '메뉴 조회 여부', -- 메뉴 조회 여부
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 메뉴';

-- (기관) 기관 메뉴
ALTER TABLE tb_org_menu
	ADD CONSTRAINT PK_tb_org_menu -- PK_tb_org_menu
		PRIMARY KEY (
			ORG_ID,  -- 기관 코드
			MENU_CD  -- 메뉴 코드
		);

-- IX_tb_org_menu
CREATE INDEX IX_tb_org_menu
	ON tb_org_menu( -- (기관) 기관 메뉴
		ORG_ID ASC,      -- 기관 코드
		PAR_MENU_CD ASC  -- 상위 메뉴 코드
	);

-- (기관) 메시지 템플릿
CREATE TABLE tb_org_msg_tpl (
	MSG_TPL_ID      VARCHAR(30)   NOT NULL COMMENT '메시지 템플릿 ID', -- 메시지 템플릿 ID
	ORG_ID          VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	MSG_TPL_CD      VARCHAR(30)   NOT NULL COMMENT '메시지 템플릿 코드', -- 메시지 템플릿 코드
	MSG_TPL_NM      VARCHAR(200)  NOT NULL COMMENT '메시지 템플릿 명', -- 메시지 템플릿 명
	MSG_TPL_TYPE_CD VARCHAR(30)   NULL     COMMENT '메시지 템플릿 타입', -- 메시지 템플릿 타입
	MSG_TPL_CTS     VARCHAR(2000) NOT NULL COMMENT '메시지 템플릿 내용', -- 메시지 템플릿 내용
	USE_YN          CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 메시지 템플릿';

-- (기관) 메시지 템플릿
ALTER TABLE tb_org_msg_tpl
	ADD CONSTRAINT PK_tb_org_msg_tpl -- PK_tb_org_msg_tpl
		PRIMARY KEY (
			MSG_TPL_ID -- 메시지 템플릿 ID
		);

-- (기관) 메시지 템플릿 언어
CREATE TABLE tb_org_msg_tpl_lang (
	MSG_TPL_ID    VARCHAR(30)  NOT NULL COMMENT '메시지 템플릿 번호', -- 메시지 템플릿 ID
	LANG_CD       VARCHAR(30)  NOT NULL COMMENT '언어 코드', -- 언어 코드
	MSG_TPL_TITLE VARCHAR(200) NOT NULL COMMENT '메시지 템플릿 제목', -- 메시지 템플릿 제목
	MSG_TPL_CTS   LONGTEXT     NOT NULL COMMENT '메시지 템플릿 내용' -- 메시지 템플릿 내용
)
COMMENT '(기관) 메시지 템플릿 언어';

-- (기관) 메시지 템플릿 언어
ALTER TABLE tb_org_msg_tpl_lang
	ADD CONSTRAINT PK_tb_org_msg_tpl_lang -- PK_tb_org_msg_tpl_lang
		PRIMARY KEY (
			MSG_TPL_ID, -- 메시지 템플릿 ID
			LANG_CD     -- 언어 코드
		);

-- (기관) 기관 정보
CREATE TABLE tb_org_org_info (
	ORG_ID             VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	ORG_NM             VARCHAR(200)  NOT NULL COMMENT '기관 명', -- 기관 명
	SYS_TYPE_CD        VARCHAR(30)   NOT NULL COMMENT '시스템 유형코드', -- 시스템 유형코드
	DOMAIN_NM          VARCHAR(200)  NOT NULL COMMENT '도메인명', -- 도메인명
	START_DTTM         VARCHAR(14)   NULL     COMMENT '시작 일시', -- 시작 일시
	END_DTTM           VARCHAR(14)   NULL     COMMENT '종료 일시', -- 종료 일시
	USE_YN             CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	DFLT_LANG_CD       VARCHAR(30)   NOT NULL DEFAULT 'ko' COMMENT '기본 언어 코드', -- 기본 언어 코드
	PRODUCT_CD         VARCHAR(30)   NULL     COMMENT '상품 코드', -- 상품 코드
	LAYOUT_TPL_CD      VARCHAR(30)   NULL     COMMENT 'LAYOUT 템플릿 코드', -- LAYOUT 템플릿 코드
	COLOR_TPL_CD       VARCHAR(30)   NULL     COMMENT '색상 템플릿 코드', -- 색상 템플릿 코드
	LIMIT_NOP_CNT      INT           NULL     COMMENT '제한 인원 수', -- 제한 인원 수
	TPL_CD             VARCHAR(30)   NULL     COMMENT '템플릿 코드', -- 템플릿 코드
	TOP_LOGO_FILE_SN   INT           NULL     COMMENT 'TOP LOGO 파일 고유번호', -- TOP LOGO 파일 고유번호
	SUB_LOGO_1_FILE_SN INT           NULL     COMMENT 'SUB LOGO 1 파일 고유번호', -- SUB LOGO 1 파일 고유번호
	SUB_LOGO_1_URL     VARCHAR(500)  NULL     COMMENT 'SUB LOGO 1 URL', -- SUB LOGO 1 URL
	SUB_LOGO_2_FILE_SN INT           NULL     COMMENT 'SUB LOGO 2 파일 고유번호', -- SUB LOGO 2 파일 고유번호
	SUB_LOGO_2_URL     VARCHAR(500)  NULL     COMMENT 'SUB LOGO 2 URL', -- SUB LOGO 2 URL
	ADM_LOGO_FILE_SN   INT           NULL     COMMENT '로고 파일 번호', -- 로고 파일 번호
	WWW_FOOTER         VARCHAR(2000) NULL     COMMENT '홈페이지 FOOTER', -- 홈페이지 FOOTER
	ADM_FOOTER         VARCHAR(2000) NULL     COMMENT '기관 FOOTER', -- 기관 FOOTER
	MENU_VER           VARCHAR(100)  NULL     COMMENT '메뉴 버전', -- 메뉴 버전
	EMAIL_ADDR         VARCHAR(100)  NULL     COMMENT '이메일 주소', -- 이메일 주소
	EMAIL_NM           VARCHAR(200)  NULL     COMMENT '이메일 명', -- 이메일 명
	RPRST_PHONE_NO     VARCHAR(30)   NULL     COMMENT '대표 전화 번호', -- 대표 전화 번호
	CHRG_PRSN_INFO     VARCHAR(100)  NULL     COMMENT '담당자 정보', -- 담당자 정보
	MULTI_LOGIN_YN     CHAR(1)       NULL     COMMENT '멀티 로그인 여부', -- 멀티 로그인 여부
	PSWD_CHG_USE_YN    CHAR(1)       NULL     COMMENT '비밀번호 변경 사용 여부', -- 비밀번호 변경 사용 여부
	PSWD_USE_PERIOD    INT           NULL     COMMENT '비밀번호 사용 기간', -- 비밀번호 사용 기간
	MBR_ID_TYPE        VARCHAR(10)   NULL     COMMENT '회원 아이디 유형', -- 회원 아이디 유형
	MBR_APLC_USE_YN    CHAR(1)       NULL     COMMENT '회원 가입 사용 여부', -- 회원 가입 사용 여부
	SITE_USAGE_CD      VARCHAR(30)   NULL     COMMENT '사이트 용도', -- 사이트 용도
	ORG_SNM            VARCHAR(200)  NULL     COMMENT '기관 명 별칭', -- 기관 명 별칭
	RPRST_FAX_NO       VARCHAR(30)   NULL     COMMENT '팩스 번호', -- 팩스 번호
	ORG_BIZ_NO         VARCHAR(30)   NULL     COMMENT '기관 등록 번호', -- 기관 등록 번호
	ORG_POST           VARCHAR(10)   NULL     COMMENT '우편번호', -- 우편번호
	ORG_ADDR           VARCHAR(255)  NULL     COMMENT '기관 주소', -- 기관 주소
	RGTR_ID             VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(기관) 기관 정보';

-- (기관) 기관 정보
ALTER TABLE tb_org_org_info
	ADD CONSTRAINT PK_tb_org_org_info -- PK_tb_org_org_info
		PRIMARY KEY (
			ORG_ID -- 기관 코드
		);

-- (기타) 세션 관리
CREATE TABLE tb_session (
	USER_ID    VARCHAR(30)  NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	SESSION_ID VARCHAR(100) NOT NULL COMMENT '세션 ID', -- 세션 ID
	REG_DTTM   VARCHAR(14)  NULL     COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(기타) 세션 관리';

-- (기타) 세션 관리
ALTER TABLE tb_session
	ADD CONSTRAINT PK_tb_session -- PK_tb_session
		PRIMARY KEY (
			USER_ID -- 사용자 번호
		);

-- (통계) 과목별 수강 통계
CREATE TABLE tb_stat_stdy_cors (
	CRE_YEAR           VARCHAR(4)    NOT NULL COMMENT '과정 년도', -- 과정 년도
	CRE_TERM           VARCHAR(2)    NOT NULL COMMENT '과정 학기', -- 과정 학기
	CRS_CD             VARCHAR(30)   NOT NULL COMMENT '과정 코드', -- 과정 코드
	DECLS_NO           VARCHAR(3)    NOT NULL COMMENT '분반 번호', -- 분반 번호
	USER_ID            VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	CRS_CRE_CD         VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	CRS_CRE_NM         VARCHAR(200)  NOT NULL COMMENT '과정개설 명', -- 과정개설 명
	ENR_HP             INT           NULL     COMMENT '신청 학점', -- 신청 학점
	CONN_DAY           INT           NULL     COMMENT '접속일수', -- 접속일수
	CONN_TM_SUM        INT           NULL     COMMENT '접속시간 합계', -- 접속시간 합계
	DAY_TM_AVG         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 평균', -- 일 접속시간 평균
	DAY_TM_DEV         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 표준편차', -- 일 접속시간 표준편차
	DAY_TERM_DEV       DECIMAL(10,3) NULL     COMMENT '접속일 간격 표준편차', -- 접속일 간격 표준편차
	DAY_TERM_AVG       DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '접속일 간격 평균', -- 접속일 간격 평균
	CONN_DAY_RATIO     DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주간 접속 비율', -- 주간 접속 비율
	CONN_WEEKDAY_RATIO DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주중 접속비율', -- 주중 접속비율
	REG_DTTM           VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 과목별 수강 통계';

-- (통계) 과목별 수강 통계
ALTER TABLE tb_stat_stdy_cors
	ADD CONSTRAINT PK_tb_stat_stdy_cors -- PK_tb_stat_stdy_cors
		PRIMARY KEY (
			CRE_YEAR, -- 과정 년도
			CRE_TERM, -- 과정 학기
			CRS_CD,   -- 과정 코드
			DECLS_NO, -- 분반 번호
			USER_ID   -- 사용자 번호
		);

-- IX_tb_stat_stdy_cors
CREATE INDEX IX_tb_stat_stdy_cors
	ON tb_stat_stdy_cors( -- (통계) 과목별 수강 통계
		CRE_YEAR ASC,   -- 과정 년도
		CRE_TERM ASC,   -- 과정 학기
		USER_ID ASC,    -- 사용자 번호
		CRS_CRE_CD ASC  -- 과정개설 코드
	);

-- (통계) 수강 통계 합계
CREATE TABLE tb_stat_stdy_sum (
	CRE_YEAR           VARCHAR(4)    NOT NULL COMMENT '과정 년도', -- 과정 년도
	CRE_TERM           VARCHAR(2)    NOT NULL COMMENT '과정 학기', -- 과정 학기
	USER_ID            VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	ENR_HP             INT           NULL     COMMENT '신청 학점', -- 신청 학점
	CONN_DAY           INT           NULL     COMMENT '접속일수', -- 접속일수
	CONN_TM_SUM        INT           NULL     COMMENT '접속시간 합계', -- 접속시간 합계
	DAY_TM_AVG         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 평균', -- 일 접속시간 평균
	DAY_TM_DEV         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 표준편차', -- 일 접속시간 표준편차
	DAY_TERM_AVG       DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '접속일 간격 평균', -- 접속일 간격 평균
	DAY_TERM_DEV       DECIMAL(10,3) NULL     COMMENT '접속일 간격 표준편차', -- 접속일 간격 표준편차
	CONN_DAY_RATIO     DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주간 접속 비율', -- 주간 접속 비율
	CONN_WEEKDAY_RATIO DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주중 접속비율', -- 주중 접속비율
	REG_DTTM           VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 수강 통계 합계';

-- (통계) 수강 통계 합계
ALTER TABLE tb_stat_stdy_sum
	ADD CONSTRAINT PK_tb_stat_stdy_sum -- PK_tb_stat_stdy_sum
		PRIMARY KEY (
			CRE_YEAR, -- 과정 년도
			CRE_TERM, -- 과정 학기
			USER_ID   -- 사용자 번호
		);

-- (통계) 주차별 수강 통계
CREATE TABLE tb_stat_stdy_week (
	CRE_YEAR           VARCHAR(4)    NOT NULL COMMENT '과정 년도', -- 과정 년도
	CRE_TERM           VARCHAR(2)    NOT NULL COMMENT '과정 학기', -- 과정 학기
	USER_ID            VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	LT_WEEK            INT           NOT NULL COMMENT '강의 주차', -- 강의 주차
	ENR_HP             INT           NULL     COMMENT '신청 학점', -- 신청 학점
	CONN_DAY           INT           NULL     COMMENT '접속일수', -- 접속일수
	CONN_TM_SUM        INT           NULL     COMMENT '접속시간 합계', -- 접속시간 합계
	DAY_TM_AVG         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 평균', -- 일 접속시간 평균
	DAY_TM_DEV         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 표준편차', -- 일 접속시간 표준편차
	DAY_TERM_AVG       DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '접속일 간격 평균', -- 접속일 간격 평균
	DAY_TERM_DEV       DECIMAL(10,3) NULL     COMMENT '접속일 간격 표준편차', -- 접속일 간격 표준편차
	CONN_DAY_RATIO     DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주간 접속 비율', -- 주간 접속 비율
	CONN_WEEKDAY_RATIO DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주중 접속비율', -- 주중 접속비율
	REG_DTTM           VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 주차별 수강 통계';

-- (통계) 주차별 수강 통계
ALTER TABLE tb_stat_stdy_week
	ADD CONSTRAINT PK_tb_stat_stdy_week -- PK_tb_stat_stdy_week
		PRIMARY KEY (
			CRE_YEAR, -- 과정 년도
			CRE_TERM, -- 과정 학기
			USER_ID,  -- 사용자 번호
			LT_WEEK   -- 강의 주차
		);

-- (통계) 수강 통계 주차 누적 합계
CREATE TABLE tb_stat_stdy_weeksum (
	CRE_YEAR           VARCHAR(4)    NOT NULL COMMENT '과정 년도', -- 과정 년도
	CRE_TERM           VARCHAR(2)    NOT NULL COMMENT '과정 학기', -- 과정 학기
	USER_ID            VARCHAR(30)   NOT NULL COMMENT '사용자 번호', -- 사용자 번호
	LT_WEEK            INT           NOT NULL COMMENT '강의 주차', -- 강의 주차
	ENR_HP             INT           NULL     COMMENT '신청 학점', -- 신청 학점
	CONN_DAY           INT           NULL     COMMENT '접속일수', -- 접속일수
	CONN_DAY_SUM       INT           NULL     COMMENT '접속일수 누적 합계', -- 접속일수 누적 합계
	CONN_TM            INT           NULL     COMMENT '접속시간', -- 접속시간
	CONN_TM_SUM        INT           NULL     COMMENT '접속시간 합계', -- 접속시간 합계
	DAY_TM_AVG         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 평균', -- 일 접속시간 평균
	DAY_TM_DEV         DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '일 접속시간 표준편차', -- 일 접속시간 표준편차
	DAY_TERM_AVG       DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '접속일 간격 평균', -- 접속일 간격 평균
	DAY_TERM_DEV       DECIMAL(10,3) NULL     COMMENT '접속일 간격 표준편차', -- 접속일 간격 표준편차
	CONN_DAY_RATIO     DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주간 접속 비율', -- 주간 접속 비율
	CONN_WEEKDAY_RATIO DECIMAL(10,3) NULL     DEFAULT 0.000 COMMENT '주중 접속비율', -- 주중 접속비율
	REG_DTTM           VARCHAR(14)   NULL     COMMENT '등록 일시', -- 등록 일시
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(통계) 수강 통계 주차 누적 합계';

-- (통계) 수강 통계 주차 누적 합계
ALTER TABLE tb_stat_stdy_weeksum
	ADD CONSTRAINT PK_tb_stat_stdy_weeksum -- PK_tb_stat_stdy_weeksum
		PRIMARY KEY (
			CRE_YEAR, -- 과정 년도
			CRE_TERM, -- 과정 학기
			USER_ID,  -- 사용자 번호
			LT_WEEK   -- 강의 주차
		);

-- (시스템) 권한 그룹
CREATE TABLE tb_sys_auth_grp (
	MENU_TYPE       VARCHAR(30)   NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	AUTH_GRP_CD     VARCHAR(30)   NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	SYS_TYPE_CD     VARCHAR(30)   NULL     COMMENT '시스템 유형코드', -- 시스템 유형코드
	USE_YN          CHAR(1)       NULL     DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	AUTH_GRP_NM     VARCHAR(200)  NOT NULL COMMENT '권한 그룹 명', -- 권한 그룹 명
	AUTH_GRP_DESC   VARCHAR(2000) NULL     COMMENT '권한 그룹 설명', -- 권한 그룹 설명
	AUTH_GRP_ODR    INT           NOT NULL COMMENT '권한 그룹 순서', -- 권한 그룹 순서
	FILE_LIMIT_SIZE INT           NULL     COMMENT '파일 용량 제한 크기', -- 파일 용량 제한 크기
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 권한 그룹';

-- (시스템) 권한 그룹
ALTER TABLE tb_sys_auth_grp
	ADD CONSTRAINT PK_tb_sys_auth_grp -- PK_tb_sys_auth_grp
		PRIMARY KEY (
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD  -- 권한 그룹 코드
		);

-- (시스템) 권한 그룹 언어
CREATE TABLE tb_sys_auth_grp_lang (
	MENU_TYPE     VARCHAR(30)   NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	AUTH_GRP_CD   VARCHAR(30)   NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	LANG_CD       VARCHAR(30)   NOT NULL COMMENT '언어 코드', -- 언어 코드
	AUTH_GRP_NM   VARCHAR(200)  NOT NULL COMMENT '권한 그룹 명', -- 권한 그룹 명
	AUTH_GRP_DESC VARCHAR(2000) NULL     COMMENT '권한 그룹 설명' -- 권한 그룹 설명
)
COMMENT '(시스템) 권한 그룹 언어';

-- (시스템) 권한 그룹 언어
ALTER TABLE tb_sys_auth_grp_lang
	ADD CONSTRAINT PK_tb_sys_auth_grp_lang -- PK_tb_sys_auth_grp_lang
		PRIMARY KEY (
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD, -- 권한 그룹 코드
			LANG_CD      -- 언어 코드
		);

-- (시스템) 권한 그룹 메뉴
CREATE TABLE tb_sys_auth_grp_menu (
	AUTH_GRP_CD VARCHAR(30) NOT NULL COMMENT '권한 그룹 코드', -- 권한 그룹 코드
	MENU_CD     VARCHAR(30) NOT NULL COMMENT '메뉴 코드', -- 메뉴 코드
	MENU_TYPE   VARCHAR(30) NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	VIEW_AUTH   CHAR(1)     NULL     COMMENT '조회 권한', -- 조회 권한
	CRE_AUTH    CHAR(1)     NULL     COMMENT '등록 권한', -- 등록 권한
	MOD_AUTH    CHAR(1)     NULL     COMMENT '수정 권한', -- 수정 권한
	DEL_AUTH    CHAR(1)     NULL     COMMENT '삭제 권한', -- 삭제 권한
	RGTR_ID      VARCHAR(30) NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14) NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 권한 그룹 메뉴';

-- (시스템) 권한 그룹 메뉴
ALTER TABLE tb_sys_auth_grp_menu
	ADD CONSTRAINT PK_tb_sys_auth_grp_menu -- PK_tb_sys_auth_grp_menu
		PRIMARY KEY (
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_CD,     -- 메뉴 코드
			MENU_TYPE    -- 메뉴 유형
		);

-- (시스템) 배치 프로그램 정보
CREATE TABLE tb_sys_batch_info (
	BATCH_ID           VARCHAR(30)   NOT NULL COMMENT '배치 아이디', -- 배치 아이디
	ORG_ID             VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	BATCH_CD           VARCHAR(30)   NOT NULL COMMENT '배치 코드', -- 배치 코드
	BATCH_NM           VARCHAR(200)  NOT NULL COMMENT '배치 명', -- 배치 명
	BATCH_DESC         VARCHAR(2000) NULL     COMMENT '배치 설명', -- 배치 설명
	BATCH_SCH          VARCHAR(500)  NOT NULL COMMENT '배치 일정', -- 배치 일정
	EXEC_YN            CHAR(1)       NOT NULL COMMENT '실행 여부', -- 실행 여부
	LAST_EXEC_END_DTTM VARCHAR(14)   NULL     COMMENT '최종 실행 일시', -- 최종 실행 일시
	MANUAL_EXEC_URL    VARCHAR(500)  NULL     COMMENT '수동실행 URL', -- 수동실행 URL
	NEXT_TM_SYNC_YN    CHAR(1)       NOT NULL COMMENT '다음학기 동기화 여부', -- 다음학기 동기화 여부
	USE_YN             CHAR(1)       NOT NULL COMMENT '사용 여부', -- 사용 여부
	RGTR_ID             VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 배치 프로그램 정보';

-- (시스템) 배치 프로그램 정보
ALTER TABLE tb_sys_batch_info
	ADD CONSTRAINT PK_tb_sys_batch_info -- PK_tb_sys_batch_info
		PRIMARY KEY (
			BATCH_ID -- 배치 아이디
		);

-- (시스템) 시스템 설정
CREATE TABLE tb_sys_cfg (
	CFG_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '설정 분류 코드', -- 설정 분류 코드
	CFG_CD      VARCHAR(30)   NOT NULL COMMENT '설정 코드', -- 설정 코드
	CFG_NM      VARCHAR(50)   NOT NULL COMMENT '설정 명', -- 설정 명
	CFG_VAL     VARCHAR(100)  NOT NULL COMMENT '설정 값', -- 설정 값
	CFG_DESC    VARCHAR(2000) NULL     COMMENT '설정 비고', -- 설정 비고
	USE_YN      CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID      VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)   NOT NULL COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)   NOT NULL COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 시스템 설정';

-- (시스템) 시스템 설정
ALTER TABLE tb_sys_cfg
	ADD CONSTRAINT PK_tb_sys_cfg -- PK_tb_sys_cfg
		PRIMARY KEY (
			CFG_CTGR_CD, -- 설정 분류 코드
			CFG_CD       -- 설정 코드
		);

-- (시스템) 시스템 설정 분류
CREATE TABLE tb_sys_cfg_ctgr (
	CFG_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '설정 분류 코드', -- 설정 분류 코드
	CTGR_NM     VARCHAR(200)  NOT NULL COMMENT '분류 명', -- 분류 명
	CTGR_DESC   VARCHAR(2000) NULL     COMMENT '분류 설명', -- 분류 설명
	USE_YN      CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID      VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM    VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID      VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM    VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 시스템 설정 분류';

-- (시스템) 시스템 설정 분류
ALTER TABLE tb_sys_cfg_ctgr
	ADD CONSTRAINT PK_tb_sys_cfg_ctgr -- PK_tb_sys_cfg_ctgr
		PRIMARY KEY (
			CFG_CTGR_CD -- 설정 분류 코드
		);

-- (시스템) 시스템 코드
CREATE TABLE tb_sys_code (
	CODE_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '코드 분류 코드', -- 코드 분류 코드
	CODE_CD      VARCHAR(30)   NOT NULL COMMENT '코드', -- 코드
	CODE_NM      VARCHAR(50)   NOT NULL COMMENT '코드 명', -- 코드 명
	CODE_DESC    VARCHAR(2000) NOT NULL COMMENT '코드 설명', -- 코드 설명
	CODE_OPTN    VARCHAR(100)  NULL     COMMENT '코드 옵션', -- 코드 옵션
	CODE_ODR     INT           NOT NULL COMMENT '코드 순서', -- 코드 순서
	USE_YN       CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID       VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 시스템 코드';

-- (시스템) 시스템 코드
ALTER TABLE tb_sys_code
	ADD CONSTRAINT PK_tb_sys_code -- PK_tb_sys_code
		PRIMARY KEY (
			CODE_CTGR_CD, -- 코드 분류 코드
			CODE_CD       -- 코드
		);

-- IX_tb_sys_code
CREATE INDEX IX_tb_sys_code
	ON tb_sys_code( -- (시스템) 시스템 코드
		CODE_CTGR_CD ASC -- 코드 분류 코드
	);

-- (시스템) 시스템 코드  분류
CREATE TABLE tb_sys_code_ctgr (
	CODE_CTGR_CD   VARCHAR(30)   NOT NULL COMMENT '코드 분류 코드', -- 코드 분류 코드
	SYS_TYPE_CD    VARCHAR(30)   NULL     COMMENT '시스템 유형코드', -- 시스템 유형코드
	CODE_CTGR_NM   VARCHAR(50)   NOT NULL COMMENT '코드 분류 명', -- 코드 분류 명
	CODE_CTGR_DESC VARCHAR(2000) NULL     COMMENT '코드 분류 설명', -- 코드 분류 설명
	CODE_CTGR_ODR  INT           NOT NULL COMMENT '코드 분류 순서', -- 코드 분류 순서
	USE_YN         CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID         VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID         VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM       VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 시스템 코드 분류';

-- (시스템) 시스템 코드  분류
ALTER TABLE tb_sys_code_ctgr
	ADD CONSTRAINT PK_tb_sys_code_ctgr -- PK_tb_sys_code_ctgr
		PRIMARY KEY (
			CODE_CTGR_CD -- 코드 분류 코드
		);

-- IX_tb_sys_code_ctgr
CREATE INDEX IX_tb_sys_code_ctgr
	ON tb_sys_code_ctgr( -- (시스템) 시스템 코드  분류
		SYS_TYPE_CD ASC -- 시스템 유형코드
	);

-- (시스템) 시스템 코드 언어
CREATE TABLE tb_sys_code_lang (
	CODE_CTGR_CD VARCHAR(30)   NOT NULL COMMENT '코드 분류 코드', -- 코드 분류 코드
	CODE_CD      VARCHAR(30)   NOT NULL COMMENT '코드', -- 코드
	LANG_CD      VARCHAR(30)   NOT NULL COMMENT '언어 코드', -- 언어 코드
	CODE_NM      VARCHAR(50)   NOT NULL COMMENT '코드 명', -- 코드 명
	CODE_DESC    VARCHAR(2000) NULL     COMMENT '코드 설명' -- 코드 설명
)
COMMENT '(시스템) 시스템 코드 언어';

-- (시스템) 시스템 코드 언어
ALTER TABLE tb_sys_code_lang
	ADD CONSTRAINT PK_tb_sys_code_lang -- PK_tb_sys_code_lang
		PRIMARY KEY (
			CODE_CTGR_CD, -- 코드 분류 코드
			CODE_CD,      -- 코드
			LANG_CD       -- 언어 코드
		);

-- (시스템) 파일
CREATE TABLE tb_sys_file (
	FILE_SN             VARCHAR(30)  NOT NULL COMMENT '파일 번호', -- 파일 번호
	ORG_ID              VARCHAR(30)  NOT NULL COMMENT '기관 코드', -- 기관 코드
	REPO_CD             VARCHAR(30)  NOT NULL COMMENT '저장소 코드', -- 저장소 코드
	REPO_PATH           VARCHAR(200) NULL     COMMENT '저장소 경로', -- 저장소 경로
	FILE_PATH           VARCHAR(200) NULL     COMMENT '파일 경로', -- 파일 경로
	FILE_NM             VARCHAR(200) NOT NULL COMMENT '파일 명', -- 파일 명
	FILE_SAVE_NM        VARCHAR(200) NOT NULL COMMENT '파일 저장 명', -- 파일 저장 명
	FILE_EXT            VARCHAR(50)  NULL     COMMENT '파일 확장자', -- 파일 확장자
	FILE_SIZE           INT          NULL     COMMENT '파일 크기', -- 파일 크기
	FILE_TYPE           VARCHAR(30)  NULL     COMMENT '파일 유형', -- 파일 유형
	MIME_TYPE           VARCHAR(100) NULL     COMMENT '마임 유형', -- 마임 유형
	HITS                INT          NULL     COMMENT '조회 수', -- 조회 수
	LAST_INQ_DTTM       VARCHAR(14)  NULL     COMMENT '마지막 조회 일시', -- 마지막 조회 일시
	RGTR_ID              VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM            VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	FILE_BIND_DATA_SN   VARCHAR(100) NULL     COMMENT '파일 할당 자료 번호', -- 파일 할당 자료 번호
	ETC_INFO_1          VARCHAR(200) NULL     COMMENT '부가 정보 1', -- 부가 정보 1
	ETC_INFO_2          VARCHAR(200) NULL     COMMENT '부가 정보 2', -- 부가 정보 2
	ETC_INFO_3          VARCHAR(200) NULL     COMMENT '부가 정보 3', -- 부가 정보 3
	CANVAS_PATH         VARCHAR(100) NULL     COMMENT 'CANVAS 이전 경로', -- CANVAS 이전 경로
	CVNT_FILE           VARCHAR(200) NULL     COMMENT '변환 파일', -- 변환 파일
	THUMB               VARCHAR(200) NULL     COMMENT '썸네일 이미지', -- 썸네일 이미지
	OBJECT_STORAGE_PATH VARCHAR(200) NULL     COMMENT '오브젝트 스토리지 경로' -- 오브젝트 스토리지 경로
)
COMMENT '(시스템) 파일';

-- (시스템) 파일
ALTER TABLE tb_sys_file
	ADD CONSTRAINT PK_tb_sys_file -- PK_tb_sys_file
		PRIMARY KEY (
			FILE_SN -- 파일 번호
		);

-- IX_tb_sys_file
CREATE INDEX IX_tb_sys_file
	ON tb_sys_file( -- (시스템) 파일
		FILE_BIND_DATA_SN ASC -- 파일 할당 자료 번호
	);

-- (시스템) 파일함
CREATE TABLE tb_sys_file_box (
	FILE_BOX_CD      VARCHAR(30)  NOT NULL COMMENT '파일함 코드', -- 파일함 코드
	PAR_FILE_BOX_CD  VARCHAR(30)  NULL     COMMENT '상위 파일함 코드', -- 상위 파일함 코드
	FILE_SN          VARCHAR(30)  NULL     COMMENT '파일 번호', -- 파일 번호
	FILE_BOX_TYPE_CD VARCHAR(30)  NOT NULL COMMENT '파일함 구분 코드', -- 파일함 구분 코드
	FILE_BOX_NM      VARCHAR(200) NOT NULL COMMENT '파일함 명', -- 파일함 명
	RGTR_ID           VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM         VARCHAR(14)  NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID           VARCHAR(30)  NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM         VARCHAR(14)  NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 파일함';

-- (시스템) 파일함
ALTER TABLE tb_sys_file_box
	ADD CONSTRAINT PK_tb_sys_file_box -- PK_tb_sys_file_box
		PRIMARY KEY (
			FILE_BOX_CD -- 파일함 코드
		);

-- (시스템) 파일 저장소
CREATE TABLE tb_sys_file_repo (
	REPO_CD        VARCHAR(30)  NOT NULL COMMENT '저장소 코드', -- 저장소 코드
	PAR_TABLE_NM   VARCHAR(100) NULL     COMMENT '상위 테이블 명', -- 상위 테이블 명
	PAR_FIELD_NM   VARCHAR(100) NULL     COMMENT '상위 컬럼 명', -- 상위 컬럼 명
	REPO_DFLT_PATH VARCHAR(100) NULL     COMMENT '저장소 기본 경로', -- 저장소 기본 경로
	RGTR_ID         VARCHAR(30)  NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM       VARCHAR(14)  NOT NULL COMMENT '등록 일시' -- 등록 일시
)
COMMENT '(시스템) 파일 저장소';

-- (시스템) 파일 저장소
ALTER TABLE tb_sys_file_repo
	ADD CONSTRAINT PK_tb_sys_file_repo -- PK_tb_sys_file_repo
		PRIMARY KEY (
			REPO_CD -- 저장소 코드
		);

-- (시스템) 파일 용량 제한
CREATE TABLE tb_sys_file_size_limit (
	FILE_SIZE_LIMIT_ID VARCHAR(30) NOT NULL COMMENT '파일 용량 제한 ID', -- 파일 용량 제한 ID
	LIMIT_TYPE_CD      VARCHAR(30) NOT NULL COMMENT '용량 제한 구분 코드', -- 용량 제한 구분 코드
	LIMIT_TYPE_DETL_CD VARCHAR(30) NOT NULL COMMENT '용량 제한 상세 구분 코드', -- 용량 제한 상세 구분 코드
	LIMIT_SIZE         INT         NULL     COMMENT '용량 제한 크기', -- 용량 제한 크기
	RGTR_ID             VARCHAR(30) NULL     COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM           VARCHAR(14) NULL     COMMENT '등록 일시', -- 등록 일시
	MDFR_ID             VARCHAR(30) NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM           VARCHAR(14) NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 파일 용량 제한';

-- (시스템) 파일 용량 제한
ALTER TABLE tb_sys_file_size_limit
	ADD CONSTRAINT PK_tb_sys_file_size_limit -- PK_tb_sys_file_size_limit
		PRIMARY KEY (
			FILE_SIZE_LIMIT_ID -- 파일 용량 제한 ID
		);

-- (시스템) 업무 일정
CREATE TABLE tb_sys_job_sch (
	JOB_SCH_SN    VARCHAR(30)   NOT NULL COMMENT '업무 일정 번호', -- 업무 일정 번호
	ORG_ID        VARCHAR(30)   NOT NULL COMMENT '기관 코드', -- 기관 코드
	HAKSA_YEAR    VARCHAR(4)    NULL     COMMENT '학사 년도', -- 학사 년도
	HAKSA_TERM    VARCHAR(4)    NULL     COMMENT '학사 학기', -- 학사 학기
	CALENDAR_CTGR VARCHAR(30)   NOT NULL COMMENT '일정 분류', -- 일정 분류
	SCH_START_DT  VARCHAR(14)   NOT NULL COMMENT '일정 시작 일자', -- 일정 시작 일자
	SCH_END_DT    VARCHAR(14)   NOT NULL COMMENT '일정 종료 일자', -- 일정 종료 일자
	JOB_SCH_NM    VARCHAR(200)  NOT NULL COMMENT '업무 일정 명', -- 업무 일정 명
	SCH_CMNT      VARCHAR(1000) NULL     COMMENT '일정 코멘트', -- 일정 코멘트
	USE_YN        CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	RGTR_ID        VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM      VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID        VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM      VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 업무 일정';

-- (시스템) 업무 일정
ALTER TABLE tb_sys_job_sch
	ADD CONSTRAINT PK_tb_sys_job_sch -- PK_tb_sys_job_sch
		PRIMARY KEY (
			JOB_SCH_SN -- 업무 일정 번호
		);

-- (시스템) 업무 일정 예외
CREATE TABLE tb_sys_job_sch_exc (
	JOB_EXC_SN   VARCHAR(30)   NOT NULL COMMENT '업무일정 예외 번호', -- 업무일정 예외 번호
	JOB_SCH_SN   VARCHAR(30)   NOT NULL COMMENT '업무 일정 번호', -- 업무 일정 번호
	CRS_CRE_CD   VARCHAR(30)   NOT NULL COMMENT '과정개설 코드', -- 과정개설 코드
	SCH_START_DT VARCHAR(14)   NOT NULL COMMENT '일정 시작 일자', -- 일정 시작 일자
	SCH_END_DT   VARCHAR(14)   NOT NULL COMMENT '일정 종료 일자', -- 일정 종료 일자
	EXC_CMNT     VARCHAR(1000) NULL     COMMENT '예외 처리 사유', -- 예외 처리 사유
	RGTR_ID       VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM     VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID       VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM     VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 업무 일정 예외';

-- (시스템) 업무 일정 예외
ALTER TABLE tb_sys_job_sch_exc
	ADD CONSTRAINT PK_tb_sys_job_sch_exc -- PK_tb_sys_job_sch_exc
		PRIMARY KEY (
			JOB_EXC_SN -- 업무일정 예외 번호
		);

-- (시스템) 시스템 메뉴
CREATE TABLE tb_sys_menu (
	MENU_CD         VARCHAR(30)   NOT NULL COMMENT '메뉴 코드', -- 메뉴 코드
	PAR_MENU_CD     VARCHAR(30)   NULL     COMMENT '상위 메뉴 코드', -- 상위 메뉴 코드
	MENU_TYPE       VARCHAR(30)   NOT NULL COMMENT '메뉴 유형', -- 메뉴 유형
	MENU_URL        VARCHAR(500)  NULL     COMMENT '메뉴 URL', -- 메뉴 URL
	MENU_NM         VARCHAR(200)  NOT NULL COMMENT '메뉴 명', -- 메뉴 명
	MENU_DESC       VARCHAR(2000) NULL     COMMENT '메뉴 설명', -- 메뉴 설명
	MENU_LVL        INT           NULL     COMMENT '메뉴 레벨', -- 메뉴 레벨
	MENU_ODR        INT           NOT NULL COMMENT '메뉴 순서', -- 메뉴 순서
	USE_YN          CHAR(1)       NOT NULL DEFAULT 'Y' COMMENT '사용 여부', -- 사용 여부
	LEFT_MENU_IMG   VARCHAR(200)  NULL     COMMENT '좌측 메뉴 이미지', -- 좌측 메뉴 이미지
	LEFT_MENU_TITLE VARCHAR(200)  NULL     COMMENT '좌측 메뉴 타이틀', -- 좌측 메뉴 타이틀
	TOP_MENU_YN     CHAR(1)       NULL     COMMENT '상단 메뉴 여부', -- 상단 메뉴 여부
	MENU_PATH       VARCHAR(500)  NULL     COMMENT '메뉴 경로', -- 메뉴 경로
	TOP_MENU_IMG    VARCHAR(200)  NULL     COMMENT '상단 메뉴 이미지', -- 상단 메뉴 이미지
	MENU_TITLE      VARCHAR(200)  NULL     COMMENT '메뉴 타이틀', -- 메뉴 타이틀
	OPTN_CTGR_CD_1  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드1', -- 옵션 분류 코드1
	OPTN_CD_1       VARCHAR(30)   NULL     COMMENT '옵션 코드1', -- 옵션 코드1
	OPTN_CTGR_CD_2  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드2', -- 옵션 분류 코드2
	OPTN_CD_2       VARCHAR(30)   NULL     COMMENT '옵션 코드2', -- 옵션 코드2
	OPTN_CTGR_CD_3  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드3', -- 옵션 분류 코드3
	OPTN_CD_3       VARCHAR(30)   NULL     COMMENT '옵션 코드3', -- 옵션 코드3
	OPTN_CTGR_CD_4  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드4', -- 옵션 분류 코드4
	OPTN_CD_4       VARCHAR(30)   NULL     COMMENT '옵션 코드4', -- 옵션 코드4
	OPTN_CTGR_CD_5  VARCHAR(30)   NULL     COMMENT '옵션 분류 코드5', -- 옵션 분류 코드5
	OPTN_CD_5       VARCHAR(30)   NULL     COMMENT '옵션 코드5', -- 옵션 코드5
	SSL_YN          CHAR(1)       NULL     DEFAULT 'N' COMMENT 'SSL 여부', -- SSL 여부
	DIV_LINE_USE_YN CHAR(1)       NULL     COMMENT '구분선 사용 여부', -- 구분선 사용 여부
	MENU_VIEW_YN    CHAR(1)       NULL     DEFAULT 'N' COMMENT '메뉴 조회 여부', -- 메뉴 조회 여부
	RGTR_ID          VARCHAR(30)   NOT NULL COMMENT '등록자 번호', -- 등록자 번호
	REG_DTTM        VARCHAR(14)   NOT NULL COMMENT '등록 일시', -- 등록 일시
	MDFR_ID          VARCHAR(30)   NULL     COMMENT '수정자 번호', -- 수정자 번호
	MOD_DTTM        VARCHAR(14)   NULL     COMMENT '수정 일시' -- 수정 일시
)
COMMENT '(시스템) 시스템 메뉴';

-- (시스템) 시스템 메뉴
ALTER TABLE tb_sys_menu
	ADD CONSTRAINT PK_tb_sys_menu -- PK_tb_sys_menu
		PRIMARY KEY (
			MENU_CD -- 메뉴 코드
		);

-- (시스템) 시스템 유형
CREATE TABLE tb_sys_type (
	SYS_TYPE_CD   VARCHAR(30)   NOT NULL COMMENT '시스템 유형코드', -- 시스템 유형코드
	SYS_TYPE_NM   VARCHAR(200)  NOT NULL COMMENT '시스템 유형 명', -- 시스템 유형 명
	SYS_TYPE_DESC VARCHAR(2000) NULL     COMMENT '시스템 유형 설명' -- 시스템 유형 설명
)
COMMENT '(시스템) 시스템 유형';

-- (시스템) 시스템 유형
ALTER TABLE tb_sys_type
	ADD CONSTRAINT PK_tb_sys_type -- PK_tb_sys_type
		PRIMARY KEY (
			SYS_TYPE_CD -- 시스템 유형코드
		);

-- (게시판) 게시판 게시글
ALTER TABLE tb_home_bbs_atcl
	ADD CONSTRAINT FK_tb_home_bbs_atcl -- FK_tb_home_bbs_atcl
		FOREIGN KEY (
			BBS_ID -- 게시판 ID
		)
		REFERENCES tb_home_bbs_info ( -- (게시판) 게시판 정보
			BBS_ID -- 게시판 ID
		),
	ADD INDEX IFK_tb_home_bbs_atcl (
		BBS_ID ASC -- 게시판 ID
	);

-- (게시판) 게시판 게시글
ALTER TABLE tb_home_bbs_atcl
	ADD CONSTRAINT FK_tb_home_bbs_atcl2 -- FK_tb_home_bbs_atcl2
		FOREIGN KEY (
			PAR_ATCL_ID -- 상위 게시글 ID
		)
		REFERENCES tb_home_bbs_atcl ( -- (게시판) 게시판 게시글
			ATCL_ID -- 게시글 ID
		),
	ADD INDEX IFK_tb_home_bbs_atcl2 (
		PAR_ATCL_ID ASC -- 상위 게시글 ID
	);

-- (게시판) 게시판 게시글
ALTER TABLE tb_home_bbs_atcl
	ADD CONSTRAINT FK_tb_home_bbs_atcl3 -- FK_tb_home_bbs_atcl3
		FOREIGN KEY (
			HEAD_CD, -- 말머리 코드
			BBS_ID   -- 게시판 ID
		)
		REFERENCES tb_home_bbs_head ( -- (게시판) 게시판 말머리
			HEAD_CD, -- 말머리 코드
			BBS_ID   -- 게시판 ID
		),
	ADD INDEX IFK_tb_home_bbs_atcl3 (
		HEAD_CD ASC, -- 말머리 코드
		BBS_ID ASC   -- 게시판 ID
	);

-- (게시판) 게시판 댓글
ALTER TABLE tb_home_bbs_cmnt
	ADD CONSTRAINT FK_tb_home_bbs_cmnt -- FK_tb_home_bbs_cmnt
		FOREIGN KEY (
			ATCL_ID -- 게시글 ID
		)
		REFERENCES tb_home_bbs_atcl ( -- (게시판) 게시판 게시글
			ATCL_ID -- 게시글 ID
		),
	ADD INDEX IFK_tb_home_bbs_cmnt (
		ATCL_ID ASC -- 게시글 ID
	);

-- (게시판) 게시판 말머리
ALTER TABLE tb_home_bbs_head
	ADD CONSTRAINT FKtb_home_bbs_head -- FK_tb_home_bbs_head
		FOREIGN KEY (
			BBS_ID -- 게시판 ID
		)
		REFERENCES tb_home_bbs_info ( -- (게시판) 게시판 정보
			BBS_ID -- 게시판 ID
		),
	ADD INDEX IFK_tb_home_bbs_head (
		BBS_ID ASC -- 게시판 ID
	);

-- (게시판) 게시판 정보
ALTER TABLE tb_home_bbs_info
	ADD CONSTRAINT FK_tb_home_bbs_info -- FK_tb_home_bbs_info
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		),
	ADD INDEX IFK_tb_home_bbs_info (
		ORG_ID ASC -- 기관 코드
	);

-- (게시판) 게시글 조회
ALTER TABLE tb_home_bbs_view
	ADD CONSTRAINT FK_tb_home_bbs_view -- FK_tb_home_bbs_view
		FOREIGN KEY (
			ATCL_ID -- 게시글 ID
		)
		REFERENCES tb_home_bbs_atcl ( -- (게시판) 게시판 게시글
			ATCL_ID -- 게시글 ID
		),
	ADD INDEX IFK_tb_home_bbs_view (
		ATCL_ID ASC -- 게시글 ID
	);

-- (회원정보) 사용자 권한 그룹
ALTER TABLE tb_home_user_auth_grp
	ADD CONSTRAINT FK_tb_home_user_auth_grp -- FK_tb_home_user_auth_grp
		FOREIGN KEY (
			USER_ID -- 사용자 번호
		)
		REFERENCES tb_home_user_login ( -- (회원정보) 로그인
			USER_ID -- 사용자 번호
		),
	ADD INDEX IFK_tb_home_user_auth_grp (
		USER_ID ASC -- 사용자 번호
	);

-- (과제) 과제 피드백
ALTER TABLE tb_lms_asmnt_fdbk
	ADD CONSTRAINT FK_tb_lms_asmnt_fdbk -- FK_tb_lms_asmnt_fdbk
		FOREIGN KEY (
			ASMNT_CD -- 과제 코드
		)
		REFERENCES tb_lms_asmnt ( -- (과제) 과제 정보
			ASMNT_CD -- 과제 코드
		),
	ADD INDEX IFK_tb_lms_asmnt_fdbk (
		ASMNT_CD ASC -- 과제 코드
	);

-- (과제) 과제 참여자 이력
ALTER TABLE tb_lms_asmnt_join_hsty
	ADD CONSTRAINT FK_tb_lms_asmnt_join_hsty -- FK_tb_lms_asmnt_join_hsty
		FOREIGN KEY (
			ASMNT_SEND_CD -- 과제 제출 코드
		)
		REFERENCES tb_lms_asmnt_join_user ( -- (과제) 과제 참여자
			ASMNT_SEND_CD -- 과제 제출 코드
		),
	ADD INDEX IFK_tb_lms_asmnt_join_hsty (
		ASMNT_SEND_CD ASC -- 과제 제출 코드
	);

-- (과제) 과제 참여자
ALTER TABLE tb_lms_asmnt_join_user
	ADD CONSTRAINT FK_tb_lms_asmnt_join_user -- FK_tb_lms_asmnt_join_user
		FOREIGN KEY (
			ASMNT_CD -- 과제 코드
		)
		REFERENCES tb_lms_asmnt ( -- (과제) 과제 정보
			ASMNT_CD -- 과제 코드
		),
	ADD INDEX IFK_tb_lms_asmnt_join_user (
		ASMNT_CD ASC -- 과제 코드
	);

-- (과제) 과제 상호평가
ALTER TABLE tb_lms_asmnt_mut_eval
	ADD CONSTRAINT FK_tb_lms_asmnt_mut_eval -- FK_tb_lms_asmnt_mut_eval
		FOREIGN KEY (
			ASMNT_SEND_CD -- 과제 제출 코드
		)
		REFERENCES tb_lms_asmnt_join_user ( -- (과제) 과제 참여자
			ASMNT_SEND_CD -- 과제 제출 코드
		),
	ADD INDEX IFK_tb_lms_asmnt_mut_eval (
		ASMNT_SEND_CD ASC -- 과제 제출 코드
	);

-- (과제) 과제 제출 파일
ALTER TABLE tb_lms_asmnt_sbmt_file
	ADD CONSTRAINT FK_tb_lms_asmnt_sbmt_file -- FK_tb_lms_asmnt_sbmt_file
		FOREIGN KEY (
			ASMNT_SEND_CD -- 과제 제출 코드
		)
		REFERENCES tb_lms_asmnt_join_user ( -- (과제) 과제 참여자
			ASMNT_SEND_CD -- 과제 제출 코드
		),
	ADD INDEX IFK_tb_lms_asmnt_sbmt_file (
		ASMNT_SEND_CD ASC -- 과제 제출 코드
	);

-- (과정) 과정 테마 분류
ALTER TABLE tb_lms_cre_tm_ctgr
	ADD CONSTRAINT FK_tb_lms_cre_tm_ctgr -- FK_tb_lms_cre_tm_ctgr
		FOREIGN KEY (
			PAR_CRE_TM_CTGR_CD -- 상위 테마 분류 코드
		)
		REFERENCES tb_lms_cre_tm_ctgr ( -- (과정) 과정 테마 분류
			CRE_TM_CTGR_CD -- 테마 분류 코드
		),
	ADD INDEX IFK_tb_lms_cre_tm_ctgr (
		PAR_CRE_TM_CTGR_CD ASC -- 상위 테마 분류 코드
	);

-- (과정) 과정 분류
ALTER TABLE tb_lms_crs_ctgr
	ADD CONSTRAINT FK_tb_lms_crs_ctgr -- FK_tb_lms_crs_ctgr
		FOREIGN KEY (
			PAR_CRS_CTGR_CD -- 상위 과정 분류 코드
		)
		REFERENCES tb_lms_crs_ctgr ( -- (과정) 과정 분류
			CRS_CTGR_CD -- 과정 분류 코드
		),
	ADD INDEX IFK_tb_lms_crs_ctgr (
		PAR_CRS_CTGR_CD ASC -- 상위 과정 분류 코드
	);

-- (시험) 시험 정보
ALTER TABLE tb_lms_exam
	ADD CONSTRAINT FK_tb_lms_exam -- FK_tb_lms_exam
		FOREIGN KEY (
			EXAM_CTGR_CD, -- 시험 분류 코드
			ORG_ID        -- 기관 코드
		)
		REFERENCES tb_lms_exam_ctgr ( -- (시험) 시험 분류
			EXAM_CTGR_CD, -- 시험 분류 코드
			ORG_ID        -- 기관 코드
		),
	ADD INDEX IFK_tb_lms_exam (
		EXAM_CTGR_CD ASC, -- 시험 분류 코드
		ORG_ID ASC        -- 기관 코드
	);

-- (시험) 시험 문제
ALTER TABLE tb_lms_exam_qstn
	ADD CONSTRAINT FK_tb_lms_exam_qstn -- FK_tb_lms_exam_qstn
		FOREIGN KEY (
			EXAM_CD -- 시험 코드
		)
		REFERENCES tb_lms_exam ( -- (시험) 시험 정보
			EXAM_CD -- 시험 코드
		),
	ADD INDEX IFK_tb_lms_exam_qstn (
		EXAM_CD ASC -- 시험 코드
	);

-- (시험) 시험 응시
ALTER TABLE tb_lms_exam_stare
	ADD CONSTRAINT FK_tb_lms_exam_stare -- FK_tb_lms_exam_stare
		FOREIGN KEY (
			EXAM_CD -- 시험 코드
		)
		REFERENCES tb_lms_exam ( -- (시험) 시험 정보
			EXAM_CD -- 시험 코드
		),
	ADD INDEX IFK_tb_lms_exam_stare (
		EXAM_CD ASC -- 시험 코드
	);

-- (시험) 시험 응시 이력
ALTER TABLE tb_lms_exam_stare_hsty
	ADD CONSTRAINT FK_tb_lms_exam_stare_hsty -- FK_tb_lms_exam_stare_hsty
		FOREIGN KEY (
			STD_NO,  -- 수강생 번호
			EXAM_CD  -- 시험 코드
		)
		REFERENCES tb_lms_exam_stare ( -- (시험) 시험 응시
			STD_NO,  -- 수강생 번호
			EXAM_CD  -- 시험 코드
		),
	ADD INDEX IFK_tb_lms_exam_stare_hsty (
		STD_NO ASC,  -- 수강생 번호
		EXAM_CD ASC  -- 시험 코드
	);

-- (시험) 시험 응시 시험지
ALTER TABLE tb_lms_exam_stare_paper
	ADD CONSTRAINT FK_tb_lms_exam_stare_paper2 -- FK_tb_lms_exam_stare_paper2
		FOREIGN KEY (
			STD_NO -- 수강생 번호
		)
		REFERENCES tb_lms_std ( -- (강의) 수강생
			STD_NO -- 수강생 번호
		),
	ADD INDEX IFK_tb_lms_exam_stare_paper2 (
		STD_NO ASC -- 수강생 번호
	);

-- (시험) 시험 응시 시험지 이력
ALTER TABLE tb_lms_exam_stare_paper_hsty
	ADD CONSTRAINT FK_tb_lms_exam_stare_paper_hsty -- FK_tb_lms_exam_stare_paper_hsty
		FOREIGN KEY (
			EXAM_CD,      -- 시험 코드
			EXAM_QSTN_SN  -- 시험 문제 번호
		)
		REFERENCES tb_lms_exam_qstn ( -- (시험) 시험 문제
			EXAM_CD,      -- 시험 코드
			EXAM_QSTN_SN  -- 시험 문제 번호
		),
	ADD INDEX IFK_tb_lms_exam_stare_paper_hsty (
		EXAM_CD ASC,      -- 시험 코드
		EXAM_QSTN_SN ASC  -- 시험 문제 번호
	);

-- (시험) 시험 응시 시험지 이력
ALTER TABLE tb_lms_exam_stare_paper_hsty
	ADD CONSTRAINT FK_tb_lms_exam_stare_paper_hsty2 -- FK_tb_lms_exam_stare_paper_hsty2
		FOREIGN KEY (
			STD_NO -- 수강생 번호
		)
		REFERENCES tb_lms_std ( -- (강의) 수강생
			STD_NO -- 수강생 번호
		),
	ADD INDEX IFK_tb_lms_exam_stare_paper_hsty2 (
		STD_NO ASC -- 수강생 번호
	);

-- (토론) 토론 게시글
ALTER TABLE tb_lms_forum_atcl
	ADD CONSTRAINT FK_tb_lms_forum_atcl -- FK_tb_lms_forum_atcl
		FOREIGN KEY (
			FORUM_CD -- 토론 코드
		)
		REFERENCES tb_lms_forum ( -- (토론) 토론 정보
			FORUM_CD -- 토론 코드
		),
	ADD INDEX IFK_tb_lms_forum_atcl (
		FORUM_CD ASC -- 토론 코드
	);

-- (토론) 토론 댓글
ALTER TABLE tb_lms_forum_cmnt
	ADD CONSTRAINT FK_tb_lms_forum_cmnt -- FK_tb_lms_forum_cmnt
		FOREIGN KEY (
			ATCL_SN -- 게시글 번호
		)
		REFERENCES tb_lms_forum_atcl ( -- (토론) 토론 게시글
			ATCL_SN -- 게시글 번호
		),
	ADD INDEX IFK_tb_lms_forum_cmnt (
		ATCL_SN ASC -- 게시글 번호
	);

-- (토론) 토론 피드백
ALTER TABLE tb_lms_forum_fdbk
	ADD CONSTRAINT FK_tb_lms_forum_fdbk -- FK_tb_lms_forum_fdbk
		FOREIGN KEY (
			STD_NO,   -- 수강생 번호
			FORUM_CD  -- 토론 코드
		)
		REFERENCES tb_lms_forum_join_user ( -- (토론) 토론 참여자
			STD_NO,   -- 수강생 번호
			FORUM_CD  -- 토론 코드
		),
	ADD INDEX IFK_tb_lms_forum_fdbk (
		FORUM_CD ASC, -- 토론 코드
		STD_NO ASC    -- 수강생 번호
	);

-- (토론) 토론 참여자
ALTER TABLE tb_lms_forum_join_user
	ADD CONSTRAINT FK_tb_lms_forum_join_user -- FK_tb_lms_forum_join_user
		FOREIGN KEY (
			FORUM_CD -- 토론 코드
		)
		REFERENCES tb_lms_forum ( -- (토론) 토론 정보
			FORUM_CD -- 토론 코드
		),
	ADD INDEX IFK_tb_lms_forum_join_user (
		FORUM_CD ASC -- 토론 코드
	);

-- (강의) 학습 콘텐츠
ALTER TABLE tb_lms_lesson_cnts
	ADD CONSTRAINT FK_tb_lms_lesson_cnts -- FK_tb_lms_lesson_cnts
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		),
	ADD INDEX IFK_tb_lms_lesson_cnts (
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (강의) 학습 콘텐츠
ALTER TABLE tb_lms_lesson_cnts
	ADD CONSTRAINT FK_tb_lms_lesson_cnts2 -- FK_tb_lms_lesson_cnts2
		FOREIGN KEY (
			LESSON_TIME_ID -- 교시 ID
		)
		REFERENCES tb_lms_lesson_time ( -- (강의) 학습 일정 교시
			LESSON_TIME_ID -- 교시 ID
		),
	ADD INDEX IFK_tb_lms_lesson_cnts2 (
		LESSON_TIME_ID ASC -- 교시 ID
	);

-- (강의) 학습 기록 상세
ALTER TABLE tb_lms_lesson_study_detail
	ADD CONSTRAINT FK_tb_lms_lesson_study_detail -- FK_tb_lms_lesson_study_detail
		FOREIGN KEY (
			STD_NO,         -- 수강생 번호
			LESSON_CNTS_ID  -- 학습 콘텐츠 ID
		)
		REFERENCES tb_lms_lesson_study_record ( -- (강의) 학습 기록
			STD_NO,         -- 수강생 번호
			LESSON_CNTS_ID  -- 학습 콘텐츠 ID
		),
	ADD INDEX IFK_tb_lms_lesson_study_detail (
		STD_NO ASC,         -- 수강생 번호
		LESSON_CNTS_ID ASC  -- 학습 콘텐츠 ID
	);

-- (강의) 페이지 학습 기록
ALTER TABLE tb_lms_lesson_study_page
	ADD CONSTRAINT FK_tb_lms_lesson_study_page -- FK_tb_lms_lesson_study_page
		FOREIGN KEY (
			STD_NO,         -- 수강생 번호
			LESSON_CNTS_ID  -- 학습 콘텐츠 ID
		)
		REFERENCES tb_lms_lesson_study_record ( -- (강의) 학습 기록
			STD_NO,         -- 수강생 번호
			LESSON_CNTS_ID  -- 학습 콘텐츠 ID
		),
	ADD INDEX IFK_tb_lms_lesson_study_page (
		LESSON_CNTS_ID ASC, -- 학습 콘텐츠 ID
		STD_NO ASC          -- 수강생 번호
	);

-- (강의) 학습 기록
ALTER TABLE tb_lms_lesson_study_record
	ADD CONSTRAINT FK_tb_lms_lesson_study_record1 -- FK_tb_lms_lesson_study_record1
		FOREIGN KEY (
			LESSON_CNTS_ID -- 학습 콘텐츠 ID
		)
		REFERENCES tb_lms_lesson_cnts ( -- (강의) 학습 콘텐츠
			LESSON_CNTS_ID -- 학습 콘텐츠 ID
		),
	ADD INDEX IFK_tb_lms_lesson_study_record1 (
		LESSON_CNTS_ID ASC -- 학습 콘텐츠 ID
	);

-- (강의) 학습 기록
ALTER TABLE tb_lms_lesson_study_record
	ADD CONSTRAINT FK_tb_lms_lesson_study_record2 -- FK_tb_lms_lesson_study_record2
		FOREIGN KEY (
			STD_NO -- 수강생 번호
		)
		REFERENCES tb_lms_std ( -- (강의) 수강생
			STD_NO -- 수강생 번호
		),
	ADD INDEX IFK_tb_lms_lesson_study_record2 (
		STD_NO ASC -- 수강생 번호
	);

-- (강의) 주차 학습 상황
ALTER TABLE tb_lms_lesson_study_state
	ADD CONSTRAINT FK_tb_lms_lesson_study_state2 -- FK_tb_lms_lesson_study_state2
		FOREIGN KEY (
			STD_NO -- 수강생 번호
		)
		REFERENCES tb_lms_std ( -- (강의) 수강생
			STD_NO -- 수강생 번호
		),
	ADD INDEX IFK_tb_lms_lesson_study_state2 (
		STD_NO ASC -- 수강생 번호
	);

-- (강의) 학습 일정 교시
ALTER TABLE tb_lms_lesson_time
	ADD CONSTRAINT FK_tb_lms_lesson_time -- FK_tb_lms_lesson_time
		FOREIGN KEY (
			LESSON_SCHEDULE_ID -- 학습 일정 ID
		)
		REFERENCES tb_lms_lesson_schedule ( -- (강의) 학습 일정
			LESSON_SCHEDULE_ID -- 학습 일정 ID
		),
	ADD INDEX IFK_tb_lms_lesson_time (
		LESSON_SCHEDULE_ID ASC -- 학습 일정 ID
	);

-- (상호평가) 상호평가 등급
ALTER TABLE tb_lms_mut_eval_grade
	ADD CONSTRAINT FK_tb_lms_mut_eval_grade -- FK_tb_lms_mut_eval_grade
		FOREIGN KEY (
			EVAL_CD, -- 평가 코드
			QSTN_CD  -- 문제 코드
		)
		REFERENCES tb_lms_mut_eval_qstn ( -- (상호평가) 상호평가 등급 문항
			EVAL_CD, -- 평가 코드
			QSTN_CD  -- 문제 코드
		),
	ADD INDEX IFK_tb_lms_mut_eval_grade (
		QSTN_CD ASC, -- 문제 코드
		EVAL_CD ASC  -- 평가 코드
	);

-- (상호평가) 상호평가 결과
ALTER TABLE tb_lms_mut_eval_rslt
	ADD CONSTRAINT FK_tb_lms_mut_eval_rslt -- FK_tb_lms_mut_eval_rslt
		FOREIGN KEY (
			EVAL_CD, -- 평가 코드
			RLTN_CD  -- 연결 코드
		)
		REFERENCES tb_lms_mut_eval_rltn ( -- (상호평가) 상호평가 연결
			EVAL_CD, -- 평가 코드
			RLTN_CD  -- 연결 코드
		),
	ADD INDEX IFK_tb_lms_mut_eval_rslt (
		EVAL_CD ASC, -- 평가 코드
		RLTN_CD ASC  -- 연결 코드
	);

-- (설문) 설문 정보
ALTER TABLE tb_lms_resch
	ADD CONSTRAINT FK_tb_lms_resch -- FK_tb_lms_resch
		FOREIGN KEY (
			RESCH_CTGR_CD -- 설문 분류 코드
		)
		REFERENCES tb_lms_resch_ctgr ( -- (설문) 설문 분류
			RESCH_CTGR_CD -- 설문 분류 코드
		),
	ADD INDEX IFK_tb_lms_resch (
		RESCH_CTGR_CD ASC -- 설문 분류 코드
	);

-- (설문) 설문 응답
ALTER TABLE tb_lms_resch_ansr
	ADD CONSTRAINT FK_tb_lms_resch_ansr -- FK_tb_lms_resch_ansr
		FOREIGN KEY (
			RESCH_CD, -- 설문 코드
			USER_ID   -- 사용자 번호
		)
		REFERENCES tb_lms_resch_join_user ( -- (설문) 설문 참여자
			RESCH_CD, -- 설문 코드
			USER_ID   -- 사용자 번호
		),
	ADD INDEX IFK_tb_lms_resch_ansr (
		USER_ID ASC,  -- 사용자 번호
		RESCH_CD ASC  -- 설문 코드
	);

-- (설문) 설문 응답
ALTER TABLE tb_lms_resch_ansr
	ADD CONSTRAINT FK_tb_lms_resch_ansr2 -- FK_tb_lms_resch_ansr2
		FOREIGN KEY (
			RESCH_QSTN_ITEM_CD -- 설문 항목 선택지 코드
		)
		REFERENCES tb_lms_resch_qstn_item ( -- (설문) 설문 문항 선택지
			RESCH_QSTN_ITEM_CD -- 설문 항목 선택지 코드
		),
	ADD INDEX IFK_tb_lms_resch_ansr2 (
		RESCH_QSTN_ITEM_CD ASC -- 설문 항목 선택지 코드
	);

-- (설문) 설문 응답
ALTER TABLE tb_lms_resch_ansr
	ADD CONSTRAINT FK_tb_lms_resch_ansr3 -- FK_tb_lms_resch_ansr3
		FOREIGN KEY (
			RESCH_QSTN_CD -- 설문 항목 코드
		)
		REFERENCES tb_lms_resch_qstn ( -- (설문) 설문 문항
			RESCH_QSTN_CD -- 설문 항목 코드
		),
	ADD INDEX IFK_tb_lms_resch_ansr3 (
		RESCH_QSTN_CD ASC -- 설문 항목 코드
	);

-- (설문) 설문 응답
ALTER TABLE tb_lms_resch_ansr
	ADD CONSTRAINT FK_tb_lms_resch_ansr4 -- FK_tb_lms_resch_ansr4
		FOREIGN KEY (
			RESCH_SCALE_CD -- 설문 척도 코드
		)
		REFERENCES tb_lms_resch_scale ( -- (설문) 설문 평가 척도
			RESCH_SCALE_CD -- 설문 척도 코드
		),
	ADD INDEX IFK_tb_lms_resch_ansr4 (
		RESCH_SCALE_CD ASC -- 설문 척도 코드
	);

-- (설문) 설문 개설과정 연결
ALTER TABLE tb_lms_resch_cre_crs_rltn
	ADD CONSTRAINT FK_tb_lms_resch_cre_crs_rltn -- FK_tb_lms_resch_cre_crs_rltn
		FOREIGN KEY (
			RESCH_CD -- 설문 코드
		)
		REFERENCES tb_lms_resch ( -- (설문) 설문 정보
			RESCH_CD -- 설문 코드
		),
	ADD INDEX IFK_tb_lms_resch_cre_crs_rltn (
		RESCH_CD ASC -- 설문 코드
	);

-- (설문) 설문 분류
ALTER TABLE tb_lms_resch_ctgr
	ADD CONSTRAINT FK_tb_lms_resch_ctgr -- FK_tb_lms_resch_ctgr
		FOREIGN KEY (
			PAR_RESCH_CTGR_CD -- 상위 설문 분류 코드
		)
		REFERENCES tb_lms_resch_ctgr ( -- (설문) 설문 분류
			RESCH_CTGR_CD -- 설문 분류 코드
		),
	ADD INDEX IFK_tb_lms_resch_ctgr (
		PAR_RESCH_CTGR_CD ASC -- 상위 설문 분류 코드
	);

-- (설문) 설문 페이지
ALTER TABLE tb_lms_resch_page
	ADD CONSTRAINT FK_tb_lms_resch_page -- FK_tb_lms_resch_page
		FOREIGN KEY (
			RESCH_CD -- 설문 코드
		)
		REFERENCES tb_lms_resch ( -- (설문) 설문 정보
			RESCH_CD -- 설문 코드
		),
	ADD INDEX IFK_tb_lms_resch_page (
		RESCH_CD ASC -- 설문 코드
	);

-- (설문) 설문 문항
ALTER TABLE tb_lms_resch_qstn
	ADD CONSTRAINT FK_tb_lms_resch_qstn -- FK_tb_lms_resch_qstn
		FOREIGN KEY (
			RESCH_PAGE_CD -- 설문 페이지 코드
		)
		REFERENCES tb_lms_resch_page ( -- (설문) 설문 페이지
			RESCH_PAGE_CD -- 설문 페이지 코드
		),
	ADD INDEX IFK_tb_lms_resch_qstn (
		RESCH_PAGE_CD ASC -- 설문 페이지 코드
	);

-- (설문) 설문 문항 선택지
ALTER TABLE tb_lms_resch_qstn_item
	ADD CONSTRAINT FK_tb_lms_resch_qstn_item -- FK_tb_lms_resch_qstn_item
		FOREIGN KEY (
			RESCH_QSTN_CD -- 설문 항목 코드
		)
		REFERENCES tb_lms_resch_qstn ( -- (설문) 설문 문항
			RESCH_QSTN_CD -- 설문 항목 코드
		),
	ADD INDEX IFK_tb_lms_resch_qstn_item (
		RESCH_QSTN_CD ASC -- 설문 항목 코드
	);

-- (설문) 설문 평가 척도
ALTER TABLE tb_lms_resch_scale
	ADD CONSTRAINT FK_tb_lms_resch_scale -- FK_tb_lms_resch_scale
		FOREIGN KEY (
			RESCH_QSTN_CD -- 설문 항목 코드
		)
		REFERENCES tb_lms_resch_qstn ( -- (설문) 설문 문항
			RESCH_QSTN_CD -- 설문 항목 코드
		),
	ADD INDEX IFK_tb_lms_resch_scale (
		RESCH_QSTN_CD ASC -- 설문 항목 코드
	);

-- (세미나) 세미나 참석
ALTER TABLE tb_lms_seminar_atnd
	ADD CONSTRAINT FK_tb_lms_seminar_atnd -- FK_tb_lms_seminar_atnd
		FOREIGN KEY (
			SEMINAR_ID -- 세미나 ID
		)
		REFERENCES tb_lms_seminar ( -- (세미나) 세미나 정보
			SEMINAR_ID -- 세미나 ID
		),
	ADD INDEX IFK_tb_lms_seminar_atnd (
		SEMINAR_ID ASC -- 세미나 ID
	);

-- (세미나) 세미나 참석 이력
ALTER TABLE tb_lms_seminar_hsty
	ADD CONSTRAINT FK_tb_lms_seminar_hsty -- FK_tb_lms_seminar_hsty
		FOREIGN KEY (
			SEMINAR_ID -- 세미나 ID
		)
		REFERENCES tb_lms_seminar ( -- (세미나) 세미나 정보
			SEMINAR_ID -- 세미나 ID
		),
	ADD INDEX IFK_tb_lms_seminar_hsty (
		SEMINAR_ID ASC -- 세미나 ID
	);

-- (강의) 수강생
ALTER TABLE tb_lms_std
	ADD CONSTRAINT FK_tb_lms_std -- FK_tb_lms_std
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		),
	ADD INDEX IFK_tb_lms_std (
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (성적) 기관 성적 항목 설정
ALTER TABLE tb_lms_std_org_score_item_conf
	ADD CONSTRAINT FK_tb_lms_std_org_score_item_conf -- FK_tb_lms_std_org_score_item_conf
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		),
	ADD INDEX IFK_tb_lms_std_org_score_item_conf (
		ORG_ID ASC -- 기관 코드
	);

-- (성적) 수강생 아이템별 성적
ALTER TABLE tb_lms_std_score_item
	ADD CONSTRAINT FK_tb_lms_std_score_item2 -- FK_tb_lms_std_score_item2
		FOREIGN KEY (
			SCORE_ITEM_ID -- 성적 항목 ID
		)
		REFERENCES tb_lms_std_score_item_conf ( -- (성적) 성적 항목 설정
			SCORE_ITEM_ID -- 성적 항목 ID
		),
	ADD INDEX IFK_tb_lms_std_score_item2 (
		SCORE_ITEM_ID ASC -- 성적 항목 ID
	);

-- (성적) 성적 항목 설정
ALTER TABLE tb_lms_std_score_item_conf
	ADD CONSTRAINT FK_tb_lms_std_score_item_conf -- FK_tb_lms_std_score_item_conf
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		),
	ADD INDEX IFK_tb_lms_std_score_item_conf (
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (팀구성) 팀 정보
ALTER TABLE tb_lms_team
	ADD CONSTRAINT FK_tb_lms_team -- FK_tb_lms_team
		FOREIGN KEY (
			TEAM_CTGR_CD -- 팀 분류 코드
		)
		REFERENCES tb_lms_team_ctgr ( -- (팀구성) 팀 분류
			TEAM_CTGR_CD -- 팀 분류 코드
		),
	ADD INDEX IFK_tb_lms_team (
		TEAM_CTGR_CD ASC -- 팀 분류 코드
	);

-- (팀구성) 팀 분류
ALTER TABLE tb_lms_team_ctgr
	ADD CONSTRAINT FK_tb_lms_team_ctgr -- FK_tb_lms_team_ctgr
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		),
	ADD INDEX IFK_tb_lms_team_ctgr (
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (기관) 권한 그룹 메뉴
ALTER TABLE tb_org_auth_grp_menu
	ADD CONSTRAINT FK_tb_org_auth_grp_menu -- FK_tb_org_auth_grp_menu
		FOREIGN KEY (
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_TYPE,   -- 메뉴 유형
			ORG_ID       -- 기관 코드
		)
		REFERENCES tb_org_auth_grp ( -- (기관) 권한 그룹
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_TYPE,   -- 메뉴 유형
			ORG_ID       -- 기관 코드
		),
	ADD INDEX IFK_tb_org_auth_grp_menu (
		MENU_TYPE ASC,   -- 메뉴 유형
		AUTH_GRP_CD ASC, -- 권한 그룹 코드
		ORG_ID ASC       -- 기관 코드
	);

-- (기관) 기관 시스템 코드
ALTER TABLE tb_org_code
	ADD CONSTRAINT FK_tb_org_code -- FK_tb_org_code
		FOREIGN KEY (
			ORG_ID,       -- 기관 코드
			CODE_CTGR_CD  -- 코드 분류 코드
		)
		REFERENCES tb_org_code_ctgr ( -- (기관) 기관 시스템 코드 분류
			ORG_ID,       -- 기관 코드
			CODE_CTGR_CD  -- 코드 분류 코드
		),
	ADD INDEX IFK_tb_org_code (
		ORG_ID ASC,       -- 기관 코드
		CODE_CTGR_CD ASC  -- 코드 분류 코드
	);

-- (기관) 메시지 템플릿
ALTER TABLE tb_org_msg_tpl
	ADD CONSTRAINT FK_tb_org_msg_tpl -- FK_tb_org_msg_tpl
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		),
	ADD INDEX IFK_tb_org_msg_tpl (
		ORG_ID ASC -- 기관 코드
	);

-- (기관) 기관 정보
ALTER TABLE tb_org_org_info
	ADD CONSTRAINT FK_tb_org_org_info -- FK_tb_org_org_info
		FOREIGN KEY (
			SYS_TYPE_CD -- 시스템 유형코드
		)
		REFERENCES tb_sys_type ( -- (시스템) 시스템 유형
			SYS_TYPE_CD -- 시스템 유형코드
		),
	ADD INDEX IFK_tb_org_org_info (
		SYS_TYPE_CD ASC -- 시스템 유형코드
	);

-- (시스템) 권한 그룹
ALTER TABLE tb_sys_auth_grp
	ADD CONSTRAINT FK_tb_sys_auth_grp -- FK_tb_sys_auth_grp
		FOREIGN KEY (
			SYS_TYPE_CD -- 시스템 유형코드
		)
		REFERENCES tb_sys_type ( -- (시스템) 시스템 유형
			SYS_TYPE_CD -- 시스템 유형코드
		),
	ADD INDEX IFK_tb_sys_auth_grp (
		SYS_TYPE_CD ASC -- 시스템 유형코드
	);

-- (시스템) 권한 그룹 언어
ALTER TABLE tb_sys_auth_grp_lang
	ADD CONSTRAINT FK_tb_sys_auth_grp_lang -- FK_tb_sys_auth_grp_lang
		FOREIGN KEY (
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD  -- 권한 그룹 코드
		)
		REFERENCES tb_sys_auth_grp ( -- (시스템) 권한 그룹
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD  -- 권한 그룹 코드
		),
	ADD INDEX IFK_tb_sys_auth_grp_lang (
		MENU_TYPE ASC,   -- 메뉴 유형
		AUTH_GRP_CD ASC  -- 권한 그룹 코드
	);

-- (시스템) 권한 그룹 메뉴
ALTER TABLE tb_sys_auth_grp_menu
	ADD CONSTRAINT FK_tb_sys_auth_grp_menu -- FK_tb_sys_auth_grp_menu
		FOREIGN KEY (
			MENU_CD -- 메뉴 코드
		)
		REFERENCES tb_sys_menu ( -- (시스템) 시스템 메뉴
			MENU_CD -- 메뉴 코드
		),
	ADD INDEX IFK_tb_sys_auth_grp_menu (
		MENU_CD ASC -- 메뉴 코드
	);

-- (시스템) 시스템 설정
ALTER TABLE tb_sys_cfg
	ADD CONSTRAINT FK_tb_sys_cfg -- FK_tb_sys_cfg
		FOREIGN KEY (
			CFG_CTGR_CD -- 설정 분류 코드
		)
		REFERENCES tb_sys_cfg_ctgr ( -- (시스템) 시스템 설정 분류
			CFG_CTGR_CD -- 설정 분류 코드
		),
	ADD INDEX IFK_tb_sys_cfg (
		CFG_CTGR_CD ASC -- 설정 분류 코드
	);

-- (시스템) 시스템 코드 언어
ALTER TABLE tb_sys_code_lang
	ADD CONSTRAINT FK_tb_sys_code_lang -- FK_tb_sys_code_lang
		FOREIGN KEY (
			CODE_CTGR_CD, -- 코드 분류 코드
			CODE_CD       -- 코드
		)
		REFERENCES tb_sys_code ( -- (시스템) 시스템 코드
			CODE_CTGR_CD, -- 코드 분류 코드
			CODE_CD       -- 코드
		),
	ADD INDEX IFK_tb_sys_code_lang (
		CODE_CTGR_CD ASC, -- 코드 분류 코드
		CODE_CD ASC       -- 코드
	);

-- (시스템) 파일
ALTER TABLE tb_sys_file
	ADD CONSTRAINT FK_tb_sys_file -- FK_tb_sys_file
		FOREIGN KEY (
			REPO_CD -- 저장소 코드
		)
		REFERENCES tb_sys_file_repo ( -- (시스템) 파일 저장소
			REPO_CD -- 저장소 코드
		),
	ADD INDEX IFK_tb_sys_file (
		REPO_CD ASC -- 저장소 코드
	);

-- (시스템) 업무 일정 예외
ALTER TABLE tb_sys_job_sch_exc
	ADD CONSTRAINT FK_tb_sys_job_sch_exc -- FK_tb_sys_job_sch_exc
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		),
	ADD INDEX IFK_tb_sys_job_sch_exc (
		CRS_CRE_CD ASC -- 과정개설 코드
	);

-- (시스템) 업무 일정 예외
ALTER TABLE tb_sys_job_sch_exc
	ADD CONSTRAINT FK_tb_sys_job_sch_exc2 -- FK_tb_sys_job_sch_exc2
		FOREIGN KEY (
			JOB_SCH_SN -- 업무 일정 번호
		)
		REFERENCES tb_sys_job_sch ( -- (시스템) 업무 일정
			JOB_SCH_SN -- 업무 일정 번호
		),
	ADD INDEX IFK_tb_sys_job_sch_exc2 (
		JOB_SCH_SN ASC -- 업무 일정 번호
	);

-- (시스템) 시스템 메뉴
ALTER TABLE tb_sys_menu
	ADD CONSTRAINT FK_tb_sys_menu -- FK_tb_sys_menu
		FOREIGN KEY (
			PAR_MENU_CD -- 상위 메뉴 코드
		)
		REFERENCES tb_sys_menu ( -- (시스템) 시스템 메뉴
			MENU_CD -- 메뉴 코드
		),
	ADD INDEX IFK_tb_sys_menu (
		PAR_MENU_CD ASC -- 상위 메뉴 코드
	);

-- (게시판) 게시판 정보 언어
ALTER TABLE tb_home_bbs_info_lang
	ADD CONSTRAINT FK_tb_home_bbs_info_lang -- FK_tb_home_bbs_info_lang
		FOREIGN KEY (
			BBS_ID -- 게시판 ID
		)
		REFERENCES tb_home_bbs_info ( -- (게시판) 게시판 정보
			BBS_ID -- 게시판 ID
		);

-- (게시판) 게시판 정보 연결
ALTER TABLE tb_home_bbs_rltn
	ADD CONSTRAINT FK_tb_home_bbs_rltn -- FK_tb_home_bbs_rltn
		FOREIGN KEY (
			BBS_ID -- 게시판 ID
		)
		REFERENCES tb_home_bbs_info ( -- (게시판) 게시판 정보
			BBS_ID -- 게시판 ID
		);

-- (회원정보) 로그인
ALTER TABLE tb_home_user_login
	ADD CONSTRAINT FK_tb_home_user_login -- FK_tb_home_user_login
		FOREIGN KEY (
			USER_ID -- 사용자 번호
		)
		REFERENCES tb_home_user_info ( -- (회원정보) 사용자 정보
			USER_ID -- 사용자 번호
		);

-- (과제) 과제 상호평가 결과
ALTER TABLE tb_lms_asmnt_mut_eval_rslt
	ADD CONSTRAINT FK_tb_lms_asmnt_mut_eval_rslt -- FK_tb_lms_asmnt_mut_eval_rslt
		FOREIGN KEY (
			EVAL_CD, -- 평가 코드
			RLTN_CD  -- 연결 코드
		)
		REFERENCES tb_lms_mut_eval_rltn ( -- (상호평가) 상호평가 연결
			EVAL_CD, -- 평가 코드
			RLTN_CD  -- 연결 코드
		);

-- (과정) 개설과정 평가 방법
ALTER TABLE tb_lms_cre_crs_eval
	ADD CONSTRAINT FK_tb_lms_cre_crs_eval -- FK_tb_lms_cre_crs_eval
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 개설과정 파일 용량 제한
ALTER TABLE tb_lms_cre_crs_file_size_limit
	ADD CONSTRAINT FK_tb_lms_cre_crs_file_size_limit -- FK_tb_lms_cre_crs_file_size_limit
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 개설과정 주차 일정
ALTER TABLE tb_lms_cre_crs_lesson_plan
	ADD CONSTRAINT FK_tb_lms_cre_crs_lesson_plan -- FK_tb_lms_cre_crs_lesson_plan
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 개설과정 강사 연결
ALTER TABLE tb_lms_cre_crs_tch_rltn
	ADD CONSTRAINT FK_tb_lms_cre_crs_tch_rltn -- FK_tb_lms_cre_crs_tch_rltn
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		);

-- (과정) 과정 정보 콘텐츠
ALTER TABLE tb_lms_crs_info_cnts
	ADD CONSTRAINT FK_tb_lms_crs_info_cnts -- FK_tb_lms_crs_info_cnts
		FOREIGN KEY (
			CRS_CD -- 과정 코드
		)
		REFERENCES tb_lms_crs ( -- (과정) 과정
			CRS_CD -- 과정 코드
		);

-- (시험) 시험 개설과정 연결
ALTER TABLE tb_lms_exam_cre_crs_rltn
	ADD CONSTRAINT FK_tb_lms_exam_cre_crs_rltn -- FK_tb_lms_exam_cre_crs_rltn
		FOREIGN KEY (
			EXAM_CD -- 시험 코드
		)
		REFERENCES tb_lms_exam ( -- (시험) 시험 정보
			EXAM_CD -- 시험 코드
		);

-- (시험) 시험 응시 시험지
ALTER TABLE tb_lms_exam_stare_paper
	ADD CONSTRAINT FK_tb_lms_exam_stare_paper -- FK_tb_lms_exam_stare_paper
		FOREIGN KEY (
			EXAM_CD,      -- 시험 코드
			EXAM_QSTN_SN  -- 시험 문제 번호
		)
		REFERENCES tb_lms_exam_qstn ( -- (시험) 시험 문제
			EXAM_CD,      -- 시험 코드
			EXAM_QSTN_SN  -- 시험 문제 번호
		);

-- (토론) 토론 개설과정 연결
ALTER TABLE tb_lms_forum_cre_crs_rltn
	ADD CONSTRAINT FK_tb_lms_forum_cre_crs_rltn -- FK_tb_lms_forum_cre_crs_rltn
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		);

-- (토론) 토론 개설과정 연결
ALTER TABLE tb_lms_forum_cre_crs_rltn
	ADD CONSTRAINT FK_tb_lms_forum_cre_crs_rltn2 -- FK_tb_lms_forum_cre_crs_rltn2
		FOREIGN KEY (
			FORUM_CD -- 토론 코드
		)
		REFERENCES tb_lms_forum ( -- (토론) 토론 정보
			FORUM_CD -- 토론 코드
		);

-- (강의) 학습 페이지
ALTER TABLE tb_lms_lesson_page
	ADD CONSTRAINT FK_tb_lms_lesson_page -- FK_tb_lms_lesson_page
		FOREIGN KEY (
			LESSON_CNTS_ID -- 학습 콘텐츠 ID
		)
		REFERENCES tb_lms_lesson_cnts ( -- (강의) 학습 콘텐츠
			LESSON_CNTS_ID -- 학습 콘텐츠 ID
		);

-- (강의) 학습 일정
ALTER TABLE tb_lms_lesson_schedule
	ADD CONSTRAINT FK_tb_lms_lesson_schedule -- FK_(강의) 학습 일정
		FOREIGN KEY (
			CRS_CRE_CD -- 과정개설 코드
		)
		REFERENCES tb_lms_cre_crs ( -- (과정) 개설과정
			CRS_CRE_CD -- 과정개설 코드
		);

-- (강의) 주차 학습 상황
ALTER TABLE tb_lms_lesson_study_state
	ADD CONSTRAINT FK_tb_lms_lesson_study_state1 -- FK_tb_lms_lesson_study_state1
		FOREIGN KEY (
			LESSON_SCHEDULE_ID -- 학습 일정 ID
		)
		REFERENCES tb_lms_lesson_schedule ( -- (강의) 학습 일정
			LESSON_SCHEDULE_ID -- 학습 일정 ID
		);

-- (상호평가) 상호평가 연결
ALTER TABLE tb_lms_mut_eval_rltn
	ADD CONSTRAINT FK_tb_lms_mut_eval_rltn -- FK_tb_lms_mut_eval_rltn
		FOREIGN KEY (
			EVAL_CD -- 평가 코드
		)
		REFERENCES tb_lms_mut_eval ( -- (상호평가) 상호평가
			EVAL_CD -- 평가 코드
		);

-- (설문) 설문 참여자
ALTER TABLE tb_lms_resch_join_user
	ADD CONSTRAINT FK_tb_lms_resch_join_user -- FK_tb_lms_resch_join_user
		FOREIGN KEY (
			RESCH_CD -- 설문 코드
		)
		REFERENCES tb_lms_resch ( -- (설문) 설문 정보
			RESCH_CD -- 설문 코드
		);

-- (성적) 성적 출석 점수기준
ALTER TABLE tb_lms_score_atnd_conf
	ADD CONSTRAINT FK_tb_lms_score_atnd_conf -- FK_tb_lms_score_atnd_conf
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		);

-- (성적) 성적 환산 등급
ALTER TABLE tb_lms_score_grade_conf
	ADD CONSTRAINT FK_tb_lms_score_grade_conf -- FK_tb_lms_score_grade_conf
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		);

-- (성적) 성적 상대평가 비율 기준
ALTER TABLE tb_lms_score_rel_conf
	ADD CONSTRAINT FK_tb_lms_score_rel_conf -- FK_tb_lms_score_rel_conf
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		);

-- (성적) 수강생 성적
ALTER TABLE tb_lms_std_score
	ADD CONSTRAINT FK_tb_lms_std_score -- FK_tb_lms_std_score
		FOREIGN KEY (
			STD_NO -- 수강생 번호
		)
		REFERENCES tb_lms_std ( -- (강의) 수강생
			STD_NO -- 수강생 번호
		);

-- (성적) 수강생 아이템별 성적
ALTER TABLE tb_lms_std_score_item
	ADD CONSTRAINT FK_tb_lms_std_score_item -- FK_tb_lms_std_score_item
		FOREIGN KEY (
			STD_NO -- 수강생 번호
		)
		REFERENCES tb_lms_std ( -- (강의) 수강생
			STD_NO -- 수강생 번호
		);

-- (팀구성) 팀 멤버
ALTER TABLE tb_lms_team_member
	ADD CONSTRAINT FK_tb_lms_team_member -- FK_tb_lms_team_member
		FOREIGN KEY (
			TEAM_CD -- 팀 코드
		)
		REFERENCES tb_lms_team ( -- (팀구성) 팀 정보
			TEAM_CD -- 팀 코드
		);

-- (과정) 학기 주차 일정
ALTER TABLE tb_lms_term_lesson
	ADD CONSTRAINT FK_tb_lms_term_lesson -- FK_tb_lms_term_lesson
		FOREIGN KEY (
			TERM_CD -- 학기 코드
		)
		REFERENCES tb_lms_term ( -- (과정) 학기
			TERM_CD -- 학기 코드
		);

-- (로그) 강의실 활동 이력
ALTER TABLE tb_log_lesson_actn_hsty
	ADD CONSTRAINT FK_tb_log_lesson_actn_hsty -- FK_tb_log_lesson_actn_hsty
		FOREIGN KEY (
			USER_ID -- 사용자 번호
		)
		REFERENCES tb_home_user_info ( -- (회원정보) 사용자 정보
			USER_ID -- 사용자 번호
		);

-- (기관) 권한 그룹 언어
ALTER TABLE tb_org_auth_grp_lang
	ADD CONSTRAINT FK_tb_org_auth_grp_lang -- FK_tb_org_auth_grp_lang
		FOREIGN KEY (
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_TYPE,   -- 메뉴 유형
			ORG_ID       -- 기관 코드
		)
		REFERENCES tb_org_auth_grp ( -- (기관) 권한 그룹
			AUTH_GRP_CD, -- 권한 그룹 코드
			MENU_TYPE,   -- 메뉴 유형
			ORG_ID       -- 기관 코드
		);

-- (기관) 기관 설정
ALTER TABLE tb_org_cfg
	ADD CONSTRAINT FK_tb_org_cfg -- FK_tb_org_cfg
		FOREIGN KEY (
			ORG_ID,      -- 기관 코드
			CFG_CTGR_CD  -- 설정 분류 코드
		)
		REFERENCES tb_org_cfg_ctgr ( -- (기관) 기관 설정 분류
			ORG_ID,      -- 기관 코드
			CFG_CTGR_CD  -- 설정 분류 코드
		);

-- (기관) 기관 설정 분류
ALTER TABLE tb_org_cfg_ctgr
	ADD CONSTRAINT FK_tb_org_cfg_ctgr -- FK_tb_org_cfg_ctgr
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		);

-- (기관) 기관 시스템 코드 분류
ALTER TABLE tb_org_code_ctgr
	ADD CONSTRAINT FK_tb_org_code_ctgr -- FK_tb_org_code_ctgr
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		);

-- (기관) 기관 접속 IP
ALTER TABLE tb_org_conn_ip
	ADD CONSTRAINT FK_tb_org_conn_ip -- FK_tb_org_conn_ip
		FOREIGN KEY (
			ORG_ID -- 기관 코드
		)
		REFERENCES tb_org_org_info ( -- (기관) 기관 정보
			ORG_ID -- 기관 코드
		);

-- (기관) 메시지 템플릿 언어
ALTER TABLE tb_org_msg_tpl_lang
	ADD CONSTRAINT FK_tb_org_msg_tpl_lang -- FK_tb_org_msg_tpl_lang
		FOREIGN KEY (
			MSG_TPL_ID -- 메시지 템플릿 ID
		)
		REFERENCES tb_org_msg_tpl ( -- (기관) 메시지 템플릿
			MSG_TPL_ID -- 메시지 템플릿 ID
		);

-- (시스템) 권한 그룹 메뉴
ALTER TABLE tb_sys_auth_grp_menu
	ADD CONSTRAINT FK_tb_sys_auth_grp_menu2 -- FK_tb_sys_auth_grp_menu2
		FOREIGN KEY (
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD  -- 권한 그룹 코드
		)
		REFERENCES tb_sys_auth_grp ( -- (시스템) 권한 그룹
			MENU_TYPE,   -- 메뉴 유형
			AUTH_GRP_CD  -- 권한 그룹 코드
		);