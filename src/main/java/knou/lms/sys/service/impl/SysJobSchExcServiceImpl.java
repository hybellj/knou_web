package knou.lms.sys.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.framework.util.IdGenerator;
import knou.lms.log.sysjobsch.dao.LogSysJobSchExcDAO;
import knou.lms.log.sysjobsch.vo.LogSysJobSchExcVO;
import knou.lms.sys.dao.SysJobSchDAO;
import knou.lms.sys.dao.SysJobSchExcDAO;
import knou.lms.sys.service.SysJobSchExcService;
import knou.lms.sys.vo.SysJobSchExcVO;

@Service("sysJobSchExcService")
public class SysJobSchExcServiceImpl extends ServiceBase implements SysJobSchExcService {
    
    @Resource(name="sysJobSchExcDAO")
    private SysJobSchExcDAO sysJobSchExcDAO;
    
    @Resource(name="sysJobSchDAO")
    private SysJobSchDAO sysJobSchDAO;
    
    @Resource(name="logSysJobSchExcDAO")
    private LogSysJobSchExcDAO logSysJobSchExcDAO;

    /*****************************************************
     * <p>
     * TODO 업무일정 예외 조회
     * </p>
     * 업무일정 예외 조회
     * 
     * @param SysJobSchExcVO
     * @return SysJobSchExcVO
     * @throws Exception
     ******************************************************/
    @Override
    public SysJobSchExcVO select(SysJobSchExcVO vo) throws Exception {
        return sysJobSchExcDAO.select(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 예외 목록 조회
     * </p>
     * 업무일정 예외 목록 조회
     * 
     * @param SysJobSchExcVO
     * @return List<SysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    @Override
    public List<SysJobSchExcVO> list(SysJobSchExcVO vo) throws Exception {
        return sysJobSchExcDAO.list(vo);
    }

    /*****************************************************
     * <p>
     * TODO 업무일정 예외 삭제
     * </p>
     * 업무일정 예외 삭제
     * 
     * @param SysJobSchExcVO
     * @return void
     * @throws Exception
     ******************************************************/
    @Override
    public void delete(SysJobSchExcVO vo) throws Exception {
        SysJobSchExcVO sjevo = sysJobSchExcDAO.select(vo);
        
        sysJobSchExcDAO.delete(vo);
        
        LogSysJobSchExcVO logVO = new LogSysJobSchExcVO();
        logVO.setExcLogSn(IdGenerator.getNewId("LOG"));
        logVO.setCrsCreCd(vo.getCrsCreCd());
        logVO.setExcLogCts("삭제 : " + sjevo.getCrsCreNm() + " 과목 " + sjevo.getSysjobSchdlnm());
        logVO.setRgtrId(vo.getUserId());
        logSysJobSchExcDAO.insert(logVO);
    }

}
