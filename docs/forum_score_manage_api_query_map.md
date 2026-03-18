# forum_score_manage API/Query 추적 결과

## 1. 화면 개요
- 대상 화면: `src/main/webapp/WEB-INF/jsp/forum/lect/forum_score_manage.jsp`
- 주요 기능: 참여자 목록 조회/검색/페이징, 점수 저장(일괄/개별/글자수 기준/참여형), 피드백 저장, 팝업(메모/피드백/EZ-Grader/팀구성원/토론현황), 엑셀 업다운 연계
- 주요 include:
  - `/WEB-INF/jsp/forum/common/forum_common_inc.jsp` (공통 modal, fileDown)
  - `/WEB-INF/jsp/forum/common/forum_info_inc.jsp` (상단 토론정보/팀 구성원 버튼)

## 2. 호출 API 목록
- `/forum/forumLect/Form/scoreManage.do`
- `/forum/forumLect/forumJoinUserList.do`
- `/forum/forumLect/updateForumJoinUserScore.do`
- `/forum/forumLect/updateForumJoinUserLenScore.do`
- `/forum/forumLect/participateScore.do`
- `/forum/forumLect/setScoreRatio.do`
- `/forum/forumLect/Form/regFdbk.do`
- `/file/fileHome/saveFileInfo.do`
- `/forum/forumLect/forumProfMemoPop.do`
- `/forum/forumLect/forumFdbkPop.do`
- `/forum/forumLect/allForumFdbkPop.do`
- `/forum/forumLect/forumScoreExcelUploadPop.do`
- `/forum/forumLect/listScoreExcel.do`
- `/forum/ezgPop/ezgMainForm.do`
- `/forum/forumLect/teamMemberList.do`
- `/forum/forumLect/forumChartViewPop.do`
- `/forum/forumLect/Form/forumList.do`
- `/forum/forumLect/Form/editForumForm.do`
- `/forum/forumLect/Form/delForum.do`
- `/forum/forumLect/Form/infoManage.do`
- `/forum/forumLect/Form/bbsManage.do`
- `/forum/forumLect/Form/mutEvalResult.do`
- `/common/fileInfoView.do`
- `/forum/forumLect/teamSelectList.do` (미호출 함수)
- `/forum/forumLect/viewScoreChart.do` (주석 코드)

## 3. API 별 호출 흐름

### A. 참여자 목록 조회/검색/페이징
- JSP/JS 위치: `listForumUser`, 검색 onchange/keyup, `gfn_renderPaging`
- URL: `/forum/forumLect/forumJoinUserList.do`
- Controller: `ForumLectController.forumJoinUserList`
- Service: `ForumJoinUserService.listPaging` (`ForumJoinUserServiceImpl.listPaging`)
- DAO: `ForumJoinUserDAO.listPaging`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml`
  - `listPaging`

### B. 일괄 점수저장(등록/가감)
- JSP/JS 위치: `submitScore`
- URL: `/forum/forumLect/updateForumJoinUserScore.do`
- Controller: `ForumLectController.updateForumJoinUserScore`
- Service: `ForumJoinUserService.updateForumJoinUserScore`
- DAO: `ForumJoinUserDAO.listStdScore`, `ForumJoinUserDAO.insertStdScore`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml`
  - `listStdScore`, `insertStdScore`

### C. 글자수 기반 점수 부여
- JSP/JS 위치: `lenScore`
- URL: `/forum/forumLect/updateForumJoinUserLenScore.do`
- Controller: `ForumLectController.updateForumJoinUserLenScore`
- Service: `ForumJoinUserService.updateForumJoinUserLenScore`
- DAO: `ForumJoinUserDAO.getSelectCtsLen`, `ForumJoinUserDAO.insertStdScore`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml`
  - `getSelectCtsLen`, `insertStdScore`

### D. 참여형 일괄평가
- JSP/JS 위치: `partiScore`
- URL: `/forum/forumLect/participateScore.do`
- Controller: `ForumLectController.participateScore`
- Service: `ForumJoinUserService.participateScore`
- DAO: `ForumJoinUserDAO.participateScore`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml`
  - `participateScore`

### E. 개별 점수 수정
- JSP/JS 위치: `setScoreRatio`
- URL: `/forum/forumLect/setScoreRatio.do`
- Controller: `ForumLectController.setScoreRatio`
- Service: `ForumJoinUserService.setScoreRatio`
- DAO: `ForumJoinUserDAO.insertStdScore`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml`
  - `insertStdScore`

### F. 피드백 저장
- JSP/JS 위치: `submitFdbk`
- URL: `/forum/forumLect/Form/regFdbk.do`
- Controller: `ForumLectController.regFdbk`
- Service: `ForumFdbkService.insertFdbk` (+ 내부 `SysFileService.insertFileInfo`)
- DAO: `ForumFdbkDAO.insertFdbk` (+ 내부 `SysFileDAO.insert`)
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/forum/ForumFdbkMapper_SQL.xml` / `insertFdbk`
  - `src/main/resources/sqlmap/mappers/system/SysFileMapper_SQL.xml` / `insert`

### G. 피드백 첨부 업로드 검증
- JSP/JS 위치: `finishUpload`
- URL: `/file/fileHome/saveFileInfo.do`
- Controller: `FileHomeController.saveFileInfo`
- Service/DAO/Mapper: DB 미사용(물리파일 존재 체크)

### H. 메모/피드백 팝업
- URL: `/forum/forumLect/forumProfMemoPop.do`, `/forum/forumLect/forumFdbkPop.do`
- Controller: `ForumLectController.forumProfMemoPop`, `ForumLectController.forumFeedBack`
- Service:
  - `CrecrsService.infoCreCrs`
  - `ForumJoinUserService.selectProfMemo`
