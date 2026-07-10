package knou.lms.log2.user.service;

import knou.framework.context2.UserContext;
import knou.lms.log2.user.vo.LogLrnActvInqHstryVO;
import knou.lms.user.CurrentUser;

public interface LogLrnActvService {

    void lrnActvInqHstryRegist(LogLrnActvInqHstryVO vo, @CurrentUser UserContext userCtx) throws Exception;
}
