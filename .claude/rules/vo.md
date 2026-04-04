# VO Rules

위치: `knou.lms.{domain}.vo`
- 모든 VO는 `DefaultVO` 상속
- 필드명: lowerCamelCase
- 필드 주석: DB 컬럼 COMMENT 기준 (인라인 //)
- `private static final long serialVersionUID = 1L;`

## VO 종류 (고정)

| 클래스명 | 용도 | 포함 필드 |
|----------|------|-----------|
| `{Target}SearchVO` | 검색 + 페이징 조건 | 검색조건 + pageIndex/pageUnit/pageSize/firstIndex/lastIndex/recordCountPerPage |
| `{Target}ListVO` | 목록 1행 | 목록 표시 컬럼 + totalCnt |
| `{Target}DetailVO` | 상세 단건 | 상세 표시 컬럼 전체 |
| `{Target}SaveVO` | 등록/수정 요청 | 저장 전용 파라미터 (필드 많을수록 반드시 분리) |
| `{Target}ResultVO` | 단건 결과 (필요시만) | ProcessResultVO<T>로 충분하면 생성 금지 |

## 세션 필수값 주입
- `orgId` / `langCd` 등 세션값 → Controller에서 SearchVO에 set (VO 생성자 금지)

## 레거시 예외
- 레거시가 ListVO 하나로 검색+row 같이 사용 중이면 → 신규만 규칙 준수, 레거시는 점진 분리
