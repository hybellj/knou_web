package knou.lms.log.recom.service;

import knou.lms.log.recom.vo.LogRecomVO;

public interface LogRecomService {
    
    /***************************************************** 
     * 좋아요,추천 등록(up) 한다.
     * @param vo
     * @throws Exception
     ******************************************************/
    public void insert(LogRecomVO vo) throws Exception;
    
    /**
     * 좋아요,추천 삭제(down) 한다.
     * @param LogRecomVO
     * @throws Exception
     */
    public void delete(LogRecomVO vo) throws Exception;

    /**
     * 전체 추천수를 조회 한다.
     * @param LogRecomVO
     * @throws Exception
     */
    public int count(LogRecomVO vo) throws Exception;
    
    
    /***************************************************** 
     * 특정 추천자의 추천수를 조회 한다.
     * @param vo
     * @return int 
     * @throws Exception
     ******************************************************/ 
    public int countRecomRgtrId(LogRecomVO vo) throws Exception;
    
}
