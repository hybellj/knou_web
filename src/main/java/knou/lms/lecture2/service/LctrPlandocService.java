package knou.lms.lecture2.service;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.TxtbkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface LctrPlandocService {
    public List<EgovMap> lctrPlandocList(LctrPlandocVO vo) throws Exception;

    public ProcessResultVO<EgovMap> lctrPlandocListPaging(LctrPlandocVO vo) throws Exception;

    public LctrPlandocVO lctrPlandocSelect(String sbjctId) throws Exception;

    public LctrPlandocVO lctrPlandocModify(UserContext userCtx, LctrPlandocVO lctrPlandocVO) throws Exception;

    public List<TxtbkVO> txtbkList(String sbjctId) throws Exception;

}