---
name: knou-sbjct-refactor
description: KNOU LMS subject-domain refactoring guide for src/main/java/knou/lms/crs/sbjct. Use when working on SbjctTmpltController, SbjctOfringController, OpenLctrOfringController, SbjctControllerBase, SbjctAuthHelper, ViewFacadeService, ExcelHandler, Controller lightening, permission/access checks, JSP model key preservation, ResultDTO flow, or comment/message-code rule cleanup in the subject domain.
---

# KNOU Sbjct Refactor

## 시작 전 확인
- 먼저 `.codex/rules/04_controller_rules.md`, `10_service_rules.md`, `15_comment_rules.md`, `16_sbjct_refactoring_rules.md`를 읽는다.
- 대상 Controller와 연결된 Service, ViewFacadeService, ExcelHandler, `SbjctControllerBase`, `SbjctAuthHelper`를 함께 확인한다.
- 기존 JSP attribute key, view name, redirect 흐름은 변경하지 않는 것을 기본값으로 둔다.

## Controller 경량화 기준
- Controller에는 HTTP 경계 처리, `@CurrentUser UserContext` 기반 요청값 보정, 권한 진입점 호출, `ModelMap` 전달, view name/redirect 반환만 남긴다.
- 화면 모델 조립은 `~ViewFacadeService`로 위임한다.
- Controller는 `~ViewFacadeService`가 반환한 `Map<String, Object>`를 `model.addAllAttributes(resultMap)`로 전달한다.
- AJAX handler는 Service가 반환한 `ResultDTO<T>`를 우선 그대로 반환하고, 공통 실패 메시지는 `withFailMessage(...)`, 성공 저장 메시지는 `successSave(...)`를 사용한다.
- Controller에서 DB 기준 중복 검증, 관계 검증, Excel row 검증, 파일 삭제를 처리하지 않는다.

## 권한과 접근 체크
- 일반 과목개설 화면 접근은 `resolveSbjctOfringViewAccess(...)`를 사용한다.
- 일반 과목개설 저장/비동기 접근은 `resolveSbjctOfringAsyncAccess(...)`를 사용한다.
- 공개강좌 화면 접근은 `resolveOpenLctrOfringViewAccess(...)`를 사용한다.
- 공개강좌 저장/비동기 접근은 `resolveOpenLctrOfringAsyncAccess(...)`를 사용한다.
- 후속 단계 관리 가능 여부는 `canManageNextStep(...)`를 사용한다.
- 과목 템플릿은 기존 과목개설 엔티티가 없으므로 `SbjctAuthHelper.resolveSearchOrgId(...)`로 기관 context를 보정한다.
- `SbjctOfringAccessPolicy`를 Controller마다 직접 주입해 반복 호출하지 않는다.

## Facade, Service, Excel 책임
- `~ViewFacadeService`는 화면 모델 조립만 담당하며 `Model`, `ModelMap`, `HttpServletRequest`를 받지 않는다.
- ViewFacadeService 구현체는 기존 JSP key를 유지하는 `Map<String, Object>`를 반환한다.
- 권한/기관 보정 공통 기능은 `SbjctAuthHelper`에 둔다.
- Excel 다운로드 모델 생성은 `excel` 패키지의 `~ExcelHandler`가 담당한다.
- Excel 업로드의 파일 목록 파싱, `ExcelUtilPoi` read, row 변환, row 검증, 임시파일 삭제는 Service가 담당한다.
- 업무 실패 사유는 Service에서 `ResultDTO` message로 반환한다.

## 분리 판단
- 일반 과목개설과 공개강좌의 공통코드 필터 정책은 다르므로 무리하게 합치지 않는다.
- 팝업 upload context처럼 외형은 비슷하지만 정책 대상이 다르면 공통 helper를 만들지 않는다.
- `web.support`, 상속용 support class, 모호한 utility class를 새로 만들지 않는다.
- method 추가보다 기존 흐름 유지가 명확하면 불필요한 private method를 만들지 않는다.

## 주석과 메시지
- 새 Java public/private method와 Override method에는 기능을 한글 문장으로 설명하는 Javadoc을 작성한다.
- `@param`, `@return`, `@throws` 태그는 필요한 경우만 쓰고 설명 문구는 붙이지 않는다.
- 주석은 method명이나 기술명을 반복하지 말고 기능/동작을 설명한다.
- Java `getMessage(...)`, `setResultFailed(getMessage(...))`, validator message code 옆에는 `/* 한글 메시지 */`를 둔다.
- JSP `<spring:message>` 옆에도 문법적으로 안전한 위치에 한글 메시지 주석을 둔다.

## 검증
- 변경 후 `mvn -q -DskipTests compile`을 실행한다.
- Controller에 `ExcelUtilPoi`, `FileUtil`, `AtflVO`, Excel row 처리용 `HashMap`/`LinkedHashMap` import가 남지 않았는지 확인한다.
- FacadeService에 웹 객체 파라미터가 들어가지 않았는지 확인한다.
- JSP attribute key와 view name이 유지되었는지 확인한다.
