# 04. Controller Rules

## 위치
- knou.lms.{domain}.web

## 응답/역할 규칙
- AJAX 전용: @ResponseBody + ProcessResultVO<T>만 반환
- View 이동: String으로 JSP view 반환

## 표준 주입/반환 흐름(요약)
- Controller에서 세션 필수값을 SearchVO에 주입(orgId/langCd 등)
- Service 호출
- 성공 시 resultSuccess() 세팅 후 반환
