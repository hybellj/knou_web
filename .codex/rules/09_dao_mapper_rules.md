# 09. DAO (Mapper Interface) Rules

## 위치/형태
- 위치: knou.lms.{domain}.dao
- MyBatis Mapper Interface만 사용
- @Mapper("lowercaseCamelCaseDAO") 필수
  예: @Mapper("sbjctDAO")

## Service 주입
- @Resource(name="sbjctDAO")

## DAO Method Comments
- Every DAO method must have a single-line `//` comment directly above the method.
- The DAO comment text must reuse the MyBatis XML SQL block `설명 : ...` text with the `설명 : ` prefix removed.
- Example: XML `설명 : 토론정보조회(1건)` -> DAO `// 토론정보조회(1건)`
