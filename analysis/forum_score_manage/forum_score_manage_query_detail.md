# forum_score_manage 쿼리 상세 분석

## 1. 분석 대상 개요
- 총 API 수: 15
- 총 SQL 수: 25
- SELECT / 저장계 비율: SELECT 17 : 저장계 8

## 2. SQL별 상세 분석
### [infoCreCrs] - 팝업용 과목 요약
- 파일: src/main/resources/sqlmap/mappers/crs/crecrs/CreCrsMapper_SQL.xml
- 호출 URL: /forum/forumLect/forumFdbkPop.do
- Controller: forumFeedBack
- 유형: SELECT
- 목적: 팝업용 과목 요약
- 주요 테이블: TB_LMS_SBJCT; 
- 입력 파라미터: crsCreCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: DELYN=N;USEYN=Y;SBJCT_ID=crsCreCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: SBJCT_ID;CRS_ID;SBJCTNM;DVCLAS_NO
- 업무 의미: 피드백/메모 팝업 헤더
- 리스크: 리스크 낮음
- 비고: dependent=, action=fdbkList,stdMemoForm, confidence=HIGH

### [select] - 강의실 기본정보
- 파일: src/main/resources/sqlmap/mappers/crs/crecrs/CreCrsMapper_SQL.xml
- 호출 URL: /forum/forumLect/Form/scoreManage.do
- Controller: scoreManage
- 유형: SELECT
- 목적: 강의실 기본정보
- 주요 테이블: TB_LMS_SBJCT_OFRNG; TB_LMS_SBJCT_ADM;TB_LMS_USER
- 입력 파라미터: orgId;sbjctOfrngId;crsCreCd;creYear;creTerm;deptId;useYn;univGbn;crsTypeCd;searchValue
- 동적 조건: if 다수 + foreach crsTypeCdList
- 조인 구조: A 기준 LEFT JOIN
- 필터 조건: DELYN=N + 동적 조건
- 정렬/페이징: 정렬=listQuery choose 정렬, 페이징=없음
- 결과: 개설과목 기본 컬럼
- 업무 의미: scoreManage의 creCrsVO 로드
- 리스크: 조건 많아 실행계획 편차
- 비고: dependent=FN_LIKE_VAL;ROWNUM, action=scoreManage, confidence=MEDIUM

### [selectCreCrs] - 개설과목 상세정보
- 파일: src/main/resources/sqlmap/mappers/crs/crecrs/CreCrsMapper_SQL.xml
- 호출 URL: /forum/forumLect/Form/editForumForm.do
- Controller: editForumForm
- 유형: SELECT
- 목적: 개설과목 상세정보
- 주요 테이블: TB_LMS_SBJCT; TB_LMS_TERM_CRE_CRS_RLTN
- 입력 파라미터: crsCreCd
- 동적 조건: 없음
- 조인 구조: A.SBJCT_ID=B.SBJCT_ID LEFT JOIN
- 필터 조건: DELYN=N;USEYN=Y;SBJCT_ID=crsCreCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: 과목/학기/교수/수강생수
- 업무 의미: 수정폼 메타 표시
- 리스크: ORG_ID 하드코딩 존재
- 비고: dependent=CASE;NVL, action=editForum, confidence=HIGH

### [count] - 토론 목록 건수
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/Form/forumList.do
- Controller: forumListForm
- 유형: SELECT
- 목적: 토론 목록 건수
- 주요 테이블: TB_LMS_DSCS; include selectQuery 내부 다수 객체
- 입력 파라미터: ForumVO 검색 파라미터
- 동적 조건: selectQuery 내부 동적조건
- 조인 구조: include selectQuery 의존
- 필터 조건: absent=Y
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: totalCnt
- 업무 의미: 목록 총건수
- 리스크: 복잡한 include로 count 비용 증가 가능
- 비고: dependent=selectQuery, action=viewForumList, confidence=MEDIUM

