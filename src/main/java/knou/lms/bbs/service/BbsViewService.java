package knou.lms.bbs.service;

import java.util.List;

import knou.lms.bbs.vo.BbsViewVO;
import knou.lms.common.vo.ProcessResultVO;

public interface BbsViewService {

    /***************************************************** 
     * 게시판 조회 정보
     * @param vo
     * @return BbsViewVO
     * @throws Exception
     ******************************************************/
    public BbsViewVO selectBbsView(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 조회자 목록 수
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countBbsView(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 조회자 목록 페이징
     * @param vo
     * @return List<BbsViewVO>
     * @throws Exception
     ******************************************************/
    public List<BbsViewVO> listBbsView(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 목록 페이징
     * @param vo
     * @return ProcessResultVO<BbsViewVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<BbsViewVO> listBbsViewPaging(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 조회자 정보 등록
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insertBbsView(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 게시판 조회자 정보 수정
     * @param vo
     * @throws Exception
     ******************************************************/
    public void updateBbsView(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 수강생별 조회 목록
     * @param vo
     * @return int
     * @throws Exception
     ******************************************************/
    public int countBbsViewStd(BbsViewVO vo) throws Exception;
    
    /***************************************************** 
     * 수강생별 조회자 목록 수
     * @param vo
     * @return List<BbsViewVO>
     * @throws Exception
     ******************************************************/
    public List<BbsViewVO> listBbsViewStd(BbsViewVO vo) throws Exception;
}
