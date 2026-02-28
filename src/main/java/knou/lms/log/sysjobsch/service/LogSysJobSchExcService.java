package knou.lms.log.sysjobsch.service;

import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.sysjobsch.vo.LogSysJobSchExcVO;

public interface LogSysJobSchExcService {
    
    /*****************************************************
     * TODO 업무일정 예외 로그 목록 조회
     * @param LogSysJobSchExcVO
     * @return ProcessResultVO<LogSysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    public ProcessResultVO<LogSysJobSchExcVO> list(LogSysJobSchExcVO vo) throws Exception;

}
