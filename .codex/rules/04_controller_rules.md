# 04. Controller Rules

## 얇고 가벼운 Controller 규칙
- Controller는 HTTP 경계 처리만 담당한다. RequestMapping, 세션 필수값 주입, Validator 호출, Model 구성, View 반환, redirect/response 위임까지만 처리한다.
- 중복 체크, 관계 검증, 저장/수정 가능 여부, DB 기준 존재 여부 확인, 업무 실패 메시지 선택은 Service로 위임한다.
- AJAX handler는 Controller에서 요청/세션 context 값만 보정한 뒤 Service의 `ResultDTO<T>`를 그대로 반환하는 것을 우선한다.
- `ProcessResultVO<T>`는 레거시 유지가 필요한 기존 handler에서만 허용한다.
- Controller에서 여러 count 조회 결과를 조합하여 업무 유효성을 판정하지 않는다. URL 우회 시에도 같은 검증이 적용되도록 Service에서 판정한다.
- 반복되는 실패 메시지 보정은 `ControllerBase` 또는 도메인별 ControllerBase helper로 분리한다.
- Excel 업로드의 파일 목록 파싱, 엑셀 read, 행 변환, 행 검증, 임시파일 삭제는 Controller에서 처리하지 않고 Service로 위임한다.
- Excel 다운로드 모델 생성은 전용 `~ExcelHandler`가 담당하고, Controller는 제목/검색조건 복원과 `model.addAllAttributes(...)`만 처리한다.
- 목록/등록/상세 화면의 기관, 코드, 기본 VO 조립은 전용 `~ViewFacadeService`로 위임한다.
- `~ViewFacadeService`는 `Model`, `ModelMap`, `HttpServletRequest` 같은 웹 객체를 파라미터로 받지 않고 `Map<String, Object>`를 반환한다.
- Controller는 `~ViewFacadeService`가 반환한 Map을 `model.addAllAttributes(resultMap)`로 풀어 기존 JSP attribute key를 보존한다.

## 위치
- knou.lms.{domain}.web

## 응답/역할 규칙
- AJAX 전용: `@ResponseBody + ResultDTO<T>` 반환
- View 이동: String으로 JSP view 반환

## 표준 주입/반환 흐름(요약)
- 세션/사용자 정보는 `SessionInfo` 직접 호출 대신 `@CurrentUser UserContext userCtx`에서 읽는다.
- Controller에서 세션 필수값을 SearchVO에 주입(orgId/langCd 등)
- `PageInfo` subclass 요청은 VO 전용 `addParams` 복호화 흐름에 기대지 않고 request parameter 직접 바인딩을 사용한다.
- Service 호출
- 성공 시 resultSuccess() 세팅 후 반환

## Exception 규칙
- 신규/리팩터링 Controller method는 실제 checked exception 전파가 필요한 경우에만 `throws Exception`을 선언한다.
- Service interface/impl도 DAO 또는 호출 API가 checked exception을 요구하지 않으면 `throws Exception`을 선언하지 않는다.

## Validation 규칙
- 단순 필수값, 길이, 형식 검증은 VO annotation과 `@Valid` 사용을 우선한다.
- 숫자 필수값은 `@NotNull`, 문자열 필수값은 `@NotBlank`를 사용한다.
- 저장/수정 모드별 분기, DB 조회가 필요한 검증, 여러 필드 조합 검증은 Service 또는 가벼운 Validator/helper에서 처리한다.
- 기존 Validator Java Class는 즉시 전면 제거하지 않고, 신규/리팩터링 시 annotation으로 대체 가능한 부분부터 축소한다.

## Model 전달 규칙
- View로 값을 전달할 때는 `model.addAttribute()`를 우선 사용한다.
- 불가피한 레거시 호환 상황에서만 `request.setAttribute()`를 차선으로 사용한다.
- ViewFacadeService가 반환한 `Map<String, Object>`는 `model.addAllAttributes(...)`로 전달한다.

## Message Code 주석 규칙
- `getMessage("...")`처럼 Spring message code를 직접 사용하는 라인에는 해당 코드의 한글 메시지 값을 인라인 주석으로 함께 작성한다.
- Controller의 Spring message code 주석 상세 기준은 `.codex/rules/15_comment_rules.md`의 `Spring Message 주석 원칙`을 따른다.

## Javadoc 주석 규칙
- Controller method 주석은 Javadoc 형식(`/** ... */`)을 유지한다.
- 첫 줄에는 method 역할을 한글 문장으로 작성한다.
- `@param`, `@return`, `@throws` 태그는 필요한 경우 작성하되, 태그 뒤에 설명 문구를 붙이지 않는다.

```java
/**
 * 관리자 과목 목록 화면을 조회한다.
 * @param searchVo
 * @param model
 * @param userCtx
 * @return
 * @throws Exception
 */
```
