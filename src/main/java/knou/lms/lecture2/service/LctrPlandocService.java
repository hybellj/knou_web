package knou.lms.lecture2.service;

import knou.framework.context2.UserContext;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.file.vo.AtflVO;
import knou.lms.lecture2.vo.LctrPlandocVO;
import knou.lms.lecture2.vo.RltmExamVO;
import knou.lms.lecture2.vo.TxtbkVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;
import java.util.Map;

public interface LctrPlandocService {
    public List<EgovMap> lctrPlandocList(LctrPlandocVO vo) throws Exception;

    public ProcessResultVO<EgovMap> lctrPlandocListPaging(LctrPlandocVO vo) throws Exception;

    public LctrPlandocVO lctrPlandocSelect(String sbjctId) throws Exception;

    public LctrPlandocVO lctrPlandocModify(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    public LctrPlandocVO admLctrPlandocRegist(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    public LctrPlandocVO admLctrPlandocModify(LctrPlandocVO lctrPlandocVO, UserContext userCtx) throws Exception;

    int admLctrPlandocDelete(LctrPlandocVO lctrPlandocVO) throws Exception;

    List<EgovMap> admSbjctSchdlListForPlandocRegist(String sbjctId) throws Exception;

    public List<TxtbkVO> txtbkList(String sbjctId) throws Exception;

    Map<String, List<AtflVO>> selectPlandocFileMap(String lctrPlandocId);

    List<EgovMap> stdntLctrPlandocList(LctrPlandocVO vo);

    ProcessResultVO<EgovMap> stdntLctrPlandocListPaging(LctrPlandocVO vo) throws Exception;

    List<EgovMap> orgList(LctrPlandocVO planParamVO, UserContext userCtx);

    List<EgovMap> sbjctList(LctrPlandocVO planParamVO, UserContext userCtx);

    ProcessResultVO<EgovMap> admLctrPlandocListPaging(LctrPlandocVO vo) throws Exception;

    List<RltmExamVO> rltmExamList(String lctrPlandocId);

    List<RltmExamVO> rltmExamFormList(String lctrPlandocId);
}
