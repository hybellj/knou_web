# Controller Rules

위치: `knou.lms.{domain}.web`

## 응답 규칙
- AJAX: `@ResponseBody` + `ProcessResultVO<T>` 반환
- View 이동: `String` (JSP 경로) 반환

## 표준 흐름
1. 세션 필수값(`orgId`/`langCd` 등) → SearchVO에 set
2. Service 호출
3. 성공 시 `resultSuccess()` 세팅 후 반환

## 메서드 네이밍 (고정)

| 유형 | 메서드명 | Mapping |
|------|----------|---------|
| 화면 | `{subject}{Target}ListView()` | `{subject}{Target}ListView.do` |
| 목록(AJAX) | `{subject}{Target}List()` | `{subject}{Target}List.do` |
| 단건(AJAX) | `{subject}{Target}Select()` | `{subject}{Target}Select.do` |
| 저장(AJAX) | `{subject}{Target}Save()` | `{subject}{Target}Save.do` |
| 삭제(AJAX) | `{subject}{Target}Delete()` | `{subject}{Target}Delete.do` |
| 부분수정(AJAX) | `{subject}{Target}UpdateXxx()` | `{subject}{Target}UpdateXxx.do` |

subject 예: `admin` / `prof` / `std`  
Target 예: `Sbjct` / `Forum` / `Asmt`
