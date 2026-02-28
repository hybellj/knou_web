package knou.lms.user.facade;

import knou.framework.context2.UserContext;
import knou.lms.user.vo.UserPrfilVO;
import knou.lms.user.vo.UserPrfilView;

public interface UserPrfilFacadeService {
    UserPrfilView loadUserPrfil(UserContext userCtx) throws Exception;

    UserPrfilView loadUserPrfilModify(UserContext userCtx) throws Exception;

    void modifyUserPrfil(UserContext userCtx, UserPrfilVO vo) throws Exception;
}
