---
name: jsp-dynamic-file-uploader
description: Use when implementing or refactoring JSP/JavaScript file upload flows that dynamically create a DX5 UiFileUploader near the active editor, remove it on cancel or save, and submit getUploadFiles/getUploadPath/getDelFileIds to backend APIs. Trigger for requests about dynamic uploader creation, per-target uploader mounting, upload state cleanup, or DX5-based JSP attachment UI.
---

# JSP Dynamic File Uploader

Use this skill for JSP screens that should create a fresh DX5 uploader only when the user enters add/edit mode.

## Use this pattern

- Create the uploader at the active textarea or form block, not as a permanently mounted shared widget.
- Remove the uploader host DOM on cancel and after the flow completes.
- Keep one small set of lifecycle helpers:
  - `create...UploaderAt(selector, oldFiles?)`
  - `get...Uploader()`
  - `remove...Uploader()`
- For edit flows, inject old files after creation with `addOldFileList`.

## Preferred implementation shape

1. Store only current uploader identity and host id.
2. On add/edit entry:
   - remove any active uploader
   - allocate a new uploader id
   - append a host `<div>` right below the active textarea
   - call `UiFileUploader({ id, targetId, path, limitCount, limitSize, oneLimitSize, listSize, fileList:"", finishFunc, allowedTypes:"*" })`
3. On save:
   - if uploader exists and `availUpload()` is true, call `startUpload()`
   - otherwise save immediately
4. In save payloads:
   - new files: `getUploadFiles()`
   - upload path: `getUploadPath()`
   - deleted old files on edit: `getDelFileIds()`
5. On cancel/cleanup:
   - call `removeAll()` and `revokeAllVirtualFiles()` when available
   - remove the uploader host DOM

## Avoid

- Reusing one fixed uploader instance and only moving its position
- Popup-style uploader shells unless the screen truly needs a popup
- Recovery-heavy code that tries to heal broken uploader DOM instead of recreating it
- Extra state variables when current uploader id and current mode are enough

## Current project reference

Use [forum_feedback.jsp](D:/03_work_knou_LMS/01_Working_Src/01_mygit/src/main/webapp/WEB-INF/jsp/forum2/popup/forum_feedback.jsp) as the working example for:

- `createFeedbackUploaderAt`
- `getFeedbackUploader`
- `removeActiveFeedbackUploader`
- add/edit save flows using DX5 uploader APIs

## Response expectations

When using this skill:

- prefer minimal lifecycle code
- preserve existing backend parameter names
- keep add and edit behavior symmetric
- explicitly check whether the user wants shared uploader reuse; otherwise default to create/remove-per-entry
