# forum_score_manage 3단계 확장 분석 요약

## 1. 전체 SQL 개요
- 분석 기준: `docs/forum_score_manage_query_detail.csv`
- 집계 단위: `mapper_xml + sql_id`
- 총 SQL 수: 25
- 고위험 분류 기준: 지정 9개 조건 중 2개 이상 충족

## 2. 복잡도 분포
- 점수 5: 3건 (`listPaging`, `selectForum`, `count`)
- 점수 4: 4건 (`select`, `selectCreCrs`, `listStdScore`, `participateScore`)
- 점수 3: 2건 (`selectProfMemo`, `Team_SQL.list`)
- 점수 2 이하: 16건
- 고위험(2조건 이상): 9건

## 3. 성능 우려 SQL 목록
- HIGH:
  - `ForumJoinUserMapper_SQL.xml::listPaging`
  - `Forum_SQL.xml::selectForum`
  - `Forum_SQL.xml::count`
  - `CreCrsMapper_SQL.xml::select`
  - `CreCrsMapper_SQL.xml::selectCreCrs`
  - `ForumJoinUserMapper_SQL.xml::listStdScore`
  - `ForumJoinUserMapper_SQL.xml::participateScore`
- MEDIUM:
  - `ForumJoinUserMapper_SQL.xml::selectProfMemo`
  - `Team_SQL.xml::list`
  - `ForumJoinUserMapper_SQL.xml::insertStdScore`

## 4. 업무적으로 중요한 SQL 목록
- HIGH:
  - `ForumJoinUserMapper_SQL.xml::listPaging` (평가대상 선정/상태 판정 핵심)
  - `Forum_SQL.xml::selectForum` (권한/기간/통계 복합 규칙)
  - `ForumJoinUserMapper_SQL.xml::participateScore` (참여형 100/0 반영)
  - `ForumJoinUserMapper_SQL.xml::insertStdScore` (점수 저장 핵심)
- MEDIUM:
  - `Forum_SQL.xml::count`, `CreCrsMapper_SQL.xml::select`, `selectCreCrs`, `listStdScore`, `selectProfMemo`, `Team_SQL.xml::list`

## 5. 즉시 점검 필요 항목
1. `insertStdScore`의 `CAST(NULL AS NUMBER)` 점수 반영식 정합성
2. `listPaging`의 다중 상관 서브쿼리 구조 및 주석 처리된 페이징 구문
3. `Forum_SQL.count`가 상세 include(`selectQuery`)를 재사용하는 구조(카운트 비용 과다)
4. Oracle 11g 기준 비호환 문법 혼재 여부(`IFNULL`, `LIMIT`, `ON DUPLICATE KEY UPDATE`)

## 6. 향후 리팩토링 우선순위
1. `listPaging`: 반복 상관서브쿼리 집계 조인화 및 검색 인덱스 전략 정비
2. `selectForum`/`count`: 화면용 상세 계산과 count용 경량 SQL 분리
3. `participateScore`/`listStdScore`: 대량 처리 시 대상 추출/갱신 분리
4. `selectCreCrs`/`selectProfMemo`: 코드/사용자 정보 반복 조회 통합
