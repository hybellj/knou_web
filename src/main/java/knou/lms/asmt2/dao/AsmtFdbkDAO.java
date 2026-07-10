package knou.lms.asmt2.dao;

import knou.lms.asmt2.vo.AsmtFdbkVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("asmtFdbkDAO")
public interface AsmtFdbkDAO {

    void asmtFdbkBulkRegist(List<AsmtFdbkVO> fdbkUserList);

    List<EgovMap> asmtFdbkList(AsmtFdbkVO vo) throws Exception;

    void asmtFdbkModify(AsmtFdbkVO vo) throws Exception;

    EgovMap asmtFdbkSelect(AsmtFdbkVO vo) throws Exception;

    void asmtFdbkDelete(AsmtFdbkVO vo) throws Exception;
}
