package knou.lms.user.service;

import knou.lms.user.vo.UsrEmailAuthVO;

public interface UsrEmailAuthService {

    /*****************************************************
     * TODO 이메일 인증 관리 정보 조회
     * @param UsrEmailAuthVO
     * @return UsrEmailAuthVO
     * @throws Exception
     ******************************************************/
    public UsrEmailAuthVO select(UsrEmailAuthVO vo) throws Exception;
    
    /*****************************************************
     * TODO 이메일 인증 관리 정보 등록
     * @param UsrEmailAuthVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(UsrEmailAuthVO vo) throws Exception;
    
    /*****************************************************
     * TODO 이메일 인증 관리 정보 수정
     * @param UsrEmailAuthVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void update(UsrEmailAuthVO vo) throws Exception;
    
}
