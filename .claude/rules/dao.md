# DAO (Mapper Interface) Rules

위치: `knou.lms.{domain}.dao`

```java
@Mapper("sbjctDAO")                    // lowerCamelCase + DAO
public interface SbjctDAO {
    List<SbjctListVO>   selectSbjctList(SbjctSearchVO vo);
    SbjctDetailVO       selectSbjct(SbjctDetailVO vo);
    int                 insertSbjct(SbjctSaveVO vo);
    int                 updateSbjct(SbjctSaveVO vo);
    int                 deleteSbjct(SbjctSaveVO vo);
}
```

Service에서 주입: `@Resource(name = "sbjctDAO")`

## 메서드 네이밍 (고정)

| 동작 | 패턴 | 예시 |
|------|------|------|
| 목록 | `select{Target}List` | `selectSbjctList` |
| 단건 | `select{Target}` | `selectSbjct` |
| 등록 | `insert{Target}` | `insertSbjct` |
| 수정 | `update{Target}` | `updateSbjct` |
| 삭제 | `delete{Target}` | `deleteSbjct` |
| 부분수정 | `update{Target}{FieldName}` | `updateSbjctUseYn` |
| MERGE | `merge{Target}` | `mergeForumJoinUser` |

## XML id 규칙
DAO 메서드명 = XML id **완전 동일**  
예) `selectSbjctList` → `<select id="selectSbjctList" ...>`
