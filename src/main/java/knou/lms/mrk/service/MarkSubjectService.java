package knou.lms.mrk.service;

import knou.framework.common.PageInfo;
import knou.lms.common.dto.ResultDTO;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.mrk.vo.MarkSubjectVO;
import knou.lms.mrk.vo.MrkProcExcpProcVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface MarkSubjectService {

    EgovMap getStdMrkDetails (String sbjctid, String userId);

    ProcessResultVO<EgovMap> stdMrkList(String orgId, String sbjctId, String searchType);

    void stdMrkInit(String orgId, String sbjctId, String userId);

//    List<SubjectMarkDetailVO> attdSummaryList(String sbjctId) throws Exception;

    Map<String, BigDecimal> getMrkItmStngInfoMap(String orgId, String sbjctId);

    ProcessResultVO<EgovMap> stdMrkModify(Map<String, Map<String, String>> stdMrkList,String orgId, String sbjctId, String mdfrId);

    ResultDTO<EgovMap> stdScrCnvsStsModify(MarkSubjectVO vo);

    Map<String, Double> getAvgScrInfoByMrkItm(String sbjctId);

    EgovMap getMrkRangeStatus(String sbjctId);

    ResultDTO<EgovMap> mrkProcExcpProcListPaging(PageInfo pageInfo);

    ResultDTO<EgovMap> allMrkProcExcpProcListPaging(PageInfo pageInfo);

    void mrkProcExcpProcRegist(List<MrkProcExcpProcVO> list, String rgtrId);

    void mrkProcExcpProcDelete(List<MrkProcExcpProcVO> list);
}
