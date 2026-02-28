package knou.lms.seminar.service;

import java.util.List;

import knou.lms.seminar.vo.SeminarHstyVO;

public interface SeminarHstyService {
    
    /*****************************************************
     * TODO 세미나 참석 기록 정보 조회
     * @param SeminarHstyVO
     * @return SeminarHstyVO
     * @throws Exception
     ******************************************************/
    public SeminarHstyVO select(SeminarHstyVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 참석 기록 목록 조회
     * @param SeminarHstyVO
     * @return List<SeminarHstyVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarHstyVO> list(SeminarHstyVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 참석 기록 등록
     * @param SeminarHstyVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SeminarHstyVO vo) throws Exception;

}
