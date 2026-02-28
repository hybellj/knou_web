package knou.lms.sys.web;

import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.ControllerBase;
import knou.framework.common.SessionInfo;
import knou.framework.util.StringUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.crs.term.service.TermService;
import knou.lms.crs.term.vo.TermVO;
import knou.lms.sys.service.SysJobSchExcService;
import knou.lms.sys.service.SysJobSchService;
import knou.lms.sys.vo.SysJobSchVO;

@Controller
@RequestMapping(value="/jobSchHome")
public class SysJobSchHomeController extends ControllerBase {

    @Resource(name="sysJobSchService")
    private SysJobSchService sysJobSchService;
    
    @Resource(name="sysJobSchExcService")
    private SysJobSchExcService sysJobSchExcService;
    
    @Resource(name="termService")
    private TermService termService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /***************************************************** 
     * TODO 업무일정 조회 ajax
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewSysJobSch.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> viewSysJobSch(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            SysJobSchVO sysJobSchVO = sysJobSchService.select(vo);
            resultVO.setReturnVO(sysJobSchVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 업무일정 마지막 일시 정보 조회 ajax
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/viewSysJobSchByEndDt.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> viewSysJobSchByEndDt(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            vo.setOrgId(orgId);
            
            SysJobSchVO sysJobSchVO = sysJobSchService.selectByEndDt(vo);
            resultVO.setReturnVO(sysJobSchVO);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getCommonFailMessage()); // 에러가 발생했습니다!
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * 업무일정 조회 ajax
     * @param SysJobSchVO 
     * @return ProcessResultVO<SysJobSchVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/checkLectEvalPeriod.do")
    @ResponseBody
    public ProcessResultVO<SysJobSchVO> checkLectEvalPeriod(SysJobSchVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<SysJobSchVO> resultVO = new ProcessResultVO<>();
        String orgId = SessionInfo.getOrgId(request);
        
        try {
            TermVO termVO = new TermVO();
            termVO.setOrgId(orgId);
            termVO = termService.selectCurrentTerm(termVO);
            
            SysJobSchVO sysJobSchSearchVO = new SysJobSchVO();
            sysJobSchSearchVO.setOrgId(orgId);
            sysJobSchSearchVO.setUseYn("Y");
            sysJobSchSearchVO.setTermCd(termVO.getTermCd());
            // 00190501: 중간강의평가일정, 00190505: 기말강의평가일정
            sysJobSchSearchVO.setSqlForeach(new String[]{"00190501", "00190505"});
            List<SysJobSchVO> jobSchList = sysJobSchService.list(sysJobSchSearchVO);
            
            boolean isPeriod = false;
            
            for(SysJobSchVO sysJobSchVO2 : jobSchList) {
                if("Y".equals(StringUtil.nvl(sysJobSchVO2.getSysjobSchdlPeriodYn()))) {
                    isPeriod = true;
                }
            }
            
            if(isPeriod) {
                resultVO.setResult(1);
            } else {
                resultVO.setResult(0);
            }
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(getMessage("sch.error.search")); // 일정 조회에 실패하였습니다.
        }
        
        return resultVO;
    }
}
