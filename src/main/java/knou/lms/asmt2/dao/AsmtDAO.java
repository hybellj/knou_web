package knou.lms.asmt2.dao;

import knou.lms.asmt2.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("asmt2DAO")
public interface AsmtDAO {

    List<EgovMap> asmtListPaging(AsmtVO vo) throws Exception;

    void mrkRfltrtModify(AsmtVO vo) throws Exception;

    void mrkOynModify(AsmtVO vo) throws Exception;

    EgovMap asmtSelect(AsmtVO asmtVO) throws Exception;
}