### [deleteForum] - 토론 본문 논리삭제
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/Form/delForum.do
- Controller: delForum
- 유형: UPDATE
- 목적: 토론 본문 논리삭제
- 주요 테이블: TB_LMS_DSCS; 
- 입력 파라미터: forumCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: DSCS_ID=forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: DELYN;MOD_DTTM
- 업무 의미: 삭제 본 단계
- 리스크: 리스크 낮음
- 비고: dependent=FN_DTTM, action=delForum, confidence=HIGH

### [deleteForumCreCrsRltn] - 연결정보 논리삭제
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/Form/delForum.do
- Controller: delForum
- 유형: UPDATE
- 목적: 연결정보 논리삭제
- 주요 테이블: TB_LMS_FORUM_CRE_CRS_RLTN; 
- 입력 파라미터: forumCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: DSCS_ID=forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: DELYN
- 업무 의미: 삭제 선행 단계
- 리스크: 리스크 낮음
- 비고: dependent=, action=delForum, confidence=HIGH

### [getScoreRatio] - 성적반영 대상 토론 목록
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/Form/delForum.do
- Controller: delForum
- 유형: SELECT
- 목적: 성적반영 대상 토론 목록
- 주요 테이블: TB_LMS_DSCS; 
- 입력 파라미터: crsCreCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: DELYN=N;MRK_RFLTYN=Y;SBJCT_ID=crsCreCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: forumCd
- 업무 의미: 비율 재계산 대상 추출
- 리스크: 후속 update 반복 호출 가능
- 비고: dependent=, action=delForum, confidence=HIGH

### [selectForum] - 토론 상세/통계/권한 조회
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/forumChartViewPop.do
- Controller: forumChartViewPop
- 유형: SELECT
- 목적: 토론 상세/통계/권한 조회
- 주요 테이블: TB_LMS_DSCS; TB_LMS_TEAM_CTGR;TB_LMS_ATNDLC_SBJCT;TB_LMS_DSCS_ATCL;TB_LMS_DSCS_CMNT;MTL_EVL
- 입력 파라미터: forumCd;crsCreCd;userId
- 동적 조건: 없음
- 조인 구조: DSCS 단건 + 상관서브쿼리 다수
- 필터 조건: DSCS_ID=forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: forumTitle;scoreRatio;forumJoinUserCnt;writeAuth
- 업무 의미: 화면 공통 상세 원천
- 리스크: 상관서브쿼리 과다
- 비고: dependent=NVL;TO_DATE;SYSDATE, action=scoreManage,forumView,forumChartView, confidence=HIGH

### [selectScoreChart] - 점수 통계 조회
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/viewScoreChart.do
- Controller: viewScoreChart
- 유형: SELECT
- 목적: 점수 통계 조회
- 주요 테이블: TB_LMS_DSCS_PTCP; 
- 입력 파라미터: forumCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: DSCS_ID=forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: minScore;maxScore;avgScore
- 업무 의미: 차트 통계
- 리스크: 현재 JSP 함수 주석으로 미사용 가능
- 비고: dependent=ROUND;AVG, action=scoreChartSet, confidence=MEDIUM

### [setScoreRatio] - 성적반영비율 갱신
- 파일: src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml
- 호출 URL: /forum/forumLect/Form/delForum.do
- Controller: delForum
- 유형: UPDATE
- 목적: 성적반영비율 갱신
- 주요 테이블: TB_LMS_DSCS; 
- 입력 파라미터: scoreRatio;forumCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: DSCS_ID=forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: MRK_RFLTRT
- 업무 의미: 재산정 비율 반영
- 리스크: 계산 로직은 서비스 의존
- 비고: dependent=, action=delForum, confidence=HIGH

