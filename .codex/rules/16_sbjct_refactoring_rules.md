# 16. Sbjct Refactoring Rules

## 적용 범위
- `src/main/java/knou/lms/crs/sbjct` 과목 도메인 리팩터링에 적용한다.
- 대상 Controller는 `SbjctTmpltController`, `SbjctOfringController`, `OpenLctrOfringController`를 기준으로 한다.

## Controller 경량화
- Controller는 `SbjctControllerBase`만 상속한다.
- Controller에는 view name, redirect, `ModelMap` 전달, `@CurrentUser UserContext` 기반 요청값 보정만 남긴다.
- 화면 모델 조립은 `~ViewFacadeService`로 위임하고, Controller는 `model.addAllAttributes(resultMap)`만 수행한다.
- `~ViewFacadeService`는 `Model`, `ModelMap`, `HttpServletRequest`를 파라미터로 받지 않는다.
- 저장/수정/삭제/엑셀 업로드 업무 검증은 Service로 위임하고 `ResultDTO`로 실패 사유를 반환한다.

## 권한 처리
- 일반 과목개설 화면 접근은 `resolveSbjctOfringViewAccess(...)`를 사용한다.
- 일반 과목개설 비동기/저장 접근은 `resolveSbjctOfringAsyncAccess(...)`를 사용한다.
- 공개강좌 화면 접근은 `resolveOpenLctrOfringViewAccess(...)`를 사용한다.
- 공개강좌 비동기/저장 접근은 `resolveOpenLctrOfringAsyncAccess(...)`를 사용한다.
- 과목 템플릿은 기존 과목개설 엔티티가 없으므로 `SbjctAuthHelper.resolveSearchOrgId(...)`로 기관 context를 보정한다.
- `SbjctOfringAccessPolicy`를 각 Controller에 반복 주입하지 않고 `SbjctControllerBase`를 통해 접근한다.
- 후속 단계 관리 가능 여부는 `canManageNextStep(...)`를 사용한다.

## Facade와 Helper
- 권한/기관 보정 공통 기능은 `SbjctAuthHelper`에 둔다.
- View 모델 조립은 `facade` 패키지의 `~ViewFacadeService`와 `impl` 구현체에 둔다.
- 모호한 `web.support` 패키지나 상속용 support class를 새로 만들지 않는다.
- 공통화가 정책 차이를 숨기면 분리한다. 일반 과목개설과 공개강좌의 코드/권한 필터는 무리하게 합치지 않는다.

## Excel 처리
- 엑셀 다운로드 모델 생성은 `excel` 패키지의 `~ExcelHandler`가 담당한다.
- 엑셀 업로드의 파일 목록 파싱, `ExcelUtilPoi` read, 행 변환, 행 검증, 임시파일 삭제는 Service가 담당한다.
- Controller는 업로드 전 접근 권한과 상태를 확인한 뒤 Service upload method를 호출한다.
- 업로드 팝업의 `validUploadContext`와 기존 JSP model key는 유지한다.

## JSP 호환
- 기존 JSP attribute key와 view name은 변경하지 않는다.
- `spring:message`와 Java `getMessage(...)` 옆에는 코드값의 한글 메시지 주석을 유지한다.
