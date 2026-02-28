package knou.lms.dashboard.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import knou.framework.common.ServiceBase;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.dashboard.dao.SchDAO;
import knou.lms.dashboard.service.SchService;
import knou.lms.dashboard.vo.SchVO;

@Service("schService")
public class SchServiceImpl extends ServiceBase implements SchService {
    
    @Resource(name="schDAO")
    private SchDAO schDAO;

    /*****************************************************
     * <p>
     * 캘린더 정보 조회
     * </p>
     * 캘린더 정보 조회
     *
     * @param SchVO
     * @return ProcessResultVO<SchVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SchVO> listCalendar(SchVO vo) throws Exception {
        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {
            List<SchVO> schList = schDAO.listCalendar(vo);
            resultVO.setResult(1);
            resultVO.setReturnList(schList);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }
        return resultVO;
    }

    /*****************************************************
     * <p>
     * 일정 조회
     * </p>
     * 일정 조회
     *
     * @param SchVO
     * @return ProcessResultVO<SchVO>
     * @throws Exception
     ******************************************************/
    @Override
    public ProcessResultVO<SchVO> listSchedule(SchVO vo) throws Exception {
        
        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {
            
            List<SchVO> scheduleList = schDAO.listSchedule(vo);
            resultVO.setResult(1);
            resultVO.setReturnList(scheduleList);
            
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }
        return resultVO;
    }
    
    @Override
    public ProcessResultVO<SchVO> stuListSchedule(SchVO vo) throws Exception {
        
        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {
            
            List<SchVO> scheduleList = schDAO.stuListSchedule(vo);
            resultVO.setResult(1);
            resultVO.setReturnList(scheduleList);
            
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }
        return resultVO;
    }
    
    @Override
    public ProcessResultVO<SchVO> profListSchedule(SchVO vo) throws Exception {
        
        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {
            
            List<SchVO> scheduleList = schDAO.profListSchedule(vo);
            resultVO.setResult(1);
            resultVO.setReturnList(scheduleList);
            
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }
        return resultVO;
    }

    @Override
    public ProcessResultVO<SchVO> listAcadSch(SchVO vo) throws Exception {
        ProcessResultVO<SchVO> resultVO = new ProcessResultVO<SchVO>();
        try {
            List<SchVO> schList = schDAO.listAcadSch(vo);
            resultVO.setResult(1);
            resultVO.setReturnList(schList);
        } catch(Exception e) {
            e.printStackTrace();
            resultVO.setResult(-1);
            resultVO.setMessage(e.getMessage());
        }
        return resultVO;
    }

}
