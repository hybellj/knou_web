package knou.lms.bbs.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.bbs.vo.BbsInfoLangVO;

@Mapper("bbsInfoLangDAO")
public interface BbsInfoLangDAO {
    
    /***************************************************** 
     * 게시판 언어 정보
     * @param vo
     * @return BbsInfoLangVO
     * @throws Exception
     ******************************************************/
    public BbsInfoLangVO selectBbsInfoLang(BbsInfoLangVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 언어 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsInfoLang(BbsInfoLangVO vo) throws Exception;

    /***************************************************** 
     * 게시판 언어 전체삭제
     * @param vo
     * @throws Exception
     ******************************************************/
    public void deleteBbsInfoLangAll(BbsInfoLangVO vo) throws Exception;
    
}
