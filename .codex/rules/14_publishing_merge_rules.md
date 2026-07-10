# 14. Publishing Merge Rules

- 목적은 신규 퍼블리싱 반영이 아니라 기존 기능 유지 + 신규 마크업 적용이다.
- 기존 JS selector(id/name/data-role)가 끊기지 않도록 유지한다.
- input name, hidden field, form id는 서버 바인딩 기준이므로 임의 변경 금지
- JSTL/spring:message/include/taglib 유지
- `spring:message`를 사용하는 라인에는 해당 코드값의 한글 메시지 값을 항상 JSP/JS 주석으로 함께 작성
- JSP/JavaScript 화면 문구는 3회 이상 반복되는 경우에만 메시지 객체나 JS 상수로 모으고, 1~2회 사용 문구는 사용 위치에 직접 `<spring:message>`를 작성
- 신규 `spring:message` key를 등록하기 전 `.codex/rules/15_comment_rules.md`의 `Spring Message 코드 선택 원칙`에 따라 공통 message key를 먼저 확인
- `aria-label` 속성값은 `spring:message`로 치환하지 않고 퍼블리싱 원문 문자열을 유지
- Chosen 대상 select의 option을 `html`, `append`, `empty` 등으로 동적 변경하거나 `val(...)`로 선택값을 변경한 뒤에는 반드시 `.trigger("chosen:updated")` 호출
- 퍼블리싱의 `modal-overlay` 블록은 실제 JSP에 그대로 이식하지 않고, 서비스 화면 팝업은 기존 프로젝트 패턴인 `UiDialog` 호출과 팝업 JSP로 구현
- 저장/조회/목록 기능이 먼저 동작해야 한다.
- CSS class 정리는 기능 반영 후 마지막에 수행
- 기존 이벤트가 신규 퍼블리싱에서 사라지면 data-role 또는 id adapter를 추가
- Controller/Service/DAO/Mapper 구조 변경은 필요한 경우에만 최소 범위로 수행
- 파일 인코딩 변경 절대 금지
