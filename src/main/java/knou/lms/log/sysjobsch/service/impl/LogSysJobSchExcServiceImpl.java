package knou.lms.log.sysjobsch.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.sysjobsch.dao.LogSysJobSchExcDAO;
import knou.lms.log.sysjobsch.service.LogSysJobSchExcService;
import knou.lms.log.sysjobsch.vo.LogSysJobSchExcVO;

@Service("logSysJobSchExcService")
public class LogSysJobSchExcServiceImpl extends ServiceBase implements LogSysJobSchExcService {

    @Resource(name="logSysJobSchExcDAO")
    private LogSysJobSchExcDAO logSysJobSchExcDAO;

    /*****************************************************
     * <p>
     * TODO 업무일정 예외 로그 목록 조회
     * </p>
     * 업무일정 예외 로그 목록 조회
     *
     * @param LogSysJobSchExcVO
     * @return ProcessResultVO<LogSysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<LogSysJobSchExcVO> list(LogSysJobSchExcVO vo) throws Exception {
        ProcessResultVO<LogSysJobSchExcVO> resultVO = new ProcessResultVO<LogSysJobSchExcVO>();
        
        try {
            List<LogSysJobSchExcVO> returnList = logSysJobSchExcDAO.list(vo);
            resultVO.setReturnList(returnList);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
        }
        
        return resultVO;
    }
    
}
