package knou.lms.bbs.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.bbs.vo.BbsRltnVO;

@Mapper("bbsRltnDAO")
public interface BbsRltnDAO {

    /***************************************************** 
     * 게시판 정보 연결 목록
     * @param vo
     * @return List<BbsRltnVO>
     * @throws Exception
     ******************************************************/
    public List<BbsRltnVO> listBbsRltn(BbsRltnVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 정보 연결 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertBbsRltn(BbsRltnVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 정보 연결 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsRltn(BbsRltnVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 정보 연결 전체 삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsRltnAll(BbsRltnVO vo) throws Exception;
    
}
