# 10. Service / ServiceImpl Rules

## Service Interface
- 위치: knou.lms.{domain}.service

## ServiceImpl
- 위치: knou.lms.{domain}.service.impl
- 표준 형태:
@Service("xxxService")
public class XxxServiceImpl extends ServiceBase implements XxxService

## ServiceBase
- 모든 ServiceImpl은 ServiceBase 상속
- ServiceBase는 EgovAbstractServiceImpl 상속
