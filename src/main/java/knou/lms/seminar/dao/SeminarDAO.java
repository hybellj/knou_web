package knou.lms.seminar.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.seminar.vo.SeminarVO;

@Mapper("seminarDAO")
public interface SeminarDAO {
    
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
     * @return List<SeminarVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarVO> listPaging(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 등록
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 수정
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 삭제
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 출결여부 수정
     * @param SeminarVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateSeminarAttProc(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 Zoom 분반 목록
     * @param SeminarVO
     * @return List<SeminarVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarVO> listSeminarByZoom(SeminarVO vo) throws Exception;
    
    /*****************************************************
     * TODO 특정 주차 세미나 개설 여부
     * @param SeminarVO
     * @return Integer
     * @throws Exception
     ******************************************************/
    public Integer countBySchedule(SeminarVO vo) throws Exception;

}
