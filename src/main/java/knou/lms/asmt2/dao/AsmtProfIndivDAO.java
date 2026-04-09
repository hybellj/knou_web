package knou.lms.asmt2.dao;

import knou.lms.asmt2.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.egovframe.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("asmt2ProfIndivDAO")
public interface AsmtProfIndivDAO {

    List<EgovMap> indivStdList(AsmtVO vo) throws Exception;

    List<EgovMap> indivSbmsnTrgtList(AsmtVO vo) throws Exception;
}
