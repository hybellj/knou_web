package knou.lms.lecture2.facade;

import knou.framework.context2.UserContext;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LctrPlandocView;

public interface LctrPlandocFacadeService {
    LctrPlandocView loadLctrPlandocView(UserContext userCtx, LctrPlandocVO lctrPlandocVO) throws Exception;

    LctrPlandocView loadLctrPlandocModifyView(UserContext userCtx, LctrPlandocVO lctrPlandocVO) throws Exception;

}