### [insertFdbk] - 피드백 본문 저장
- 파일: src/main/resources/sqlmap/mappers/forum/ForumFdbkMapper_SQL.xml
- 호출 URL: /forum/forumLect/Form/regFdbk.do
- Controller: regFdbk
- 유형: INSERT
- 목적: 피드백 본문 저장
- 주요 테이블: TB_LMS_DSCS_FDBK; 
- 입력 파라미터: forumFdbkCd;forumCd;stdNo;parForumFdbkCd;teamCd;fdbkCts;userId
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: forumCd/stdNo
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: DSCS_FDBK_ID;DSCS_ID;STD_ID;FDBK_CTS
- 업무 의미: 피드백 저장
- 리스크: stdNo 파라미터명 매핑 확인 필요
- 비고: dependent=FN_GET_USER_NM;FN_DTTM, action=submitFdbk, confidence=MEDIUM

### [forumJoinUserList] - 차트용 점수 목록 조회
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/forumChartViewPop.do
- Controller: forumChartViewPop
- 유형: SELECT
- 목적: 차트용 점수 목록 조회
- 주요 테이블: TB_LMS_DSCS_PTCP; TB_LMS_ATNDLC_SBJCT
- 입력 파라미터: forumCd
- 동적 조건: 없음
- 조인 구조: U.STD_ID=S.STD_ID
- 필터 조건: DSCS_ID=forumCd and 수강상태 S
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: stdNo;SCR;evalYn
- 업무 의미: 차트 통계 계산 입력
- 리스크: 앱단 추가 집계 필요
- 비고: dependent=IFNULL, action=forumChartView, confidence=HIGH

### [getForumJoinUser] - 참여자 행 존재 여부 확인
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/forumFdbkPop.do
- Controller: forumFeedBack
- 유형: SELECT
- 목적: 참여자 행 존재 여부 확인
- 주요 테이블: TB_LMS_DSCS_PTCP; 
- 입력 파라미터: stdNo;forumCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: STD_ID=stdNo and DSCS_ID=forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: count
- 업무 의미: 팝업 선등록 판단
- 리스크: 리스크 낮음
- 비고: dependent=COUNT, action=fdbkList, confidence=HIGH

### [getSelectCtsLen] - 글자수 조건 충족 여부
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/updateForumJoinUserLenScore.do
- Controller: updateForumJoinUserLenScore
- 유형: SELECT
- 목적: 글자수 조건 충족 여부
- 주요 테이블: TB_LMS_DSCS_PTCP; TB_LMS_DSCS_ATCL;TB_LMS_DSCS_CMNT
- 입력 파라미터: forumCd;stdNo;ctsLen;chkCmnt
- 동적 조건: if chkCmnt==Y
- 조인 구조: A-B/A-C를 DSCS_ID+STD_ID로 연결
- 필터 조건: forumCd/stdNo + 글자수 조건
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: count
- 업무 의미: 글자수 기반 점수부여 대상 판정
- 리스크: OR 조건 시 인덱스 효율 저하 가능
- 비고: dependent=COUNT, action=lenScore, confidence=HIGH

### [insertJoinUser] - 참여자 일괄 생성/동기화
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/ezgPop/ezgMainForm.do
- Controller: getEzgMainView
- 유형: INSERT
- 목적: 참여자 일괄 생성/동기화
- 주요 테이블: TB_LMS_DSCS_PTCP; TB_LMS_ATNDLC_SBJCT;TB_LMS_DSCS;TB_LMS_TEAM_CTGR;TB_LMS_TEAM;TB_LMS_TEAM_MBR
- 입력 파라미터: crsCreCd;forumCd;rgtrId;searchKey;stdNo
- 동적 조건: if searchKey==INSERT; if stdNo
- 조인 구조: 수강생과 토론/팀 매핑
- 필터 조건: 수강상태 S;DSCS DELYN N;forumCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: STD_ID;DSCS_ID;TEAM_ID;SCR
- 업무 의미: 평가 전 참여자 준비
- 리스크: Oracle 기준 ON DUPLICATE KEY 비호환 가능
- 비고: dependent=FN_DTTM, action=ezGraderPop, confidence=MEDIUM

