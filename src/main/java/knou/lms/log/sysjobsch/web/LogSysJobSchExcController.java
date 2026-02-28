package knou.lms.log.sysjobsch.web;

import java.util.HashMap;
import java.util.Locale;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import knou.framework.common.SessionInfo;
import knou.framework.util.ExcelUtilPoi;
import knou.framework.util.LocaleUtil;
import knou.lms.common.vo.ProcessResultVO;
import knou.lms.log.sysjobsch.service.LogSysJobSchExcService;
import knou.lms.log.sysjobsch.vo.LogSysJobSchExcVO;

@Controller
@RequestMapping(value="/logSysJobSchExc")
public class LogSysJobSchExcController {

    private static final Logger LOGGER = LoggerFactory.getLogger(LogSysJobSchExcController.class);
    
    @Resource(name="logSysJobSchExcService")
    private LogSysJobSchExcService logSysJobSchExcService;
    
    @Resource(name="messageSource")
    private MessageSource messageSource;
    
    /***************************************************** 
     * TODO 업무일정 예외 로그 목록 조회
     * @param LogSysJobSchExcVO
     * @return ProcessResultVO<LogSysJobSchExcVO>
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/schExcList.do")
    @ResponseBody
    public ProcessResultVO<LogSysJobSchExcVO> schExcList(LogSysJobSchExcVO vo, ModelMap map, HttpServletRequest request) throws Exception {
        ProcessResultVO<LogSysJobSchExcVO> resultVO = new ProcessResultVO<LogSysJobSchExcVO>();
        Locale locale = LocaleUtil.getLocale(request);
        
        try {
            resultVO = logSysJobSchExcService.list(vo);
            resultVO.setResult(1);
        } catch(Exception e) {
            resultVO.setResult(-1);
            resultVO.setMessage(messageSource.getMessage("fail.common.msg", null, locale));/* 에러가 발생했습니다! */
        }
        
        return resultVO;
    }
    
    /***************************************************** 
     * TODO 업무일정 예외 로그 목록 엑셀다운로드
     * @param GradeVO 
     * @return "excelView"
     * @throws Exception
     ******************************************************/
    @RequestMapping(value="/schExcListExcelDown.do")
    public String schExcListExcelDown(LogSysJobSchExcVO vo, ModelMap model, HttpServletRequest request) throws Exception {
        Locale locale = LocaleUtil.getLocale(request);
        vo.setOrgId(SessionInfo.getOrgId(request));
        
        ProcessResultVO<LogSysJobSchExcVO> resultList = logSysJobSchExcService.list(vo);
        
        String[] searchValues = {};
        
        //POI의 SXSSFWorkbook를 이용한 대용량 엑셀 출력 공통 함수 이용
        //엑셀 정보값 세팅
        HashMap<String, Object> map1 = new HashMap<String, Object>();
        map1.put("title", messageSource.getMessage("score.label.exc.log", null, locale));          // 예외처리로그
        map1.put("sheetName", messageSource.getMessage("score.label.exc.log", null, locale));      // 예외처리로그
        map1.put("searchValues", searchValues);
        map1.put("excelGrid", vo.getExcelGrid());
        map1.put("list", resultList.getReturnList());
        
        HashMap<String, Object> modelMap1 = new HashMap<String, Object>();
        modelMap1.put("outFileName", messageSource.getMessage("score.label.exc.log", null, locale));  // 예외처리로그
        modelMap1.put("sheetName", messageSource.getMessage("score.label.exc.log", null, locale));    // 예외처리로그
        modelMap1.put("list", resultList.getReturnList());
        
        //엑셀화
        ExcelUtilPoi excelUtilPoi = new ExcelUtilPoi();
        modelMap1.put("workbook", excelUtilPoi.simpleBigGrid(map1));
        model.addAllAttributes(modelMap1);
        
        return "excelView";
    }
    
}
