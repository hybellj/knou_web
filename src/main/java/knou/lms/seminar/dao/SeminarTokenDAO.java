package knou.lms.seminar.dao;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.seminar.vo.SeminarTokenVO;
import knou.lms.seminar.vo.SeminarVO;

@Mapper("seminarTokenDAO")
public interface SeminarTokenDAO {
    
    /*****************************************************
     * TODO 세미나 OAuth 토큰 정보 조회
     * @param SeminarTokenVO
     * @return SeminarTokenVO
     * @throws Exception
     ******************************************************/
    public SeminarTokenVO selectAccessToken(SeminarTokenVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 OAuth 토큰 등록
     * @param SeminarTokenVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insertAccessToken(SeminarTokenVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 OAuth 토큰 수정
     * @param SeminarTokenVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void updateAccessToken(SeminarTokenVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 OAuth 토큰 삭제
     * @param SeminarTokenVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void deleteAccessToken(SeminarTokenVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 OAuth 토큰 여부 조회
     * @param SeminarVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int countByCreCrs(SeminarVO vo) throws Exception;

}