### [insertStdScore] - 점수 업서트
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/updateForumJoinUserScore.do
- Controller: updateForumJoinUserScore
- 유형: MERGE
- 목적: 점수 업서트
- 주요 테이블: TB_LMS_DSCS_PTCP; DUAL
- 입력 파라미터: stdNo;userId;crsCreCd;forumCd;teamCd;rgtrId;mdfrId;SCR
- 동적 조건: choose stdNo/FN_GET_STD_NO
- 조인 구조: MERGE ON STD_ID+DSCS_ID
- 필터 조건: 키일치 시 update;없으면 insert
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: SCR;TEAM_ID;EVLYN
- 업무 의미: 점수저장 핵심
- 리스크: CASE에서 CAST(NULL AS NUMBER) 형태 확인 필요
- 비고: dependent=FN_GET_STD_NO;FN_DTTM, action=submitScore, confidence=LOW

### [listPaging] - 참여자 목록/검색/상태 조회
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/forumJoinUserList.do
- Controller: forumJoinUserList
- 유형: SELECT
- 목적: 참여자 목록/검색/상태 조회
- 주요 테이블: TB_LMS_ATNDLC_SBJCT; TB_LMS_DSCS;TB_LMS_USR;TB_LMS_DSCS_PTCP;TB_LMS_DSCS_ATCL;TB_LMS_DSCS_CMNT;TB_LMS_DSCS_FDBK
- 입력 파라미터: forumCd;crsCreCd;forumCtgrCd;searchKey;searchSort;searchValue;userId
- 동적 조건: if forumCtgrCd/searchKey/searchSort/searchValue
- 조인 구조: A.USER_ID=U.USER_ID + 다수 상관서브쿼리
- 필터 조건: 수강상태 S;AUDITYN N;forumCd 고정;동적 검색
- 정렬/페이징: 정렬=ROW_NUMBER;ORDER BY lineNo, 페이징=LIMIT 주석 처리(확인 필요)
- 결과: lineNo;stdNo;userId;userNm;SCR;joinStatus
- 업무 의미: 화면 목록/검색/정렬의 핵심 데이터
- 리스크: 상관서브쿼리 과다;IFNULL/LIMIT 혼용
- 비고: dependent=FN_LIKE_VAL;IFNULL;ROW_NUMBER, action=listForumUser, confidence=HIGH

### [listStdScore] - 점수반영 전 기준점수 조회
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/updateForumJoinUserScore.do
- Controller: updateForumJoinUserScore
- 유형: SELECT
- 목적: 점수반영 전 기준점수 조회
- 주요 테이블: TB_LMS_ATNDLC_SBJCT; TB_LMS_DSCS_PTCP
- 입력 파라미터: forumCd;crsCreCd;conditionType;stdNoList;stdNo
- 동적 조건: if conditionType checked/joinY/joinN; if stdNo
- 조인 구조: A.STD_ID=C.STD_ID and C.DSCS_ID=forumCd
- 필터 조건: 과정/수강상태 필터 + 대상군 필터
- 정렬/페이징: 정렬=ROW_NUMBER, 페이징=없음
- 결과: stdNo;SCR;joinStatus;atclCnt;cmntCnt
- 업무 의미: 일괄 점수저장 대상 선정
- 리스크: foreach IN 대량 시 성능 저하
- 비고: dependent=ROW_NUMBER;IFNULL, action=submitScore, confidence=HIGH

### [participateScore] - 참여형 일괄평가 점수 반영
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/Form/scoreManage.do
- Controller: scoreManage
- 유형: INSERT
- 목적: 참여형 일괄평가 점수 반영
- 주요 테이블: TB_LMS_DSCS_PTCP; TB_LMS_DSCS_ATCL;TB_LMS_DSCS_CMNT
- 입력 파라미터: forumCd;rgtrId;searchMenu;searchKey
- 동적 조건: if searchMenu==ONCE; choose searchKey
- 조인 구조: 대상 T 서브쿼리 upsert
- 필터 조건: forumCd;atclCnt 기준 join/notjoin
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: STD_ID;DSCS_ID;SCR;EVLYN
- 업무 의미: 참여형 버튼 핵심 처리
- 리스크: DB 방언 의존성 높음
- 비고: dependent=FN_DTTM, action=partiScore, confidence=HIGH

