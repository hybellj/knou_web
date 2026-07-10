package knou.lms.lecture2.facade;

import knou.framework.context2.UserContext;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.LctrPlandocView;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface LctrPlandocFacadeService {
    LctrPlandocView loadLctrPlandocView(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    LctrPlandocView loadLctrPlandocModifyView(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    EgovMap loadFilterOptions(UserContext userCtx);

    LctrPlandocView loadAdmLctrPlandocView(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    LctrPlandocView loadAdmLctrPlandocWriteView(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    EgovMap loadAdmFilterOptions(UserContext userCtx);

}
