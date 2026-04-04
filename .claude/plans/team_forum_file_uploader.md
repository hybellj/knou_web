# 팀 토론 행별 파일 업로더 추가 — 완성 구현 계획

## 작업 개요

`prof_forum_write_view.jsp`의 `buildForumTeamListHtml()`이 생성하는 팀별 테이블 행에
에디터(`editor-box`) 아래 파일첨부 행을 추가한다.

### 제약 조건
- 업로더: **simple 모드 / 1개 제한 / JS 동적 생성** (`uiex:dextuploader` 태그 불가 — AJAX 이후 렌더링)
- `saveForum()` 시 팀 수만큼 업로더 존재 → **순차 업로드** 후 저장
- 팀별 `uploadFiles` / `uploadPath` → `teamForumDtlList[i]` 파라미터로 서버 전달
- 서버는 자식 토론 ID(`childDscsId`)를 `refId`로 첨부파일 저장

---

## 변경 파일 목록

| 파일 | 상태 | 변경 내용 |
|------|------|-----------|
| `src/main/java/knou/lms/forum2/vo/Forum2TeamDscsVO.java` | ✅ 완료 | 필드 2개 추가 |
| `src/main/java/knou/lms/forum2/service/impl/ForumServiceImpl.java` | ✅ 완료 | 팀별 첨부파일 처리 추가 |
| `src/main/webapp/WEB-INF/jsp/forum2/lect/prof_forum_write_view.jsp` | ✅ 완료 | JS 전체 흐름 수정 |

---

## Step 1 (✅ 완료): `Forum2TeamDscsVO.java` — 필드 추가

추가된 내용:
```java
// 팀별 파일 업로드 파라미터 (JSP → Service 전달용, DB 컬럼 없음)
private String teamUploadFiles; // 팀별 업로드된 파일 JSON 문자열
private String teamUploadPath;  // 팀별 업로드 경로

public String getTeamUploadFiles() { return teamUploadFiles; }
public void setTeamUploadFiles(String teamUploadFiles) { this.teamUploadFiles = teamUploadFiles; }
public String getTeamUploadPath() { return teamUploadPath; }
public void setTeamUploadPath(String teamUploadPath) { this.teamUploadPath = teamUploadPath; }
```

---

## Step 2 (🔶 진행중): `ForumServiceImpl.java` — 팀별 첨부파일 처리

### 2-1. `doInsertForum()` ✅ 완료

이미 적용된 코드 — teamForumDtlList 루프 내 `forumDAO.insertForum(vo)` 이후:

```java
String childDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
vo.setDscsId(childDscsId);
// ... (기존 vo 세팅)
forumDAO.insertForum(vo);

// 팀별 첨부파일 저장 (refId = 자식 토론 ID)
if (!StringUtil.isNull(teamDtl.getTeamUploadFiles())) {
    List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
            teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
    for (AtflVO atflVO : teamFiles) {
        atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
        atflVO.setRefId(childDscsId);
        atflVO.setRgtrId(vo.getRgtrId());
        atflVO.setMdfrId(vo.getMdfrId());
        atflVO.setAtflRepoId(CommConst.REPO_DSCS);
    }
    if (!teamFiles.isEmpty()) {
        attachFileService.insertAtflList(teamFiles);
    }
}
```

### 2-2. `doUpdateForum()` 🔲 미완료

수정 시 자식 토론 ID(`childDscsId`)를 알아야 파일을 저장할 수 있다.
→ JS의 `buildForumTeamListHtml()`에서 `data-dscs-id` 속성으로 자식 dscsId를 행에 심고,
  `appendTeamForumDetailParams()`에서 `teamDscsId`로 전달하면 `teamDtl.getDscsId()`로 사용 가능.

#### 2-4 분기 수정 (TEAM 유지 + byteam Y→Y)

