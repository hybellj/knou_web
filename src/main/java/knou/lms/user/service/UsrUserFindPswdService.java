package knou.lms.user.service;

import knou.lms.user.vo.UsrUserFindPswdVO;

public interface UsrUserFindPswdService {

    /*****************************************************
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 수를 카운트 한다.
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int count(UsrUserFindPswdVO vo) throws Exception;
    
    /*****************************************************
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 조회한다.
     * @param UsrUserFindPswdVO
     * @return UsrUserFindPswdVO
     * @throws Exception
     ******************************************************/
    public UsrUserFindPswdVO select(UsrUserFindPswdVO vo) throws Exception;
    
    /*****************************************************
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 등록한다.
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int insert(UsrUserFindPswdVO vo) throws Exception;
    
    /*****************************************************
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 수정한다.
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int update(UsrUserFindPswdVO vo) throws Exception;
    
    /*****************************************************
     * TODO 비밀번호 찾기 EMAIL/SMS 템플릿 정보를 삭제한다.
     * @param UsrUserFindPswdVO
     * @return int
     * @throws Exception
     ******************************************************/
    public int delete(UsrUserFindPswdVO vo) throws Exception;
    
    /*****************************************************
     * TODO 비밀번호 찾기 이메일 템플릿 변수 적용결과 조회
     * @param 
     * @return UsrUserFindPswdVO
     * @throws Exception
     ******************************************************/
    public UsrUserFindPswdVO getResetPassEmailTpl() throws Exception;
    
    /*****************************************************
     * TODO 비밀번호 초기화 이메일 템플릿 변수 적용결과 조회
     * @param 
     * @return UsrUserFindPswdVO
     * @throws Exception
     ******************************************************/
    public UsrUserFindPswdVO getResetPassResultEmailTpl() throws Exception;
    
}
