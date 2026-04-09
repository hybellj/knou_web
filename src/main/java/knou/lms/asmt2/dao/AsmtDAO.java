package knou.lms.asmt2.dao;

import knou.lms.asmt2.vo.AsmtTrgtVO;
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

    List<EgovMap> dvclasList(AsmtVO vo) throws Exception;

    List<EgovMap> lrnGrpTeamList(AsmtVO vo) throws Exception;

    void asmtGrpRegist(AsmtVO vo) throws Exception;

    void asmtRegist(AsmtVO vo) throws Exception;

    void asmtTrgtListRegist(List<AsmtTrgtVO> insertList) throws Exception;

    List<AsmtTrgtVO> teamTrgtList(AsmtVO vo) throws Exception;

    void subAsmtByCopyRegist(AsmtVO vo) throws Exception;

    List<AsmtTrgtVO> allStdTrgtList(AsmtVO vo) throws Exception;
}
