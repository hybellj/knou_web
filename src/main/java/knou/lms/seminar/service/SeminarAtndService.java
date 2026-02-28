package knou.lms.seminar.service;

import java.util.List;

import knou.lms.seminar.vo.SeminarAtndVO;

public interface SeminarAtndService {
    
    /*****************************************************
     * TODO 세미나 참석 수강생 리스트 조회
     * @param SeminarAtndVO
     * @return List<SeminarAtndVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarAtndVO> listStd(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 참석 수강생 정보 조회
     * @param SeminarAtndVO
     * @return SeminarAtndVO
     * @throws Exception
     ******************************************************/
    public SeminarAtndVO selectStd(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 수강생 출결 관리 등록, 수정
     * @param SeminarAtndVO
     * @return SeminarAtndVO
     * @throws Exception
     ******************************************************/
    public void update(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * 세미나 메모 수정
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateMemo(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * 세미나 메모 단건 수정
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateMemoOne(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 주차 출결 수정
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateLessonStudyStatus(SeminarAtndVO vo) throws Exception;
    
}
