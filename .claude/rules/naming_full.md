# Naming Conventions (전체)

## Controller 클래스
`{Target}Controller`  
예) `SbjctController`, `ForumController`, `ProfAsmtController`  
→ 화면/기능 단위로 분리 (도메인 전체를 1개로 뭉치지 말 것)

## RequestMapping
형식: `(주체)+(업무구분)+(용어단어)+(기능어).do`

### 기능어 고정 집합
| 기능어 | 설명 |
|--------|------|
| `ListView` | 화면 이동 |
| `List` | 목록 AJAX |
| `Select` | 단건 조회 AJAX |
| `Save` | 등록/수정 AJAX |
| `Delete` | 삭제 AJAX |
| `Update` | 부분수정 AJAX (사용여부 토글 등) |

예) `profAsmtListView.do` / `profAsmtSelect.do` / `profAsmtList.do`

## JSP 파일명 (lower_snake_case 고정)
- 모두 소문자 + 단어별 `_` 연결 + `.jsp`
- 대문자 금지 / camelCase 금지 / 하이픈(-) 금지

| 변환 전 | 변환 후 |
|---------|---------|
| `profAsmtListView.jsp` | `prof_asmt_list_view.jsp` |
| `adminSbjctWriteView.jsp` | `admin_sbjct_write_view.jsp` |

## VO 네이밍
`{Target}{Role}VO`  
Role: `Search` / `List` / `Detail` / `Save` / `Result`

## DAO / XML
- DAO: `{crud}{Target}` 또는 `{crud}{Target}{FieldName}`
- XML id = DAO 메서드명 1:1

## Service / ServiceImpl
- Interface: `{Target}Service`
- Impl: `{Target}ServiceImpl` (`@Service("{target}Service")`)

## DB Directory
- `/db/ddl` : 참고용 DDL 원본 보관 (명시적으로 지정한 경우만 참조)
