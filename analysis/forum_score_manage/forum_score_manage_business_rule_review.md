# forum_score_manage 업무 규칙 분석 리뷰

### [listPaging] - 평가 대상자 목록/검색/상태 판별
- 화면 연결 기능: `/forum/forumLect/forumJoinUserList.do`, `/forum/forumLect/listScoreExcel.do`
- 평가 대상 선정 기준: `SBJCT_ID`, `ATNDLC_STSCD='S'`, `AUDITYN='N'`, (SUBS 시 시험 재응시 대상 IN)
- 권한 분기 여부: `searchKey`(leader/member), `searchSort`(evalY/evalN) 분기 존재
- 기간 조건 반영 여부: 지각 판정(`FRST_INQ_DTTM >= DSCS_EDTTM`) 반영
- 삭제/상태값 필터 여부: `DSCS.DELYN='N'`, 게시글/댓글 `DELYN='N'`
- 점수 계산 로직 존재 여부: 점수 표시 및 미평가(`scoreNull`) 분기
- 집계 기준: 사용자별 게시글/댓글/상호평가 카운트 및 평균
- 업무상 중요한 조건: 팀 리더/멤버 판별, 검색/정렬/평가상태 필터
- 규칙 누락 가능성: 페이징 LIMIT 주석 처리 상태, `forumCtgrCd` 분기별 정렬 정책 혼재
- 업무 리스크 등급: HIGH

### [selectForum] - 토론 단건 상세/권한/통계 로드
- 화면 연결 기능: `scoreManage`, `forumView`, `forumChartView`
- 평가 대상 선정 기준: 토론 단건(`DSCS_ID=forumCd`)
- 권한 분기 여부: `writeAuth` 계산식 내 기간 + `AUDITYN` 기반 분기
- 기간 조건 반영 여부: `DSCS_SDTTM/DSCS_EDTTM` 기준 참여 가능 시점 반영
- 삭제/상태값 필터 여부: 서브쿼리 다수에서 `DELYN='N'` 반영
- 점수 계산 로직 존재 여부: 개인점수/집계점수 직접 계산은 일부 서브쿼리에서 조회
- 집계 기준: 게시글/댓글 수, 참여자 수, 점수/상호평가 연계
- 업무상 중요한 조건: SUBS 유형의 시험 연계(IN + EXISTS)
- 규칙 누락 가능성: 권한/통계/연계 정보가 단일 SQL에 과밀
- 업무 리스크 등급: HIGH

### [count (Forum_SQL)] - 토론 목록 총건수 산출
- 화면 연결 기능: `/forum/forumLect/Form/forumList.do`
- 평가 대상 선정 기준: `selectQuery` 결과 중 `absent='Y'`
- 권한 분기 여부: `searchKeyNm`(STUDENT 여부) 분기
- 기간 조건 반영 여부: `forumStartDttm~forumEndDttm` 조건 입력 시 반영
- 삭제/상태값 필터 여부: `A.DELYN='N'`
- 점수 계산 로직 존재 여부: 없음(건수 산출)
- 집계 기준: include 결과행 COUNT
- 업무상 중요한 조건: `absent` 계산식
- 규칙 누락 가능성: COUNT인데 상세 계산 로직을 동일 사용
- 업무 리스크 등급: MEDIUM

### [select (CreCrsMapper)] - 강의실/개설과목 기본 컨텍스트 조회
- 화면 연결 기능: `/forum/forumLect/Form/scoreManage.do`
- 평가 대상 선정 기준: `SBJCT_OFRNG_ID`, `DELYN='N'` 중심
- 권한 분기 여부: 명시적 권한 분기 없음
- 기간 조건 반영 여부: 해당 없음
- 삭제/상태값 필터 여부: `DELYN`, `USEYN`, 인증상태 등 동적 필터
- 점수 계산 로직 존재 여부: 없음
- 집계 기준: 없음(단건/조건조회)
- 업무상 중요한 조건: 다수 검색 파라미터 조합
- 규칙 누락 가능성: `searchValue` 조건 내 참조 객체(`USR`, `D`) 정합성 확인 필요
- 업무 리스크 등급: MEDIUM

### [selectCreCrs] - 토론 수정 팝업용 과목 상세
- 화면 연결 기능: `/forum/forumLect/Form/editForumForm.do`
- 평가 대상 선정 기준: `SBJCT_ID=crsCreCd`
- 권한 분기 여부: 없음
- 기간 조건 반영 여부: 없음
- 삭제/상태값 필터 여부: 일부 서브쿼리에 `USEYN='Y'`
- 점수 계산 로직 존재 여부: 없음
- 집계 기준: 수강생수/코드명 파생 조회
- 업무상 중요한 조건: 과목 메타(학기/학과/이수구분) 제공
- 규칙 누락 가능성: ORG_ID 상수값(`ORG0000001`) 하드코딩 의존
- 업무 리스크 등급: MEDIUM

