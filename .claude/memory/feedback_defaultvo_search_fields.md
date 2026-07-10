---
name: DefaultVO 공통 검색 필드 사용
description: 검색 파라미터(기간·검색어)는 VO에 직접 선언하지 말고 DefaultVO 상속 필드를 사용
type: feedback
---

DefaultVO에 공통 검색 파라미터 필드가 이미 정의되어 있다. VO나 XML 파라미터에서 별도 선언 금지.

- 검색 기간 시작: `searchFrom`
- 검색 기간 종료: `searchTo`
- 검색어: `searchText`

**Why:** VO에 중복 선언하면 필드가 분산되고 규칙 위반이 된다.

**How to apply:** 신규 검색 VO 작성 시 기간/검색어 파라미터는 DefaultVO 필드를 바로 사용. XML `#{searchFrom}`, `#{searchTo}`, `#{searchText}` 로 참조. JSP AJAX data 객체 키도 이 이름으로 통일.
