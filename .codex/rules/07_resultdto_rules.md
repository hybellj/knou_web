# 07. ResultDTO Rules

## 상태 세팅
- 신규/리팩터링 AJAX 응답은 `ResultDTO<T>`를 사용한다.
- 성공/실패 상태는 `setResultSuccess()` / `setResultFailed()` 등 상태 세팅 메서드를 사용한다.
- 성공 메시지는 `returnMessage(getMessage("..."))` 또는 `setResultSuccess(message)`를 사용한다.

## 목록 응답 표준
- 목록 응답은 `returnList + pageInfo` 조합을 표준으로 한다.
- 단건 응답은 `data`를 사용한다.
- 처리 건수 기반 성공 여부는 `setSuccessCount(count)` 사용을 허용한다.

## 레거시
- `ProcessResultVO<T>`는 기존 기능 유지가 필요한 경우에만 허용한다.
