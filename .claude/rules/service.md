# Service / ServiceImpl Rules

## Service Interface
위치: `knou.lms.{domain}.service`

## ServiceImpl
위치: `knou.lms.{domain}.service.impl`

```java
@Service("xxxService")
public class XxxServiceImpl extends ServiceBase implements XxxService {
    @Resource(name = "xxxDAO")
    private XxxDAO xxxDAO;
}
```

## 상속 구조
`ServiceImpl` → `ServiceBase` → `EgovAbstractServiceImpl`

## ProcessResultVO 응답 표준
- 목록: `returnList` + `pageInfo` 조합
- 상태: `resultSuccess()` / `resultFailed()` 메서드 사용
