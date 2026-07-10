# 11. DAO Method Naming

## 기본 규칙
- DAO / Mapper method naming은 `.codex/rules/02_naming_conventions.md`를 따른다.
- 신규/리팩터링 기능은 Controller method명을 기준으로 Service / DAO / MyBatis XML id를 동일하게 맞춘다.
- `ListPaging`은 기능명이며 count/list 분리 여부를 강제하지 않는다.

## MERGE(Oracle) 사용 시(고정)
- Controller naming rule에 따른 기능명과 동일하게 맞추는 것을 우선한다.
- 단일 내부 helper DAO가 필요한 경우에만 `merge{Target}` 형태를 허용한다.
  예: mergeForumJoinUser(ForumSaveVO vo)
- SQL 주석에 “MERGE 사용 사유(Upsert)” 반드시 명시
