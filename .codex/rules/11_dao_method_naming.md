# 11. DAO Method Naming (완전 통일)

## CRUD 기본 세트(고정)
- 목록: select{Target}List
- 단건: select{Target}
- 등록: insert{Target}
- 수정: update{Target}
- 삭제: delete{Target}

예) Sbjct
- selectSbjctList(SbjctSearchVO vo)
- selectSbjct(SbjctDetailVO vo)
- insertSbjct(SbjctSaveVO vo)
- updateSbjct(SbjctSaveVO vo)
- deleteSbjct(SbjctSaveVO vo)

## 부분수정/토글(고정)
- update{Target}{FieldName}
  예: updateSbjctUseYn(SbjctSaveVO vo)
  예: updateForumOpenYn(ForumSaveVO vo)

## MERGE(Oracle) 사용 시(고정)
- merge{Target}
  예: mergeForumJoinUser(ForumSaveVO vo)
- SQL 주석에 “MERGE 사용 사유(Upsert)” 반드시 명시
