# 05. MyBatis XML Rules

## 기본 원칙
- resultType은 VO를 우선한다.
- 단순 목록/통계/운영성 조회처럼 전용 VO 생성 이득이 낮은 경우 `EgovMap`을 허용한다.
- `Map`/`HashMap`은 명확한 사유가 있는 레거시 호환 외에는 사용하지 않는다.
- Oracle 11g 문법만 사용
- 페이징은 `CommonSQL.pagePrefix2`, `CommonSQL.pageSuffix2` 공통 include를 사용한다.

## resultMap 사용 조건(예외)
1) 컬럼명과 VO 필드명이 자동 매핑 불가
2) Join 결과가 복합 구조(1:N, nested collection/association)
3) Legacy 호환으로 alias가 복잡한 경우(최소만 권장)

## SQL 주석 규칙 + indentation 표준
- DAO와 직접 매핑되는 `<select>`, `<insert>`, `<update>`, `<delete>`는 태그 내부에만 SQL 블록 주석(SQL ID/설명)을 작성한다.
- `<sql id="...">`처럼 include로만 사용하는 쿼리 조각은 태그 바깥에 XML 1줄 주석(기능 설명)만 작성한다.
- DAO and Service interface `//` comments must reuse the SQL block `설명 : ...` text without the `설명 : ` prefix.

예시:
<!-- 과목 목록 공통 조회 조건 -->
<sql id="listQuery">
    SELECT ...
</sql>

<select ...>
    /*
        SQL ID : SbjctDAO.selectSbjctList
        설  명 : 과목목록조회(페이징)
    */
    <include refid="CommonSQL.pagePrefix2" />
    <include refid="listQuery" />
    <include refid="CommonSQL.pageSuffix2" />
</select>
