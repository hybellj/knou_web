package knou.lms.log.sysjobsch.dao;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import knou.lms.log.sysjobsch.vo.LogSysJobSchExcVO;

@Mapper("logSysJobSchExcDAO")
public interface LogSysJobSchExcDAO {
    
    /*****************************************************
     * TODO 업무일정 예외 로그 목록 조회
     * @param LogSysJobSchExcVO
     * @return List<LogSysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    public List<LogSysJobSchExcVO> list(LogSysJobSchExcVO vo) throws Exception;
    
    /*****************************************************
     * TODO 업무일정 예외 로그 등록
     * @param LogSysJobSchExcVO
     * @return void
     * @throws Exception
     ******************************************************/
    public void insert(LogSysJobSchExcVO vo) throws Exception;

}
