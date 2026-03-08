# 02. Naming Conventions (완전 고정)

## Controller Class 네이밍(고정)
- {Target}Controller
- 예: SbjctController, ForumController, ProfAsmtController
- {Target}은 “화면/기능 단위” (도메인 전체를 1개 컨트롤러로 뭉치지 말 것)

## RequestMapping 네이밍(고정)
형식: (주체)+(업무구분)+(용어단어)+(기능어).do

### 기능어 고정 집합
- ListView(화면)
- List(목록)
- Select(단건조회)
- Save(등록/수정)
- Delete(삭제)
- Update(부분수정: 사용여부 토글 등)

예)
- profAsmtListView.do
- profAsmtSelect.do
- profAsmtList.do

## Controller method 네이밍(고정)
- 화면: {subject}{Target}ListView()
- 목록(AJAX): {subject}{Target}List()
- 단건(AJAX): {subject}{Target}Select()
- 저장(AJAX): {subject}{Target}Save()
- 삭제(AJAX): {subject}{Target}Delete()
- 부분수정(AJAX): {subject}{Target}UpdateXxx()

subject(주체) 예: admin / prof / std  
Target(대상) 예: Sbjct / Forum / Asmt

## JSP 파일명 규칙(고정)
- 모두 소문자 + 단어별 underscore 연결 + .jsp
- 예외 없이 대문자 금지, camelCase 금지, 하이픈(-) 금지

예)
- prof_asmt_list_view.jsp
- prof_asmt_write_view.jsp
- admin_sbjct_list_view.jsp

변환 예시
- profAsmtListView.jsp → prof_asmt_list_view.jsp
- adminSbjctWriteView.jsp → admin_sbjct_write_view.jsp
