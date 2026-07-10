# 02. Naming Conventions (통합 Codex Rule)

## 1. Controller Class 네이밍 (고정)
- **형식**: `{Target}Controller`
- **지침**: `{Target}`은 "화면/기능 단위"를 의미합니다. 도메인 전체를 하나의 컨트롤러로 뭉치지 말고, 업무적 목적에 따라 명확히 분리합니다.
- **예시**: `DscsProfAtclController`, `DscsStdntAtclController`, `AcademicLinkController`

---

## 2. RequestMapping URL 네이밍 (고정)
- **형식**: `(주체) + (업무구분) + (용어단어) + (기능어).do`
- **지침**: 주체(`prof`, `stdnt`, `adm`)를 전면에 배치하고, 모든 동적 요청은 `.do`로 일원화합니다. 비동기 통신(AJAX) 역시 URL에 `Ajax`를 붙이지 않고 아래 지정된 기능어 집합을 조합하여 처리합니다.

### 기능어 고정 집합
- **`ListView`** : 화면 이동 (JSP 렌더링)
- **`List`** : 일반 목록 조회 (AJAX 데이터 반환)
- **`ListPaging`** : 페이징 처리된 목록 조회 (AJAX 데이터 반환)
- **`Detail`** : 단건 상세 조회 / 상태 조회 (AJAX 데이터 반환)
- **`Regist`** : 신규 등록 처리 (AJAX)
- **`Modify`** : 수정 처리 (AJAX)
- **`Delete`** : 물리/논리 삭제 처리 (AJAX)
- **`Hide`** : 숨김 처리와 같은 특정 상태 부분 수정 (AJAX)
- **`Fetch`** : 외부 학사 시스템 등으로부터 데이터를 가져오는 연동 처리 (AJAX)

### Mapping 예시
- `profDscsAtclListView.do` (교수 토론 게시글 화면)
- `profDscsAtclListPaging.do` (교수 토론 페이징 목록 조회)
- `stdntDscsAtclRegist.do` (학습자 토론 게시글 등록)
- `stdntDscsAtclStatusDetail.do` (학습자 나의 게시글 상태 조회)
- `profAcademicRecordFetch.do` (교수자 학사 정보 연동 실행)

---

## 3. Controller Method 및 Service Method 네이밍 (고정)
- **지침**: RequestMapping URL의 단어 순서 및 카멜케이스(camelCase) 규칙을 **Controller method / Service method / DAO method / MyBatis XML id까지 동일하게 복사하여 일치**시킵니다. 이를 통해 웹 요청부터 SQL까지 추적성을 극대화합니다.

- **화면(JSP 반환)**: `(주체) + (Target) + ListView()`
- **목록(AJAX)**: `(주체) + (Target) + List()`
- **페이징 목록(AJAX)**: `(주체) + (Target) + ListPaging()`
- **단건/상세(AJAX)**: `(주체) + (Target) + Detail()` 또는 `(주체) + (Target) + StatusDetail()`
- **저장/등록(AJAX)**: `(주체) + (Target) + Regist()`
- **수정(AJAX)**: `(주체) + (Target) + Modify()`
- **삭제(AJAX)**: `(주체) + (Target) + Delete()`
- **특수 부분수정(AJAX)**: `(주체) + (Target) + Hide()`
- **외부 연동(AJAX)**: `(주체) + (Target) + Fetch()`

---

## 4. DAO / Mapper Method 네이밍 (Controller 기준)
- **지침**: 신규/리팩터링 기능은 Controller method명을 기준명으로 삼고, 같은 기능의 Service method / DAO method / MyBatis XML id를 동일하게 맞춥니다.
- **ListPaging**은 기능명이며, SQL 내부에서 count/list를 분리할지 여부를 강제하지 않습니다.
- 내부 helper DAO가 별도로 필요한 경우에만 CRUD prefix(`select`, `insert`, `update`, `delete`, `merge`)를 허용합니다.
- 현재 트랜잭션 설정은 ServiceImpl method 전체에 적용되므로 DAO method prefix로 트랜잭션을 구분하지 않습니다.

---

## 5. 계층 간 Naming 연동 종합 매트릭스 (예시)

| 기능 분류 | Controller URL / Method | Service Method | DAO / Mapper Method |
| :--- | :--- | :--- | :--- |
| **교수 목록 화면** | `profDscsAtclListView.do` | (화면 이동이므로 생략 가능) | - |
| **교수 페이징 조회** | `profDscsAtclListPaging.do` | `profDscsAtclListPaging()` | `profDscsAtclListPaging()` |
| **학습자 글 등록** | `stdntDscsAtclRegist.do` | `stdntDscsAtclRegist()` | `stdntDscsAtclRegist()` |
| **학습자 글 수정** | `stdntDscsAtclModify.do` | `stdntDscsAtclModify()` | `stdntDscsAtclModify()` |
| **교수 글 숨김** | `profDscsAtclHide.do` | `profDscsAtclHide()` | `profDscsAtclHide()` |
| **학습자 상태 상세** | `stdntDscsAtclStatusDetail.do`| `stdntDscsAtclStatusDetail()` | `stdntDscsAtclStatusDetail()` |
| **교수 학사연동** | `profAcademicRecordFetch.do` | `profAcademicRecordFetch()` | `profAcademicRecordFetch()` |

---

## 6. JSP 파일명 규칙 (완전 고정 - 수정 없음)
- 모두 소문자 + 단어별 underscore(`_`) 연결 + `.jsp`
- 예외 없이 대문자 금지, camelCase 금지, 하이픈(`-`) 금지

**변환 예시**
- `profDscsAtclListView.do` 요청 시 → `prof_dscs_atcl_list_view.jsp`
- `stdntDscsAtclRegistView.do` 요청 시 → `stdnt_dscs_atcl_write_view.jsp`