```java
// 기존:
for (Forum2TeamDscsVO teamDtl : teamForumDtlList) {
    if (teamDtl == null || StringUtil.isNull(teamDtl.getTeamId())) continue;
    teamDtl.setUpDscsId(vo.getDscsId());
    teamDtl.setMdfrId(vo.getMdfrId());
    teamDtl.setRgtrId(vo.getRgtrId());
    forumDAO.updateChildForumDtls(teamDtl);
    // ↓ 추가
    if (!StringUtil.isNull(teamDtl.getTeamUploadFiles()) && !StringUtil.isNull(teamDtl.getDscsId())) {
        List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
                teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
        for (AtflVO atflVO : teamFiles) {
            atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
            atflVO.setRefId(teamDtl.getDscsId());   // JS에서 전달된 자식 토론 ID
            atflVO.setRgtrId(vo.getRgtrId());
            atflVO.setMdfrId(vo.getMdfrId());
            atflVO.setAtflRepoId(CommConst.REPO_DSCS);
        }
        if (!teamFiles.isEmpty()) {
            attachFileService.insertAtflList(teamFiles);
        }
    }
}
```

#### 2-3 분기 수정 (NORMAL → TEAM 전환)

```java
// insertForum(vo) 이후 (doInsertForum과 동일 패턴):
String childDscsId = IdGenerator.getNewId(IdPrefixType.DSCS.getCode());
vo.setDscsId(childDscsId);
// ...
forumDAO.insertForum(vo);
// ↓ 추가
if (!StringUtil.isNull(teamDtl.getTeamUploadFiles())) {
    List<AtflVO> teamFiles = FileUtil.getUploadAtflList(
            teamDtl.getTeamUploadFiles(), teamDtl.getTeamUploadPath());
    for (AtflVO atflVO : teamFiles) {
        atflVO.setAtflId(IdGenUtil.genNewId(IdPrefixType.ATFL));
        atflVO.setRefId(childDscsId);
        atflVO.setRgtrId(vo.getRgtrId());
        atflVO.setMdfrId(vo.getMdfrId());
        atflVO.setAtflRepoId(CommConst.REPO_DSCS);
    }
    if (!teamFiles.isEmpty()) {
        attachFileService.insertAtflList(teamFiles);
    }
}
```

> **TODO**: 수정 시 팀별 기존 파일 삭제는 미구현. 대표 토론과 동일한 패턴으로 추후 추가.

---

## Step 3 (🔲 미완료): `prof_forum_write_view.jsp` — JS 수정

### 3-1. 전역 변수 추가

`const editors = {};` 바로 아래에 추가:

```javascript
var teamUploaderIds   = [];  // 팀 업로더 ID 목록 (순서 보장)
var teamUploadResults = {};  // { uploaderId: {uploadFiles, uploadPath} }
```

---

### 3-2. `buildForumTeamListHtml()` 수정

#### ① 행 헤더에 `data-dscs-id` 추가 (수정 모드에서 자식 dscsId 전달용)

현재 line 610:
```javascript
html += "    <tr class='subForumTr' data-team-id='" + escHtml(v.teamId || '') + "' data-team-nm='" + escHtml(v.teamnm || '') + "'>";
```
→ 변경:
```javascript
html += "    <tr class='subForumTr' data-team-id='" + escHtml(v.teamId || '') + "' data-team-nm='" + escHtml(v.teamnm || '') + "' data-dscs-id='" + escHtml(v.dscsId || '') + "'>";
```

#### ② 에디터 행(line 630) 다음에 파일첨부 행 추가

현재 line 630~631 사이:
```javascript
            html += "                    </tr>";
            html += "                </tbody>";
```
→ 아래 행 삽입:
```javascript
            html += "                    </tr>";
            html += "                    <tr>";
            html += "                        <th><label>파일첨부</label></th>";
            html += "                        <td>";
            html += "                            <div id='teamUploaderWrap_" + v.teamId + "_" + i + "'></div>";
            html += "                        </td>";
            html += "                    </tr>";
            html += "                </tbody>";
```

---

