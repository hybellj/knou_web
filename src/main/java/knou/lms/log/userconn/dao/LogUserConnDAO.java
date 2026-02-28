package knou.lms.log.userconn.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.log.userconn.vo.LogUserConnStateVO;

@Mapper("logUserConnDAO")
public interface LogUserConnDAO {

	/**
     * 사용자 접속 상태 조회
     * @param  LogUserConnStateVO
     * @return void 
     * @throws Exception
     */
    public LogUserConnStateVO selectLogUserConnState(LogUserConnStateVO vo) throws Exception;
	
    /**
     * 사용자 접속 상태 저장
     * @param  LogUserConnStateVO
     * @return void 
     * @throws Exception
     */
    public void insertLogUserConnState(LogUserConnStateVO vo) throws Exception;
    
    /**
     * 사용자 접속 상태 수정
     * @param  LogUserConnStateVO
     * @return void 
     * @throws Exception
     */
    public void updateLogUserConnState(LogUserConnStateVO vo) throws Exception;
    
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
     * 과목 접속자 수 조회 
     * @param  LogUserConnStateVO
     * @return int
     * @throws Exception
     */
    public int countLogUserConnState(LogUserConnStateVO vo) throws Exception;
}
