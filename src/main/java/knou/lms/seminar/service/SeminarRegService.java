package knou.lms.seminar.service;

import java.util.List;

import knou.lms.seminar.vo.SeminarRegVO;

public interface SeminarRegService {
    
    /*****************************************************
     * TODO 세미나 사전 등록 참가자 정보 조회
     * @param SeminarRegVO
     * @return SeminarRegVO
     * @throws Exception
     ******************************************************/
    public SeminarRegVO select(SeminarRegVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 사전 등록 참가자 목록 조회
     * @param SeminarRegVO
     * @return List<SeminarRegVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarRegVO> list(SeminarRegVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 사전 등록 참가자 등록
     * @param SeminarRegVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SeminarRegVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 사전 등록 참가자 수정
     * @param SeminarRegVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(SeminarRegVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 사전 등록 참가자 삭제
     * @param SeminarRegVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(SeminarRegVO vo) throws Exception;

}
