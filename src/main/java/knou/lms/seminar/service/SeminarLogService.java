package knou.lms.seminar.service;

import java.util.List;

import knou.lms.seminar.vo.SeminarLogVO;

public interface SeminarLogService {
    
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

}
