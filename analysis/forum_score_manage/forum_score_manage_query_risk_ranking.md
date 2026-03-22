# SQL 복잡도 랭킹
- 총 SQL 수: 25 (`forum_score_manage_query_detail.csv` 행 기준)
- 고위험 SQL 수: 9 (고위험 조건 2개 이상 충족)
- 위험도 상위 TOP 5:
  1. `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml::listPaging`
  2. `src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml::selectForum`
  3. `src/main/resources/sqlmap/mappers/forum/Forum_SQL.xml::count` (`selectQuery` 포함)
  4. `src/main/resources/sqlmap/mappers/crs/crecrs/CreCrsMapper_SQL.xml::select`
  5. `src/main/resources/sqlmap/mappers/crs/crecrs/CreCrsMapper_SQL.xml::selectCreCrs`

## 상세 랭킹
### 1) sql_id: listPaging
- 복잡도 점수 (1~5): 5
- 복잡 원인:
  - 서브쿼리 2개 이상(다수 스칼라/집계)
  - 상관 서브쿼리 존재
  - 동적 조건 5개 이상(`forumCtgrCd`, `searchKey`, `searchSort`, `searchValue`, `pagingYn`)
  - 페이징 + 복합 정렬(ROW_NUMBER + 조건부 ORDER BY)
  - WHERE 절 컬럼 함수 적용(`LOWER(deptNm/userId/userNm)`)
- 예상 리스크:
  - 대량 사용자 대상 조회 시 반복 서브쿼리 비용 급증
  - 조건 조합별 실행계획 변동 가능성

### 2) sql_id: selectForum
- 복잡도 점수 (1~5): 5
- 복잡 원인:
  - 서브쿼리 2개 이상(다수 집계/단건 조회)
  - 상관 서브쿼리 존재
  - EXISTS + IN 혼용(`forumJoinUserCnt`, `writeAuth` 관련)
  - WHERE 절 컬럼 함수 적용(`TO_DATE(A.DSCS_SDTTM/EDTTM, ...)`)
- 예상 리스크:
  - 단건 조회라도 서브쿼리 수가 많아 응답시간 편차 가능
  - 토론 상태/권한 계산 로직이 SQL 내 과밀

### 3) sql_id: count (Forum_SQL)
- 복잡도 점수 (1~5): 5
- 복잡 원인:
  - `selectQuery` include 기반으로 서브쿼리 2개 이상
  - 상관 서브쿼리 존재
  - EXISTS + IN 혼용
  - WHERE 절 컬럼 함수 적용(`TO_DATE`, `LOWER`)
- 예상 리스크:
  - 단순 COUNT 요청이 고비용 상세 계산을 같이 수행
  - 목록 진입 시 응답 지연 유발 가능

### 4) sql_id: select (CreCrsMapper)
- 복잡도 점수 (1~5): 4
- 복잡 원인:
  - `selectQuery` include 내부 서브쿼리 2개 이상
  - 상관 서브쿼리 존재
  - 동적 조건 5개 이상
  - WHERE 절 컬럼 함수 적용(`LOWER(...) LIKE FN_LIKE_VAL(...)`)
- 예상 리스크:
  - 파라미터 조합별 플랜 변경 가능성
  - 검색 조건 사용 시 인덱스 활용 저하 가능

### 5) sql_id: selectCreCrs
- 복잡도 점수 (1~5): 4
- 복잡 원인:
  - 서브쿼리 2개 이상(부서명/코드명/인원수 등)
  - 상관 서브쿼리 존재
  - 다중 조회 항목을 단일 SQL에 집중
- 예상 리스크:
  - 수정 화면 초기 로딩 시 지연 발생 가능
  - 코드성 서브쿼리 반복 호출 비용 증가

### 6) sql_id: listStdScore
- 복잡도 점수 (1~5): 4
- 복잡 원인:
  - 서브쿼리 2개 이상
  - 상관 서브쿼리 존재
  - 동적 조건 다수(`conditionType`, `stdNoList`, `stdNo`)
- 예상 리스크:
  - 체크 대상 대량(`IN foreach`) 시 성능 저하
  - 일괄채점 사전조회 지연 가능

### 7) sql_id: participateScore
- 복잡도 점수 (1~5): 4
- 복잡 원인:
  - 서브쿼리 2개 이상
  - 상관 서브쿼리 존재
  - 동적 분기(`searchMenu`, `searchKey`) 존재
- 예상 리스크:
  - 대량 upsert 시 DML 부하/락 경합 가능
  - 참여형 일괄처리 응답시간 편차

### 8) sql_id: selectProfMemo
- 복잡도 점수 (1~5): 3
- 복잡 원인:
  - 서브쿼리 2개 이상
  - 상관 서브쿼리 존재
- 예상 리스크:
  - 팝업 반복 조회 시 불필요한 사용자 정보 재조회

### 9) sql_id: list (Team_SQL)
- 복잡도 점수 (1~5): 3
- 복잡 원인:
  - 서브쿼리 2개 이상
  - 상관 서브쿼리 존재
  - WHERE 절 컬럼 함수 적용(`LOWER(TEAM.TEAMNM)`)
- 예상 리스크:
  - 팀 검색 시 leader/count 서브쿼리 반복 비용
