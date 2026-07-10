# 12. MyBatis XML id Naming

- DAO / Mapper method naming은 `.codex/rules/02_naming_conventions.md`를 따른다.
- XML의 id는 DAO 메서드명과 1:1 동일
  예: DAO 메서드 selectSbjctList → XML id="selectSbjctList"
- 신규/리팩터링 기능은 Controller method / Service method / DAO method / MyBatis XML id를 동일하게 맞추는 것을 우선한다.
- 페이징 XML은 `CommonSQL.pagePrefix2`, `CommonSQL.pageSuffix2`를 사용한다.
