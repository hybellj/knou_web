# forum_score_manage 성능 분석 리뷰

### [listPaging]
- 유형: SELECT
- 주요 테이블: `TB_LMS_ATNDLC_SBJCT`, `TB_LMS_DSCS`, `TB_LMS_USR`, `TB_LMS_DSCS_PTCP` + 다수 참조 테이블(`TB_LMS_DSCS_ATCL`, `TB_LMS_DSCS_CMNT`, `TB_LMS_DSCS_FDBK`, `TB_LMS_TEAM*`, `TB_LMS_DSCS_MTL_EVL`)
- 조인 방식: 메인 JOIN + 다수 상관 스칼라 서브쿼리
- 서브쿼리 구조: 사용자별 카운트/최근 피드백/팀정보/평가정보 다중 상관 서브쿼리
- 페이징 방식: `ROW_NUMBER() OVER(...)` 생성 후 외부 정렬, `LIMIT` 구문은 주석 처리
- 인덱스 활용 가능성: `DSCS_ID`, `STD_ID`, `USER_ID`, `SBJCT_ID` 중심으로 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: `LOWER(column) LIKE FN_LIKE_VAL(...)`로 검색 컬럼 인덱스 활용 저하 가능
- Full Scan 가능성: 높음(서브쿼리 반복 + 함수 검색)
- 실행계획 불안정 요인: 동적 조건 다수, 조건 조합별 Cardinality 변동
- 개선 여지: 반복 스칼라 서브쿼리 집계 조인화, 검색 컬럼 함수 제거/함수기반 인덱스 검토, 페이징 구문 일관화
- 성능 리스크 등급: HIGH

### [selectForum]
- 유형: SELECT
- 주요 테이블: `TB_LMS_DSCS` + 다수 참조(`TB_LMS_DSCS_ATCL/CMNT/PTCP`, `TB_LMS_ATNDLC_SBJCT`, `TB_LMS_EXAM_*`, `MTL_EVL`, `TB_LMS_MUT_EVAL_RLTN`)
- 조인 방식: 단일 메인 테이블 + 다수 상관 서브쿼리
- 서브쿼리 구조: 카운트/코드명/권한/시험연계/상호평가 연계 다중 조회
- 페이징 방식: 없음
- 인덱스 활용 가능성: `DSCS_ID` 단건 필터로 기본 접근 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: `TO_DATE(A.DSCS_SDTTM/EDTTM, ...)` 연산 사용
- Full Scan 가능성: 중간(메인 단건이더라도 내부 서브쿼리 대상 테이블 스캔 가능)
- 실행계획 불안정 요인: 서브쿼리 다수, EXISTS/IN/CASE 결합
- 개선 여지: 코드성/집계성 서브쿼리 사전 조인 또는 캐시성 조회 분리
- 성능 리스크 등급: HIGH

