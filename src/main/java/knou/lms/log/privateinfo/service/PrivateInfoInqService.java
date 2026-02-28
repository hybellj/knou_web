package knou.lms.log.privateinfo.service;

import knou.lms.log.privateinfo.vo.PrivateInfoInqVO;

public interface PrivateInfoInqService {

    /**
     * 개인정보 조회 이력 정보를 저장하고 결과를 반환한다.
     * @param PrivateInfoInqVO
     * @return
     */
    public abstract void add(PrivateInfoInqVO vo) throws Exception;
    
}
