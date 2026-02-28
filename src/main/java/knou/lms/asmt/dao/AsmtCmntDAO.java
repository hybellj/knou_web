package knou.lms.asmt.dao;

import knou.lms.asmt.vo.AsmtVO;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

@Mapper("asmtCmntDAO")
public interface AsmtCmntDAO {

    /*****************************************************
     * 과제 댓글 조회
     * @param AsmntVO
     * @return AsmtVO
     * @throws Exception
     ******************************************************/
    public AsmtVO selectCmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제 댓글 목록 조회
     * @param AsmntVO
     * @return List<AsmtVO>
     * @throws Exception
     ******************************************************/
    public List<AsmtVO> listCmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제 댓글 등록
     * @param AsmntVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertCmnt(AsmtVO vo) throws Exception;

    /*****************************************************
     * 과제 댓글 수정
     * @param AsmntVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateCmnt(AsmtVO vo) throws Exception;

}
