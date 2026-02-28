package knou.lms.seminar.service;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.util.EgovMap;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.seminar.vo.SeminarAtndVO;
import knou.lms.seminar.vo.SeminarVO;

public interface SeminarService {
    
    /*****************************************************
     * TODO 세미나 정보 조회
     * @param SeminarVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    public SeminarVO select(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 리스트 조회
     * @param SeminarVO
     * @return List<SeminarVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarVO> list(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 리스트 조회 페이징
     * @param SeminarVO
     * @return ProcessResultVO<SeminarVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<SeminarVO> listPaging(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 등록
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertSeminar(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 수정
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateSeminar(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 삭제
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteSeminar(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 ZOOM 호스트 URL 조회
     * @param SeminarAtndVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    public SeminarVO getHostUrl(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 ZOOM 학습자 URL 조회
     * @param SeminarAtndVO
     * @return SeminarVO
     * @throws Exception
     ******************************************************/
    public SeminarVO getJoinUrl(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 ZOOM 출결 처리
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void seminarAttendSet(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 ZOOM 출결 목록
     * @param SeminarVO
     * @return List<EgovMap>
     * @throws Exception
     ******************************************************/
    public List<EgovMap> seminarAttendList(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 특정 주차 세미나 개설 여부
     * @param SeminarVO
     * @return Integer
     * @throws Exception
     ******************************************************/
    public Integer countBySchedule(SeminarVO vo) throws Exception;
    
}