### [selectProfMemo] - 교수메모 팝업 상세
- 파일: src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml
- 호출 URL: /forum/forumLect/forumFdbkPop.do
- Controller: forumFeedBack
- 유형: SELECT
- 목적: 교수메모 팝업 상세
- 주요 테이블: TB_LMS_DSCS_PTCP; TB_LMS_DSCS
- 입력 파라미터: forumCd;stdNo
- 동적 조건: 없음
- 조인 구조: A.DSCS_ID=B.DSCS_ID LEFT JOIN + 학습자 서브쿼리
- 필터 조건: forumCd/stdNo
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: deptNm;userId;userNm;SCR;profMemo
- 업무 의미: 팝업 상세 표시
- 리스크: 학습자 정보 서브쿼리 반복
- 비고: dependent=NVL, action=fdbkList,stdMemoForm, confidence=HIGH

### [list] - 첨부파일 목록 조회
- 파일: src/main/resources/sqlmap/mappers/system/SysFileMapper_SQL.xml
- 호출 URL: /forum/forumLect/Form/editForumForm.do
- Controller: editForumForm
- 유형: SELECT
- 목적: 첨부파일 목록 조회
- 주요 테이블: TB_LMS_ATFL; TB_LMS_ATFL_REPO
- 입력 파라미터: repoCd;fileBindDataSn;fileNm;fileExt;fileSnList
- 동적 조건: if repoCd ASMNT 분기; if fileBindDataSn/fileNm/fileExt/fileSnList
- 조인 구조: A.ATFL_REPO_ID=B.ATFL_REPO_ID
- 필터 조건: repo/fileBindDataSn 중심
- 정렬/페이징: 정렬=ORDER BY A.FILE_ID, 페이징=listPageing 별도 존재
- 결과: fileSn;fileNm;fileSaveNm;filePath
- 업무 의미: 수정폼 첨부 목록
- 리스크: 대량 fileSnList IN 성능 주의
- 비고: dependent=listQuery;selectQuery, action=editForum, confidence=HIGH

### [select] - 다운로드 파일 메타 조회
- 파일: src/main/resources/sqlmap/mappers/system/SysFileMapper_SQL.xml
- 호출 URL: /common/fileInfoView.do
- Controller: fileInfoView
- 유형: SELECT
- 목적: 다운로드 파일 메타 조회
- 주요 테이블: TB_LMS_ATFL; TB_LMS_ATFL_REPO
- 입력 파라미터: fileSn;repoCd;userId;parTableNm;parFieldNm;isUsingTable
- 동적 조건: if repoCd; if FILE_BOX; if parFieldNm
- 조인 구조: A.ATFL_REPO_ID=B.ATFL_REPO_ID
- 필터 조건: FILE_ID=fileSn + 저장소 조건
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: filePath;fileSaveNm;fileNm;mime
- 업무 의미: 다운로드 URL 생성
- 리스크: / 동적치환 주의
- 비고: dependent=INSTR;SUBSTR, action=fileDown, confidence=HIGH

### [updateFileLastInqDttm] - 조회수/마지막조회시각 갱신
- 파일: src/main/resources/sqlmap/mappers/system/SysFileMapper_SQL.xml
- 호출 URL: /common/fileInfoView.do
- Controller: fileInfoView
- 유형: UPDATE
- 목적: 조회수/마지막조회시각 갱신
- 주요 테이블: TB_LMS_ATFL; 
- 입력 파라미터: fileSn
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: FILE_ID=fileSn
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: INQ_CNT;LST_INQ_DTTM
- 업무 의미: 다운로드 접근 이력
- 리스크: 핫파일 row lock 가능성
- 비고: dependent=FN_DTTM, action=fileDown, confidence=HIGH

