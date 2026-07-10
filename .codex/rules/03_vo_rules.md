# 03. VO Rules (네이밍 완전 고정)

## 공통 규칙
- 위치: knou.lms.{domain}.vo
- 기존 업무 VO는 `DefaultVO` 상속을 유지할 수 있다.
- 신규 VO는 업무 범위와 기존 화면/공통 필드 의존성을 확인한 뒤 POJO 또는 `DefaultVO` 상속을 선택한다.
- `DefaultVO`가 제공하는 `pageIndex`, `listScale`, `pageScale`, `orgId`, `searchValue`, `excelGrid`, audit/file 계열 필드는 레거시 화면/공통 처리 호환 필드로 인정한다.
- 필드명: lowerCamelCase
- 필드 주석은 `SbjctAdmVO`처럼 필드 선언 라인에 인라인 `//`로 작성한다.
- DB 컬럼 기반 필드는 DB 컬럼 COMMENT 기준으로 작성한다.
- 검색조건, 화면 제어값, 조인 표시명, 가공 표시값처럼 DB 컬럼과 직접 대응하지 않는 필드는 `/* DB와 관계없는 파라미터 */` 구획 아래에 분리하고 인라인 `//` 주석을 작성한다.
- `PageInfo` subclass에 직접 선언하는 검색조건 필드 주석은 `.codex/rules/06_paging_rules_oracle11g.md`를 따른다.

## serialVersionUID 규칙
- `DefaultVO` 또는 `Serializable`을 상속/구현하는 VO만 `serialVersionUID`를 선언한다.
- 신규 POJO VO에는 불필요한 `serialVersionUID`를 추가하지 않는다.

## VO 클래스 네이밍(고정)
VO 이름은 “대상명(Target) + 역할(Role) + VO”로만 만든다.

(1) 검색/요청 VO (목록조건 + 페이징)
- {Target}SearchVO
- 포함: 검색조건 중심
- 신규/리팩터링 페이징은 `PageInfo` 직접 파라미터 사용을 우선한다.
- deprecated 된 `new PageInfo(vo)` 흐름을 위해 paging 필드를 VO에 억지로 추가하지 않는다.
- 기존 `DefaultVO` 기반 list view는 초기 목록 상태에 `pageIndex`, `listScale`, `pageScale`을 사용할 수 있다.
- AJAX 목록 조회는 `PageInfo` 또는 `PageInfo` subclass의 `currentPageNo`, `recordCountPerPage`, `pageSize`를 직접 파라미터로 받을 수 있다.
- 세션필수값(orgId/langCd 등)은 Controller에서 세팅

(2) 목록 Row VO (목록 1건)
- {Target}ListVO
- 포함: 목록 표시 컬럼 + totalCnt (COUNT(*) OVER() 사용 시)

(3) 상세 VO
- {Target}DetailVO

(4) 저장/수정 요청 VO
- {Target}SaveVO
- 등록/수정 파라미터 “저장 전용” 분리 (필드 많을수록 반드시 분리)

(5) 단건 결과 VO (필요 시만)
- {Target}ResultVO
- 일반적으로 `ResultDTO<T>`의 `data`/`returnList`로 충분하면 ResultVO 생성 금지

예외
- 레거시가 ListVO 하나로 검색+row를 같이 쓴다면 신규는 규칙 준수, 레거시는 점진 분리.
