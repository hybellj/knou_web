# 00. Core Stack & Principles (Base Rule v1.9)

## 기술 스택 고정

-   Framework: eGovFramework 4.x
-   JDK: 21 (record 사용 금지)
-   Build: Maven
-   DB: Oracle 11g ONLY (12c 문법 금지)
-   Front: JSTL + jQuery
-   통신: AJAX
-   모든 AJAX 응답은 ProcessResultVO`<T>`{=html} (프로젝트 공통 Result
    VO)

## 금지/주의 (프로젝트 기본 원칙)

-   Oracle 12c 문법 금지
-   MyBatis resultType=VO 기본 (Map/HashMap/EgovMap 금지)
-   JSP 파일명은 모두 소문자 + 단어별 underscore 연결 (lower_snake_case)

------------------------------------------------------------------------

## 00. Output & Workflow Guardrail (항상 적용)

### A. 작업 모드 (항상)

-   항상 **최소 변경 / 우선 동작 보장(make-it-run-first)** 모드로
    작업한다.
-   광범위한 리팩토링이나 구조 재설계를 먼저 시작하지 않는다.
-   작업 범위는 **대상 기능과 직접 관련된 파일로만 제한**한다.

### B. 실행 순서 (항상)

1)  **SAVE(INSERT/UPDATE/MERGE)** 가 먼저 성공하도록 처리한다.
    -   DB 제약조건(PK / NOT NULL 등)을 우선 통과해야 한다.
2)  이후 **READ(SELECT)** 가 정상 동작하도록 맞춘다.
    -   필요 시 alias 등으로 호환성을 유지한다.
3)  UI(JSP/JS) 변경은 최소화한다.
    -   가능하면 서버단 매핑/변환으로 흡수한다.

### C. 매핑 정책 (항상)

-   매핑은 반드시 **UseYn = 'Y' 로 확정된 항목만 적용**한다.
-   매핑이 모호하면 추측하지 말고 **TODO로 표시**한다.
-   Oracle 11g 환경을 고려하여 SQL은 명시적이고 호환 가능하게 작성한다.

### D. 출력 정책 (토큰 절약 원칙)

-   사용자가 명시적으로 요청하지 않는 한\
    **전체 diff 또는 긴 코드 블록을 출력하지 않는다.**

-   반드시 아래 고정 요약 포맷을 사용한다.

#### 📌 필수 요약 포맷

CHANGED: - `<file_path>`{=html} : \<1-line change reason\> -
`<file_path>`{=html} : \<1-line change reason\>

TODO: - \<short TODO 1\> - \<short TODO 2\>

RISKS: - `<only if exists: JOIN/PK-FK/GROUP BY/MERGE/NOT NULL>`{=html}

NOTES: - \<optional, max 3 lines\>

### E. 중단 조건

다음 정보가 없으면 작업을 진행하지 말고\
**최소 필요 산출물만 요청한다.**

-   대상 JSP/JS 일부 코드
-   관련 Controller / Service
-   Mapper XML statement id
-   영향받는 테이블의 TO-BE DDL
