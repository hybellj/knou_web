package knou.lms.asmt2.service;

import knou.lms.asmt2.vo.AsmtFdbkVO;
import knou.lms.common.vo.ProcessResultVO;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

public interface AsmtFdbkService {

    void asmtFdbkRegist(AsmtFdbkVO vo, String fdbkUsersJson) throws Exception;

    ProcessResultVO<EgovMap> asmtFdbkList(AsmtFdbkVO vo) throws Exception;

    void asmtFdbkModify(AsmtFdbkVO vo) throws Exception;

    ProcessResultVO<EgovMap> asmtFdbkSelect(AsmtFdbkVO vo) throws Exception;

    void asmtFdbkDelete(AsmtFdbkVO vo) throws Exception;

    void asmtEzgFdbkRegist(AsmtFdbkVO vo);
}
