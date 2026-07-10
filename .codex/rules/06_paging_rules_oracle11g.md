# 06. Paging Rules (Oracle 11g)

## 원칙
- Controller: `PageInfo`를 직접 파라미터로 받거나 필요한 검색조건을 함께 받는다.
- Service: `ResultDTO<T>`와 `PageInfo` 표준 흐름을 사용한다.
- MyBatis: `CommonSQL.pagePrefix2`, `CommonSQL.pageSuffix2` include 기반으로 페이징한다.
- `pageSuffix2`는 `PaginationInfo`의 `firstRecordIndex`, `lastRecordIndex` getter 값을 사용한다.
- `ListPaging`은 Controller naming rule 기준의 기능명이며, count/list 분리 여부를 강제하지 않는다.
- 기존 `DefaultVO` 기반 list view는 첫 목록 진입 초기값에 `pageIndex/listScale/pageScale`을 사용할 수 있다.

## Controller 표준 예시(요약)
- orgId/langCd 등은 `@CurrentUser UserContext userCtx`에서 얻어 `PageInfo` 또는 검색조건 객체에 set
- service.{controllerMethodName}(pageInfo 또는 searchVO)
- `setResultSuccess()` 세팅

## AJAX Request 규칙
- 신규/리팩터링 목록 AJAX는 `currentPageNo`, `recordCountPerPage`, `pageSize`를 직접 POST 파라미터로 전송한다.
- 목록 view JSP 초기값은 기존 화면 구조에 따라 `DefaultVO`의 `pageIndex/listScale/pageScale` 또는 별도 화면 상수를 사용할 수 있다.
- 검색조건도 `PageInfo` 또는 `PageInfo` subclass property명과 동일한 직접 POST 파라미터로 전송한다.
- 화면 상태 유지가 필요한 경우 `encParams`는 별도 파라미터로 유지할 수 있다.
- `PageInfo` subclass는 VO가 아니므로 VO 전용 `addParams` 복호화/주입 흐름에 의존하지 않는다.
- `PageInfo` subclass에 직접 선언하는 검색조건 필드는 필드 선언 라인에 인라인 `//` 주석을 작성한다.
- `PageInfo` subclass 필드에는 별도 구획 주석을 추가하지 않는다.
- 신규/리팩터링 목록 AJAX에서 페이징/검색조건을 `addParams`에 암호화하여 전달하지 않는다.
- `pageIndex`, `listScale`, `pageScale`은 기존 `DefaultVO` 기반 list view의 초기 화면 상태로 사용할 수 있다.

## Service 표준 흐름(고정)
- `ResultDTO<T> resultDto = new ResultDTO<T>(pageInfo);`
- 총 건수 산출 방식은 기능별로 선택한다.
  - 별도 count query 사용 가능
  - `COUNT(*) OVER()` 사용 가능
- 목록 조회 후 `resultDto.setReturnList(list);`
- `resultDto.getPageInfo().setTotalRecordCount(totalCount);`

## 금지
- 신규/리팩터링에서 deprecated 된 `new PageInfo(vo)` 사용 금지
- 신규/리팩터링에서 deprecated 된 `pageInfo.setTotalRecord(list)` 사용 금지
- AJAX 목록 endpoint 입력명은 `currentPageNo`, `recordCountPerPage`, `pageSize`를 사용한다.
- 신규/리팩터링에서 `firstIndex/lastIndex/pageIndex/listScale/pageScale` 동기화용 helper를 만들지 않는다.