### [count (Forum_SQL)]
- 유형: SELECT
- 주요 테이블: `TB_LMS_DSCS` (`selectQuery` include 기반)
- 조인 방식: include 내부 조건/서브쿼리에 의존
- 서브쿼리 구조: include 내부에 다수 상관 서브쿼리 포함
- 페이징 방식: 없음
- 인덱스 활용 가능성: `SBJCT_ID`, `DELYN` 필터는 활용 여지 있음(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: `LOWER(...)`, `TO_DATE(...)` 사용
- Full Scan 가능성: 높음
- 실행계획 불안정 요인: count 목적 대비 과도한 계산 포함
- 개선 여지: COUNT 전용 경량 SQL 분리
- 성능 리스크 등급: HIGH

### [select (CreCrsMapper)]
- 유형: SELECT
- 주요 테이블: `TB_LMS_SBJCT_OFRNG`, `TB_LMS_SBJCT_ADM`, `TB_LMS_USER` + 선택적 서브쿼리 테이블
- 조인 방식: LEFT JOIN + 동적 조건 다수
- 서브쿼리 구조: 조건별 스칼라 서브쿼리 포함
- 페이징 방식: 없음
- 인덱스 활용 가능성: `SBJCT_OFRNG_ID`, `SBJCT_ID`, `DEPT_ID`, `UNIV_GBNCD` 필터 활용 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: `LOWER(...) LIKE FN_LIKE_VAL(...)`
- Full Scan 가능성: 중간~높음(검색어 사용 시)
- 실행계획 불안정 요인: 동적 조건 5개 이상
- 개선 여지: 검색 컬럼 함수 최적화, 조건별 SQL 분리
- 성능 리스크 등급: HIGH

### [selectCreCrs]
- 유형: SELECT
- 주요 테이블: `TB_LMS_SBJCT`, `TB_LMS_TERM_CRE_CRS_RLTN` + 코드/부서/카운트 참조 테이블
- 조인 방식: 메인 단건 + 다수 스칼라 서브쿼리
- 서브쿼리 구조: 코드명/부서명/교수/수강생수 등 다중
- 페이징 방식: 없음
- 인덱스 활용 가능성: `SBJCT_ID` 중심 접근 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: 명시적 WHERE 함수 적용은 제한적
- Full Scan 가능성: 중간(서브쿼리 대상 테이블)
- 실행계획 불안정 요인: 다수 서브쿼리 반복
- 개선 여지: 반복 코드조회 조인화
- 성능 리스크 등급: HIGH

### [listStdScore]
- 유형: SELECT
- 주요 테이블: `TB_LMS_ATNDLC_SBJCT`, `TB_LMS_DSCS_PTCP`, `TB_LMS_DSCS_ATCL`, `TB_LMS_DSCS_CMNT`
- 조인 방식: LEFT JOIN + 상관 카운트 서브쿼리
- 서브쿼리 구조: 참여/댓글 카운트 2개 상관 서브쿼리
- 페이징 방식: 없음
- 인덱스 활용 가능성: `SBJCT_ID`, `STD_ID`, `DSCS_ID` 중심 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: 두드러진 WHERE 함수 적용은 없음
- Full Scan 가능성: 중간(대량 `stdNoList` IN)
- 실행계획 불안정 요인: `conditionType` 분기 + foreach IN 길이 변동
- 개선 여지: 집계 사전 조인화, IN 리스트 대체(임시테이블/배치)
- 성능 리스크 등급: HIGH

### [participateScore]
- 유형: INSERT
- 주요 테이블: `TB_LMS_DSCS_PTCP`, `TB_LMS_DSCS_ATCL`, `TB_LMS_DSCS_CMNT`
- 조인 방식: INSERT-SELECT + 상관 카운트 서브쿼리
- 서브쿼리 구조: 대상 행별 게시글/댓글 카운트
- 페이징 방식: 없음
- 인덱스 활용 가능성: `DSCS_ID`, `STD_ID` 중심 필요(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: WHERE 함수 적용은 제한적
- Full Scan 가능성: 중간~높음(대상 토론 참여자 전체 처리)
- 실행계획 불안정 요인: `searchMenu`, `searchKey` 분기
- 개선 여지: 대상군 추출/갱신 분리, 대량 처리 시 배치화
- 성능 리스크 등급: HIGH

### [selectProfMemo]
- 유형: SELECT
- 주요 테이블: `TB_LMS_DSCS_PTCP`, `TB_LMS_DSCS`, `TB_LMS_ATNDLC_SBJCT`, `TB_LMS_USR`, `TB_LMS_USER_ACNT`
- 조인 방식: LEFT JOIN + 사용자정보 상관 서브쿼리
- 서브쿼리 구조: dept/user/userNm 조회 서브쿼리 반복
- 페이징 방식: 없음
- 인덱스 활용 가능성: `DSCS_ID`, `STD_ID` 접근 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: `NVL(A.SCR,0)`은 SELECT 절로 제한
- Full Scan 가능성: 낮음~중간
- 실행계획 불안정 요인: 상대적으로 낮음
- 개선 여지: 사용자 정보 조인으로 통합
- 성능 리스크 등급: MEDIUM

### [list (Team_SQL)]
- 유형: SELECT
- 주요 테이블: `TB_LMS_TEAM`, `TB_LMS_TEAM_MBR`, `TB_LMS_USER`
- 조인 방식: 메인 단일 테이블 + 상관 서브쿼리(리더명/인원수)
- 서브쿼리 구조: 2개 상관 서브쿼리
- 페이징 방식: 없음
- 인덱스 활용 가능성: `TEAM_ID`, `LRN_GRP_ID` 가능(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: `LOWER(TEAM.TEAMNM)`
- Full Scan 가능성: 중간(팀명 검색 시)
- 실행계획 불안정 요인: 검색조건 유무
- 개선 여지: 리더/인원수 집계 조인화
- 성능 리스크 등급: MEDIUM

### [insertStdScore]
- 유형: MERGE
- 주요 테이블: `TB_LMS_DSCS_PTCP`, `DUAL`
- 조인 방식: `MERGE ... USING (SELECT ... FROM DUAL)`
- 서브쿼리 구조: 없음(표현식 중심)
- 페이징 방식: 없음
- 인덱스 활용 가능성: `ON (STD_ID, DSCS_ID)` 키 인덱스 필요(인덱스 존재 여부 확인 필요)
- 인덱스 무력화 가능성: WHERE 함수 적용은 없음
- Full Scan 가능성: 키 인덱스 부재 시 가능
- 실행계획 불안정 요인: 낮음
- 개선 여지: `CAST(NULL AS NUMBER)` 사용 구문 점검 필요(값 계산식 검증)
- 성능 리스크 등급: MEDIUM
