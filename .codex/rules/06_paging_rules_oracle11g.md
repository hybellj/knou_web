# 06. Paging Rules (Oracle 11g)

## 원칙
- Controller: 세션필수값을 VO에 주입
- Service: PageInfo 표준 흐름
- MyBatis: CommonSQL.pagePrefix/pageSubfix include 기반(ROWNUM 페이징)

## Controller 표준 예시(요약)
- orgId를 SessionInfo 등으로 얻어 SearchVO에 set
- service.select{Target}List(vo)
- resultSuccess() 세팅

## Service 표준 흐름(고정)
- PageInfo pageInfo = new PageInfo(vo);
- DAO 목록 조회
- pageInfo.setTotalRecord(list); (목록 row의 totalCnt 기반)
- processResultVO.setReturnList(list);
- processResultVO.setPageInfo(pageInfo);