### 3-3. `createTeamFileUploader()` 함수 신규 추가

`buildForumTeamListHtml()` 함수 바로 다음(`escHtml` 함수 앞)에 추가:

```javascript
/** 팀별 파일 업로더 동적 생성 (DextUploaderTag.java 출력 구조를 JS로 재현) */
function createTeamFileUploader(teamId, idx, uploadPath) {
    var uid  = 'teamFileUploader_' + teamId + '_' + idx;
    var wrap = 'teamUploaderWrap_' + teamId + '_' + idx;
    var h    = 36; // simple uiMode: listSize(1) * 36px

    var html = [
        "<div id='" + uid + "-container' class='dext5-container'",
        "     style='width:100%;height:" + h + "px;display:flex;'></div>",
        "<div id='" + uid + "-btn-area' class='dext5-btn-area simple' style='display:flex;'>",
        "    <button type='button' id='" + uid + "_btn-add'",
        "            style='height:" + h + "px;' title='파일 선택'><i class='xi-file-add-o'></i></button>",
        "    <button type='button' id='" + uid + "_btn-delete' disabled='true'",
        "            style='height:" + h + "px;' title='삭제'><i class='xi-trash-o'></i></button>",
        "    <button type='button' id='" + uid + "_btn-reset'",
        "            style='height:" + h + "px;display:none;' title='초기화'",
        "            onclick=\"resetDextFiles('" + uid + "')\"><i class='xi-refresh'></i></button>",
        "</div>"
    ].join('');
    $('#' + wrap).html(html);

    UiFileUploader({
        id             : uid,
        parentId       : uid + '-container',
        btnFile        : uid + '_btn-add',
        btnDelete      : uid + '_btn-delete',
        uploadMode     : 'ORAF',
        maxTotalSize   : 100,
        maxFileSize    : 100,
        fileCount      : 1,
        extensionFilter: '*',
        finishFunc     : '',    // continueUploadChain에서 동적 세팅
        uploadUrl      : '/dext/uploadFileDext.up',
        path           : uploadPath,  // ← 반드시 유효한 값 (절대 빈값 금지)
        oldFiles       : [],
        useFileBox     : false,
        style          : 'list',
        uiMode         : 'simple'
    });

    if (teamUploaderIds.indexOf(uid) === -1) {
        teamUploaderIds.push(uid);
    }
}
```

---

### 3-4. `loadForumTeamList()` 수정

현재 line 578~584:
```javascript
if (returnList.length > 0) {
    returnList.forEach(function(v, i) {
        editors[v.teamId + '_editor' + i] = UiEditor({
            targetId  : v.teamId + '_contentTextArea_' + i,
            uploadPath: "/forum",
            height    : "250px"
        });
    });
}
```

→ 변경:
```javascript
if (returnList.length > 0) {
    // 재로드 시 업로더 목록 초기화 (중복 방지)
    teamUploaderIds   = [];
    teamUploadResults = {};

    returnList.forEach(function(v, i) {
        editors[v.teamId + '_editor' + i] = UiEditor({
            targetId  : v.teamId + '_contentTextArea_' + i,
            uploadPath: "${forum2VO.uploadPath}",   // "/forum" 하드코딩 → EL 로 수정
            height    : "250px"
        });
        createTeamFileUploader(v.teamId, i, "${forum2VO.uploadPath}");
    });
}
```

---

### 3-5. `appendTeamForumDetailParams()` 수정

현재 `$teamRows.each(function() {` → `$teamRows.each(function(rowIdx) {` 로 수정.

그리고 line 852 `appendTeamForumDetailParam(index, 'attchFileId', attchFileId);` 를 아래로 대체:

