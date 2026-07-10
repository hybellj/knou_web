package knou.lms.asmt2.dao;

import knou.lms.asmt2.vo.AsmtEvlVO;
import knou.lms.asmt2.vo.AsmtSbmsnVO;
import knou.lms.asmt2.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("asmt2ProfIndivDAO")
public interface AsmtProfIndivDAO {

    List<EgovMap> indivStdList(AsmtVO vo) throws Exception;

    List<EgovMap> indivSbmsnTrgtList(AsmtVO vo) throws Exception;

    List<EgovMap> resbmsnCandidateList(AsmtVO vo) throws Exception;

    List<EgovMap> resbmsnTrgtList(AsmtVO vo) throws Exception;


    void asmtMemoModify(AsmtEvlVO vo) throws Exception;

    List<EgovMap> prevAsmtSbmsnList(AsmtVO vo) throws Exception;

    void asmtExlnBulkModify(List<AsmtEvlVO> exlnList) throws Exception;

    void asmtExlnModify(AsmtEvlVO vo) throws Exception;

    List<EgovMap> asmtSbmsnHistList(AsmtVO vo) throws Exception;

    EgovMap lastAsmtSbmsnSelect(AsmtSbmsnVO sbmsnParamVO) throws Exception;

    void asmtMemoAppendModify(AsmtEvlVO item);
}