- DAO:
  - `CrecrsDAO.infoCreCrs`
  - `ForumJoinUserDAO.getForumJoinUser` -> (없으면) `insertStdScore` -> `selectProfMemo`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/crs/crecrs/CreCrsMapper_SQL.xml` / `infoCreCrs`
  - `src/main/resources/sqlmap/mappers/forum/ForumJoinUserMapper_SQL.xml` / `getForumJoinUser`, `insertStdScore`, `selectProfMemo`

### I. 엑셀 관련
- 업로드 팝업: `/forum/forumLect/forumScoreExcelUploadPop.do` (뷰 반환)
- 목록 엑셀다운: `/forum/forumLect/listScoreExcel.do`
  - Controller: `ForumLectController.listScoreExcel`
  - Service: `ForumJoinUserService.listPageing`
  - DAO/SQL: `ForumJoinUserDAO.listPaging` / `ForumJoinUserMapper_SQL.xml:listPaging`

### J. EZ-Grader 팝업
- URL: `/forum/ezgPop/ezgMainForm.do`
- Controller: `ForumEzGraderLectController.getEzgMainView`
- Service/DAO/SQL: `ForumJoinUserService.insertJoinUser` -> `ForumJoinUserDAO.insertJoinUser` -> `ForumJoinUserMapper_SQL.xml:insertJoinUser`

### K. 탭 이동/목록/수정/삭제/토론현황/팀구성원
- `/forum/forumLect/Form/infoManage.do`, `/Form/bbsManage.do`, `/Form/mutEvalResult.do`
  - `ForumService.selectForum` -> `ForumDAO.selectForum` -> `Forum_SQL.xml:selectForum`
- `/forum/forumLect/Form/forumList.do`
  - `ForumService.count` -> `ForumDAO.count` -> `Forum_SQL.xml:count`
- `/forum/forumLect/Form/editForumForm.do`
  - `ForumService.selectForum`, `CrecrsService.selectCreCrs`, `SysFileService.list`
  - SQL: `Forum_SQL.xml:selectForum`, `CreCrsMapper_SQL.xml:selectCreCrs`, `SysFileMapper_SQL.xml:list`
- `/forum/forumLect/Form/delForum.do`
  - `ForumService.deleteForumCreCrsRltn`, `deleteForum`, `setScoreRatio`
  - SQL: `Forum_SQL.xml:deleteForumCreCrsRltn`, `deleteForum`, `getScoreRatio`, `setScoreRatio`
- `/forum/forumLect/forumChartViewPop.do`
  - `ForumJoinUserService.forumJoinUserList`, `ForumService.selectForum`
  - SQL: `ForumJoinUserMapper_SQL.xml:forumJoinUserList`, `Forum_SQL.xml:selectForum`
- `/forum/forumLect/teamMemberList.do`
  - `TeamCtgrService.teamList` -> `TeamCtgrDAO.teamList` -> `TeamCtgr_SQL.xml:teamList`

### L. include 경유 파일 다운로드
- JSP/JS 위치: `forum_common_inc.jsp -> fileDown`
- URL: `/common/fileInfoView.do`
- Controller: `FileUpDownController.fileInfoView`
- Service: `SysFileService.getFile`
- DAO: `SysFileDAO.select`, `SysFileDAO.updateFileLastInqDttm`
- Mapper XML / SQL ID:
  - `src/main/resources/sqlmap/mappers/system/SysFileMapper_SQL.xml`
  - `select`, `updateFileLastInqDttm`

## 4. 아직 확인이 불명확한 항목
- `gfn_renderPaging`의 `eventName`이 `listExamUser`인데, `forum_score_manage.jsp` 내 `listExamUser` 함수 정의 없음 (`listForumUser`와 불일치).
- `submitScore`/`lenScore`는 `stdNos`를 전송하지만 `ForumJoinUserVO`는 `stdIds` 필드를 사용함. 실제 바인딩 규칙 확인 필요.
- `fdbkList`로 진입하는 `forum_feedback.jsp` 내부 후속 API(`getFdbk.do` 등) 전체 체인은 본 화면 직접 include 범위를 넘어가므로 별도 확인 필요.
- `loadSelectDiv -> /teamSelectList.do`는 ready 블록에서 호출이 주석처리되어 실사용 여부 확인 필요.
- `scoreChartSet -> /viewScoreChart.do`는 함수 전체가 주석 처리되어 현재 실행되지 않음.

## 5. 다음 단계에서 상세 분석할 쿼리 목록
- `ForumJoinUserMapper_SQL.xml:listPaging` (조건 분기/검색/정렬/페이징)
- `ForumJoinUserMapper_SQL.xml:insertStdScore` (점수 저장 핵심)
- `ForumJoinUserMapper_SQL.xml:listStdScore` (가감 전 기준 점수)
- `ForumJoinUserMapper_SQL.xml:getSelectCtsLen` (글자수 계산 기준)
- `ForumJoinUserMapper_SQL.xml:participateScore` (JOIN/NOTJOIN 분기)
- `ForumFdbkMapper_SQL.xml:insertFdbk` (피드백 저장)
- `SysFileMapper_SQL.xml:insert` (피드백 첨부/음성 파일 메타 저장)
- `Forum_SQL.xml:selectForum` (화면 공통 상세 조회)
- `Forum_SQL.xml:deleteForum`, `deleteForumCreCrsRltn`, `getScoreRatio`, `setScoreRatio` (삭제/비율 재계산)
