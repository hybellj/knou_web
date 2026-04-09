package knou.lms.asmt2.service;

import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface AsmtService {

    ProcessResultVO<EgovMap> asmtListPaging(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> mrkRfltrtModify(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> mrkOynModify(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> asmtSelect(AsmtVO asmtVO) throws Exception;

    List<EgovMap> dvclasList(AsmtVO vo) throws Exception;

    List<EgovMap> lrnGrpTeamList(AsmtVO vo) throws Exception;

    List<EgovMap> indivStdList(AsmtVO vo) throws Exception;

    ProcessResultVO<EgovMap> indivSbmsnTrgt(AsmtVO vo) throws Exception;

    void profAsmtRegist(AsmtVO vo) throws Exception;
}
