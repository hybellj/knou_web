# 05. MyBatis XML Rules (VO 리턴 기본)

## 기본 원칙
- resultType은 반드시 VO
- Map/HashMap/EgovMap 금지
- Oracle 11g 문법만 사용
- 페이징은 ROWNUM 방식(공통 include 사용)

## resultMap 허용 조건(예외)
1) 컬럼명 ≠ VO 필드명 (자동 매핑 불가)
2) Join 결과가 복합 구조(1:N, nested collection/association)
3) Legacy 호환으로 alias가 복잡한 경우(최소화 권장)

## SQL 주석 규칙 + indentation 표준
- 1) XML 주석(기능 설명)
- 2) SQL 블록 주석(SQL ID/설명)

예시:
<!-- 과목목록조회(페이징) -->
<select ...>
    /*
        SQL ID : SbjctDAO.selectSbjctList
        설명 : 과목목록조회(페이징)
    */
    <include refid="CommonSQL.pagePrefix" />
    <include refid="listQuery" />
    <include refid="CommonSQL.pageSubfix" />
</select>
