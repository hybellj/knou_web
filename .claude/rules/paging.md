# Paging Rules (Oracle 11g ROWNUM)

## 계층별 역할

**Controller**
- 세션필수값 → SearchVO에 set 후 Service 호출

**Service (고정 흐름)**
```java
PageInfo pageInfo = new PageInfo(vo);
List<XxxListVO> list = xxxDAO.selectXxxList(vo);
pageInfo.setTotalRecord(list);          // list row의 totalCnt 기반
processResultVO.setReturnList(list);
processResultVO.setPageInfo(pageInfo);
```

**MyBatis**
```xml
<include refid="CommonSQL.pagePrefix" />
<include refid="listQuery" />           <!-- 실제 조회 쿼리 -->
<include refid="CommonSQL.pageSubfix" />
```

## 주의
- Oracle 12c `FETCH FIRST n ROWS ONLY` / `OFFSET` 문법 절대 사용 금지
- totalCnt는 `COUNT(*) OVER()` 또는 별도 count 쿼리로 처리 (프로젝트 공통 방식 따름)
