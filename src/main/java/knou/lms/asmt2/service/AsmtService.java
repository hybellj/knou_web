package knou.lms.asmt2.service;

import knou.lms.asmt2.vo.AsmtVO;
import knou.lms.common.vo.ProcessResultVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface AsmtService {

    ProcessResultVO<EgovMap> asmtListPaging(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> mrkRfltrtModify(AsmtVO vo) throws Exception;

    ProcessResultVO<AsmtVO> MrkOynModify(AsmtVO vo) throws Exception;
}
