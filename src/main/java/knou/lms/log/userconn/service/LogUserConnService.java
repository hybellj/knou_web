package knou.lms.log.userconn.service;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import knou.lms.log.userconn.vo.LogUserConnStateVO;

public interface LogUserConnService {    
	
    /**
     * 사용자 접속 상태 저장
     * @param request
     * @throws Exception
     */
    public void saveUserConnState(HttpServletRequest request) throws Exception;
    
    /**
     * 사용자 접속 상태 목록 조회
     * @param  LogUserConnStateVO
     * @return List<LogUserConnStateVO> 
     * @throws Exception
     */
    public List<LogUserConnStateVO> listLogUserConnState(LogUserConnStateVO vo) throws Exception;
    
    /**
     * 사용자 접속 상태 최신 목록 조회
     * @param  LogUserConnStateVO
     * @return List<LogUserConnStateVO> 
     * @throws Exception
     */
    public List<LogUserConnStateVO> listTopLogUserConnState(LogUserConnStateVO vo) throws Exception;
    
    /**
     * 사용자 접속 상태 저장
     * @param request
     * @param workLoc
     * @throws Exception
     */
    public void saveUserConnState(HttpServletRequest request, String workLoc) throws Exception;

    /**
     * 과목 접속자 수 조회 
     * @param  LogUserConnStateVO
     * @return int
     * @throws Exception
     */
    public int countLogUserConnState(LogUserConnStateVO vo) throws Exception;
}
