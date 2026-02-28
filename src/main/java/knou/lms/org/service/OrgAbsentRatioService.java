package knou.lms.org.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.org.vo.OrgAbsentRatioVO;

public interface OrgAbsentRatioService {

    /*****************************************************
     * TODO 결시원 성적비율 리스트 조회
     * @param OrgAbsentRatioVO
     * @return ProcessResultVO<OrgAbsentRatioVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<OrgAbsentRatioVO> list(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 정보 조회
     * @param OrgAbsentRatioVO
     * @return OrgAbsentRatioVO
     * @throws Exception
     ******************************************************/
    public OrgAbsentRatioVO select(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 등록
     * @param OrgAbsentRatioVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(OrgAbsentRatioVO vo) throws Exception;
    
    /*****************************************************
     * TODO 결시원 성적비율 삭제
     * @param OrgAbsentRatioVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void delete(OrgAbsentRatioVO vo) throws Exception;
    
}
