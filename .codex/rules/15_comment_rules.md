# 15. Comment Rules

## 신규 구현 코드 주석 원칙
- 새로 구현하는 Java public/private method는 역할을 설명하는 Javadoc 주석을 작성한다.
- 새로 구현하는 JSP/JavaScript function은 함수 선언 바로 위에 `//` 주석으로 역할을 작성한다.
- 검증, 파일 처리, Excel 변환, DB 저장, 중복 확인, 롤백 의도처럼 주요 수행 로직은 코드 블록 앞에 짧은 주석을 작성한다.
- 단순 getter/setter 호출이나 코드만으로 의미가 명확한 한 줄에는 불필요한 주석을 붙이지 않는다.
- 주석은 method명이나 기술명을 그대로 반복하지 않고, 기능이나 동작을 한글 문장으로 설명한다.

## Javadoc 주석 원칙
- Java method 주석은 Javadoc 형식(`/** ... */`)을 유지한다.
- 첫 줄에는 method 역할을 한글 문장으로 작성한다.
- `@param`, `@return`, `@throws` 태그는 필요한 경우 작성하되, 태그 뒤에 설명 문구를 붙이지 않는다.
- Override method도 기존 주석이 없으면 누락으로 보고 역할 주석을 작성한다.

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

## Spring Message 주석 원칙
- Spring message code를 직접 사용하는 모든 라인에는 코드값의 한글 메시지 값을 항상 옆 주석으로 작성한다.
- Java 영역의 `getMessage("...")`, `errors.reject...("...")`, `setResultFailed(getMessage("..."))`에는 `/* 한글 메시지 */` 주석을 사용한다.
- JSP HTML 영역의 `<spring:message ...>`에는 `<%-- 한글 메시지 --%>` 주석을 사용한다.
- JSP JavaScript 영역의 `<spring:message ...>` 또는 JavaScript 문자열 안의 Spring message code에는 `// 한글 메시지` 또는 `/* 한글 메시지 */` 주석을 사용한다.
- 주석은 문자열 리터럴, JSP 태그 속성, JavaScript 객체 문법 안에 끼워 넣지 말고 문법적으로 안전한 위치에 작성한다.
- `aria-label` 속성값은 `spring:message`로 치환하지 않고 퍼블리싱 원문 문자열을 유지한다.
- JSP/JavaScript에서 화면 문구를 `CONTENTS_MSG` 같은 메시지 객체나 JS 상수로 모으는 것은 동일 문구가 3회 이상 반복될 때만 허용한다.
- 동일 문구가 1~2회만 사용되면 사용하는 위치에 직접 `<spring:message>`를 작성하고 한글 주석을 붙인다.
- 메시지 객체나 JS 상수를 사용하는 경우에도 실제 사용 위치에는 노출 문구를 알 수 있도록 한글 주석을 유지한다.

- 예: `getMessage("fail.common.msg"));/*에러가 발생했습니다!*/`
- 예: `<spring:message code="crs.sbjct.ofring.list" /> <%-- 과목개설 목록 --%>`
- 예: `'<spring:message code="fail.common.msg" />' // 에러가 발생했습니다!`

## Spring Message 코드 선택 원칙
- 새 message code를 등록하기 전에 `message-common_ko.properties`와 대응 `message-common_en.properties`에 동일 의미의 공통 키가 있는지 먼저 확인한다.
- 공통 키가 있으면 도메인별 message 파일에 별도 정의하지 않고 공통 키를 사용한다.
- 도메인별 message 파일에는 해당 화면이나 업무 도메인에 특화된 문구만 추가한다.
- 공통 키로 교체해도 JSP/JavaScript/Java 옆 한글 주석은 실제 화면에 노출되는 한글 문구 기준으로 유지한다.
- 공통 키의 한글 의미가 정확히 같지 않거나 화면 맥락상 문구가 달라야 하는 경우에만 도메인별 message key를 유지한다.
