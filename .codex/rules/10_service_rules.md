# 10. Service / ServiceImpl Rules

## Service Interface
- 위치: `knou.lms.{domain}.service`
- 모든 Service interface method 바로 위에는 한 줄 `//` 주석을 작성한다.
- DAO method와 직접 대응되는 method는 DAO method 주석과 같은 문구를 우선 사용한다.
- 예: `// 토론정보조회(1건)`

## ServiceImpl
- 위치: `knou.lms.{domain}.service.impl`
- 선언 형태:

```java
@Service("xxxService")
public class XxxServiceImpl extends ServiceBase implements XxxService
```

## ServiceBase
- 모든 ServiceImpl은 `ServiceBase`를 상속한다.
- `ServiceBase`는 `EgovAbstractServiceImpl`을 상속한다.

## 업무 검증 책임
- 저장/수정 시 DB 기준 중복 검증, 관계 검증, 기본값 보정은 Service에서 처리한다.
- Controller가 우회되어도 동일한 검증이 적용되도록 Service method 단위에서 방어한다.
- Controller가 얇게 결과를 반환할 수 있도록 업무 실패 사유는 `ResultDTO`의 message에 담아 반환한다.
- `ProcessResultVO`는 레거시 유지가 필요한 기존 Service에서만 허용한다.
- Controller에서 여러 DAO성 조회 결과를 조합하던 업무 판정은 Service method 또는 private helper로 이동한다.
- Excel 업로드 파일 목록 파싱, 엑셀 read, 행 변환, 행 검증, 임시파일 삭제는 Service에서 처리한다.
- Service에서 Spring message code를 직접 사용할 때는 현재 Locale 기준 메시지를 조회하고 `ResultDTO` message에 담아 반환한다.

## Paging 응답
- 페이징 Service는 `ResultDTO<T>`를 반환한다.
- `ResultDTO<T>` 생성 시 `new ResultDTO<T>(pageInfo)`를 사용한다.
- deprecated 된 `new PageInfo(vo)`와 `setTotalRecord(list)`는 사용하지 않는다.

## Javadoc 주석 규칙
- ServiceImpl method 주석은 Javadoc 형식(`/** ... */`)을 유지한다.
- 첫 줄에는 method 역할을 한글 문장으로 작성한다.
- `@param`, `@return`, `@throws` 태그는 필요한 경우 작성하되, 태그 뒤에 설명 문구를 붙이지 않는다.

```java
/**
 * 관리자 과목 목록 화면을 조회한다.
 * @param searchVo
 * @return
 */
```
