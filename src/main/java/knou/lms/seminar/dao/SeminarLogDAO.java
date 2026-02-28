package knou.lms.seminar.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.seminar.vo.SeminarLogVO;

@Mapper("seminarLogDAO")
public interface SeminarLogDAO {

    /*****************************************************
     * TODO 세미나 로그 정보 조회
     * @param SeminarLogVO
     * @return SeminarLogVO
     * @throws Exception
     ******************************************************/
    public SeminarLogVO select(SeminarLogVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 로그 목록 조회
     * @param SeminarLogVO
     * @return List<SeminarLogVO>
     * @throws Exception
     ******************************************************/
    public List<SeminarLogVO> list(SeminarLogVO vo) throws Exception;
    
    /*****************************************************
     * TODO 세미나 로그 등록
     * @param SeminarLogVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(SeminarLogVO vo) throws Exception;
    
}
