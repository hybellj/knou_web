# 09. DAO (Mapper Interface) Rules

## 위치/형태
- 위치: knou.lms.{domain}.dao
- MyBatis Mapper Interface만 사용
- @Mapper("lowercaseCamelCaseDAO") 필수
  예: @Mapper("sbjctDAO")

## Service 주입
- @Resource(name="sbjctDAO")
