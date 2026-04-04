---
name: jsp-file-downloader
description: Use when implementing or refactoring JSP attachment download links that call UiFileDownloader with an encoded download parameter such as encDownParam. Trigger for requests about file download buttons, attachment link rendering, JSP download anchors, or reusing the UiFileDownloader pattern in list/detail views.
---

# JSP File Downloader

Use this skill for JSP attachment UIs that download through `UiFileDownloader(encDownParam)`.

## Standard pattern

Render each downloadable item as an anchor or button that prevents navigation and calls:

```html
<a href="#_" onclick="UiFileDownloader('ENC_PARAM'); return false;">filename.ext</a>
```

## Preferred usage

- Use server-provided encoded parameters such as `encDownParam`
- Keep the click handler inline in existing JSP string-builder code if that is the local pattern
- Use `return false` to prevent stray navigation
- Render one link per file in list/detail views

## Avoid

- Constructing raw download URLs when the screen already uses `UiFileDownloader`
- Mixing direct file paths with encoded download parameters in the same component
- Replacing working downloader calls with fetch/blob logic unless the user explicitly wants that

## Current project references

Use these working examples:

- [forum_feedback.jsp](D:/03_work_knou_LMS/01_Working_Src/01_mygit/src/main/webapp/WEB-INF/jsp/forum2/popup/forum_feedback.jsp)
- [forum_bbs_manage.jsp](D:/03_work_knou_LMS/01_Working_Src/01_mygit/src/main/webapp/WEB-INF/jsp/forum2/lect/forum_bbs_manage.jsp)
- [ui-filedownloader.js](D:/03_work_knou_LMS/01_Working_Src/01_mygit/src/main/webapp/webdoc/uilib/filedownloader/ui-filedownloader.js)

## Response expectations

When using this skill:

- keep download rendering consistent with surrounding JSP code
- preserve existing class names and button styles unless asked to redesign
- prefer encoded parameter passthrough over inventing new download contracts