### [list] - 팀 목록 조회
- 파일: src/main/resources/sqlmap/mappers/team/Team_SQL.xml
- 호출 URL: /forum/forumLect/teamSelectList.do
- Controller: teamSelectList
- 유형: SELECT
- 목적: 팀 목록 조회
- 주요 테이블: TB_LMS_TEAM; TB_LMS_TEAM_MBR(서브쿼리);TB_LMS_USER(서브쿼리)
- 입력 파라미터: teamCd;teamCtgrCd;teamNm
- 동적 조건: if teamCd/teamCtgrCd/teamNm
- 조인 구조: 메인 조인 없음; 리더/인원수는 상관서브쿼리
- 필터 조건: teamId/lrn_grp_id/name 조건
- 정렬/페이징: 정렬=ORDER BY TEAM_ID, 페이징=없음
- 결과: teamCd;teamNm;leaderNm;teamMbrCnt
- 업무 의미: 팀 선택조건 구성
- 리스크: loadSelectDiv 호출 주석 상태
- 비고: dependent=ROW_NUMBER;NVL, action=loadSelectDiv, confidence=MEDIUM

### [teamList] - 팀 분류 내 팀 목록
- 파일: src/main/resources/sqlmap/mappers/team/TeamCtgr_SQL.xml
- 호출 URL: /forum/forumLect/teamMemberList.do
- Controller: teamMemberList
- 유형: SELECT
- 목적: 팀 분류 내 팀 목록
- 주요 테이블: TEAM; 
- 입력 파라미터: teamCtgrCd
- 동적 조건: 없음
- 조인 구조: 없음
- 필터 조건: TEAM_TYCD=teamCtgrCd
- 정렬/페이징: 정렬=없음, 페이징=없음
- 결과: teamCtgrCd;teamCd;teamNm
- 업무 의미: 팀구성원 팝업 팀목록
- 리스크: TEAM 객체(테이블/뷰) 확인 필요
- 비고: dependent=, action=teamMemberView, confidence=MEDIUM

## 3. 중복/유사 SQL 후보
- `ForumJoinUserMapper_SQL.xml:listPaging` vs `ForumJoinUserMapper_SQL.xml:listStdScore`: 둘 다 참여자/점수 조회이며 목적만 다름(목록표시 vs 저장대상 추출).
- `CreCrsMapper_SQL.xml:select` vs `selectCreCrs` vs `infoCreCrs`: 모두 개설과목 조회이며 조회 폭(컬럼수)만 다름.
- `SysFileMapper_SQL.xml:select` vs `list`: 파일 단건/목록 조회로 동일 selectQuery 기반.
- `ForumJoinUserMapper_SQL.xml:insertJoinUser` vs `participateScore`: 모두 참여자 테이블 upsert 성격(SQL 방언 의존).

## 4. 우선 검토 필요 SQL
- `listPaging`: 동적조건 + 상관서브쿼리 다수 + 통계컬럼 동시조회로 복잡도/성능 리스크 최고.
- `selectForum`: 화면 공통 핵심 조회이며 상관서브쿼리 다수로 호출 빈도 대비 비용 큼.
- `insertStdScore`: MERGE 구문 내 SCORE 계산식(`CAST(NULL AS NUMBER)`) 확인 필요.
- `insertJoinUser`: `ON DUPLICATE KEY` 의존으로 Oracle 정합성 확인 필요.
- `participateScore`: `ON DUPLICATE KEY` + 동적 분기(참여/미참여)로 업무영향 큼.

## 5. 후속 추천 작업
- 상세 리팩토링 후보: `listPaging`, `selectForum`의 상관서브쿼리 일부를 JOIN/CTE로 치환해 성능 안정화.
- 테스트 필요 포인트: 점수 저장(`insertStdScore`) 결과값, 참여형 일괄평가(`participateScore`) 점수분기, stdNos/stdIds 바인딩.
- 화면/API/쿼리 불일치 의심: `listExamUser` 콜백명, `loadSelectDiv`/`scoreChartSet` 주석 상태, Oracle-MyBatis 방언 혼용(`IFNULL`, `LIMIT`, `ON DUPLICATE KEY`).
