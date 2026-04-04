# MyBatis XML Rules

## 기본 원칙
- `resultType` → 반드시 VO (Map/HashMap/EgovMap 금지)
- Oracle 11g 문법만 사용
- 페이징: ROWNUM 방식 (`CommonSQL.pagePrefix` / `CommonSQL.pageSubfix` include)
- XML id = DAO 메서드명 **1:1 동일**

## resultMap 허용 조건 (예외)
1. 컬럼명 ≠ VO 필드명 (자동 매핑 불가)
2. Join 결과가 복합 구조 (1:N, nested collection/association)
3. Legacy 호환으로 alias 복잡한 경우 (최소화 권장)

## SQL 주석 형식 (고정)

```xml
<!-- 과목목록조회(페이징) -->
<select id="selectSbjctList" resultType="...">
    /*
        SQL ID : SbjctDAO.selectSbjctList
        설명 : 과목목록조회(페이징)
    */
    <include refid="CommonSQL.pagePrefix" />
    <include refid="listQuery" />
    <include refid="CommonSQL.pageSubfix" />
</select>
```

## MERGE 사용 시
- 메서드명: `merge{Target}` (예: `mergeForumJoinUser`)
- SQL 주석에 **"MERGE 사용 사유(Upsert)"** 반드시 명시
