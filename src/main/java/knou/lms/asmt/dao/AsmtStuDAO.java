package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtStuDAO")
public interface AsmtStuDAO {

    /*****************************************************
     * 정보 조회
     * @param AsmntVO
     * @return AsmtVO
     * @throws Exception
     ******************************************************/
    public AsmtVO selectObject(AsmtVO vo) throws Exception;

    /*****************************************************
     * 목록 조회
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectList(AsmtVO vo) throws Exception;

    /*****************************************************
     * 목록 조회 페이징
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> selectListPaging(AsmtVO vo) throws Exception;
}