```javascript
// 팀 업로더 결과 수집 (rowIdx = each 내부 0-based 카운터)
var uid          = 'teamFileUploader_' + teamId + '_' + rowIdx;
var uploadResult = teamUploadResults[uid] || {};
appendTeamForumDetailParam(index, 'teamUploadFiles', uploadResult.uploadFiles || '');
appendTeamForumDetailParam(index, 'teamUploadPath',  uploadResult.uploadPath  || '${forum2VO.uploadPath}');

// 자식 토론 ID (수정 모드에서 2-4 분기 파일 저장에 필요)
var childDscsId = $.trim($row.attr('data-dscs-id') || '');
appendTeamForumDetailParam(index, 'dscsId', childDscsId);
```

> `attchFileId` 라인은 삭제 (더 이상 사용 안 함).

---

### 3-6. `saveForum()` 수정

현재 line 879~896:
```javascript
function saveForum() {
    let validator = UiValidator("forumWriteForm");
    validator.then(function(result) {
        syncAllSwitchHidden();
        syncDiscussionDateTimeFields();
        appendDvclasSelParams();
        appendLrnGrpInfoParams();
        appendTeamForumDetailParams();

        let dx = dx5.get("fileUploader");
        if (dx.availUpload()) {
            dx.startUpload();
        } else {
            $("#delFileIdStr").val(dx.getDelFileIdStr());
            doSaveForum();
        }
    });
}
```

→ 변경:
```javascript
function saveForum() {
    let validator = UiValidator("forumWriteForm");
    validator.then(function(result) {
        syncAllSwitchHidden();
        syncDiscussionDateTimeFields();
        appendDvclasSelParams();
        appendLrnGrpInfoParams();
        // appendTeamForumDetailParams()는 모든 업로드 완료 후 체인 끝에서 호출

        startUploadChain();
    });
}
```

---

### 3-7. 업로드 체인 함수 4개 (기존 `finishUpload` 대체 + 신규 3개)

현재 line 858~876 의 `finishUpload()` 함수를 아래 4개로 교체:

```javascript
/** STEP 1: 메인 업로더(fileUploader) 처리 시작 */
function startUploadChain() {
    var dx = dx5.get("fileUploader");
    if (dx && dx.availUpload()) {
        dx.startUpload(); // 완료 → finishUpload() 콜백
    } else {
        if (dx) { $("#delFileIdStr").val(dx.getDelFileIdStr()); }
        continueUploadChain(0);
    }
}

/** STEP 2: 메인 업로더 완료 콜백 (기존 finishUpload 대체) */
function finishUpload() {
    var dx = dx5.get("fileUploader");
    ajaxCall("/common/uploadFileCheck.do",
        { uploadFiles: dx.getUploadFiles(), uploadPath: dx.getUploadPath() },
        function(data) {
            if (data.result > 0) {
                $("#uploadFiles").val(dx.getUploadFiles());
                continueUploadChain(0);
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }
        },
        function() {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
        }
    );
}

/** STEP 3: 팀 업로더 순차 처리 */
function continueUploadChain(teamIdx) {
    if (teamIdx >= teamUploaderIds.length) {
        appendTeamForumDetailParams(); // 업로드 결과 포함하여 수집
        doSaveForum();
        return;
    }

    var uid = teamUploaderIds[teamIdx];
    var dx  = dx5.get(uid);

    if (!dx) {
        teamUploadResults[uid] = { uploadFiles: '', uploadPath: '' };
        continueUploadChain(teamIdx + 1);
        return;
    }

    if (dx.availUpload()) {
        DX_ENV[uid].finishFunc = "onTeamUploadComplete('" + uid + "'," + teamIdx + ")";
        dx.resetUploadUrl();
        dx.upload();
    } else {
        teamUploadResults[uid] = { uploadFiles: '', uploadPath: dx.getUploadPath() };
        continueUploadChain(teamIdx + 1);
    }
}

/** STEP 4: 팀 업로더 개별 완료 콜백 */
function onTeamUploadComplete(uid, teamIdx) {
    var dx = dx5.get(uid);
    ajaxCall("/common/uploadFileCheck.do",
        { uploadFiles: dx.getUploadFiles(), uploadPath: dx.getUploadPath() },
        function(data) {
            if (data.result > 0) {
                teamUploadResults[uid] = {
                    uploadFiles: dx.getUploadFiles(),
                    uploadPath : dx.getUploadPath()
                };
                continueUploadChain(teamIdx + 1);
            } else {
                UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
            }
        },
        function() {
            UiComm.showMessage("<spring:message code='success.common.file.transfer.fail'/>", "error");
        }
    );
}
```

