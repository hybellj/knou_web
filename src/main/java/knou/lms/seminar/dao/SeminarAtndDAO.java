package knou.lms.seminar.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.seminar.vo.SeminarAtndVO;

@Mapper("seminarAtndDAO")
public interface SeminarAtndDAO {
    
    /*****************************************************
     * TODO 세미나 참석 정보 조회
     * @param SeminarAtndVO
     * @return SeminarAtndVO
     * @throws Exception
     ******************************************************/
    public SeminarAtndVO select(SeminarAtndVO vo) throws Exception;

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
     * TODO 세미나 참석 수정
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 참석 시간 초기화
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void atndTimeReset(SeminarAtndVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 메모 수정
     * @param SeminarAtndVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateMemo(SeminarAtndVO vo) throws Exception;
    
}