### [listStdScore] - 일괄 점수저장 대상자 사전선별
- 화면 연결 기능: `/forum/forumLect/updateForumJoinUserScore.do`
- 평가 대상 선정 기준: `conditionType` (`checked`/`joinY`/`joinN`) + `stdNo`
- 권한 분기 여부: 없음
- 기간 조건 반영 여부: 없음
- 삭제/상태값 필터 여부: 게시글/댓글 `DELYN='N'`, 수강상태 `ATNDLC_STSCD='S'`
- 점수 계산 로직 존재 여부: 기존 `SCR` 조회
- 집계 기준: 게시글/댓글 수 카운트
- 업무상 중요한 조건: `stdNoList` 기반 대량 대상 지정
- 규칙 누락 가능성: 참여 판정이 게시글/댓글 존재 유무에만 의존
- 업무 리스크 등급: MEDIUM

### [participateScore] - 참여형 100/0점 일괄 반영
- 화면 연결 기능: `/forum/forumLect/Form/scoreManage.do` (참여형 버튼)
- 평가 대상 선정 기준: `DSCS_ID`, `searchMenu=ONCE` 시 미평가만, `searchKey`로 JOIN/NOTJOIN
- 권한 분기 여부: `searchKey` 분기
- 기간 조건 반영 여부: 없음
- 삭제/상태값 필터 여부: 게시글/댓글 `DELYN='N'`
- 점수 계산 로직 존재 여부: 있음(참여시 100, 미참여시 0)
- 집계 기준: 게시글 수(`atclCnt`) 기준
- 업무상 중요한 조건: ON DUPLICATE KEY UPDATE로 즉시 반영
- 규칙 누락 가능성: 댓글만 참여한 학습자 처리 정책 확인 필요(`searchKey`가 atclCnt 중심)
- 업무 리스크 등급: HIGH

### [selectProfMemo] - 교수메모/피드백 팝업 상단 정보
- 화면 연결 기능: `/forum/forumLect/forumFdbkPop.do`, `/forum/forumLect/forumProfMemoPop.do`
- 평가 대상 선정 기준: `DSCS_ID`, `STD_ID`
- 권한 분기 여부: 없음
- 기간 조건 반영 여부: 없음
- 삭제/상태값 필터 여부: 명시적 `DELYN` 필터 없음(조인 토론 테이블)
- 점수 계산 로직 존재 여부: 없음
- 집계 기준: 없음
- 업무상 중요한 조건: 학습자 식별/소속/점수/메모 동시 표시
- 규칙 누락 가능성: 삭제/비활성 사용자 처리 규칙 확인 필요
- 업무 리스크 등급: MEDIUM

### [list (Team_SQL)] - 팀 선택 드롭다운용 팀 목록
- 화면 연결 기능: `/forum/forumLect/teamSelectList.do`
- 평가 대상 선정 기준: `teamCd`, `teamCtgrCd`, `teamNm`
- 권한 분기 여부: 없음
- 기간 조건 반영 여부: 없음
- 삭제/상태값 필터 여부: 명시적 `DELYN` 필터 없음
- 점수 계산 로직 존재 여부: 없음
- 집계 기준: 팀원수/팀장명
- 업무상 중요한 조건: 팀 카테고리-팀 매핑 정확성
- 규칙 누락 가능성: 테이블/컬럼 네이밍(`LRN_GRP_ID`, `LDRYN`) 정합성 확인 필요
- 업무 리스크 등급: MEDIUM

### [insertStdScore] - 학습자 점수 UPSERT
- 화면 연결 기능: `/forum/forumLect/updateForumJoinUserScore.do`, `/forum/forumLect/setScoreRatio.do` 경유
- 평가 대상 선정 기준: `STD_ID + DSCS_ID`
- 권한 분기 여부: `stdNo` 존재 시 직접, 없으면 `FN_GET_STD_NO`
- 기간 조건 반영 여부: 없음
- 삭제/상태값 필터 여부: 신규 INSERT 시 `DELYN='N'`
- 점수 계산 로직 존재 여부: 있음(0~100 보정 의도)
- 집계 기준: 없음
- 업무상 중요한 조건: 평가여부 `EVLYN='Y'` 갱신
- 규칙 누락 가능성: 현재 SQL은 `CAST(NULL AS NUMBER)` 기반으로 점수값 반영식 검증 필요
- 업무 리스크 등급: HIGH