---

## 데이터 흐름 요약

```
saveForum()
  → 검증 + sync + appendDvclasSelParams + appendLrnGrpInfoParams
  → startUploadChain()
       ↓ (메인 업로더)
  finishUpload() → uploadFileCheck → #uploadFiles 세팅 → continueUploadChain(0)
       ↓ (팀 업로더 0)
  onTeamUploadComplete('uid0', 0) → uploadFileCheck → teamUploadResults['uid0'] → continueUploadChain(1)
       ↓ (팀 업로더 N-1, 마지막)
  continueUploadChain(N) → [종료 조건]
    → appendTeamForumDetailParams()   ← teamUploadResults 참조, dscsId 포함
    → doSaveForum() → POST /profForumRegist.do (또는 /profForumModify.do)

[서버] ForumServiceImpl
  doInsertForum():
    → forumDAO.insertForum(vo) — childDscsId 신규 생성
    → insertAtflList(teamFiles, refId=childDscsId)   ← 팀별 파일

  doUpdateForum() 2-4 분기 (TEAM 유지):
    → forumDAO.updateChildForumDtls(teamDtl)
    → insertAtflList(teamFiles, refId=teamDtl.getDscsId())  ← JS에서 전달된 dscsId

  doUpdateForum() 2-3 분기 (NORMAL→TEAM):
    → forumDAO.insertForum(vo) — childDscsId 신규 생성
    → insertAtflList(teamFiles, refId=childDscsId)
```

---

## 변경 라인 요약 (prof_forum_write_view.jsp)

| 위치 | 변경 유형 | 내용 |
|------|-----------|------|
| script 상단 (`const editors` 아래) | 추가 | `teamUploaderIds`, `teamUploadResults` 전역 변수 |
| `buildForumTeamListHtml()` line 610 | 수정 | `data-dscs-id` 속성 추가 |
| `buildForumTeamListHtml()` line 630 이후 | 추가 | 파일첨부 `<tr>` 행 (wrapperId 포함) |
| `buildForumTeamListHtml()` 다음 | 추가 | `createTeamFileUploader()` 함수 신규 |
| `loadForumTeamList()` forEach 블록 | 수정 | 업로더 초기화 + uploadPath 하드코딩 제거 |
| `appendTeamForumDetailParams()` each 콜백 | 수정 | `function(rowIdx)` + uploadFiles/uploadPath/dscsId 추가, attchFileId 제거 |
| `saveForum()` | 수정 | `appendTeamForumDetailParams()` 제거, `startUploadChain()` 호출 |
| `finishUpload()` | 대체 | `startUploadChain` + `finishUpload` + `continueUploadChain` + `onTeamUploadComplete` 4개로 교체 |

---

## 검증 체크리스트

- [ ] 팀 토론 등록 시 팀 행마다 파일첨부 UI 표시 확인
- [ ] `uploadPath` 빈값 아닌지 확인 (Controller `RepoInfo.getAtflRepo()` 보장)
- [ ] 파일 선택 후 저장 → `WEBDATA_PATH + uploadPath` 경로에 파일 생성 확인
- [ ] DB `ATFL`: `REF_ID = childDscsId`, `ATFL_REPO_ID = 'DSCS'` 행 조회
- [ ] 파일 없는 팀 행: 스킵되어 `teamUploadFiles=''` 로 저장
- [ ] 팀 여러 개: 순차 업로드 완료 후 저장 호출 확인
- [ ] 수정(E) 모드: `data-dscs-id` → `teamDtl.getDscsId()` 로 자식 토론 ID 전달 확인
