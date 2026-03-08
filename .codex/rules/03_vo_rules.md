# 03. VO Rules (네이밍 완전 고정)

## 공통 규칙
- 위치: knou.lms.{domain}.vo
- 모든 VO는 DefaultVO 상속
- 필드명: lowerCamelCase
- 필드 주석: DB 컬럼 COMMENT 기준 (인라인 //)

## serialVersionUID 규칙
- 모든 VO는 Serializable 구현(보통 DefaultVO가 구현)
- UID는 고정: private static final long serialVersionUID = 1L;

## VO 클래스 네이밍(고정)
VO 이름은 “대상명(Target) + 역할(Role) + VO”로만 만든다.

(1) 검색/요청 VO (목록조건 + 페이징)
- {Target}SearchVO
- 포함: 검색조건 + 페이징(pageIndex/pageUnit/pageSize/firstIndex/lastIndex/recordCountPerPage)
- 세션필수값(orgId/langCd 등)은 Controller에서 세팅

(2) 목록 Row VO (목록 1건)
- {Target}ListVO
- 포함: 목록 표시 컬럼 + totalCnt (COUNT(*) OVER() 사용 시)

(3) 상세 VO
- {Target}DetailVO

(4) 저장/수정 요청 VO
- {Target}SaveVO
- 등록/수정 파라미터 “저장 전용” 분리 (필드 많을수록 반드시 분리)

(5) 단건 결과 VO (필요 시만)
- {Target}ResultVO
- 일반적으로 ProcessResultVO<T>로 충분하면 ResultVO 생성 금지

예외
- 레거시가 ListVO 하나로 검색+row를 같이 쓴다면 신규는 규칙 준수, 레거시는 점진 분리.
